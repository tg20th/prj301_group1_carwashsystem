<%@page import="dto.TimeSlotDTO"%>
<%@page import="java.util.List"%>
<%@page import="java.time.LocalDate"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>


<!DOCTYPE html>
<c:if test="${empty sessionScope.ACCOUNT}">
    <jsp:forward page="index.jsp"/>
</c:if>
<%
    List<TimeSlotDTO> slots = (List<TimeSlotDTO>) request.getAttribute("SLOTS");
    LocalDate selectedDate = (LocalDate) request.getAttribute("SELECTED_DATE");
    LocalDate prevDate = (LocalDate) request.getAttribute("PREV_DATE");
    LocalDate nextDate = (LocalDate) request.getAttribute("NEXT_DATE");

    if (selectedDate == null) {
        selectedDate = LocalDate.now();
    }
    if (prevDate == null) {
        prevDate = selectedDate.minusDays(1);
    }
    if (nextDate == null) {
        nextDate = selectedDate.plusDays(1);
    }

    DateTimeFormatter dateDisplay = DateTimeFormatter.ofPattern("EEEE, dd MMMM yyyy");
    DateTimeFormatter dateParam = DateTimeFormatter.ISO_LOCAL_DATE;
    DateTimeFormatter timeFmt = DateTimeFormatter.ofPattern("HH:mm");

    String successMsg = (String) request.getAttribute("success");
    String errorMsg = (String) request.getAttribute("error");
    String dateStr = selectedDate.format(dateParam);
%>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Time Slot Management | Elite Auto</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
        <link href="css/admin.css?v=1.1" rel="stylesheet">
    </head>
    <body class="admin-body">

        <%@ include file="admin_sidebar.jsp" %>

        <main class="main-wrapper p-4 p-lg-5 animate-fade-up">
            <div id="alertContainer">
                <% if (errorMsg != null) {%>
                <div class="alert alert-danger border-0 bg-danger bg-opacity-10 text-danger rounded-4 p-3 mb-4 d-flex align-items-center shadow-sm alert-dismissible fade show">
                    <i class="fa-solid fa-circle-exclamation me-2"></i>
                    <div class="small fw-medium"><%= errorMsg%></div>
                    <button type="button" class="btn-close ms-auto shadow-none" data-bs-dismiss="alert"></button>
                </div>
                <% } %>
                <% if (successMsg != null) {%>
                <div class="alert alert-success border-0 bg-success bg-opacity-10 text-success rounded-4 p-3 mb-4 d-flex align-items-center shadow-sm alert-dismissible fade show">
                    <i class="fa-solid fa-circle-check me-2"></i>
                    <div class="small fw-medium"><%= successMsg%></div>
                    <button type="button" class="btn-close ms-auto shadow-none" data-bs-dismiss="alert"></button>
                </div>
                <% }%>
            </div>

            <div class="d-flex flex-column flex-lg-row justify-content-between align-items-lg-end gap-3 mb-4 pb-2">
                <div>
                    <h2 class="fw-bold tracking-tight mb-1 text-dark">Time Slot Management</h2>
                    <p class="text-muted small mb-0">Fixed schedule: 24 slots/day (08:00–20:00). Empty dates stay empty until you Auto Generate.</p>
                </div>
                <div class="d-flex gap-2 flex-wrap">
                    <button class="btn btn-dark rounded-pill px-4 py-2 small fw-medium" id="btnAutoGenerate">
                        <i class="fa-solid fa-wand-magic-sparkles me-1"></i> Auto Generate
                    </button>
                </div>
            </div>

            <div class="bg-white rounded-4 shadow-sm border border-light p-4 mb-4">
                <div class="d-flex flex-column flex-md-row align-items-center justify-content-between gap-3">
                    <a href="TimeSlotController?date=<%= prevDate.format(dateParam)%>" class="btn btn-light rounded-pill px-4 py-2 fw-medium">
                        <i class="fa-solid fa-chevron-left me-1"></i> Previous Day
                    </a>
                    <div class="text-center">
                        <span class="badge bg-dark bg-opacity-10 text-dark rounded-pill px-3 py-2 mb-2 d-inline-block small fw-semibold">
                            <i class="fa-regular fa-calendar me-1"></i> Selected Date
                        </span>
                        <h3 class="fw-bold text-dark mb-1"><%= selectedDate.format(dateDisplay)%></h3>
                        <input type="date" id="datePicker" class="form-control form-control-sm border-light rounded-pill text-center mx-auto"
                               style="max-width: 200px;" value="<%= dateStr%>">
                    </div>
                    <a href="TimeSlotController?date=<%= nextDate.format(dateParam)%>" class="btn btn-light rounded-pill px-4 py-2 fw-medium">
                        Next Day <i class="fa-solid fa-chevron-right ms-1"></i>
                    </a>
                </div>
            </div>

            <div class="d-flex gap-3 mb-4 flex-wrap">
                <span class="badge rounded-pill px-3 py-2 slot-legend slot-available"><i class="fa-solid fa-circle me-1"></i> Has Availability</span>
                <span class="badge rounded-pill px-3 py-2 slot-legend slot-unavailable"><i class="fa-solid fa-circle me-1"></i> Full</span>
                <span class="text-muted small ms-auto align-self-center">
                    <%= (slots != null ? slots.size() : 0)%> slots &middot; Operating hours 08:00 – 20:00
                </span>
            </div>

            <% if (slots == null || slots.isEmpty()) { %>
            <div class="bg-white rounded-4 shadow-sm border border-light text-center py-5">
                <i class="fa-regular fa-clock fa-3x text-muted mb-3"></i>
                <p class="text-muted mb-1">No time slots for this date.</p>
                <p class="text-muted small mb-3">Click <strong>Auto Generate</strong> above to create 24 default slots.</p>
                <button class="btn btn-dark rounded-pill px-4 btn-auto-generate">
                    <i class="fa-solid fa-wand-magic-sparkles me-1"></i> Auto Generate
                </button>
            </div>
            <% } else { %>
            <div class="timeslot-grid">
                <% for (TimeSlotDTO slot : slots) {
                        boolean isFull = slot.isFull();
                        String statusClass = isFull ? "slot-card-unavailable" : "slot-card-available";
                        String statusIcon = isFull ? "fa-ban" : "fa-check-circle";
                        String statusLabel = isFull ? "FULL" : "OPEN";
                        String startStr = slot.getStartTime().toLocalTime().format(timeFmt);
                        String endStr = slot.getEndTime().toLocalTime().format(timeFmt);
                %>
                <div class="slot-card <%= statusClass%>" data-slot-id="<%= slot.getSlotId()%>"
                     data-full="<%= isFull%>"
                     data-start="<%= startStr%>"
                     data-end="<%= endStr%>">
                    <div class="slot-card-time"><%= startStr%> – <%= endStr%></div>
                    <div class="slot-card-status">
                        <i class="fa-solid <%= statusIcon%> me-1"></i><%= statusLabel%>
                    </div>
                    <div class="slot-card-hint small">
                        <%= slot.getBookedCount()%>/<%= slot.getTotalBayCount()%> booked
                        · <%= slot.getAvailableBayCount()%> free
                    </div>
                    <div class="slot-card-hint small">Click to view bookings</div>
                </div>
                <% } %>
            </div>
            <% }%>
        </main>

        <!-- Booking Details Modal -->
        <div class="modal fade" id="bookingModal" tabindex="-1">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content border-0 rounded-4 shadow">
                    <div class="modal-header border-0 pb-0">
                        <h5 class="modal-title fw-bold"><i class="fa-solid fa-calendar-check me-2"></i>Booking Details</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <div id="bookingLoading" class="text-center py-4 text-muted">
                            <div class="spinner-border spinner-border-sm me-2"></div> Loading...
                        </div>
                        <div id="bookingContent" class="d-none">
                            <div id="bookingList" class="vstack gap-3"></div>
                        </div>
                        <div id="bookingError" class="alert alert-danger d-none small rounded-3"></div>
                    </div>
                    <div class="modal-footer border-0 pt-0">
                        <button type="button" class="btn btn-dark rounded-pill px-4" data-bs-dismiss="modal">Close</button>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script>
        const APP_CONTEXT = '<%= request.getContextPath()%>';
        const CURRENT_DATE = '<%= dateStr%>';

        function showAlert(message, type) {
            const container = document.getElementById('alertContainer');
            const icon = type === 'success' ? 'fa-circle-check' : 'fa-circle-exclamation';
            const alertClass = type === 'success' ? 'alert-success bg-success bg-opacity-10 text-success' : 'alert-danger bg-danger bg-opacity-10 text-danger';
            container.innerHTML = '<div class="alert ' + alertClass + ' border-0 rounded-4 p-3 mb-4 d-flex align-items-center shadow-sm alert-dismissible fade show">'
                    + '<i class="fa-solid ' + icon + ' me-2"></i><div class="small fw-medium">' + message + '</div>'
                    + '<button type="button" class="btn-close ms-auto shadow-none" data-bs-dismiss="alert"></button></div>';
        }

        function reloadPage() {
            window.location.href = APP_CONTEXT + '/TimeSlotController?date=' + CURRENT_DATE;
        }

        document.getElementById('datePicker').addEventListener('change', function () {
            window.location.href = APP_CONTEXT + '/TimeSlotController?date=' + this.value;
        });

        function autoGenerateSlots() {
            const btn = document.getElementById('btnAutoGenerate');
            const originalHtml = btn ? btn.innerHTML : '';
            if (btn) {
                btn.disabled = true;
                btn.innerHTML = '<span class="spinner-border spinner-border-sm me-1"></span> Generating...';
            }

            fetch(APP_CONTEXT + '/TimeSlotController?action=generate&responseType=json&date=' + CURRENT_DATE, {method: 'POST'})
                    .then(function (r) {
                        if (!r.ok)
                            throw new Error('Server error (' + r.status + ')');
                        return r.json();
                    })
                    .then(function (data) {
                        showAlert(data.message, data.success ? 'success' : 'error');
                        if (data.success && (data.created > 0 || data.message.indexOf('already exist') >= 0)) {
                            setTimeout(reloadPage, data.created > 0 ? 800 : 1200);
                        }
                    })
                    .catch(function (err) {
                        showAlert('Auto generate failed: ' + err.message, 'error');
                    })
                    .finally(function () {
                        if (btn) {
                            btn.disabled = false;
                            btn.innerHTML = originalHtml;
                        }
                    });
        }

        document.getElementById('btnAutoGenerate').addEventListener('click', autoGenerateSlots);
        document.querySelectorAll('.btn-auto-generate').forEach(function (btn) {
            btn.addEventListener('click', autoGenerateSlots);
        });

        document.querySelectorAll('.slot-card').forEach(card => {
            card.addEventListener('click', function () {
                openBookingModal(card.dataset.slotId);
            });
        });

        function openBookingModal(slotId) {
            const modal = new bootstrap.Modal(document.getElementById('bookingModal'));
            const listEl = document.getElementById('bookingList');
            document.getElementById('bookingLoading').classList.remove('d-none');
            document.getElementById('bookingContent').classList.add('d-none');
            document.getElementById('bookingError').classList.add('d-none');
            listEl.innerHTML = '';
            modal.show();

            fetch(APP_CONTEXT + '/TimeSlotController?action=booking&slotId=' + slotId)
                    .then(r => r.json())
                    .then(data => {
                        document.getElementById('bookingLoading').classList.add('d-none');
                        if (data.success && data.bookings && data.bookings.length > 0) {
                            document.getElementById('bookingContent').classList.remove('d-none');
                            data.bookings.forEach(function (bk) {
                                const item = document.createElement('div');
                                item.className = 'border rounded-3 p-3';
                                item.innerHTML =
                                        '<div class="fw-semibold mb-1">Bay #' + bk.washBayId + ' · Booking #' + bk.bookingId + '</div>' +
                                        '<div class="small text-muted">' + bk.customerName + ' · ' + bk.licensePlate + '</div>' +
                                        '<div class="small">' + bk.service + '</div>' +
                                        '<div class="small text-muted">' + bk.vehicleInfo + '</div>' +
                                        '<div class="badge bg-dark bg-opacity-10 text-dark mt-2">' + bk.status + '</div>';
                                listEl.appendChild(item);
                            });
                        } else {
                            const errEl = document.getElementById('bookingError');
                            errEl.textContent = data.message || 'No bookings in this slot.';
                            errEl.classList.remove('d-none');
                        }
                    });
        }
        </script>
    </body>
</html>