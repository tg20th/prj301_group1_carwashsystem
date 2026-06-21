package controller;

import dao.CustomerDAO;
import dao.InvoiceDAO;
import dto.Account;
import dto.Customer;
import dto.InvoiceHistoryDetail;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "InvoicePrintController", urlPatterns = {"/InvoicePrint"})
public class InvoicePrintController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Account account = (Account) request.getSession().getAttribute("ACCOUNT");
        if (account == null) {
            response.sendRedirect("MainController?action=home");
            return;
        }

        String invoiceIdParam = request.getParameter("invoiceId");
        if (invoiceIdParam == null || invoiceIdParam.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing invoice ID");
            return;
        }

        try {
            int invoiceId = Integer.parseInt(invoiceIdParam);
            InvoiceDAO invoiceDAO = new InvoiceDAO();
            InvoiceHistoryDetail detail;

            if (account.getRoleID() == 1) {
                detail = invoiceDAO.getInvoiceHistoryDetailForAdmin(invoiceId);
            } else {
                Customer customer = new CustomerDAO().getCustomerByAccountID(account.getAccountID());
                if (customer == null || !invoiceDAO.isInvoiceOwnedByCustomer(invoiceId, customer.getCusID())) {
                    response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
                    return;
                }
                detail = invoiceDAO.getInvoiceHistoryDetail(invoiceId, customer.getCusID());
            }

            if (detail == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Invoice not found");
                return;
            }

            request.setAttribute("INVOICE", detail);
            request.getRequestDispatcher("invoice_print.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid invoice ID");
        }
    }
}