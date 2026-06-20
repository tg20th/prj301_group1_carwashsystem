<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<c:if test="${empty sessionScope.ACCOUNT}">
    <jsp:forward page="index.jsp"/>
</c:if>

<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Booking Management | Elite Auto</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
        <link href="css/admin.css?v=1.1" rel="stylesheet">
        
        <style>
            /* Tổng quan nền */
            body { background-color: #f4f7fe; font-family: 'Inter', sans-serif; color: #334155; }
            
            .tracking-tight { letter-spacing: -0.025em; }

            .booking-row { transition: background-color 0.3s ease; }
            .booking-row:hover { background-color: #f8fafc; }
            
            /* Custom Tab Buttons */
            .filter-btn { transition: all 0.3s ease; border: 1px solid transparent; }
            .filter-btn:hover { background-color: #f1f5f9; color: #0f172a !important; }
            .filter-btn.active { background-color: #0f172a !important; color: white !important; box-shadow: 0 4px 6px -1px rgba(15, 23, 42, 0.2); border-color: #0f172a; }
            
            /* Nút Đen (Black) chuẩn SaaS */
            .btn-dark-custom { background-color: #0f172a; color: white; border: none; transition: transform 0.2s, box-shadow 0.2s; }
            .btn-dark-custom:hover { background-color: #1e293b; transform: translateY(-2px); box-shadow: 0 10px 15px -3px rgba(15, 23, 42, 0.25); color: white; }
        </style>
    </head>
    <body class="admin-body">

        <jsp:include page="admin_sidebar.jsp"/>

        <main class="main-wrapper p-4 p-lg-5 animate-fade-up">

            <c:if test="${not empty error}">
                <div class="alert alert-danger border-0 bg-danger bg-opacity-10 text-danger rounded-4 p-3 mb-4 d-flex align-items-center shadow-sm auto-dismiss-alert">
                    <i class="bi bi-exclamation-circle-fill me-2 fs-5"></i>
                    <div class="small fw-bold">${error}</div>
                    <button type="button" class="btn-close ms-auto shadow-none small" data-bs-dismiss="alert"></button>
                </div>
            </c:if>
            
            <c:if test="${not empty success}">
                <div class="alert alert-success border-0 bg-success bg-opacity-10 text-success rounded-4 p-3 mb-4 d-flex align-items-center shadow-sm auto-dismiss-alert">
                    <i class="bi bi-check-circle-fill me-2 fs-5"></i>
                    <div class="small fw-bold">${success}</div>
                    <button type="button" class="btn-close ms-auto shadow-none small" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-end mb-4 pb-2">
                <div>
                    <h2 class="fw-bolder tracking-tight mb-1 text-dark fs-2">Today's Bookings</h2>
                    <p class="text-secondary fw-medium mb-0">Overview and update booking status</p>
                </div>
                
                <div class="mt-3 mt-md-0 d-flex gap-3 align-items-center overflow-x-auto" style="scrollbar-width: none;">
                    <ul class="nav nav-pills bg-white p-2 rounded-pill shadow-sm border mb-0 d-inline-flex flex-nowrap" id="statusFilters">
                        <li class="nav-item"><button class="nav-link filter-btn rounded-pill px-4 fw-bold text-muted text-nowrap" data-filter="ALL" onclick="filterTable('ALL', this)">All</button></li>
                        <li class="nav-item"><button class="nav-link filter-btn rounded-pill px-4 fw-bold text-muted text-nowrap" data-filter="Upcoming" onclick="filterTable('Upcoming', this)">Upcoming</button></li>
                        <li class="nav-item"><button class="nav-link filter-btn rounded-pill px-4 fw-bold text-muted text-nowrap" data-filter="InProgress" onclick="filterTable('InProgress', this)">Washing</button></li>
                        <li class="nav-item"><button class="nav-link filter-btn rounded-pill px-4 fw-bold text-muted text-nowrap" data-filter="Completed" onclick="filterTable('Completed', this)">Completed</button></li>
                        
                        <li class="nav-item"><button class="nav-link filter-btn rounded-pill px-4 fw-bold text-muted text-nowrap" data-filter="Cancelled" onclick="filterTable('Cancelled', this)">Cancelled</button></li>
                        <li class="nav-item"><button class="nav-link filter-btn rounded-pill px-4 fw-bold text-muted text-nowrap" data-filter="NoShow" onclick="filterTable('NoShow', this)">No Show</button></li>
                    </ul>
                </div>
            </div>

            <div class="bg-white p-4 rounded-4 shadow-sm border border-light h-100 d-flex flex-column">

                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h5 class="fw-bolder m-0 text-dark tracking-tight"><i class="bi bi-card-list me-2 text-primary"></i>Booking List</h5>
                    <span class="badge bg-primary bg-opacity-10 text-primary border border-primary border-opacity-25 rounded-pill px-3 py-1 shadow-sm">
                        Total: ${empty LISTOFBOOKING ? 0 : fn:length(LISTOFBOOKING)}
                    </span>
                </div>

                <c:choose>
                    <c:when test="${empty LISTOFBOOKING}">
                        <div class="d-flex flex-column justify-content-center align-items-center flex-grow-1 py-5">
                            <div class="gradient-primary rounded-circle d-inline-flex align-items-center justify-content-center mb-3 shadow" style="width: 80px; height: 80px;">
                                <i class="bi bi-inbox fs-1 text-white"></i>
                            </div>
                            <h4 class="fw-bold text-dark">No Bookings Found</h4>
                            <p class="text-muted">There are no bookings for today.</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="table-responsive flex-grow-1" style="min-height: 400px;">
                            <table class="table table-borderless table-hover mb-0 align-middle">
                                <thead class="table-light">
                                    <tr class="border-bottom border-light text-nowrap">
                                        <th class="text-muted fw-bold small text-uppercase py-3 ps-3 rounded-start" style="letter-spacing: 0.5px;">ID</th>
                                        <th class="text-muted fw-bold small text-uppercase py-3" style="letter-spacing: 0.5px;">Customer</th>
                                        <th class="text-muted fw-bold small text-uppercase py-3" style="letter-spacing: 0.5px;">Vehicle</th>
                                        <th class="text-muted fw-bold small text-uppercase py-3" style="letter-spacing: 0.5px;">Service</th>
                                        <th class="text-muted fw-bold small text-uppercase py-3" style="letter-spacing: 0.5px;">Time Slot</th>
                                        <th class="text-muted fw-bold small text-uppercase py-3 text-center" style="letter-spacing: 0.5px;">Status</th>
                                        <th class="text-muted fw-bold small text-uppercase py-3 text-end pe-4 rounded-end" style="letter-spacing: 0.5px;">Action</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="b" items="${LISTOFBOOKING}">
                                        <c:set var="status" value="${empty b.status ? 'Pending' : b.status}" />
                                        <c:set var="statusLower" value="${fn:toLowerCase(status)}" />
                                        
                                        <c:set var="badgeColor" value="bg-secondary bg-opacity-10 text-secondary border-secondary" />
                                        <c:set var="statusIcon" value="" />
                                        
                                        <c:choose>
                                            <c:when test="${statusLower == 'completed'}">
                                                <c:set var="badgeColor" value="bg-success bg-opacity-10 text-success border-success" />
                                                <c:set var="statusIcon" value="<i class='bi bi-check-circle-fill me-1'></i>" />
                                            </c:when>
                                            <c:when test="${statusLower == 'inprogress'}">
                                                <c:set var="badgeColor" value="bg-info bg-opacity-10 text-info border-info" />
                                                <c:set var="statusIcon" value="<span class='spinner-grow spinner-grow-sm me-1' role='status' style='width: 0.6rem; height: 0.6rem;'></span>" />
                                            </c:when>
                                            <c:when test="${statusLower == 'pending'}">
                                                <c:set var="badgeColor" value="bg-warning bg-opacity-10 text-warning border-warning" />
                                                <c:set var="statusIcon" value="<i class='bi bi-clock me-1'></i>" />
                                            </c:when>
                                            <c:when test="${statusLower == 'confirmed'}">
                                                <c:set var="badgeColor" value="bg-primary bg-opacity-10 text-primary border-primary" />
                                                <c:set var="statusIcon" value="<i class='bi bi-patch-check-fill me-1'></i>" />
                                            </c:when>
                                            <c:when test="${statusLower == 'cancelled' || statusLower == 'noshow'}">
                                                <c:set var="badgeColor" value="bg-danger bg-opacity-10 text-danger border-danger" />
                                                <c:set var="statusIcon" value="<i class='bi bi-x-circle-fill me-1'></i>" />
                                            </c:when>
                                        </c:choose>

                                        <c:set var="rowOpacity" value="${statusLower == 'completed' || statusLower == 'cancelled' || statusLower == 'noshow' ? 'bg-light bg-opacity-50' : ''}" />

                                        <tr data-status="${status}" class="border-bottom border-light booking-row py-2 ${rowOpacity}">
                                            <td class="text-muted small fw-bold ps-3 font-monospace py-3">#${b.bookingID}</td>
                                            <td class="py-3">
                                                <div class="fw-bolder text-dark" style="font-size: 1.05rem;">${b.cusName}</div>
                                            </td>
                                            <td class="py-3">
                                                <div class="d-flex align-items-center mb-1">
                                                    <span class="fw-bold text-dark me-2">${b.vehicleName}</span>
                                                    <span class="badge bg-light text-dark border">${b.vehicleType}</span>
                                                </div>
                                                <div class="font-monospace text-muted fw-bold small px-2 py-1 bg-light rounded d-inline-block border">
                                                    ${b.licensePlate}
                                                </div>
                                            </td>
                                            <td class="py-3">
                                                <span class="text-primary fw-bold small"><i class="bi bi-stars me-1"></i>${b.service}</span>
                                            </td>
                                            <td class="py-3">
                                                <div class="text-dark fw-bolder" style="font-size: 0.9rem;">
                                                    ${b.timeslot.start.hour}:${b.timeslot.start.minute < 10 ? '0' : ''}${b.timeslot.start.minute} 
                                                    <i class="bi bi-arrow-right-short text-muted mx-1"></i> 
                                                    ${b.timeslot.end.hour}:${b.timeslot.end.minute < 10 ? '0' : ''}${b.timeslot.end.minute}
                                                </div>
                                                <div class="text-muted small fw-medium">
                                                    ${b.timeslot.start.dayOfMonth < 10 ? '0' : ''}${b.timeslot.start.dayOfMonth}/${b.timeslot.start.monthValue < 10 ? '0' : ''}${b.timeslot.start.monthValue}/${b.timeslot.start.year}
                                                </div>
                                            </td>
                                            <td class="text-center py-3">
                                                <span class="badge ${badgeColor} border border-opacity-25 px-3 py-2 rounded-pill shadow-sm text-uppercase" style="font-size: 0.7rem; letter-spacing: 0.5px;">
                                                    ${statusIcon} ${status}
                                                </span>
                                            </td>
                                            <td class="text-end pe-4 py-3">
                                                <c:choose>
                                                    <c:when test="${statusLower == 'confirmed'}">
                                                        <form action="MainController?action=process_booking" method="POST" class="m-0 p-0 d-inline-block">
                                                            <input type="hidden" name="actionAdmin" value="checkin">
                                                            <input type="hidden" name="id" value="${b.bookingID}">
                                                            <button type="submit" class="btn btn-sm btn-dark-custom rounded-pill px-4 py-2 fw-bold shadow-sm">
                                                                <i class="bi bi-box-arrow-in-right me-1"></i>Check In
                                                            </button>
                                                        </form>
                                                    </c:when>
                                                    <c:when test="${statusLower == 'pending'}">
                                                        <span class="text-muted small fw-bold"><i class="bi bi-credit-card me-1"></i>Awaiting Payment</span>
                                                    </c:when>
                                                    <c:when test="${statusLower == 'inprogress'}">
                                                        <form action="MainController?action=process_booking" method="POST" class="m-0 p-0 d-inline-block">
                                                            <input type="hidden" name="actionAdmin" value="checkout">
                                                            <input type="hidden" name="id" value="${b.bookingID}">
                                                            <button type="submit" class="btn btn-sm btn-outline-danger rounded-pill px-3 py-2 fw-bold shadow-sm">
                                                                <i class="bi bi-box-arrow-left me-1"></i>Check Out
                                                            </button>
                                                        </form>
                                                    </c:when>
                                                    <c:when test="${statusLower == 'completed'}">
                                                        <span class="text-success small fw-bold"><i class="bi bi-check2-all me-1"></i>Done</span>
                                                    </c:when>
                                                    <c:when test="${statusLower == 'cancelled' || statusLower == 'noshow'}">
                                                        <span class="text-danger small fw-bold"><i class="bi bi-slash-circle me-1"></i>Closed</span>
                                                    </c:when>
                                                </c:choose>
                                            </td>
                                        </tr>
                                    </c:forEach>

                                    <tr id="noDataRow" style="display: none;">
                                        <td colspan="7" class="text-center py-5">
                                            <div class="gradient-warning rounded-circle d-inline-flex align-items-center justify-content-center mb-3 shadow" style="width: 80px; height: 80px;">
                                                <i class="bi bi-search fs-1 text-white"></i>
                                            </div>
                                            <h6 class="text-dark fw-bold fs-5">No bookings match this filter</h6>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </main>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

        <script>
            document.addEventListener("DOMContentLoaded", function () {
                // 1. Phục hồi tab đang xem
                let savedFilter = sessionStorage.getItem('currentBookingFilter') || 'ALL';
                let activeBtn = document.querySelector('.filter-btn[data-filter="'+ savedFilter +'"]');
                if (activeBtn) {
                    filterTable(savedFilter, activeBtn, false);
                } else {
                    document.querySelector('.filter-btn[data-filter="ALL"]').classList.add('active');
                }

                // 2. TỰ ĐỘNG TẮT THÔNG BÁO SAU 4 GIÂY
                setTimeout(function () {
                    let alerts = document.querySelectorAll('.auto-dismiss-alert'); 
                    alerts.forEach(function (alert) {
                        alert.style.transition = "opacity 0.5s ease-out, transform 0.5s ease-out";
                        alert.style.opacity = "0"; 
                        alert.style.transform = "translateY(-10px)"; 

                        setTimeout(() => {
                            if (alert.parentNode) alert.parentNode.removeChild(alert);
                        }, 500);
                    });
                }, 4000); 
            });

            // ==================== LỌC DỮ LIỆU TABS ====================
            function filterTable(status, btnElement, saveToSession = true) {
                if (saveToSession) {
                    sessionStorage.setItem('currentBookingFilter', status);
                }

                document.querySelectorAll('.filter-btn').forEach(btn => {
                    btn.classList.remove('active');
                });
                btnElement.classList.add('active');

                let rows = document.querySelectorAll(".booking-row");
                let visibleCount = 0;

                rows.forEach(row => {
                    let rowStatus = row.getAttribute('data-status');
                    let isVisible = status === 'ALL'
                        || rowStatus === status
                        || (status === 'Upcoming' && (rowStatus === 'Pending' || rowStatus === 'Confirmed'));
                    if (isVisible) {
                        row.style.display = "";
                        visibleCount++;
                    } else {
                        row.style.display = "none";
                    }
                });

                let noDataRow = document.getElementById('noDataRow');
                if (noDataRow) {
                    noDataRow.style.display = (visibleCount === 0) ? "" : "none";
                }
            }
        </script>
    </body>
</html>