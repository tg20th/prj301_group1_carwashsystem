<%@page import="java.util.List"%>
<%@page import="dto.Booking"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    Integer invoiceId = (Integer) request.getAttribute("INVOICE_ID");
    List<Booking> bookings = (List<Booking>) request.getAttribute("BOOKINGS");
    Boolean sandbox = (Boolean) request.getAttribute("SANDBOX");
    if (sandbox == null) sandbox = false;
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thanh toán thành công | Business</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="css/style.css" rel="stylesheet">
    <link href="css/business.css" rel="stylesheet">
</head>
<body class="bus-page d-flex flex-column min-vh-100">
    <div class="bg-white border-bottom py-2 shadow-sm">
        <div class="container">
            <a href="MainController?action=business_dashboard" class="text-decoration-none text-dark fw-semibold small">
                <i class="bi bi-building me-1"></i>EliteAuto Business
            </a>
        </div>
    </div>

    <div class="flex-grow-1 d-flex align-items-center justify-content-center p-3">
        <div class="bus-card p-4 p-md-5 text-center" style="max-width:480px;width:100%;">
            <i class="bi bi-check-circle-fill text-success" style="font-size:3rem;"></i>
            <h4 class="fw-bold mt-3 mb-2">Thanh toán thành công!</h4>
            <% if (sandbox) { %>
            <span class="badge bg-warning text-dark mb-2">Sandbox</span>
            <% } %>
            <p class="text-muted small mb-0">
                Hóa đơn #<%= invoiceId != null ? invoiceId : "—" %> —
                <%= bookings != null ? bookings.size() : 0 %> booking đã được xác nhận.
            </p>

            <% if (bookings != null && !bookings.isEmpty()) { %>
            <div class="small mt-4 text-start">
                <% for (Booking b : bookings) { %>
                <div class="d-flex justify-content-between align-items-center border-bottom py-2">
                    <div>
                        <div class="fw-semibold">#<%= b.getBookingID() %> — <%= b.getLicensePlate() %></div>
                        <div class="text-muted"><%= b.getService() %> · <%= b.getBayName() %></div>
                    </div>
                    <span class="badge bg-success-subtle text-success border border-success-subtle"><%= b.getStatus() %></span>
                </div>
                <% } %>
            </div>
            <% } %>

            <p class="text-muted small mt-3 mb-0">Điểm thưởng đã được cộng cho tổng hóa đơn.</p>

            <div class="d-grid gap-2 mt-4">
                <a href="MainController?action=viewbusinesshistory" class="btn btn-black rounded-pill">Xem lịch sử booking</a>
                <a href="MainController?action=business_booking" class="btn btn-outline-dark rounded-pill">Đặt thêm lịch</a>
                <a href="MainController?action=business_dashboard" class="btn btn-outline-secondary rounded-pill">Về Dashboard</a>
            </div>
        </div>
    </div>
</body>
</html>