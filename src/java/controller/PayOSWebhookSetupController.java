package controller;

import config.PayOSConfig;
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import service.PayOSService;

/**
 * Gọi 1 lần để đăng ký webhook với payOS (thay cho nhập tay trên dashboard).
 * URL: /PayOSWebhookSetupController
 */
@WebServlet(name = "PayOSWebhookSetupController", urlPatterns = {"/PayOSWebhookSetupController"})
public class PayOSWebhookSetupController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        PayOSConfig.load(getServletContext());
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();

        if (!PayOSConfig.isConfigured()) {
            out.print("<h3>Chưa cấu hình payos.properties</h3>");
            return;
        }

        String base = PayOSConfig.returnBaseUrl();
        if (base == null || base.isEmpty()) {
            out.print("<h3>Thiếu payos.return.base.url trong payos.properties</h3>");
            return;
        }

        String webhookUrl = base + "/PaymentWebhookController";
        try {
            String result = new PayOSService().confirmWebhookUrl(webhookUrl);
            out.print("<h3>Đăng ký webhook thành công</h3>");
            out.print("<p>URL: " + webhookUrl + "</p>");
            out.print("<pre>" + result + "</pre>");
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("<h3>Đăng ký webhook thất bại</h3>");
            out.print("<p>" + e.getMessage() + "</p>");
            out.print("<hr><h4>Lỗi 1010 là gì?</h4>");
            out.print("<p>Cloudflare/ngrok chặn payOS gọi vào máy bạn (phổ biến với ngrok free).</p>");
            out.print("<p><b>Không cần webhook vẫn test được:</b> sau khi quét QR trả tiền, hệ thống tự kiểm tra qua returnUrl + polling.</p>");
            out.print("<p>Chỉ cần Tomcat + ngrok chạy, đặt lịch, quét QR, chờ trang chuyển sang Confirmed.</p>");
            out.print("<hr><p>Muốn webhook thật: dùng <a href='https://developers.cloudflare.com/cloudflare-one/connections/connect-networks/downloads/'>cloudflared</a> thay ngrok:<br>");
            out.print("<code>cloudflared tunnel --url http://localhost:8080</code></p>");
        }
    }
}