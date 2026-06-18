package controller;

import dao.BookingDAO;
import dao.CustomerDAO;
import dto.Account;
import dto.Booking;
import dto.Customer;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

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
        if ("cancel".equals(action)) {
            handleCancel(request, customer);
        }

        loadHistoryPage(request, response, customer);
    }

    private void handleCancel(HttpServletRequest request, Customer customer) {
        try {
            int bookingId = Integer.parseInt(request.getParameter("bookingId"));
            BookingDAO bookingDAO = new BookingDAO();
            if (!bookingDAO.isBookingOwnedByCustomer(bookingId, customer.getCusID())) {
                request.setAttribute("ERROR_MSG", "Invalid booking selection.");
                return;
            }
            int result = bookingDAO.cancelBooking(bookingId);
            if (result > 0) {
                request.setAttribute("SUCCESS_MSG", "Booking cancelled successfully.");
            } else {
                request.setAttribute("ERROR_MSG", "Could not cancel booking. Please try again.");
            }
        } catch (NumberFormatException e) {
            request.setAttribute("ERROR_MSG", "Invalid booking ID.");
        }
    }

    private void loadHistoryPage(HttpServletRequest request, HttpServletResponse response, Customer customer)
            throws ServletException, IOException {
        BookingDAO bookingDAO = new BookingDAO();
        List<Booking> bookings = bookingDAO.getBookingsByCustomerId(customer.getCusID());
        int activeCount = bookingDAO.countActiveBookingsByCustomerId(customer.getCusID());

        request.setAttribute("BOOKINGS", bookings);
        request.setAttribute("ACTIVE_COUNT", activeCount);
        request.getRequestDispatcher("customer_booking_history.jsp").forward(request, response);
    }
}