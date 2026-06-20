<%@page import="dto.Booking"%>
<%@page import="dto.TimeSlot"%>
<%@page import="java.util.List"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="java.time.LocalDateTime"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<c:if test="account == null">
    <jsp:forward page="index.jsp"/>
</c:if>
<%
    List<Booking> listBooking = (List<Booking>) request.getAttribute("LISTOFBOOKING");
    DateTimeFormatter timeFormatter = DateTimeFormatter.ofPattern("HH:mm");
    DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");

    // Hứng thông báo từ Backend (BookingProcessController gửi qua request.setAttribute)
    String successMsg = (String) request.getAttribute("success");
    String errorMsg = (String) request.getAttribute("error");
%>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Booking Management | Elite Auto</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
        <link href="css/admin.css?v=1.1" rel="stylesheet">
        <style>
            .booking-row {
                transition: background-color 0.3s ease;
            }
            .filter-btn.active {
                background-color: #212529 !important;
                color: white !important;
            }
        </style>
    </head>
    <body class="admin-body">

        <jsp:include page="admin_sidebar.jsp"/>

        <main class="main-wrapper p-4 p-lg-5 animate-fade-up">

            <% if (errorMsg != null) {%>
            <div class="alert alert-danger border-0 bg-danger bg-opacity-10 text-danger rounded-4 p-3 mb-4 d-flex align-items-center shadow-sm alert-dismissible fade show">
                <i class="bi bi-exclamation-circle-fill me-2 fs-5"></i>
                <div class="small fw-medium"><%= errorMsg%></div>
                <button type="button" class="btn-close ms-auto shadow-none small" data-bs-dismiss="alert"></button>
            </div>
            <% } %>
            <% if (successMsg != null) {%>
            <div class="alert alert-success border-0 bg-success bg-opacity-10 text-success rounded-4 p-3 mb-4 d-flex align-items-center shadow-sm alert-dismissible fade show">
                <i class="bi bi-check-circle-fill me-2 fs-5"></i>
                <div class="small fw-medium"><%= successMsg%></div>
                <button type="button" class="btn-close ms-auto shadow-none small" data-bs-dismiss="alert"></button>
            </div>
            <% }%>

            <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-end mb-4 pb-2">
                <div>
                    <h2 class="fw-bold tracking-tight mb-1 text-dark">Today's Bookings</h2>
                    <p class="text-muted small mb-0">Overview and update booking status</p>
                </div>
                <div class="mt-3 mt-md-0 d-flex gap-3 align-items-center">
                    <ul class="nav nav-pills bg-white p-2 rounded-pill shadow-sm border mb-0 d-inline-flex" id="statusFilters">
                        <li class="nav-item"><button class="nav-link filter-btn rounded-pill px-4 fw-medium text-dark" data-filter="ALL" onclick="filterTable('ALL', this)">All</button></li>
                        <li class="nav-item"><button class="nav-link filter-btn rounded-pill px-4 fw-medium text-dark" data-filter="Pending" onclick="filterTable('Pending', this)">Upcoming</button></li>
                        <li class="nav-item"><button class="nav-link filter-btn rounded-pill px-4 fw-medium text-dark" data-filter="InProgress" onclick="filterTable('InProgress', this)">Washing</button></li>
                        <li class="nav-item"><button class="nav-link filter-btn rounded-pill px-4 fw-medium text-dark" data-filter="Completed" onclick="filterTable('Completed', this)">Completed</button></li>
                    </ul>
                </div>
            </div>

            <div class="bg-white p-4 rounded-4 shadow-sm border border-light h-100 d-flex flex-column">

                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h6 class="fw-bold m-0 text-dark"><i class="bi bi-card-list me-2 text-primary"></i>Booking List</h6>
                    <span class="badge bg-primary bg-opacity-10 text-primary border border-primary border-opacity-25 rounded-pill px-3 py-1">
                        Total: <%= (listBooking != null) ? listBooking.size() : 0%>
                    </span>
                </div>

                <% if (listBooking == null || listBooking.isEmpty()) { %>
                <div class="d-flex flex-column justify-content-center align-items-center flex-grow-1 py-5">
                    <i class="bi bi-inbox text-muted opacity-25 mb-3" style="font-size: 4rem;"></i>
                    <h5 class="fw-bold text-dark">No Bookings Found</h5>
                </div>
                <% } else { %>
                <div class="table-responsive flex-grow-1" style="min-height: 400px;">
                    <table class="table table-custom table-borderless table-hover mb-0 align-middle">
                        <thead class="table-light">
                            <tr class="border-bottom border-light text-nowrap">
                                <th class="text-muted fw-bold small text-uppercase pb-3 ps-3 rounded-start">ID</th>
                                <th class="text-muted fw-bold small text-uppercase pb-3">Customer</th>
                                <th class="text-muted fw-bold small text-uppercase pb-3">Vehicle</th>
                                <th class="text-muted fw-bold small text-uppercase pb-3">Service</th>
                                <th class="text-muted fw-bold small text-uppercase pb-3">Time Slot</th>
                                <th class="text-muted fw-bold small text-uppercase pb-3 text-center">Status</th>
                                <th class="text-muted fw-bold small text-uppercase pb-3 text-end pe-3 rounded-end">Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                for (Booking b : listBooking) {
                                    String status = (b.getStatus() != null) ? b.getStatus() : "Pending";

                                    String startTimeStr = "N/A", endTimeStr = "N/A", dateStr = "";
                                    if (b.getTimeslot() != null) {
                                        LocalDateTime start = b.getTimeslot().getStart();
                                        LocalDateTime end = b.getTimeslot().getEnd();
                                        if (start != null) {
                                            startTimeStr = start.format(timeFormatter);
                                            dateStr = start.format(dateFormatter);
                                        }
                                        if (end != null) {
                                            endTimeStr = end.format(timeFormatter);
                                        }
                                    }
                            %>
                            <tr data-status="<%= status%>" class="border-bottom border-light booking-row <%= "Completed".equalsIgnoreCase(status) ? "bg-light bg-opacity-50" : ""%>">
                                <td class="text-muted small fw-medium ps-3 font-monospace">#<%= b.getBookingID()%></td>
                                <td><div class="fw-bold text-dark"><%= b.getCusName()%></div></td>
                                <td>
                                    <div class="d-flex align-items-center mb-1">
                                        <span class="fw-bold text-dark me-2"><%= b.getVehicleName()%></span>
                                        <span class="badge bg-light text-dark border"><%= b.getVehicleType()%></span>
                                    </div>
                                    <div class="font-monospace text-muted small px-2 py-1 bg-light rounded d-inline-block border">
                                        <%= b.getLicensePlate()%>
                                    </div>
                                </td>
                                <td><span class="text-primary fw-medium small"><i class="bi bi-stars me-1"></i><%= b.getService()%></span></td>
                                <td>
                                    <div class="text-dark fw-bold" style="font-size: 0.9rem;">
                                        <%= startTimeStr%> <i class="bi bi-arrow-right-short text-muted mx-1"></i> <%= endTimeStr%>
                                    </div>
                                    <div class="text-muted small"><%= dateStr%></div>
                                </td>

                                <td class="text-center">
                                    <% if ("Completed".equalsIgnoreCase(status)) { %>
                                    <span class="badge bg-success bg-opacity-10 text-success border border-success border-opacity-25 px-3 py-2 rounded-pill"><i class="bi bi-check-circle-fill me-1"></i>Completed</span>
                                    <% } else if ("InProgress".equalsIgnoreCase(status)) { %>
                                    <span class="badge bg-info bg-opacity-10 text-info border border-info border-opacity-25 px-3 py-2 rounded-pill"><span class="spinner-grow spinner-grow-sm me-1" role="status" style="width: 0.6rem; height: 0.6rem;"></span>Washing</span>
                                    <% } else if ("Pending".equalsIgnoreCase(status)) { %>
                                    <span class="badge bg-warning bg-opacity-10 text-warning border border-warning border-opacity-25 px-3 py-2 rounded-pill"><i class="bi bi-clock me-1"></i>Upcoming</span>
                                    <% } else {%>
                                    <span class="badge bg-secondary bg-opacity-10 text-secondary border border-secondary border-opacity-25 px-3 py-2 rounded-pill"><%= status%></span>
                                    <% } %>
                                </td>

                                <td class="text-end pe-3">
                                    <% if ("Pending".equalsIgnoreCase(status)) {%>
                                    <form action="BookingProcessController" method="POST" class="m-0 p-0 d-inline-block">
                                        <input type="hidden" name="action" value="checkin">
                                        <input type="hidden" name="id" value="<%= b.getBookingID()%>">
                                        <button type="submit" class="btn btn-sm btn-dark rounded-pill px-3 fw-medium">
                                            <i class="bi bi-box-arrow-in-right me-1"></i>Check In
                                        </button>
                                    </form>
                                    <% } else if ("InProgress".equalsIgnoreCase(status)) {%>
                                    <form action="BookingProcessController" method="POST" class="m-0 p-0 d-inline-block">
                                        <input type="hidden" name="action" value="checkout">
                                        <input type="hidden" name="id" value="<%= b.getBookingID()%>">
                                        <button type="submit" class="btn btn-sm btn-outline-danger rounded-pill px-3 fw-medium">
                                            Complete Wash
                                        </button>
                                    </form>
                                    <% } else if ("Completed".equalsIgnoreCase(status)) { %>
                                    <span class="text-success small fw-medium"><i class="bi bi-check2-all me-1"></i>Done</span>
                                    <% } %>
                                </td>
                            </tr>
                            <% } %>

                            <tr id="noDataRow" style="display: none;">
                                <td colspan="7" class="text-center py-5">
                                    <i class="bi bi-inbox opacity-25 mb-3 d-block" style="font-size: 3rem;"></i>
                                    <h6 class="text-muted fw-bold">No bookings match this filter</h6>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                <% }%>
            </div>

        </main>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

        <script>
                            document.addEventListener("DOMContentLoaded", function () {
                                // 1. Phục hồi tab đang xem
                                let savedFilter = sessionStorage.getItem('currentBookingFilter') || 'ALL';
                                let activeBtn = document.querySelector(`.filter-btn[data-filter="${savedFilter}"]`);
                                if (activeBtn) {
                                    filterTable(savedFilter, activeBtn, false);
                                } else {
                                    document.querySelector('.filter-btn[data-filter="ALL"]').classList.add('active', 'bg-dark', 'text-white');
                                }

                                // 2. TỰ ĐỘNG TẮT THÔNG BÁO SAU 4 GIÂY
                                setTimeout(function () {
                                    let alerts = document.querySelectorAll('.alert'); // Tìm tất cả các khung thông báo
                                    alerts.forEach(function (alert) {
                                        alert.style.transition = "opacity 0.5s ease-out, transform 0.5s ease-out";
                                        alert.style.opacity = "0"; // Làm mờ đi
                                        alert.style.transform = "translateY(-10px)"; // Trượt nhẹ lên trên

                                        // Xóa hẳn khỏi giao diện sau khi hiệu ứng mờ kết thúc (0.5s)
                                        setTimeout(() => {
                                            if (alert.parentNode)
                                                alert.parentNode.removeChild(alert);
                                        }, 500);
                                    });
                                }, 4000); // 4000 mili-giây = 4 giây
                            });

                            // ==================== LỌC DỮ LIỆU TABS ====================
                            function filterTable(status, btnElement, saveToSession = true) {
                                if (saveToSession)
                                    sessionStorage.setItem('currentBookingFilter', status);

                                document.querySelectorAll('.filter-btn').forEach(btn => {
                                    btn.classList.remove('active', 'bg-dark', 'text-white');
                                    btn.classList.add('text-dark');
                                });
                                btnElement.classList.remove('text-dark');
                                btnElement.classList.add('active', 'bg-dark', 'text-white');

                                let rows = document.querySelectorAll(".booking-row");
                                let visibleCount = 0;

                                rows.forEach(row => {
                                    if (status === 'ALL' || row.getAttribute('data-status') === status) {
                                        row.style.display = "";
                                        visibleCount++;
                                    } else {
                                        row.style.display = "none";
                                    }
                                });

                                let noDataRow = document.getElementById('noDataRow');
                                if (noDataRow)
                                    noDataRow.style.display = (visibleCount === 0) ? "" : "none";
                            }
        </script>
    </body>
</html>