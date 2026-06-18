package service;

import config.PayOSConfig;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.util.Map;
import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import util.PayOSJsonUtil;

public class PayOSService {

    public PayOSPaymentResult createPaymentLink(long orderCode, int amount, String description,
            String returnUrl, String cancelUrl) throws Exception {
        String desc = buildDescription(description, orderCode);
        String signatureData = "amount=" + amount
                + "&cancelUrl=" + cancelUrl
                + "&description=" + desc
                + "&orderCode=" + orderCode
                + "&returnUrl=" + returnUrl;
        String signature = hmacSha256(signatureData, PayOSConfig.checksumKey());

        long expiredAt = (System.currentTimeMillis() / 1000L) + (15 * 60);

        String body = "{"
                + "\"orderCode\":" + orderCode + ","
                + "\"amount\":" + amount + ","
                + "\"description\":\"" + PayOSJsonUtil.escapeJson(desc) + "\","
                + "\"cancelUrl\":\"" + PayOSJsonUtil.escapeJson(cancelUrl) + "\","
                + "\"returnUrl\":\"" + PayOSJsonUtil.escapeJson(returnUrl) + "\","
                + "\"expiredAt\":" + expiredAt + ","
                + "\"signature\":\"" + signature + "\""
                + "}";

        String response = postJson(PayOSConfig.baseUrl() + "/v2/payment-requests", body);
        String code = PayOSJsonUtil.extractString(response, "code");
        if (!"00".equals(code)) {
            String message = PayOSJsonUtil.extractString(response, "desc");
            throw new IllegalStateException(message != null ? message : "payOS create payment failed");
        }

        String qrCode = PayOSJsonUtil.extractString(response, "qrCode");
        String paymentLinkId = PayOSJsonUtil.extractString(response, "paymentLinkId");
        String checkoutUrl = PayOSJsonUtil.extractString(response, "checkoutUrl");
        if (qrCode == null || qrCode.isEmpty()) {
            throw new IllegalStateException("payOS did not return QR code.");
        }
        return new PayOSPaymentResult(qrCode, paymentLinkId, checkoutUrl, orderCode);
    }

    public void cancelPaymentLink(String paymentLinkId) {
        if (paymentLinkId == null || paymentLinkId.isEmpty()) {
            return;
        }
        try {
            String body = "{\"cancellationReason\":\"Booking cancelled\"}";
            postJson(PayOSConfig.baseUrl() + "/v2/payment-requests/" + paymentLinkId + "/cancel", body);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public boolean verifyWebhookSignature(String webhookJson) {
        try {
            String dataJson = PayOSJsonUtil.extractDataObject(webhookJson);
            String signature = PayOSJsonUtil.extractRootSignature(webhookJson);
            if (dataJson == null || signature == null || signature.isEmpty()) {
                return false;
            }
            Map<String, String> data = PayOSJsonUtil.parseFlatObject(dataJson);
            String transactionStr = PayOSJsonUtil.toSignatureString(data);
            String expected = hmacSha256(transactionStr, PayOSConfig.checksumKey());
            boolean valid = expected.equalsIgnoreCase(signature);
            if (!valid) {
                System.err.println("[payOS webhook] Signature mismatch.");
                System.err.println("[payOS webhook] Sign data: " + transactionStr);
            }
            return valid;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public String confirmWebhookUrl(String webhookUrl) throws Exception {
        String body = "{\"webhookUrl\":\"" + PayOSJsonUtil.escapeJson(webhookUrl) + "\"}";
        return postJson(PayOSConfig.baseUrl() + "/confirm-webhook", body);
    }

    /**
     * Kiểm tra trạng thái link thanh toán từ payOS (dùng khi webhook không hoạt động local).
     * @return PAID, PENDING, CANCELLED hoặc null nếu lỗi
     */
    public String getPaymentLinkStatus(long orderCode) {
        try {
            String response = getJson(PayOSConfig.baseUrl() + "/v2/payment-requests/" + orderCode);
            String dataJson = PayOSJsonUtil.extractDataObject(response);
            String status = dataJson != null
                    ? PayOSJsonUtil.extractString(dataJson, "status")
                    : PayOSJsonUtil.extractString(response, "status");
            if (status != null) {
                return status.toUpperCase();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean isPaymentPaid(long orderCode) {
        String status = getPaymentLinkStatus(orderCode);
        return "PAID".equalsIgnoreCase(status);
    }

    public static long generateOrderCode(int bookingId) {
        return bookingId * 1_000_000L + (System.currentTimeMillis() % 1_000_000L);
    }

    private String buildDescription(String description, long orderCode) {
        String desc = description;
        if (desc == null || desc.trim().isEmpty()) {
            desc = "BK" + orderCode;
        }
        if (desc.length() > 25) {
            desc = desc.substring(0, 25);
        }
        return desc;
    }

    private String getJson(String endpoint) throws Exception {
        URL url = new URL(endpoint);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("GET");
        conn.setConnectTimeout(15000);
        conn.setReadTimeout(15000);
        applyPayOSHeaders(conn);
        return readResponse(conn);
    }

    private String postJson(String endpoint, String jsonBody) throws Exception {
        URL url = new URL(endpoint);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("POST");
        conn.setConnectTimeout(15000);
        conn.setReadTimeout(15000);
        conn.setDoOutput(true);
        applyPayOSHeaders(conn);
        conn.setRequestProperty("Content-Type", "application/json");

        try (OutputStream os = conn.getOutputStream()) {
            os.write(jsonBody.getBytes(StandardCharsets.UTF_8));
        }

        return readResponse(conn);
    }

    private void applyPayOSHeaders(HttpURLConnection conn) {
        conn.setRequestProperty("x-client-id", PayOSConfig.clientId());
        conn.setRequestProperty("x-api-key", PayOSConfig.apiKey());
        conn.setRequestProperty("User-Agent", "AutoWashPro/1.0");
        conn.setRequestProperty("Accept", "application/json");
    }

    private String readResponse(HttpURLConnection conn) throws Exception {
        int status = conn.getResponseCode();
        BufferedReader reader;
        if (status >= 200 && status < 300) {
            reader = new BufferedReader(new InputStreamReader(conn.getInputStream(), StandardCharsets.UTF_8));
        } else {
            reader = new BufferedReader(new InputStreamReader(
                    conn.getErrorStream() != null ? conn.getErrorStream() : conn.getInputStream(),
                    StandardCharsets.UTF_8));
        }

        StringBuilder response = new StringBuilder();
        String line;
        while ((line = reader.readLine()) != null) {
            response.append(line);
        }
        reader.close();

        if (status < 200 || status >= 300) {
            throw new IllegalStateException("payOS HTTP " + status + ": " + response);
        }
        return response.toString();
    }

    public static String hmacSha256(String data, String key) throws Exception {
        Mac mac = Mac.getInstance("HmacSHA256");
        mac.init(new SecretKeySpec(key.getBytes(StandardCharsets.UTF_8), "HmacSHA256"));
        byte[] raw = mac.doFinal(data.getBytes(StandardCharsets.UTF_8));
        StringBuilder sb = new StringBuilder();
        for (byte b : raw) {
            sb.append(String.format("%02x", b));
        }
        return sb.toString();
    }
}