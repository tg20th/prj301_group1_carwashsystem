package controller;

import config.PayOSConfig;
import dao.BookingDAO;
import dao.CustomerDAO;
import dao.InvoiceDAO;
import dto.Account;
import dto.Booking;
import dto.Customer;
import dto.InvoiceBillingDetail;
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
            InvoiceAutoCancelService autoCancelService = new InvoiceAutoCancelService();
            autoCancelService.cancelExpiredPendingInvoices();

            int invoiceId = resolveInvoiceId(request, customer);
            if (invoiceId <= 0) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid invoice");
                return;
            }

            InvoiceDAO invoiceDAO = new InvoiceDAO();
            if (!invoiceDAO.isInvoiceOwnedByCustomer(invoiceId, customer.getCusID())) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "Invalid invoice");
                return;
            }

            if (autoCancelService.isInvoiceExpired(invoiceId)) {
                new BookingDAO().cancelInvoiceBookings(invoiceId);
                request.setAttribute("ERROR_MSG",
                        "Payment window expired after 15 minutes. This invoice was cancelled.");
                request.getRequestDispatcher("CustomerBookingHistoryController").forward(request, response);
                return;
            }

            BookingDAO bookingDAO = new BookingDAO();
            BookingDAO.InvoicePaymentSummary summary = bookingDAO.getInvoicePaymentSummary(invoiceId);
            if (summary == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND,
                        "Invoice not found or payment data unavailable.");
                return;
            }

            if ("Cancelled".equalsIgnoreCase(summary.getInvoicePaymentStatus())) {
                request.setAttribute("ERROR_MSG", "This invoice has been cancelled.");
                request.getRequestDispatcher("CustomerBookingHistoryController").forward(request, response);
                return;
            }

            if ("Paid".equalsIgnoreCase(summary.getInvoicePaymentStatus())
                    || "Confirmed".equalsIgnoreCase(summary.getLeaderBookingStatus())) {
                response.sendRedirect("PaymentSuccessController?invoiceId=" + invoiceId);
                return;
            }

            List<Booking> bookings = bookingDAO.getBookingsByInvoiceId(invoiceId);
            InvoiceBillingDetail billing = invoiceDAO.getInvoiceBillingDetail(invoiceId);
            int amount = (int) summary.getTotalAmount();

            if (!PayOSConfig.isConfigured()) {
                request.setAttribute("ERROR_MSG",
                        "payOS is not configured. Add keys to WEB-INF/payos.properties");
                setPaymentAttributes(request, invoiceId, summary.getLeaderBookingId(), amount, billing, bookings, null, null, null);
                request.getRequestDispatcher("customer_payment.jsp").forward(request, response);
                return;
            }

            String baseUrl = PayOSConfig.returnBaseUrl();
            if (baseUrl.isEmpty()) {
                baseUrl = request.getRequestURL().toString()
                        .replace(request.getRequestURI(), request.getContextPath());
            }

            long orderCode = PayOSService.generateOrderCode(summary.getLeaderBookingId());
            String returnUrl = baseUrl + "/PaymentReturnController?status=success&invoiceId=" + invoiceId;
            String cancelUrl = baseUrl + "/PaymentReturnController?status=cancel&invoiceId=" + invoiceId;

            PayOSService payOSService = new PayOSService();
            PayOSPaymentResult payment = payOSService.createPaymentLink(
                    orderCode, amount, "INV" + invoiceId, returnUrl, cancelUrl);

            LocalDateTime expiredAt = LocalDateTime.now().plusMinutes(15);
            bookingDAO.updateInvoicePaymentInfo(invoiceId, payment.getOrderCode(),
                    payment.getPaymentLinkId(), expiredAt);

            setPaymentAttributes(request, invoiceId, summary.getLeaderBookingId(), amount, billing, bookings,
                    payment.getQrCode(), payment.getCheckoutUrl(), expiredAt);
            request.getRequestDispatcher("customer_payment.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid invoice ID");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("ERROR_MSG", "Could not create payment QR: " + e.getMessage());
            request.getRequestDispatcher("customer_payment.jsp").forward(request, response);
        }
    }

    private int resolveInvoiceId(HttpServletRequest request, Customer customer) throws NumberFormatException {
        String invoiceParam = request.getParameter("invoiceId");
        if (invoiceParam != null && !invoiceParam.trim().isEmpty()) {
            return Integer.parseInt(invoiceParam);
        }

        String bookingParam = request.getParameter("bookingId");
        if (bookingParam != null && !bookingParam.trim().isEmpty()) {
            int bookingId = Integer.parseInt(bookingParam);
            BookingDAO bookingDAO = new BookingDAO();
            if (!bookingDAO.isBookingOwnedByCustomer(bookingId, customer.getCusID())) {
                return -1;
            }
            Booking booking = bookingDAO.getBookingForPayment(bookingId);
            if (booking != null && booking.getInvoiceID() > 0) {
                return booking.getInvoiceID();
            }
        }
        return -1;
    }

    private void setPaymentAttributes(HttpServletRequest request, int invoiceId, int leaderBookingId,
            int amount, InvoiceBillingDetail billing, List<Booking> bookings,
            String qrCode, String checkoutUrl, LocalDateTime expiredAt) {
        request.setAttribute("INVOICE_ID", invoiceId);
        request.setAttribute("BOOKING_ID", leaderBookingId);
        request.setAttribute("AMOUNT", amount);
        request.setAttribute("BOOKINGS", bookings);
        request.setAttribute("QR_CODE", qrCode);
        request.setAttribute("CHECKOUT_URL", checkoutUrl);
        request.setAttribute("EXPIRED_AT", expiredAt);
        request.setAttribute("SANDBOX_MODE", PayOSConfig.sandboxMode());
        if (billing != null) {
            request.setAttribute("SUB_TOTAL", (int) billing.getSubTotal());
            request.setAttribute("DISCOUNT_AMOUNT", (int) billing.getDiscountAmount());
            request.setAttribute("PROMOTION_NAME", billing.getPromotionName());
        }
    }
}