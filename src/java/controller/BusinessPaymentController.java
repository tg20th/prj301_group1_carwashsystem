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
import java.time.LocalDateTime;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import service.InvoiceAutoCancelService;
import service.PayOSPaymentResult;
import service.PayOSService;

@WebServlet(name = "BusinessPaymentController", urlPatterns = {"/BusinessPaymentController"})
public class BusinessPaymentController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        PayOSConfig.load(getServletContext());

        Account account = (Account) request.getSession().getAttribute("ACCOUNT");
        Business business = (Business) request.getSession().getAttribute("BUS");
        if (account == null || business == null) {
            response.sendRedirect("MainController?action=home");
            return;
        }

        Customer customer = new CustomerDAO().getCustomerByAccountID(account.getAccountID());
        if (customer == null) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Business account required.");
            return;
        }

        try {
            InvoiceAutoCancelService autoCancelService = new InvoiceAutoCancelService();
            autoCancelService.cancelExpiredPendingInvoices();

            int invoiceId = Integer.parseInt(request.getParameter("invoiceId"));
            InvoiceDAO invoiceDAO = new InvoiceDAO();
            if (!invoiceDAO.isInvoiceOwnedByCustomer(invoiceId, customer.getCusID())) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "Invalid invoice");
                return;
            }

            if (autoCancelService.isInvoiceExpired(invoiceId)) {
                new BookingDAO().cancelInvoiceBookings(invoiceId);
                request.setAttribute("ERROR_MSG",
                        "Payment window expired after 15 minutes. This invoice was cancelled.");
                request.getRequestDispatcher("BusinessBookingHistoryController").forward(request, response);
                return;
            }

            BookingDAO bookingDAO = new BookingDAO();
            BookingDAO.InvoicePaymentSummary summary = bookingDAO.getInvoicePaymentSummary(invoiceId);
            if (summary == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Invoice not found");
                return;
            }

            if ("Cancelled".equalsIgnoreCase(summary.getInvoicePaymentStatus())) {
                request.setAttribute("ERROR_MSG", "This invoice has been cancelled.");
                request.getRequestDispatcher("BusinessBookingHistoryController").forward(request, response);
                return;
            }

            if ("Paid".equalsIgnoreCase(summary.getInvoicePaymentStatus())
                    || "Confirmed".equalsIgnoreCase(summary.getLeaderBookingStatus())) {
                response.sendRedirect("BusinessPaymentSuccessController?invoiceId=" + invoiceId);
                return;
            }

            List<Booking> bookings = bookingDAO.getBookingsByInvoiceId(invoiceId);
            int amount = (int) summary.getTotalAmount();

            if (!PayOSConfig.isConfigured()) {
                request.setAttribute("ERROR_MSG",
                        "payOS is not configured. Add keys to WEB-INF/payos.properties");
                request.setAttribute("INVOICE_ID", invoiceId);
                request.setAttribute("AMOUNT", amount);
                request.setAttribute("BOOKINGS", bookings);
                request.getRequestDispatcher("business_payment.jsp").forward(request, response);
                return;
            }

            String baseUrl = PayOSConfig.returnBaseUrl();
            if (baseUrl.isEmpty()) {
                baseUrl = request.getRequestURL().toString()
                        .replace(request.getRequestURI(), request.getContextPath());
            }

            long orderCode = PayOSService.generateOrderCode(summary.getLeaderBookingId());
            String returnUrl = baseUrl + "/BusinessPaymentReturnController?status=success&invoiceId=" + invoiceId;
            String cancelUrl = baseUrl + "/BusinessPaymentReturnController?status=cancel&invoiceId=" + invoiceId;

            PayOSService payOSService = new PayOSService();
            PayOSPaymentResult payment = payOSService.createPaymentLink(
                    orderCode, amount, "INV" + invoiceId, returnUrl, cancelUrl);

            LocalDateTime expiredAt = LocalDateTime.now().plusMinutes(15);
            bookingDAO.updateInvoicePaymentInfo(invoiceId, payment.getOrderCode(),
                    payment.getPaymentLinkId(), expiredAt);

            request.setAttribute("INVOICE_ID", invoiceId);
            request.setAttribute("LEADER_BOOKING_ID", summary.getLeaderBookingId());
            request.setAttribute("AMOUNT", amount);
            request.setAttribute("BOOKINGS", bookings);
            request.setAttribute("QR_CODE", payment.getQrCode());
            request.setAttribute("CHECKOUT_URL", payment.getCheckoutUrl());
            request.setAttribute("EXPIRED_AT", expiredAt);
            request.setAttribute("SANDBOX_MODE", PayOSConfig.sandboxMode());
            request.getRequestDispatcher("business_payment.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid invoice ID");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("ERROR_MSG", "Could not create payment QR: " + e.getMessage());
            request.getRequestDispatcher("business_payment.jsp").forward(request, response);
        }
    }
}