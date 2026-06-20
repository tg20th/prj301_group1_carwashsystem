<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Revenue Management | EliteAuto</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
        <style>
            body {
                background-color: #f4f7f6;
            }
            .wrapper {
                display: flex;
                height: 100vh;
                overflow: hidden;
            }
            .main-content {
                flex-grow: 1;
                overflow-y: auto;
                padding: 2rem;
            }
            .stat-card {
                border: none;
                border-radius: 12px;
                box-shadow: 0 4px 6px rgba(0,0,0,0.05);
            }
            .icon-box {
                width: 50px;
                height: 50px;
                border-radius: 12px;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 24px;
            }
            .bg-light-primary {
                background: #e0f0ff;
                color: #0d6efd;
            }
            .bg-light-success {
                background: #e6f8f0;
                color: #198754;
            }
            .bg-light-warning {
                background: #fff5e5;
                color: #ffc107;
            }
            .bg-light-info {
                background: #e0f6fc;
                color: #0dcaf0;
            }
        </style>
    </head>
    <body>
        <div class="wrapper">
            <jsp:include page="admin_sidebar.jsp" />

            <div class="main-content">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h3 class="fw-bold mb-0 text-dark">Revenue Dashboard</h3>
                    <form action="RevenueController" method="POST" class="d-flex gap-2">
                        <select name="year" class="form-select border-0 shadow-sm fw-bold text-primary">
                            <c:forEach var="y" items="${AVAILABLE_YEARS}">
                                <option value="${y}" <c:if test="${y == SELECTED_YEAR}">selected</c:if>>Year ${y}</option>
                            </c:forEach>
                        </select>
                        <button type="submit" class="btn btn-primary px-4 fw-bold shadow-sm">Filter</button>
                    </form>
                </div>

                <div class="row g-4 mb-4">
                    <div class="col-xl-3 col-md-6">
                        <div class="card stat-card h-100 p-3">
                            <div class="d-flex align-items-center justify-content-between">
                                <div>
                                    <h6 class="text-muted fw-bold mb-2">Net Revenue</h6>
                                    <h4 class="fw-bold text-dark mb-0"><fmt:formatNumber value="${TOTAL_REVENUE}" type="number"/> ₫</h4>
                                </div>
                                <div class="icon-box bg-light-primary"><i class="bi bi-wallet2"></i></div>
                            </div>
                        </div>
                    </div>
                    <div class="col-xl-3 col-md-6">
                        <div class="card stat-card h-100 p-3">
                            <div class="d-flex align-items-center justify-content-between">
                                <div>
                                    <h6 class="text-muted fw-bold mb-2">Total Bookings</h6>
                                    <h4 class="fw-bold text-dark mb-0"><fmt:formatNumber value="${TOTAL_BOOKINGS}" type="number"/></h4>
                                </div>
                                <div class="icon-box bg-light-success"><i class="bi bi-calendar-check"></i></div>
                            </div>
                        </div>
                    </div>
                    <div class="col-xl-3 col-md-6">
                        <div class="card stat-card h-100 p-3">
                            <div class="d-flex align-items-center justify-content-between">
                                <div>
                                    <h6 class="text-muted fw-bold mb-2">Avg. Per Booking</h6>
                                    <h4 class="fw-bold text-dark mb-0"><fmt:formatNumber value="${AVG_VALUE}" type="number"/> ₫</h4>
                                </div>
                                <div class="icon-box bg-light-warning"><i class="bi bi-cash-coin text-warning"></i></div>
                            </div>
                        </div>
                    </div>
                    <div class="col-xl-3 col-md-6">
                        <div class="card stat-card h-100 p-3">
                            <div class="d-flex align-items-center justify-content-between">
                                <div>
                                    <h6 class="text-muted fw-bold mb-2">Top Payment</h6>
                                    <h4 class="fw-bold text-dark mb-0">${TOP_PAYMENT}</h4>
                                </div>
                                <div class="icon-box bg-light-info"><i class="bi bi-credit-card"></i></div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="row g-4 mb-4">
                    <div class="col-lg-8">
                        <div class="card stat-card h-100">
                            <div class="card-header bg-white border-0 pt-4 pb-0">
                                <h5 class="fw-bold text-dark"><i class="bi bi-bar-chart-line me-2"></i>Revenue & Booking Trends</h5>
                            </div>
                            <div class="card-body">
                                <canvas id="comboChart" height="100"></canvas>
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-4">
                        <div class="card stat-card h-100">
                            <div class="card-header bg-white border-0 pt-4 pb-0">
                                <h5 class="fw-bold text-dark"><i class="bi bi-pie-chart me-2"></i>Payment Breakdown</h5>
                            </div>
                            <div class="card-body d-flex align-items-center justify-content-center">
                                <c:choose>
                                    <c:when test="${not empty PAYMENT_STATS}">
                                        <canvas id="donutChart" height="250"></canvas>
                                        </c:when>
                                        <c:otherwise>
                                        <p class="text-muted fst-italic">No payment data found for ${SELECTED_YEAR}.</p>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="card stat-card">
                    <div class="card-header bg-white border-0 pt-4 pb-3">
                        <h5 class="fw-bold text-dark"><i class="bi bi-table me-2"></i>Monthly Breakdown Data</h5>
                    </div>
                    <div class="card-body p-0">
                        <div class="table-responsive">
                            <table class="table table-hover align-middle text-center mb-0 text-nowrap" style="width: 100%;">
                                <thead class="table-light">
                                    <tr>
                                        <th class="text-secondary py-3">Month</th>
                                        <th class="text-secondary py-3">Total Bookings</th>
                                        <th class="text-secondary py-3">Revenue (VND)</th>
                                        <th class="text-secondary py-3">Growth vs Prev Month</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="stat" items="${STATS_LIST}">
                                        <tr>
                                            <td class="fw-bold text-muted py-3"> [ ${stat.month} ]</td>
                                            <td class="py-3">
                                                <span class="badge ${stat.totalBooking > 0 ? 'bg-success' : 'bg-secondary'} rounded-pill px-3">
                                                    ${stat.totalBooking}
                                                </span>
                                            </td>
                                            <td class="fw-bold text-dark fs-6 py-3">
                                                <fmt:formatNumber value="${stat.totalRevenue}" type="number"/> ₫
                                            </td>
                                            <td class="py-3">
                                                <c:choose>
                                                    <c:when test="${stat.growthRate > 0}">
                                                        <span class="text-success fw-bold"><i class="bi bi-arrow-up-right me-1"></i><fmt:formatNumber value="${stat.growthRate}" maxFractionDigits="1"/>%</span>
                                                    </c:when>
                                                    <c:when test="${stat.growthRate < 0}">
                                                        <span class="text-danger fw-bold"><i class="bi bi-arrow-down-right me-1"></i><fmt:formatNumber value="${stat.growthRate}" maxFractionDigits="1"/>%</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-muted fw-bold">-</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <script>
            // 1. Chuẩn bị dữ liệu từ Server
            const labels = [];
            const revenues = [];
            const bookings = [];
            <c:forEach var="s" items="${STATS_LIST}">
            labels.push('Tháng ${s.month}');
            revenues.push(${s.totalRevenue});
            bookings.push(${s.totalBooking});
            </c:forEach>

            // 2. Cấu hình biểu đồ Combo (Bar + Line)
            const comboCtx = document.getElementById('comboChart');
            if (comboCtx) {
                new Chart(comboCtx, {
                    type: 'line',
                    data: {
                        labels: labels,
                        datasets: [{
                                type: 'bar',
                                label: 'Revenue (₫)',
                                data: revenues,
                                backgroundColor: 'rgba(13, 110, 253, 0.8)',
                                yAxisID: 'y'
                            }, {
                                type: 'line',
                                label: 'Bookings',
                                data: bookings,
                                borderColor: '#198754',
                                backgroundColor: '#198754',
                                yAxisID: 'y1'
                            }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        animation: false, 
                        events: [], 
                        scales: {
                            x: {grid: {display: false}},
                            y: {type: 'linear', position: 'left'},
                            y1: {type: 'linear', position: 'right', grid: {drawOnChartArea: false}}
                        }
                    }
                });
            }

            // 3. Cấu hình biểu đồ Donut
            <c:if test="${not empty PAYMENT_STATS}">
            const payLabels = [];
            const payData = [];
                <c:forEach var="p" items="${PAYMENT_STATS}">
           payLabels.push('${p.method}');
           payData.push(${p.totalAmount});
                </c:forEach>

            const donutCtx = document.getElementById('donutChart');
            if (donutCtx) {
                new Chart(donutCtx, {
                    type: 'doughnut',
                    data: {
                        labels: payLabels,
                        datasets: [{
                                data: payData,
                                backgroundColor: ['#0d6efd', '#198754', '#ffc107', '#0dcaf0', '#6c757d']
                            }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        animation: false, 
                        events: [], 
                        plugins: {legend: {position: 'bottom'}},
                        cutout: '70%'
                    }
                });
            }
            </c:if>
        </script>
    </body>
</html>