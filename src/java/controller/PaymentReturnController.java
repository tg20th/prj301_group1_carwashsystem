package controller;

import config.PayOSConfig;
import dao.BookingDAO;
import dto.Booking;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import service.PayOSService;

@WebServlet(name = "PaymentReturnController", urlPatterns = {"/PaymentReturnController"})
public class PaymentReturnController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String status = request.getParameter("status");
        String bookingIdParam = request.getParameter("bookingId");

        if ("cancel".equalsIgnoreCase(status) && bookingIdParam != null) {
            try {
                int bookingId = Integer.parseInt(bookingIdParam);
                new BookingDAO().cancelBooking(bookingId);
            } catch (NumberFormatException ignored) {
            }
            response.sendRedirect(PayOSConfig.appPath("/CustomerBookingController"));
            return;
        }

        if (bookingIdParam != null) {
            try {
                int bookingId = Integer.parseInt(bookingIdParam);
                tryConfirmPayment(bookingId);
            } catch (NumberFormatException ignored) {
            }
            response.sendRedirect(PayOSConfig.appPath(
                    "/PaymentSuccessController?bookingId=" + bookingIdParam));
            return;
        }

        response.sendRedirect(PayOSConfig.appPath("/CustomerDashBoardController"));
    }

    private void tryConfirmPayment(int bookingId) {
        PayOSConfig.load(getServletContext());
        BookingDAO bookingDAO = new BookingDAO();
        Booking booking = bookingDAO.getBookingForPayment(bookingId);
        if (booking == null || booking.getPaymentOrderCode() <= 0) {
            return;
        }
        if ("Paid".equalsIgnoreCase(booking.getPaymentStatus())
                || "Confirmed".equalsIgnoreCase(booking.getStatus())) {
            return;
        }

        PayOSService payOSService = new PayOSService();
        if (payOSService.isPaymentPaid(booking.getPaymentOrderCode())) {
            int amount = (int) Math.round(booking.getPriceAtOrder() * booking.getQuantity());
            bookingDAO.confirmAfterPayment(bookingId, amount);
        }
    }
}