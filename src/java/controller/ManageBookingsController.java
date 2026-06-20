package controller;

import dao.BookingDAO;
import dao.InvoiceDAO;
import dto.Account;
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
import service.InvoiceHistoryJsonBuilder;

@WebServlet(name = "ManageBookingsController", urlPatterns = {"/ManageBookingsController"})
public class ManageBookingsController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Account account = (Account) request.getSession().getAttribute("ACCOUNT");
        if (account == null) {
            response.sendRedirect("MainController?action=home");
            return;
        }
        if (account.getRoleID() != 1) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Admin access required");
            return;
        }

        String action = request.getParameter("action");
        if ("detail".equals(action)) {
            handleDetail(request, response);
            return;
        }

        BookingDAO bookingDAO = new BookingDAO();
        bookingDAO.markNoShowBookings();

        String scope = request.getParameter("scope");
        if (scope == null || scope.trim().isEmpty()) {
            scope = "all";
        }

        InvoiceDAO invoiceDAO = new InvoiceDAO();
        List<InvoiceHistorySummary> invoices;
        if ("today".equalsIgnoreCase(scope)) {
            invoices = invoiceDAO.getTodayInvoiceSummariesForAdmin();
            scope = "today";
        } else {
            invoices = invoiceDAO.getAllInvoiceSummariesForAdmin();
            scope = "all";
        }

        request.setAttribute("INVOICES", invoices);
        request.setAttribute("ACTIVE_SCOPE", scope);
        request.getRequestDispatcher("booking_viewdetails.jsp").forward(request, response);
    }

    private void handleDetail(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();
        try {
            int invoiceId = Integer.parseInt(request.getParameter("invoiceId"));
            InvoiceHistoryDetail detail = new InvoiceDAO().getInvoiceHistoryDetailForAdmin(invoiceId);
            out.print(InvoiceHistoryJsonBuilder.buildDetailJson(detail));
        } catch (NumberFormatException e) {
            out.print("{\"success\":false,\"message\":\"Invalid invoice ID.\"}");
        }
        out.flush();
    }

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

    @Override
    public String getServletInfo() {
        return "Manage invoices for admin";
    }
}