<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>


<!DOCTYPE html>
<c:if test="${empty sessionScope.ACCOUNT}">
    <jsp:forward page="index.jsp"/>
</c:if>
<%
    Integer bookingId = (Integer) request.getAttribute("BOOKING_ID");
    Integer amount = (Integer) request.getAttribute("AMOUNT");
    String qrCode = (String) request.getAttribute("QR_CODE");
    String checkoutUrl = (String) request.getAttribute("CHECKOUT_URL");
    String errorMsg = (String) request.getAttribute("ERROR_MSG");
    java.time.LocalDateTime expiredAt = (java.time.LocalDateTime) request.getAttribute("EXPIRED_AT");
    Boolean sandboxMode = (Boolean) request.getAttribute("SANDBOX_MODE");
    if (sandboxMode == null) sandboxMode = false;
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thanh toán QR | Elite Auto</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link href="css/style.css" rel="stylesheet">
    <style>
        body { background: #f3f4f6; font-family: Inter, sans-serif; }
        .pay-card { max-width: 420px; border-radius: 1.25rem; }
        #qrcode canvas, #qrcode img { border-radius: 0.75rem; }
    </style>
</head>
<body class="d-flex align-items-center justify-content-center min-vh-100 p-3">
    <div class="card pay-card shadow-sm border-0 w-100">
        <div class="card-body p-4 text-center">
            <div class="mb-3">
                <i class="bi bi-qr-code-scan fs-2 text-dark"></i>
                <h4 class="fw-bold mt-2 mb-1">Quét mã để thanh toán</h4>
                <p class="text-muted small mb-0">Hệ thống tự động — chỉ hỗ trợ chuyển khoản QR</p>
            </div>

            <% if (errorMsg != null) { %>
            <div class="alert alert-danger small text-start"><%= errorMsg %></div>
            <% } else if (qrCode != null) { %>
            <div id="qrcode" class="d-flex justify-content-center mb-3"></div>
            <div class="bg-light rounded-4 p-3 text-start mb-3">
                <div class="d-flex justify-content-between mb-2">
                    <span class="text-muted small">Mã booking</span>
                    <span class="fw-semibold font-monospace">#<%= bookingId %></span>
                </div>
                <div class="d-flex justify-content-between mb-2">
                    <span class="text-muted small">Số tiền</span>
                    <span class="fw-bold"><%= String.format("%,d", amount) %> VND</span>
                </div>
                <div class="d-flex justify-content-between">
                    <span class="text-muted small">Hết hạn</span>
                    <span class="small" id="countdown">15:00</span>
                </div>
            </div>
            <p class="small text-muted mb-3" id="statusText">
                <span class="spinner-border spinner-border-sm me-1"></span>
                Đang chờ thanh toán... Booking sẽ chuyển sang <strong>Confirmed</strong> khi nhận tiền.
            </p>
            <% if (checkoutUrl != null && !checkoutUrl.isEmpty()) { %>
            <a href="<%= checkoutUrl %>" target="_blank" class="btn btn-outline-dark btn-sm rounded-pill">
                Mở trang thanh toán payOS
            </a>
            <% } %>
            <% if (sandboxMode) { %>
            <div class="alert alert-warning small text-start mt-3 mb-2">
                <i class="bi bi-shield-check me-1"></i>
                <strong>Chế độ sandbox:</strong> không cần chuyển tiền thật. Bấm nút bên dưới để giả lập thanh toán thành công.
            </div>
            <form action="PaymentSandboxController" method="post" class="mt-2">
                <input type="hidden" name="bookingId" value="<%= bookingId %>">
                <button type="submit" class="btn btn-success btn-sm rounded-pill w-100">
                    <i class="bi bi-check-circle me-1"></i> Giả lập thanh toán (sandbox)
                </button>
            </form>
            <% } %>
            <% } %>

            <div class="mt-3">
                <a href="CustomerBookingController" class="btn btn-link btn-sm text-muted">Quay lại đặt lịch</a>
            </div>
        </div>
    </div>

    <% if (qrCode != null && bookingId != null) { %>
    <textarea id="qrData" class="d-none"><%= qrCode %></textarea>
    <script src="https://cdn.jsdelivr.net/npm/qrcode@1.5.3/build/qrcode.min.js"></script>
    <script>
        const qrData = document.getElementById('qrData').value;
        const bookingId = <%= bookingId %>;
        QRCode.toCanvas(document.createElement('canvas'), qrData, { width: 240, margin: 1 }, function (err, canvas) {
            if (!err) document.getElementById('qrcode').appendChild(canvas);
        });

        let secondsLeft = 15 * 60;
        const countdownEl = document.getElementById('countdown');
        setInterval(() => {
            if (secondsLeft <= 0) return;
            secondsLeft--;
            const m = String(Math.floor(secondsLeft / 60)).padStart(2, '0');
            const s = String(secondsLeft % 60).padStart(2, '0');
            countdownEl.textContent = m + ':' + s;
        }, 1000);

        async function checkPaid() {
            try {
                const res = await fetch('PaymentStatusController?bookingId=' + bookingId);
                const data = await res.json();
                if (data.success && (data.status === 'Confirmed' || data.paymentStatus === 'Paid')) {
                    window.location.replace('PaymentSuccessController?bookingId=' + bookingId);
                    return true;
                }
            } catch (e) { /* ignore */ }
            return false;
        }
        checkPaid();
        setInterval(checkPaid, 1500);
    </script>
    <% } %>
</body>
</html>