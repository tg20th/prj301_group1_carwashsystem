package controller;

import config.PayOSConfig;
import dao.BookingDAO;
import dao.CustomerDAO;
import dto.Account;
import dto.Booking;
import dto.Customer;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Giả lập thanh toán thành công — chỉ hoạt động khi payos.sandbox.mode=true.
 */
@WebServlet(name = "PaymentSandboxController", urlPatterns = {"/PaymentSandboxController"})
public class PaymentSandboxController extends HttpServlet {

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
        if (account == null) {
            response.sendRedirect("MainController?action=home");
            return;
        }

        Customer customer = new CustomerDAO().getCustomerByAccountID(account.getAccountID());
        if (customer == null) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Customer account required.");
            return;
        }

        try {
            int bookingId = Integer.parseInt(request.getParameter("bookingId"));
            BookingDAO bookingDAO = new BookingDAO();
            if (!bookingDAO.isBookingOwnedByCustomer(bookingId, customer.getCusID())) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "Invalid booking");
                return;
            }

            Booking booking = bookingDAO.getBookingForPayment(bookingId);
            if (booking == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Booking not found");
                return;
            }

            if ("Confirmed".equalsIgnoreCase(booking.getStatus())
                    || "Paid".equalsIgnoreCase(booking.getPaymentStatus())) {
                response.sendRedirect("PaymentSuccessController?bookingId=" + bookingId);
                return;
            }

            int amount = (int) Math.round(booking.getPriceAtOrder() * booking.getQuantity());
            if (bookingDAO.confirmAfterPayment(bookingId, amount)) {
                response.sendRedirect("PaymentSuccessController?bookingId=" + bookingId + "&sandbox=1");
            } else {
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Sandbox confirm failed");
            }
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid booking ID");
        }
    }
}