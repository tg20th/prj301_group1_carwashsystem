package controller;

import config.PayOSConfig;
import dao.BookingDAO;
import dao.CustomerDAO;
import dao.InvoiceDAO;
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
import service.InvoiceAutoCancelService;
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
            InvoiceAutoCancelService autoCancelService = new InvoiceAutoCancelService();
            autoCancelService.cancelExpiredPendingInvoices();

            Customer customer = new CustomerDAO().getCustomerByAccountID(account.getAccountID());
            BookingDAO bookingDAO = new BookingDAO();
            if (customer == null) {
                out.print("{\"success\":false,\"message\":\"Invalid customer\"}");
                out.flush();
                return;
            }

            String invoiceParam = request.getParameter("invoiceId");
            if (invoiceParam != null && !invoiceParam.trim().isEmpty()) {
                int invoiceId = Integer.parseInt(invoiceParam);
                InvoiceDAO invoiceDAO = new InvoiceDAO();
                if (!invoiceDAO.isInvoiceOwnedByCustomer(invoiceId, customer.getCusID())) {
                    out.print("{\"success\":false,\"message\":\"Invalid invoice\"}");
                    out.flush();
                    return;
                }

                if (autoCancelService.isInvoiceExpired(invoiceId)) {
                    bookingDAO.cancelInvoiceBookings(invoiceId);
                    out.print("{\"success\":true,\"status\":\"Cancelled\",\"paymentStatus\":\"Cancelled\",\"expired\":true}");
                    out.flush();
                    return;
                }

                BookingDAO.InvoicePaymentSummary summary = bookingDAO.getInvoicePaymentSummary(invoiceId);
                if (summary == null) {
                    out.print("{\"success\":false,\"message\":\"Not found\"}");
                } else if ("Cancelled".equalsIgnoreCase(summary.getInvoicePaymentStatus())) {
                    out.print("{\"success\":true,\"status\":\"Cancelled\",\"paymentStatus\":\"Cancelled\",\"expired\":true}");
                } else {
                    if (!"Paid".equalsIgnoreCase(summary.getInvoicePaymentStatus())
                            && summary.getPaymentOrderCode() > 0) {
                        PayOSService payOSService = new PayOSService();
                        if (payOSService.isPaymentPaid(summary.getPaymentOrderCode())) {
                            bookingDAO.confirmInvoiceAfterPayment(invoiceId, (int) summary.getTotalAmount());
                            summary = bookingDAO.getInvoicePaymentSummary(invoiceId);
                        }
                    }
                    out.print("{\"success\":true,\"status\":\""
                            + escape(summary.getLeaderBookingStatus())
                            + "\",\"paymentStatus\":\""
                            + escape(summary.getInvoicePaymentStatus()) + "\"}");
                }
                out.flush();
                return;
            }

            int bookingId = Integer.parseInt(request.getParameter("bookingId"));
            if (!bookingDAO.isBookingOwnedByCustomer(bookingId, customer.getCusID())) {
                out.print("{\"success\":false,\"message\":\"Invalid booking\"}");
                out.flush();
                return;
            }

            Booking booking = bookingDAO.getBookingForPayment(bookingId);
            if (booking == null) {
                out.print("{\"success\":false,\"message\":\"Not found\"}");
            } else {
                if (booking.getInvoiceID() > 0) {
                    BookingDAO.InvoicePaymentSummary summary = bookingDAO.getInvoicePaymentSummary(booking.getInvoiceID());
                    if (summary != null) {
                        if (!"Paid".equalsIgnoreCase(summary.getInvoicePaymentStatus())
                                && summary.getPaymentOrderCode() > 0) {
                            PayOSService payOSService = new PayOSService();
                            if (payOSService.isPaymentPaid(summary.getPaymentOrderCode())) {
                                bookingDAO.confirmInvoiceAfterPayment(booking.getInvoiceID(), (int) summary.getTotalAmount());
                                summary = bookingDAO.getInvoicePaymentSummary(booking.getInvoiceID());
                            }
                        }
                        out.print("{\"success\":true,\"status\":\""
                                + escape(summary.getLeaderBookingStatus())
                                + "\",\"paymentStatus\":\""
                                + escape(summary.getInvoicePaymentStatus()) + "\"}");
                        out.flush();
                        return;
                    }
                }

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
            out.print("{\"success\":false,\"message\":\"Invalid payment reference\"}");
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