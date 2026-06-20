<%@page import="java.util.List"%>
<%@page import="dto.Booking"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    Integer invoiceId = (Integer) request.getAttribute("INVOICE_ID");
    Integer amount = (Integer) request.getAttribute("AMOUNT");
    String qrCode = (String) request.getAttribute("QR_CODE");
    String checkoutUrl = (String) request.getAttribute("CHECKOUT_URL");
    String errorMsg = (String) request.getAttribute("ERROR_MSG");
    List<Booking> bookings = (List<Booking>) request.getAttribute("BOOKINGS");
    Boolean sandboxMode = (Boolean) request.getAttribute("SANDBOX_MODE");
    if (sandboxMode == null) sandboxMode = false;
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Business Payment | Elite Auto</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="css/style.css" rel="stylesheet">
    <link href="css/business.css" rel="stylesheet">
</head>
<body class="bus-page d-flex flex-column min-vh-100">
    <div class="bg-white border-bottom py-2 shadow-sm">
        <div class="container d-flex justify-content-between align-items-center">
            <a href="BusinessDashboardController" class="text-decoration-none text-dark fw-semibold small">
                <i class="bi bi-building me-1"></i>EliteAuto Business
            </a>
            <a href="BusinessBookingController" class="text-muted small text-decoration-none">
                <i class="bi bi-arrow-left me-1"></i>Quay lại đặt lịch
            </a>
        </div>
    </div>

    <div class="flex-grow-1 d-flex align-items-center justify-content-center p-3">
        <div class="card bus-pay-card shadow-sm border-0 w-100">
            <div class="card-body p-4">
                <div class="text-center mb-3">
                    <div class="bg-light rounded-circle d-inline-flex align-items-center justify-content-center mb-3" style="width:56px;height:56px;">
                        <i class="bi bi-qr-code-scan fs-4 text-dark"></i>
                    </div>
                    <h4 class="fw-bold mb-1">Thanh toán hóa đơn doanh nghiệp</h4>
                    <p class="text-muted small mb-0">1 hóa đơn — nhiều booking — 1 lần thanh toán</p>
                </div>

                <% if (errorMsg != null) { %>
                <div class="alert alert-danger border-0 bg-danger bg-opacity-10 text-danger rounded-3 small"><%= errorMsg %></div>
                <% } else if (qrCode != null && invoiceId != null) { %>
                <div id="qrcode" class="d-flex justify-content-center mb-3"></div>
                <div class="bg-light rounded-4 p-3 mb-3">
                    <div class="d-flex justify-content-between mb-2">
                        <span class="text-muted small">Hóa đơn</span>
                        <span class="fw-semibold font-monospace">#<%= invoiceId %></span>
                    </div>
                    <div class="d-flex justify-content-between mb-2">
                        <span class="text-muted small">Số booking</span>
                        <span class="fw-semibold"><%= bookings != null ? bookings.size() : 0 %> xe</span>
                    </div>
                    <div class="d-flex justify-content-between">
                        <span class="text-muted small">Tổng tiền</span>
                        <span class="fw-bold"><%= String.format("%,d", amount) %> VND</span>
                    </div>
                </div>

                <% if (bookings != null && !bookings.isEmpty()) { %>
                <div class="small mb-3">
                    <div class="fw-semibold mb-2 text-muted text-uppercase" style="font-size:0.7rem;letter-spacing:0.04em;">Chi tiết booking</div>
                    <% for (Booking b : bookings) { %>
                    <div class="d-flex justify-content-between border-bottom py-2">
                        <span><%= b.getLicensePlate() %> — <%= b.getBayName() %></span>
                        <span class="fw-medium"><%= String.format("%,.0f", b.getPriceAtOrder()) %> VND</span>
                    </div>
                    <% } %>
                </div>
                <% } %>

                <p class="small text-muted text-center" id="statusText">
                    <span class="spinner-border spinner-border-sm me-1"></span>
                    Đang chờ thanh toán... Tất cả booking sẽ chuyển sang <strong>Confirmed</strong>.
                </p>
                <% if (checkoutUrl != null && !checkoutUrl.isEmpty()) { %>
                <div class="text-center">
                    <a href="<%= checkoutUrl %>" target="_blank" class="btn btn-outline-dark btn-sm rounded-pill">Mở trang payOS</a>
                </div>
                <% } %>
                <% if (sandboxMode) { %>
                <form action="BusinessPaymentSandboxController" method="post" class="mt-3">
                    <input type="hidden" name="invoiceId" value="<%= invoiceId %>">
                    <button type="submit" class="btn btn-success btn-sm rounded-pill w-100">
                        <i class="bi bi-check-circle me-1"></i>Giả lập thanh toán (sandbox)
                    </button>
                </form>
                <% } %>
                <% } %>
            </div>
        </div>
    </div>

    <% if (qrCode != null && invoiceId != null) { %>
    <textarea id="qrData" class="d-none"><%= qrCode %></textarea>
    <script src="https://cdn.jsdelivr.net/npm/qrcode@1.5.3/build/qrcode.min.js"></script>
    <script>
        const qrData = document.getElementById('qrData').value;
        const invoiceId = <%= invoiceId %>;
        QRCode.toCanvas(document.createElement('canvas'), qrData, { width: 240, margin: 1 }, function (err, canvas) {
            if (!err) document.getElementById('qrcode').appendChild(canvas);
        });

        async function checkPaid() {
            try {
                const res = await fetch('BusinessPaymentStatusController?invoiceId=' + invoiceId);
                const data = await res.json();
                if (data.success && data.paymentStatus === 'Paid') {
                    window.location.replace('BusinessPaymentSuccessController?invoiceId=' + invoiceId);
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