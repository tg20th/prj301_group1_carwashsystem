<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>


<c:if test="account == null">
    <jsp:forward page="MainController?action=home"/>
</c:if>
<%
    String bookingId = (String) request.getAttribute("BOOKING_ID");
    if (bookingId == null) {
        bookingId = request.getParameter("bookingId");
    }
    Boolean sandbox = (Boolean) request.getAttribute("SANDBOX");
    if (sandbox == null) {
        sandbox = "1".equals(request.getParameter("sandbox"));
    }
    String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thanh toán thành công | Elite Auto</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link href="<%= ctx %>/css/style.css" rel="stylesheet">
</head>
<body class="bg-light d-flex align-items-center justify-content-center min-vh-100 p-3">
    <div class="card border-0 shadow-sm rounded-4 text-center p-4" style="max-width: 420px;">
        <i class="bi bi-check-circle-fill text-success" style="font-size: 3rem;"></i>
        <h4 class="fw-bold mt-3">Thanh toán thành công!</h4>
        <% if (sandbox) { %>
        <span class="badge bg-warning text-dark mb-2">Sandbox — không trừ tiền thật</span>
        <% } %>
        <p class="text-muted small mb-1">Booking #<%= bookingId != null ? bookingId : "—" %> đã được xác nhận.</p>
        <p class="text-muted small">Điểm thưởng đã được cộng (1.000 VND = 1 điểm).</p>
        <div class="d-grid gap-2 mt-4">
            <a href="<%= ctx %>/CustomerBookingHistoryController" class="btn btn-dark rounded-pill">Xem My Bookings</a>
            <a href="<%= ctx %>/CustomerDashBoardController" class="btn btn-outline-secondary rounded-pill">Về Dashboard</a>
        </div>
    </div>
    <% if (bookingId != null) { %>
    <script>
        setInterval(async () => {
            try {
                const res = await fetch('<%= ctx %>/PaymentStatusController?bookingId=<%= bookingId %>');
                const data = await res.json();
                if (data.success && data.status !== 'Confirmed' && data.paymentStatus !== 'Paid') {
                    document.querySelector('h4').textContent = 'Đang xác nhận thanh toán...';
                }
            } catch (e) { /* ignore */ }
        }, 3000);
    </script>
    <% } %>
</body>
</html>