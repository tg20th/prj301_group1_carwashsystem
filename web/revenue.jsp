<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Revenue Management | EliteAuto</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">

        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
        <link href="css/admin.css?v=1.1" rel="stylesheet">

        <style>
            body {
                background-color: #f4f7fe;
                font-family: 'Inter', sans-serif;
                color: #334155;
            }

        </style>
    </head>
    <body class="admin-body d-flex">

        <jsp:include page="admin_sidebar.jsp" />

        <main class="main-wrapper p-4 p-lg-5 animate-fade-up flex-grow-1" style="min-width: 0;">

            <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center mb-4 pb-2">
                <div>
                    <h2 class="fw-bolder tracking-tight mb-1 text-dark fs-2">Revenue Dashboard</h2>
                    <p class="text-secondary fw-medium mb-0">Track your earnings, bookings, and growth trends.</p>
                </div>
                <div class="mt-3 mt-md-0">
                    <form action="RevenueController" method="POST" class="d-flex gap-2">
                        <select name="year" class="form-select vibrant-input rounded-pill cursor-pointer px-4 shadow-sm" style="min-width: 140px;">
                            <c:forEach var="y" items="${AVAILABLE_YEARS}">
                                <option value="${y}" <c:if test="${y == SELECTED_YEAR}">selected</c:if>>Year ${y}</option>
                            </c:forEach>
                        </select>
                        <button type="submit" class="btn btn-dark-custom rounded-pill px-4 fw-bold shadow-sm d-flex align-items-center gap-2">
                            <i class="bi bi-funnel-fill"></i> Filter
                        </button>
                    </form>
                </div>
            </div>

            <!-- VIBRANT KPI CARDS -->
            <div class="row g-4 mb-4">
                <div class="col-xl-3 col-md-6">
                    <div class="glass-card p-3 p-xl-4 rounded-4 shadow-sm h-100 d-flex align-items-center gap-3 hover-scale border-light">
                        <div class="gradient-info rounded-circle d-flex align-items-center justify-content-center shadow flex-shrink-0" style="width: 55px; height: 55px;">
                            <i class="bi bi-wallet2 fs-4 text-white"></i>
                        </div>
                        <div class="flex-grow-1" style="min-width: 0;">
                            <div class="text-muted fw-bold text-uppercase mb-1" style="font-size: 0.7rem; letter-spacing: 0.5px;">Net Revenue</div>
                            <h3 class="fw-bolder text-dark mb-0 tracking-tight text-truncate fs-4" title="<fmt:formatNumber value='${TOTAL_REVENUE}' type='number'/> VND">
                                <fmt:formatNumber value="${TOTAL_REVENUE}" type="number"/> VND
                            </h3>
                        </div>
                    </div>
                </div>
                <div class="col-xl-3 col-md-6">
                    <div class="glass-card p-3 p-xl-4 rounded-4 shadow-sm h-100 d-flex align-items-center gap-3 hover-scale border-light">
                        <div class="gradient-success rounded-circle d-flex align-items-center justify-content-center shadow flex-shrink-0" style="width: 55px; height: 55px;">
                            <i class="bi bi-calendar-check-fill fs-4 text-white"></i>
                        </div>
                        <div class="flex-grow-1" style="min-width: 0;">
                            <div class="text-muted fw-bold text-uppercase mb-1" style="font-size: 0.7rem; letter-spacing: 0.5px;">Total Bookings</div>
                            <h3 class="fw-bolder text-dark mb-0 tracking-tight text-truncate fs-4" title="<fmt:formatNumber value='${TOTAL_BOOKINGS}' type='number'/>">
                                <fmt:formatNumber value="${TOTAL_BOOKINGS}" type="number"/>
                            </h3>
                        </div>
                    </div>
                </div>
                <div class="col-xl-3 col-md-6">
                    <div class="glass-card p-3 p-xl-4 rounded-4 shadow-sm h-100 d-flex align-items-center gap-3 hover-scale border-light">
                        <div class="gradient-warning rounded-circle d-flex align-items-center justify-content-center shadow flex-shrink-0" style="width: 55px; height: 55px;">
                            <i class="bi bi-cash-coin fs-4 text-white"></i>
                        </div>
                        <div class="flex-grow-1" style="min-width: 0;">
                            <div class="text-muted fw-bold text-uppercase mb-1" style="font-size: 0.7rem; letter-spacing: 0.5px;">Avg. Booking</div>
                            <h3 class="fw-bolder text-dark mb-0 tracking-tight text-truncate fs-4" title="<fmt:formatNumber value='${AVG_VALUE}' type='number'/> VND">
                                <fmt:formatNumber value="${AVG_VALUE}" type="number"/> VND
                            </h3>
                        </div>
                    </div>
                </div>
                <div class="col-xl-3 col-md-6">
                    <div class="glass-card p-3 p-xl-4 rounded-4 shadow-sm h-100 d-flex align-items-center gap-3 hover-scale border-light">
                        <div class="gradient-purple rounded-circle d-flex align-items-center justify-content-center shadow flex-shrink-0" style="width: 55px; height: 55px;">
                            <i class="bi bi-credit-card-2-front-fill fs-4 text-white"></i>
                        </div>
                        <div class="flex-grow-1" style="min-width: 0;">
                            <div class="text-muted fw-bold text-uppercase mb-1" style="font-size: 0.7rem; letter-spacing: 0.5px;">Top Payment</div>
                            <h3 class="fw-bolder text-dark mb-0 tracking-tight text-truncate fs-4" title="${TOP_PAYMENT}">
                                ${empty TOP_PAYMENT ? 'N/A' : TOP_PAYMENT}
                            </h3>
                        </div>
                    </div>
                </div>
            </div>

            <div class="row g-4 mb-4 align-items-stretch">
                <div class="col-lg-8">
                    <div class="glass-card p-4 rounded-4 shadow-sm h-100 d-flex flex-column border-light">
                        <h5 class="fw-bolder text-dark mb-4 tracking-tight"><i class="bi bi-bar-chart-line-fill text-primary me-2"></i>Revenue & Booking Trends</h5>
                        <div class="flex-grow-1 position-relative" style="min-height: 300px;">
                            <canvas id="comboChart"></canvas>
                        </div>
                    </div>
                </div>

                <div class="col-lg-4">
                    <div class="glass-card p-4 rounded-4 shadow-sm h-100 d-flex flex-column border-light">
                        <h5 class="fw-bolder text-dark mb-4 tracking-tight"><i class="bi bi-pie-chart-fill text-success me-2"></i>Payment Breakdown</h5>
                        <div class="flex-grow-1 d-flex align-items-center justify-content-center position-relative" style="min-height: 250px;">
                            <c:choose>
                                <c:when test="${not empty PAYMENT_STATS}">
                                    <canvas id="donutChart"></canvas>
                                    </c:when>
                                    <c:otherwise>
                                    <div class="text-center text-muted">
                                        <i class="bi bi-inbox fs-1 mb-2 d-block opacity-50"></i>
                                        <span class="fst-italic small">No payment data found for ${SELECTED_YEAR}.</span>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </div>

            <div class="glass-card rounded-4 shadow-sm overflow-hidden d-flex flex-column border-light">
                <div class="p-4 border-bottom border-light bg-white">
                    <h5 class="fw-bolder text-dark mb-0 tracking-tight"><i class="bi bi-table text-info me-2"></i>Monthly Breakdown Data</h5>
                </div>
                <div class="table-responsive">
                    <table class="table table-borderless align-middle text-center mb-0 text-nowrap">
                        <thead class="table-light">
                            <tr class="border-bottom border-light">
                                <th class="text-muted text-uppercase fw-bold py-4 ps-4 text-start" style="font-size: 0.75rem; letter-spacing: 1px;">Month</th>
                                <th class="text-muted text-uppercase fw-bold py-4" style="font-size: 0.75rem; letter-spacing: 1px;">Total Bookings</th>
                                <th class="text-muted text-uppercase fw-bold py-4" style="font-size: 0.75rem; letter-spacing: 1px;">Revenue (VND)</th>
                                <th class="text-muted text-uppercase fw-bold py-4 pe-4 text-end" style="font-size: 0.75rem; letter-spacing: 1px;">Growth vs Prev Month</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="stat" items="${STATS_LIST}">
                                <tr class="custom-row border-bottom border-light">
                                    <td class="fw-bolder text-dark py-4 ps-4 text-start">
                                        <div class="d-flex align-items-center gap-2">
                                            <div class="bg-light rounded d-flex align-items-center justify-content-center" style="width: 32px; height: 32px;">
                                                <i class="bi bi-calendar-event text-primary small"></i>
                                            </div>
                                            Month ${stat.month}
                                        </div>
                                    </td>
                                    <td class="py-4">
                                        <span class="badge ${stat.totalBooking > 0 ? 'bg-success bg-opacity-10 text-success border border-success border-opacity-25' : 'bg-secondary bg-opacity-10 text-secondary border border-secondary border-opacity-25'} rounded-pill px-3 py-2 shadow-sm font-monospace" style="font-size: 0.8rem;">
                                            ${stat.totalBooking}
                                        </span>
                                    </td>
                                    <td class="fw-bolder text-dark fs-6 py-4 font-monospace tracking-tight">
                                        <fmt:formatNumber value="${stat.totalRevenue}" type="number"/> VND
                                    </td>
                                    <td class="py-4 pe-4 text-end">
                                        <c:choose>
                                            <c:when test="${stat.growthRate > 0}">
                                                <span class="badge bg-success text-white rounded-pill px-3 py-2 shadow-sm"><i class="bi bi-graph-up-arrow me-1"></i> +<fmt:formatNumber value="${stat.growthRate}" maxFractionDigits="1"/>%</span>
                                            </c:when>
                                            <c:when test="${stat.growthRate < 0}">
                                                <span class="badge bg-danger text-white rounded-pill px-3 py-2 shadow-sm"><i class="bi bi-graph-down-arrow me-1"></i> <fmt:formatNumber value="${stat.growthRate}" maxFractionDigits="1"/>%</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-light text-muted border rounded-pill px-3 py-2">- 0%</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </main>

        <script>
            // 1. Chuẩn bị dữ liệu từ Server (JSTL loop xuất ra JS an toàn)
            const labels = [];
            const revenues = [];
            const bookings = [];
            <c:forEach var="s" items="${STATS_LIST}">
            labels.push('Month ${s.month}');
            revenues.push(${s.totalRevenue});
            bookings.push(${s.totalBooking});
            </c:forEach>

            // 2. Cấu hình biểu đồ Combo (Bar + Line) - Thiết kế Vibrant SaaS
            const comboCtx = document.getElementById('comboChart');
            if (comboCtx) {
                new Chart(comboCtx, {
                    type: 'line',
                    data: {
                        labels: labels,
                        datasets: [{
                                type: 'bar',
                                label: 'Revenue (VND)',
                                data: revenues,
                                backgroundColor: 'rgba(99, 102, 241, 0.85)', // Màu Indigo hiện đại
                                hoverBackgroundColor: 'rgba(99, 102, 241, 1)',
                                borderRadius: 4, // Bo tròn đầu cột
                                borderSkipped: false,
                                yAxisID: 'y'
                            }, {
                                type: 'line',
                                label: 'Bookings',
                                data: bookings,
                                borderColor: '#10b981', // Màu Emerald
                                backgroundColor: '#10b981',
                                borderWidth: 3,
                                pointBackgroundColor: '#fff',
                                pointBorderColor: '#10b981',
                                pointBorderWidth: 2,
                                pointRadius: 4,
                                pointHoverRadius: 6,
                                tension: 0.3, // Đường cong mượt
                                yAxisID: 'y1'
                            }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        interaction: {
                            mode: 'index',
                            intersect: false,
                        },
                        plugins: {
                            legend: {
                                position: 'top',
                                labels: {usePointStyle: true, boxWidth: 8, font: {family: 'Inter', weight: '600'}}
                            },
                            tooltip: {
                                backgroundColor: 'rgba(15, 23, 42, 0.9)',
                                titleFont: {family: 'Inter', size: 13},
                                bodyFont: {family: 'Inter', size: 13},
                                padding: 10,
                                cornerRadius: 8
                            }
                        },
                        scales: {
                            x: {
                                grid: {display: false, drawBorder: false},
                                ticks: {font: {family: 'Inter', weight: '500'}, color: '#64748b'}
                            },
                            y: {
                                type: 'linear', position: 'left',
                                grid: {color: '#f1f5f9', borderDash: [5, 5]},
                                ticks: {font: {family: 'Inter'}, color: '#64748b'}
                            },
                            y1: {
                                type: 'linear', position: 'right',
                                grid: {drawOnChartArea: false},
                                ticks: {font: {family: 'Inter'}, color: '#64748b'}
                            }
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
                                // Bảng màu Vibrant
                                backgroundColor: ['#6366f1', '#10b981', '#f59e0b', '#0ea5e9', '#a855f7'],
                                borderWidth: 0,
                                hoverOffset: 4
                            }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        plugins: {
                            legend: {
                                position: 'bottom',
                                labels: {usePointStyle: true, padding: 20, font: {family: 'Inter', weight: '600'}}
                            },
                            tooltip: {
                                backgroundColor: 'rgba(15, 23, 42, 0.9)',
                                bodyFont: {family: 'Inter', size: 13},
                                padding: 10,
                                cornerRadius: 8
                            }
                        },
                        cutout: '75%' // Khoảng trống giữa bánh bự hơn cho thanh thoát
                    }
                });
            }
            </c:if>
        </script>
    </body>
</html>