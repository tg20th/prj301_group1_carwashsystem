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
        String invoiceIdParam = request.getParameter("invoiceId");
        String bookingIdParam = request.getParameter("bookingId");

        if ("cancel".equalsIgnoreCase(status)) {
            BookingDAO bookingDAO = new BookingDAO();
            if (invoiceIdParam != null) {
                try {
                    bookingDAO.cancelInvoiceBookings(Integer.parseInt(invoiceIdParam));
                } catch (NumberFormatException ignored) {
                }
            } else if (bookingIdParam != null) {
                try {
                    int bookingId = Integer.parseInt(bookingIdParam);
                    BookingDAO bookingDAOLegacy = new BookingDAO();
                    bookingDAOLegacy.cancelBooking(bookingId);
                } catch (NumberFormatException ignored) {
                }
            }
            response.sendRedirect(PayOSConfig.appPath("/CustomerBookingController"));
            return;
        }

        if (invoiceIdParam != null) {
            try {
                int invoiceId = Integer.parseInt(invoiceIdParam);
                tryConfirmInvoicePayment(invoiceId);
                response.sendRedirect(PayOSConfig.appPath(
                        "/PaymentSuccessController?invoiceId=" + invoiceId));
            } catch (NumberFormatException ignored) {
                response.sendRedirect(PayOSConfig.appPath("/CustomerDashBoardController"));
            }
            return;
        }

        if (bookingIdParam != null) {
            try {
                int bookingId = Integer.parseInt(bookingIdParam);
                BookingDAO bookingDAO = new BookingDAO();
                Booking booking = bookingDAO.getBookingForPayment(bookingId);
                if (booking != null && booking.getInvoiceID() > 0) {
                    tryConfirmInvoicePayment(booking.getInvoiceID());
                    response.sendRedirect(PayOSConfig.appPath(
                            "/PaymentSuccessController?invoiceId=" + booking.getInvoiceID()));
                    return;
                }
                tryConfirmLegacyBookingPayment(bookingId);
            } catch (NumberFormatException ignored) {
            }
            response.sendRedirect(PayOSConfig.appPath(
                    "/PaymentSuccessController?bookingId=" + bookingIdParam));
            return;
        }

        response.sendRedirect(PayOSConfig.appPath("/CustomerDashBoardController"));
    }

    private void tryConfirmInvoicePayment(int invoiceId) {
        PayOSConfig.load(getServletContext());
        BookingDAO bookingDAO = new BookingDAO();
        BookingDAO.InvoicePaymentSummary summary = bookingDAO.getInvoicePaymentSummary(invoiceId);
        if (summary == null || summary.getLeaderBookingId() <= 0 || summary.getPaymentOrderCode() <= 0) {
            return;
        }
        if ("Paid".equalsIgnoreCase(summary.getInvoicePaymentStatus())
                || "Confirmed".equalsIgnoreCase(summary.getLeaderBookingStatus())) {
            return;
        }

        PayOSService payOSService = new PayOSService();
        if (payOSService.isPaymentPaid(summary.getPaymentOrderCode())) {
            bookingDAO.confirmInvoiceAfterPayment(invoiceId, (int) summary.getTotalAmount());
        }
    }

    private void tryConfirmLegacyBookingPayment(int bookingId) {
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