package controller;

import config.PayOSConfig;
import dao.BookingDAO;
import dto.Booking;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.nio.charset.StandardCharsets;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import service.PayOSService;
import util.PayOSJsonUtil;

@WebServlet(name = "PaymentWebhookController", urlPatterns = {"/PaymentWebhookController"})
public class PaymentWebhookController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setStatus(HttpServletResponse.SC_OK);
        response.setContentType("text/plain;charset=UTF-8");
        response.getWriter().print("payOS webhook endpoint is running");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        PayOSConfig.load(getServletContext());
        String body = readBody(request);

        if (body == null || body.trim().isEmpty()) {
            respond(response, HttpServletResponse.SC_BAD_REQUEST, "EMPTY_BODY");
            return;
        }

        PayOSService payOSService = new PayOSService();
        if (!payOSService.verifyWebhookSignature(body)) {
            System.err.println("[payOS webhook] Invalid signature. Body: " + body);
            respond(response, HttpServletResponse.SC_BAD_REQUEST, "INVALID_SIGNATURE");
            return;
        }

        String code = PayOSJsonUtil.extractRootCode(body);
        if (code == null || !"00".equals(code)) {
            respond(response, HttpServletResponse.SC_OK, "IGNORED");
            return;
        }

        String dataJson = PayOSJsonUtil.extractDataObject(body);
        Long orderCode = PayOSJsonUtil.extractLong(dataJson, "orderCode");
        Long amount = PayOSJsonUtil.extractLong(dataJson, "amount");
        if (orderCode == null || amount == null) {
            respond(response, HttpServletResponse.SC_BAD_REQUEST, "MISSING_FIELDS");
            return;
        }

        BookingDAO bookingDAO = new BookingDAO();
        Booking booking = bookingDAO.getByPaymentOrderCode(orderCode);
        if (booking == null) {
            // payOS gửi orderCode mẫu (123) khi test webhook — vẫn trả 200
            respond(response, HttpServletResponse.SC_OK, "TEST_OK");
            return;
        }

        if ("Paid".equalsIgnoreCase(booking.getPaymentStatus())
                || "Confirmed".equalsIgnoreCase(booking.getStatus())) {
            respond(response, HttpServletResponse.SC_OK, "ALREADY_CONFIRMED");
            return;
        }

        boolean ok;
        if (booking.getInvoiceID() > 0) {
            ok = bookingDAO.confirmInvoiceAfterPayment(booking.getInvoiceID(), amount.intValue());
        } else {
            ok = bookingDAO.confirmAfterPayment(booking.getBookingID(), amount.intValue());
        }
        respond(response, ok ? HttpServletResponse.SC_OK : HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                ok ? "OK" : "FAIL");
    }

    private void respond(HttpServletResponse response, int status, String message) throws IOException {
        response.setStatus(status);
        response.setContentType("text/plain;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            out.print(message);
        }
    }

    private String readBody(HttpServletRequest request) throws IOException {
        StringBuilder sb = new StringBuilder();
        try (BufferedReader reader = new BufferedReader(
                new InputStreamReader(request.getInputStream(), StandardCharsets.UTF_8))) {
            String line;
            while ((line = reader.readLine()) != null) {
                sb.append(line);
            }
        }
        return sb.toString();
    }
}