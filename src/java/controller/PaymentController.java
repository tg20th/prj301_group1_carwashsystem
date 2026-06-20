package controller;

import config.PayOSConfig;
import dao.BookingDAO;
import dao.CustomerDAO;
import dto.Account;
import dto.Booking;
import dto.Customer;
import java.io.IOException;
import java.time.LocalDateTime;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import service.PayOSPaymentResult;
import service.PayOSService;

@WebServlet(name = "PaymentController", urlPatterns = {"/PaymentController"})
public class PaymentController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        PayOSConfig.load(getServletContext());

        Account account = (Account) request.getSession().getAttribute("ACCOUNT");
        if (account == null) {
            response.sendRedirect("MainController?action=home");
            return;
        }

        Customer customer = new CustomerDAO().getCustomerByAccountID(account.getAccountID());
        if (customer == null) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN,
                    "Only customer accounts can pay online. Please log in as a customer.");
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
                response.sendError(HttpServletResponse.SC_NOT_FOUND,
                        "Booking not found or payment data unavailable. Re-run sql/Data.sql payment patch if needed.");
                return;
            }

            if ("Confirmed".equalsIgnoreCase(booking.getStatus())
                    || "Paid".equalsIgnoreCase(booking.getPaymentStatus())) {
                response.sendRedirect("PaymentSuccessController?bookingId=" + bookingId);
                return;
            }

            if (!PayOSConfig.isConfigured()) {
                request.setAttribute("ERROR_MSG",
                        "payOS is not configured. Add keys to WEB-INF/payos.properties");
                request.getRequestDispatcher("customer_payment.jsp").forward(request, response);
                return;
            }

            String baseUrl = PayOSConfig.returnBaseUrl();
            if (baseUrl.isEmpty()) {
                baseUrl = request.getRequestURL().toString()
                        .replace(request.getRequestURI(), request.getContextPath());
            }

            int amount = (int) Math.round(booking.getPriceAtOrder() * booking.getQuantity());
            long orderCode = PayOSService.generateOrderCode(bookingId);
            String returnUrl = baseUrl + "/PaymentReturnController?status=success&bookingId=" + bookingId;
            String cancelUrl = baseUrl + "/PaymentReturnController?status=cancel&bookingId=" + bookingId;

            PayOSService payOSService = new PayOSService();
            PayOSPaymentResult payment = payOSService.createPaymentLink(
                    orderCode, amount, "BK" + bookingId, returnUrl, cancelUrl);

            LocalDateTime expiredAt = LocalDateTime.now().plusMinutes(15);
            bookingDAO.updatePaymentInfo(bookingId, payment.getOrderCode(),
                    payment.getPaymentLinkId(), expiredAt);

            request.setAttribute("BOOKING_ID", bookingId);
            request.setAttribute("AMOUNT", amount);
            request.setAttribute("QR_CODE", payment.getQrCode());
            request.setAttribute("CHECKOUT_URL", payment.getCheckoutUrl());
            request.setAttribute("EXPIRED_AT", expiredAt);
            request.setAttribute("SANDBOX_MODE", PayOSConfig.sandboxMode());
            request.getRequestDispatcher("customer_payment.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid booking ID");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("ERROR_MSG", "Could not create payment QR: " + e.getMessage());
            request.getRequestDispatcher("customer_payment.jsp").forward(request, response);
        }
    }
}