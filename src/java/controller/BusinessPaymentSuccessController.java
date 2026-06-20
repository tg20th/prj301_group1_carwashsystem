package controller;

import config.PayOSConfig;
import dao.BookingDAO;
import dao.CustomerDAO;
import dao.InvoiceDAO;
import dto.Account;
import dto.Booking;
import dto.Business;
import dto.Customer;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "BusinessPaymentSuccessController", urlPatterns = {"/BusinessPaymentSuccessController"})
public class BusinessPaymentSuccessController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        PayOSConfig.load(getServletContext());

        Account account = (Account) request.getSession().getAttribute("ACCOUNT");
        Business business = (Business) request.getSession().getAttribute("BUS");
        if (account == null || business == null) {
            response.sendRedirect("MainController?action=home");
            return;
        }

        try {
            int invoiceId = Integer.parseInt(request.getParameter("invoiceId"));
            Customer customer = new CustomerDAO().getCustomerByAccountID(account.getAccountID());
            if (customer == null || !new InvoiceDAO().isInvoiceOwnedByCustomer(invoiceId, customer.getCusID())) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "Invalid invoice");
                return;
            }

            BookingDAO bookingDAO = new BookingDAO();
            List<Booking> bookings = bookingDAO.getBookingsByInvoiceId(invoiceId);
            request.setAttribute("INVOICE_ID", invoiceId);
            request.setAttribute("BOOKINGS", bookings);
            request.setAttribute("SANDBOX", "1".equals(request.getParameter("sandbox")));
            request.getRequestDispatcher("business_payment_success.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid invoice ID");
        }
    }
}