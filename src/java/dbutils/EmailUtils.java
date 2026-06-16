package dbutils;

import java.util.Properties;
import javax.mail.Authenticator;
import javax.mail.Message;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

public class EmailUtils {

    // Thông tin cấu hình Mailtrap SMTP
    private static final String HOST = "sandbox.smtp.mailtrap.io";
    private static final String PORT = "2525";
    private static final String USERNAME = "72caa3aa3bfe1e";
    private static final String PASSWORD = "5b52135da0f24f";
    
    // Đường dẫn hệ thống (Có thể chuyển vào file config sau này)
    private static final String SYSTEM_URL = "http://localhost:8080/CarWashSystem_backup/MainController?action=home";

    private static Session getSession() {
        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", HOST);
        props.put("mail.smtp.port", PORT);

        return Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(USERNAME, PASSWORD);
            }
        });
    }

    public static boolean sendEmail(String receiver, String subject, String htmlContent) {
        try {
            Session session = getSession();
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress("noreply@eliteauto.com", "Elite Auto System"));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(receiver));
            message.setSubject(subject);
            message.setContent(htmlContent, "text/html; charset=UTF-8");

            Transport.send(message);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Tạo template email cơ sở dùng chung cho mọi email - Chuẩn phong cách Soft UI
     */
    private static String getBaseEmailTemplate(String headerTitle, String bodyContent) {
        // Sử dụng nền ngoài màu xám nhạt (như bg-light), khung trong màu trắng bo góc lớn (như rounded-4)
        return "<div style=\"font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif; background-color: #f9fafb; padding: 40px 20px; line-height: 1.6;\">"
             + "  <div style=\"max-width: 600px; margin: 0 auto; background-color: #ffffff; border-radius: 20px; overflow: hidden; box-shadow: 0 4px 15px rgba(0,0,0,0.03); border: 1px solid #f1f3f5;\">"
             
             // --- Header (Logo / Title) ---
             // Màu nền tối, chữ sáng để khớp với nút Dark theme trên web
             + "    <div style=\"background-color: #0a0a0a; padding: 30px 40px; text-align: center;\">"
             + "      <h1 style=\"color: #ffffff; margin: 0; font-size: 22px; font-weight: 700; letter-spacing: 0.5px;\">EliteAuto</h1>"
             + "    </div>"
             
             // --- Body Content ---
             + "    <div style=\"padding: 40px; color: #4a5568; font-size: 15px;\">"
             // Tiêu đề của loại Email
             + "      <h2 style=\"color: #111827; margin-top: 0; font-size: 20px; font-weight: 600; margin-bottom: 25px;\">" + headerTitle + "</h2>"
             +        bodyContent
             + "    </div>"
             
             // --- Footer ---
             + "    <div style=\"background-color: #ffffff; padding: 20px 40px 30px; text-align: center; color: #9ca3af; font-size: 13px; border-top: 1px solid #f3f4f6;\">"
             + "      <p style=\"margin: 0; font-weight: 500;\">© 2026 Elite Auto Car Wash System.</p>"
             + "      <p style=\"margin: 6px 0 0 0;\">This is an automated message, please do not reply.</p>"
             + "    </div>"
             
             + "  </div>"
             + "</div>";
    }

    public static void sendApproveEmail(String email, String businessName) {
        String subject = "Elite Auto - Business Registration Approved";
        
        // Nội dung chính của email Approve (Thêm style nhẹ nhàng, text xám đậm)
        String body = "<p style=\"margin-bottom: 16px;\">Dear <b>" + businessName + "</b>,</p>"
                + "<p style=\"margin-bottom: 16px;\">Congratulations! Your business account has been successfully verified and approved by our administrators.</p>"
                + "<p style=\"margin-bottom: 24px;\">You can now access the Car Wash Management System to start setting up your services and managing appointments.</p>"
                
                // Nút bấm kiểu Rounded-Pill (Bo tròn hai đầu), tông màu đen trắng sang trọng thay vì màu xanh lá
                + "<div style=\"text-align: center; margin: 35px 0;\">"
                + "  <a href=\"" + SYSTEM_URL + "\" style=\"background-color: #0a0a0a; color: #ffffff; padding: 12px 32px; text-decoration: none; border-radius: 50px; font-weight: 500; font-size: 15px; display: inline-block; transition: background-color 0.3s;\">Login to Your Dashboard</a>"
                + "</div>"
                
                + "<p style=\"margin-bottom: 10px;\">If you have any questions, feel free to contact our support team.</p>"
                + "<p style=\"margin: 0;\">Best regards,<br><b style=\"color: #111827;\">The Elite Auto Team</b></p>";

        String finalHtml = getBaseEmailTemplate("Registration Approved \u2705", body);
        sendEmail(email, subject, finalHtml);
    }

    public static void sendRevisionEmail(String email, String businessName, String reason) {
        String subject = "Elite Auto - Application Rejected";
        
        // Nội dung chính của email Reject/Revision
        String body = "<p style=\"margin-bottom: 16px;\">Dear <b>" + businessName + "</b>,</p>"
                + "<p style=\"margin-bottom: 20px;\">Thank you for registering with Elite Auto. We have carefully reviewed your application, but unfortunately, we cannot approve it at this time.</p>"
                
                // Khung cảnh báo (Badge soft-danger) phong cách như web
                + "<div style=\"background-color: rgba(220, 53, 69, 0.05); border-left: 4px solid #dc3545; padding: 20px; margin: 25px 0; border-radius: 0 8px 8px 0;\">"
                + "  <p style=\"margin: 0 0 8px 0; color: #b02a37; font-weight: 600; font-size: 13px; text-transform: uppercase; letter-spacing: 0.5px;\">Rejection Reason</p>"
                + "  <p style=\"margin: 0; color: #495057;\">" + reason + "</p>"
                + "</div>"
                
                + "<p style=\"margin-bottom: 24px;\">Please log in to your account to review your submission and update the required information.</p>"
                
                // Nút bấm viền (Outline button) phong cách hiện đại
                + "<div style=\"text-align: center; margin: 35px 0;\">"
                + "  <a href=\"" + SYSTEM_URL + "\" style=\"background-color: #ffffff; color: #0a0a0a; border: 1px solid #e5e7eb; padding: 12px 32px; text-decoration: none; border-radius: 50px; font-weight: 500; font-size: 15px; display: inline-block;\">Update Information</a>"
                + "</div>"
                
                + "<p style=\"margin: 0;\">Best regards,<br><b style=\"color: #111827;\">The Elite Auto Team</b></p>";

        String finalHtml = getBaseEmailTemplate("Action Required: Revision \u26A0\uFE0F", body);
        sendEmail(email, subject, finalHtml);
    }
}