package controller;

import config.PayOSConfig;
import dao.BookingDAO;
import dao.CustomerDAO;
import dao.InvoiceDAO;
import dto.Account;
import dto.Business;
import dto.Customer;
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import service.InvoiceAutoCancelService;
import service.PayOSService;

@WebServlet(name = "BusinessPaymentStatusController", urlPatterns = {"/BusinessPaymentStatusController"})
public class BusinessPaymentStatusController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        PayOSConfig.load(getServletContext());
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();

        Account account = (Account) request.getSession().getAttribute("ACCOUNT");
        Business business = (Business) request.getSession().getAttribute("BUS");
        if (account == null || business == null) {
            out.print("{\"success\":false,\"message\":\"Unauthorized\"}");
            out.flush();
            return;
        }

        try {
            InvoiceAutoCancelService autoCancelService = new InvoiceAutoCancelService();
            autoCancelService.cancelExpiredPendingInvoices();

            int invoiceId = Integer.parseInt(request.getParameter("invoiceId"));
            Customer customer = new CustomerDAO().getCustomerByAccountID(account.getAccountID());
            InvoiceDAO invoiceDAO = new InvoiceDAO();
            BookingDAO bookingDAO = new BookingDAO();

            if (customer == null || !invoiceDAO.isInvoiceOwnedByCustomer(invoiceId, customer.getCusID())) {
                out.print("{\"success\":false,\"message\":\"Invalid invoice\"}");
                out.flush();
                return;
            }

            if (autoCancelService.isInvoiceExpired(invoiceId)) {
                bookingDAO.cancelInvoiceBookings(invoiceId);
                out.print("{\"success\":true,\"paymentStatus\":\"Cancelled\",\"expired\":true}");
                out.flush();
                return;
            }

            BookingDAO.InvoicePaymentSummary summary = bookingDAO.getInvoicePaymentSummary(invoiceId);
            if (summary == null) {
                out.print("{\"success\":false,\"message\":\"Not found\"}");
            } else if ("Cancelled".equalsIgnoreCase(summary.getInvoicePaymentStatus())) {
                out.print("{\"success\":true,\"paymentStatus\":\"Cancelled\",\"expired\":true}");
            } else {
                if (!"Paid".equalsIgnoreCase(summary.getInvoicePaymentStatus())
                        && summary.getPaymentOrderCode() > 0) {
                    PayOSService payOSService = new PayOSService();
                    if (payOSService.isPaymentPaid(summary.getPaymentOrderCode())) {
                        bookingDAO.confirmInvoiceAfterPayment(invoiceId, (int) summary.getTotalAmount());
                        summary = bookingDAO.getInvoicePaymentSummary(invoiceId);
                    }
                }
                out.print("{\"success\":true,\"paymentStatus\":\""
                        + escape(summary.getInvoicePaymentStatus())
                        + "\",\"bookingCount\":" + summary.getBookingCount() + "}");
            }
        } catch (NumberFormatException e) {
            out.print("{\"success\":false,\"message\":\"Invalid invoice ID\"}");
        }
        out.flush();
    }

    private String escape(String value) {
        if (value == null) {
            return "";
        }
        return value.replace("\\", "\\\\").replace("\"", "\\\"");
    }
}