package controller;

import config.PayOSConfig;
import dao.BookingDAO;
import dao.CustomerDAO;
import dto.Account;
import dto.Booking;
import dto.Customer;
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import service.PayOSService;

@WebServlet(name = "PaymentStatusController", urlPatterns = {"/PaymentStatusController"})
public class PaymentStatusController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        PayOSConfig.load(getServletContext());
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();

        Account account = (Account) request.getSession().getAttribute("ACCOUNT");
        if (account == null) {
            out.print("{\"success\":false,\"message\":\"Unauthorized\"}");
            out.flush();
            return;
        }

        try {
            int bookingId = Integer.parseInt(request.getParameter("bookingId"));
            Customer customer = new CustomerDAO().getCustomerByAccountID(account.getAccountID());
            BookingDAO bookingDAO = new BookingDAO();
            if (customer == null || !bookingDAO.isBookingOwnedByCustomer(bookingId, customer.getCusID())) {
                out.print("{\"success\":false,\"message\":\"Invalid booking\"}");
                out.flush();
                return;
            }

            Booking booking = bookingDAO.getBookingForPayment(bookingId);
            if (booking == null) {
                out.print("{\"success\":false,\"message\":\"Not found\"}");
            } else {
                if (!"Paid".equalsIgnoreCase(booking.getPaymentStatus())
                        && booking.getPaymentOrderCode() > 0) {
                    PayOSService payOSService = new PayOSService();
                    if (payOSService.isPaymentPaid(booking.getPaymentOrderCode())) {
                        int amount = (int) Math.round(booking.getPriceAtOrder() * booking.getQuantity());
                        bookingDAO.confirmAfterPayment(bookingId, amount);
                        booking = bookingDAO.getBookingForPayment(bookingId);
                    }
                }
                out.print("{\"success\":true,\"status\":\""
                        + escape(booking.getStatus())
                        + "\",\"paymentStatus\":\""
                        + escape(booking.getPaymentStatus()) + "\"}");
            }
        } catch (NumberFormatException e) {
            out.print("{\"success\":false,\"message\":\"Invalid booking ID\"}");
        }
        out.flush();
    }

    private String escape(String value) {
        if (value == null) {
            return "";
        }
        return value.replace("\\", "\\\\").replace("\"", "\\\"");
    }
}