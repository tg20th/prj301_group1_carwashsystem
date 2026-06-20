package controller;

import dao.BookingDAO;
import dao.CustomerDAO;
import dao.InvoiceDAO;
import dto.Account;
import dto.Customer;
import dto.InvoiceHistoryDetail;
import dto.InvoiceHistorySummary;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import service.InvoiceAutoCancelService;
import service.InvoiceHistoryHelper;
import service.InvoiceHistoryJsonBuilder;

@WebServlet(name = "CustomerBookingHistoryController", urlPatterns = {"/CustomerBookingHistoryController"})
public class CustomerBookingHistoryController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Account account = (Account) request.getSession().getAttribute("ACCOUNT");
        if (account == null) {
            response.sendRedirect("MainController?action=home");
            return;
        }

        Customer customer = new CustomerDAO().getCustomerByAccountID(account.getAccountID());
        if (customer == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Customer not found");
            return;
        }

        String action = request.getParameter("action");
        if ("detail".equals(action)) {
            handleDetail(request, response, customer);
            return;
        }

        if ("cancelInvoice".equals(action)) {
            handleCancelInvoice(request, customer);
        }

        loadHistoryPage(request, response, customer);
    }

    private void handleDetail(HttpServletRequest request, HttpServletResponse response, Customer customer)
            throws IOException {
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();
        try {
            int invoiceId = Integer.parseInt(request.getParameter("invoiceId"));
            InvoiceHistoryDetail detail = new InvoiceDAO().getInvoiceHistoryDetail(invoiceId, customer.getCusID());
            out.print(InvoiceHistoryJsonBuilder.buildDetailJson(detail));
        } catch (NumberFormatException e) {
            out.print("{\"success\":false,\"message\":\"Invalid invoice ID.\"}");
        }
        out.flush();
    }

    private void handleCancelInvoice(HttpServletRequest request, Customer customer) {
        try {
            int invoiceId = Integer.parseInt(request.getParameter("invoiceId"));
            InvoiceDAO invoiceDAO = new InvoiceDAO();
            if (!invoiceDAO.isInvoiceOwnedByCustomer(invoiceId, customer.getCusID())) {
                request.setAttribute("ERROR_MSG", "Invalid invoice selection.");
                return;
            }
            InvoiceHistoryDetail detail = invoiceDAO.getInvoiceHistoryDetail(invoiceId, customer.getCusID());
            if (detail == null || !InvoiceHistoryHelper.canCancelInvoice(detail.getBookings())) {
                request.setAttribute("ERROR_MSG", "This invoice can no longer be cancelled.");
                return;
            }
            int result = new BookingDAO().cancelInvoiceBookings(invoiceId);
            if (result > 0) {
                request.setAttribute("SUCCESS_MSG", "Invoice #" + invoiceId + " was cancelled successfully.");
            } else {
                request.setAttribute("ERROR_MSG", "Could not cancel invoice. Please try again.");
            }
        } catch (NumberFormatException e) {
            request.setAttribute("ERROR_MSG", "Invalid invoice ID.");
        }
    }

    private void loadHistoryPage(HttpServletRequest request, HttpServletResponse response, Customer customer)
            throws ServletException, IOException {
        new InvoiceAutoCancelService().cancelExpiredPendingInvoices();

        BookingDAO bookingDAO = new BookingDAO();
        InvoiceDAO invoiceDAO = new InvoiceDAO();
        List<InvoiceHistorySummary> invoices = invoiceDAO.getInvoiceHistorySummaries(customer.getCusID());
        int activeCount = bookingDAO.countActiveBookingsByCustomerId(customer.getCusID());

        request.setAttribute("INVOICES", invoices);
        request.setAttribute("ACTIVE_COUNT", activeCount);
        request.getRequestDispatcher("customer_booking_history.jsp").forward(request, response);
    }
}