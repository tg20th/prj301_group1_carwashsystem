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

@WebServlet(name = "BusinessPaymentReturnController", urlPatterns = {"/BusinessPaymentReturnController"})
public class BusinessPaymentReturnController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String status = request.getParameter("status");
        String invoiceIdParam = request.getParameter("invoiceId");

        if ("cancel".equalsIgnoreCase(status) && invoiceIdParam != null) {
            try {
                int invoiceId = Integer.parseInt(invoiceIdParam);
                new BookingDAO().cancelInvoiceBookings(invoiceId);
            } catch (NumberFormatException ignored) {
            }
            response.sendRedirect(PayOSConfig.appPath("/BusinessBookingController"));
            return;
        }

        if (invoiceIdParam != null) {
            try {
                int invoiceId = Integer.parseInt(invoiceIdParam);
                tryConfirmPayment(invoiceId);
            } catch (NumberFormatException ignored) {
            }
            response.sendRedirect(PayOSConfig.appPath(
                    "/BusinessPaymentSuccessController?invoiceId=" + invoiceIdParam));
            return;
        }

        response.sendRedirect(PayOSConfig.appPath("/BusinessDashboardController"));
    }

    private void tryConfirmPayment(int invoiceId) {
        PayOSConfig.load(getServletContext());
        BookingDAO bookingDAO = new BookingDAO();
        BookingDAO.InvoicePaymentSummary summary = bookingDAO.getInvoicePaymentSummary(invoiceId);
        if (summary == null || summary.getPaymentOrderCode() <= 0) {
            return;
        }
        if ("Paid".equalsIgnoreCase(summary.getInvoicePaymentStatus())) {
            return;
        }

        PayOSService payOSService = new PayOSService();
        if (payOSService.isPaymentPaid(summary.getPaymentOrderCode())) {
            bookingDAO.confirmInvoiceAfterPayment(invoiceId, (int) summary.getTotalAmount());
        }
    }
}