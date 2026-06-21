package controller;

import config.PayOSConfig;
import dao.BookingDAO;
import dao.CustomerDAO;
import dao.InvoiceDAO;
import dto.Account;
import dto.Business;
import dto.Customer;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "BusinessPaymentSandboxController", urlPatterns = {"/BusinessPaymentSandboxController"})
public class BusinessPaymentSandboxController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        process(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        process(request, response);
    }

    private void process(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        PayOSConfig.load(getServletContext());

        if (!PayOSConfig.sandboxMode()) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Sandbox payment is disabled.");
            return;
        }

        Account account = (Account) request.getSession().getAttribute("ACCOUNT");
        Business business = (Business) request.getSession().getAttribute("BUS");
        if (account == null || business == null) {
            response.sendRedirect("MainController?action=home");
            return;
        }

        Customer customer = new CustomerDAO().getCustomerByAccountID(account.getAccountID());
        if (customer == null) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Business account required.");
            return;
        }

        try {
            int invoiceId = Integer.parseInt(request.getParameter("invoiceId"));
            InvoiceDAO invoiceDAO = new InvoiceDAO();
            if (!invoiceDAO.isInvoiceOwnedByCustomer(invoiceId, customer.getCusID())) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "Invalid invoice");
                return;
            }

            BookingDAO bookingDAO = new BookingDAO();
            BookingDAO.InvoicePaymentSummary summary = bookingDAO.getInvoicePaymentSummary(invoiceId);
            if (summary == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Invoice not found");
                return;
            }

            if ("Paid".equalsIgnoreCase(summary.getInvoicePaymentStatus())) {
                response.sendRedirect("MainController?action=business_payment_success&invoiceId=" + invoiceId);
                return;
            }

            if (bookingDAO.confirmInvoiceAfterPayment(invoiceId, (int) summary.getTotalAmount())) {
                response.sendRedirect("MainController?action=business_payment_success&invoiceId=" + invoiceId + "&sandbox=1");
            } else {
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Sandbox confirm failed");
            }
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid invoice ID");
        }
    }
}