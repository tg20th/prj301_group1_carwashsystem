<%@page import="dto.TimeSlotDTO"%>
<%@page import="java.util.List"%>
<%@page import="java.time.LocalDate"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<%
    List<TimeSlotDTO> slots = (List<TimeSlotDTO>) request.getAttribute("SLOTS");
    LocalDate selectedDate = (LocalDate) request.getAttribute("SELECTED_DATE");
    LocalDate prevDate = (LocalDate) request.getAttribute("PREV_DATE");
    LocalDate nextDate = (LocalDate) request.getAttribute("NEXT_DATE");

    if (selectedDate == null) selectedDate = LocalDate.now();
    if (prevDate == null) prevDate = selectedDate.minusDays(1);
    if (nextDate == null) nextDate = selectedDate.plusDays(1);

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
            <% if (errorMsg != null) { %>
            <div class="alert alert-danger border-0 bg-danger bg-opacity-10 text-danger rounded-4 p-3 mb-4 d-flex align-items-center shadow-sm alert-dismissible fade show">
                <i class="fa-solid fa-circle-exclamation me-2"></i>
                <div class="small fw-medium"><%= errorMsg %></div>
                <button type="button" class="btn-close ms-auto shadow-none" data-bs-dismiss="alert"></button>
            </div>
            <% } %>
            <% if (successMsg != null) { %>
            <div class="alert alert-success border-0 bg-success bg-opacity-10 text-success rounded-4 p-3 mb-4 d-flex align-items-center shadow-sm alert-dismissible fade show">
                <i class="fa-solid fa-circle-check me-2"></i>
                <div class="small fw-medium"><%= successMsg %></div>
                <button type="button" class="btn-close ms-auto shadow-none" data-bs-dismiss="alert"></button>
            </div>
            <% } %>
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
                <a href="TimeSlotController?date=<%= prevDate.format(dateParam) %>" class="btn btn-light rounded-pill px-4 py-2 fw-medium">
                    <i class="fa-solid fa-chevron-left me-1"></i> Previous Day
                </a>
                <div class="text-center">
                    <span class="badge bg-dark bg-opacity-10 text-dark rounded-pill px-3 py-2 mb-2 d-inline-block small fw-semibold">
                        <i class="fa-regular fa-calendar me-1"></i> Selected Date
                    </span>
                    <h3 class="fw-bold text-dark mb-1"><%= selectedDate.format(dateDisplay) %></h3>
                    <input type="date" id="datePicker" class="form-control form-control-sm border-light rounded-pill text-center mx-auto"
                           style="max-width: 200px;" value="<%= dateStr %>">
                </div>
                <a href="TimeSlotController?date=<%= nextDate.format(dateParam) %>" class="btn btn-light rounded-pill px-4 py-2 fw-medium">
                    Next Day <i class="fa-solid fa-chevron-right ms-1"></i>
                </a>
            </div>
        </div>

        <div class="d-flex gap-3 mb-4 flex-wrap">
            <span class="badge rounded-pill px-3 py-2 slot-legend slot-available"><i class="fa-solid fa-circle me-1"></i> Available</span>
            <span class="badge rounded-pill px-3 py-2 slot-legend slot-unavailable"><i class="fa-solid fa-circle me-1"></i> Unavailable</span>
            <span class="badge rounded-pill px-3 py-2 slot-legend slot-maintenance"><i class="fa-solid fa-circle me-1"></i> Maintenance</span>
            <span class="text-muted small ms-auto align-self-center">
                <%= (slots != null ? slots.size() : 0) %> slots &middot; Operating hours 08:00 – 20:00
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
                String status = slot.getStatus() != null ? slot.getStatus() : "AVAILABLE";
                String statusClass = "slot-card-available";
                String statusIcon = "fa-check-circle";
                if ("UNAVAILABLE".equals(status)) {
                    statusClass = "slot-card-unavailable";
                    statusIcon = "fa-ban";
                } else if ("MAINTENANCE".equals(status)) {
                    statusClass = "slot-card-maintenance";
                    statusIcon = "fa-wrench";
                }
                String startStr = slot.getStartTime().toLocalTime().format(timeFmt);
                String endStr = slot.getEndTime().toLocalTime().format(timeFmt);
                String note = slot.getMaintenanceNote() != null ? slot.getMaintenanceNote() : "";
            %>
            <div class="slot-card <%= statusClass %>" data-slot-id="<%= slot.getSlotId() %>"
                 data-status="<%= status %>"
                 data-start="<%= startStr %>"
                 data-end="<%= endStr %>"
                 data-note="<%= note.replace("\"", "&quot;") %>">
                <div class="slot-card-time"><%= startStr %> – <%= endStr %></div>
                <div class="slot-card-status">
                    <i class="fa-solid <%= statusIcon %> me-1"></i><%= status %>
                </div>
                <% if ("AVAILABLE".equals(status)) { %>
                <div class="slot-card-actions">
                    <button type="button" class="btn btn-sm btn-warning rounded-pill slot-action-maint text-dark"
                            title="Mark as Maintenance"
                            data-slot-id="<%= slot.getSlotId() %>"
                            data-start="<%= startStr %>"
                            data-end="<%= endStr %>">
                        <i class="fa-solid fa-wrench"></i>
                    </button>
                </div>
                <div class="slot-card-hint small">Click to view · <i class="fa-solid fa-wrench"></i> maintenance</div>
                <% } else if ("UNAVAILABLE".equals(status)) { %>
                <div class="slot-card-hint small">Click to view booking</div>
                <% } else if ("MAINTENANCE".equals(status)) { %>
                <div class="slot-card-hint small text-truncate" title="<%= note %>">
                    <%= note.isEmpty() ? "No note" : note %>
                </div>
                <div class="slot-card-hint small">Click to update or restore</div>
                <% } %>
            </div>
            <% } %>
        </div>
        <% } %>
    </main>

    <!-- View Details Modal -->
    <div class="modal fade" id="viewSlotModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 rounded-4 shadow">
                <div class="modal-header border-0 pb-0">
                    <h5 class="modal-title fw-bold"><i class="fa-solid fa-eye me-2"></i>Slot Details</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="row g-3">
                        <div class="col-6"><span class="text-muted small">Start Time</span><div class="fw-semibold" id="viewStart"></div></div>
                        <div class="col-6"><span class="text-muted small">End Time</span><div class="fw-semibold" id="viewEnd"></div></div>
                        <div class="col-12"><span class="text-muted small">Status</span><div class="fw-semibold" id="viewStatus"></div></div>
                    </div>
                </div>
                <div class="modal-footer border-0 pt-0">
                    <button type="button" class="btn btn-light rounded-pill px-4" data-bs-dismiss="modal">Close</button>
                    <button type="button" class="btn btn-warning rounded-pill px-4 text-dark d-none" id="btnViewToMaint">
                        <i class="fa-solid fa-wrench me-1"></i> Mark as Maintenance
                    </button>
                </div>
            </div>
        </div>
    </div>

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
                        <div class="row g-3">
                            <div class="col-6"><span class="text-muted small">Booking ID</span><div class="fw-semibold" id="bkId"></div></div>
                            <div class="col-6"><span class="text-muted small">Status</span><div class="fw-semibold" id="bkStatus"></div></div>
                            <div class="col-12"><span class="text-muted small">Customer Name</span><div class="fw-semibold" id="bkCustomer"></div></div>
                            <div class="col-12"><span class="text-muted small">Service</span><div class="fw-semibold" id="bkService"></div></div>
                            <div class="col-12"><span class="text-muted small">Vehicle Information</span><div class="fw-semibold" id="bkVehicle"></div></div>
                            <div class="col-12"><span class="text-muted small">Booking Time</span><div class="fw-semibold" id="bkTime"></div></div>
                        </div>
                    </div>
                    <div id="bookingError" class="alert alert-danger d-none small rounded-3"></div>
                </div>
                <div class="modal-footer border-0 pt-0">
                    <button type="button" class="btn btn-dark rounded-pill px-4" data-bs-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Maintenance Modal -->
    <div class="modal fade" id="maintenanceModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 rounded-4 shadow">
                <div class="modal-header border-0 pb-0">
                    <h5 class="modal-title fw-bold" id="maintModalTitle"><i class="fa-solid fa-wrench me-2"></i>Mark as Maintenance</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form id="maintenanceForm" novalidate>
                    <div class="modal-body">
                        <input type="hidden" name="slotId" id="maintSlotId">
                        <input type="hidden" name="slotDate" value="<%= dateStr %>">
                        <input type="hidden" name="updateAction" value="maintenance">
                        <input type="hidden" name="responseType" value="json">
                        <p class="text-muted small mb-3" id="maintTimeLabel"></p>
                        <p class="text-muted small mb-3" id="maintModeHint">Enter the reason for blocking this time slot from bookings.</p>
                        <div class="mb-3">
                            <label class="form-label small fw-semibold text-muted">Maintenance Reason / Note</label>
                            <textarea name="maintenanceNote" id="maintNote" class="form-control rounded-3" rows="3"
                                      placeholder="e.g. Bay equipment repair, scheduled downtime..." required></textarea>
                        </div>
                        <div id="maintError" class="alert alert-danger d-none small rounded-3"></div>
                    </div>
                    <div class="modal-footer border-0 pt-0 d-flex justify-content-between w-100">
                        <button type="button" class="btn btn-success rounded-pill px-4 d-none" id="btnRestoreSlot">
                            <i class="fa-solid fa-rotate-left me-1"></i> Restore Available
                        </button>
                        <div class="ms-auto d-flex gap-2">
                            <button type="button" class="btn btn-light rounded-pill px-4" data-bs-dismiss="modal">Cancel</button>
                            <button type="submit" class="btn btn-warning rounded-pill px-4 text-dark" id="maintSubmitBtn">Confirm</button>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        const APP_CONTEXT = '<%= request.getContextPath() %>';
        const CURRENT_DATE = '<%= dateStr %>';
        let maintenanceModalInstance = null;

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

            fetch(APP_CONTEXT + '/TimeSlotController?action=generate&responseType=json&date=' + CURRENT_DATE, { method: 'POST' })
                .then(function (r) {
                    if (!r.ok) throw new Error('Server error (' + r.status + ')');
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

        let pendingMaintSlot = null;

        function openMaintenanceModal(slotId, start, end, note, isUpdate) {
            document.getElementById('maintSlotId').value = slotId;
            document.getElementById('maintNote').value = note || '';
            document.getElementById('maintTimeLabel').textContent = start + ' – ' + end;
            document.getElementById('maintError').classList.add('d-none');

            const titleEl = document.getElementById('maintModalTitle');
            const hintEl = document.getElementById('maintModeHint');
            const submitBtn = document.getElementById('maintSubmitBtn');
            const restoreBtn = document.getElementById('btnRestoreSlot');

            if (isUpdate) {
                titleEl.innerHTML = '<i class="fa-solid fa-wrench me-2"></i>Maintenance Slot';
                hintEl.textContent = 'Update the note or restore this slot back to available for bookings.';
                submitBtn.textContent = 'Update Note';
                restoreBtn.classList.remove('d-none');
            } else {
                titleEl.innerHTML = '<i class="fa-solid fa-wrench me-2"></i>Mark as Maintenance';
                hintEl.textContent = 'This slot will be blocked from new bookings.';
                submitBtn.textContent = 'Confirm';
                restoreBtn.classList.add('d-none');
            }

            const modalEl = document.getElementById('maintenanceModal');
            maintenanceModalInstance = bootstrap.Modal.getOrCreateInstance(modalEl);
            maintenanceModalInstance.show();
        }

        function submitMaintenanceForm() {
            const form = document.getElementById('maintenanceForm');
            const errEl = document.getElementById('maintError');
            const submitBtn = document.getElementById('maintSubmitBtn');
            const note = document.getElementById('maintNote').value.trim();
            const slotId = document.getElementById('maintSlotId').value;

            errEl.classList.add('d-none');

            if (!slotId) {
                errEl.textContent = 'Invalid slot. Please close and try again.';
                errEl.classList.remove('d-none');
                return;
            }
            if (!note) {
                errEl.textContent = 'Maintenance reason is required.';
                errEl.classList.remove('d-none');
                document.getElementById('maintNote').focus();
                return;
            }

            const originalText = submitBtn.textContent;
            submitBtn.disabled = true;
            submitBtn.textContent = 'Saving...';

            postSlotAction('maintenance', { maintenanceNote: note }, null).finally(function () {
                submitBtn.disabled = false;
                submitBtn.textContent = originalText;
            });
        }

        function postSlotAction(updateAction, extraParams, onSuccess) {
            const errEl = document.getElementById('maintError');
            const slotId = document.getElementById('maintSlotId').value;
            errEl.classList.add('d-none');

            if (!slotId) {
                errEl.textContent = 'Invalid slot. Please close and try again.';
                errEl.classList.remove('d-none');
                return;
            }

            const params = new URLSearchParams();
            params.append('slotId', slotId);
            params.append('slotDate', CURRENT_DATE);
            params.append('updateAction', updateAction);
            params.append('responseType', 'json');
            if (extraParams) {
                Object.keys(extraParams).forEach(function (key) {
                    params.append(key, extraParams[key]);
                });
            }

            return fetch(APP_CONTEXT + '/UpdateTimeSlotController', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8',
                    'X-Requested-With': 'XMLHttpRequest'
                },
                body: params.toString()
            })
                .then(function (response) {
                    if (!response.ok) {
                        throw new Error('Server error (' + response.status + ')');
                    }
                    return response.json();
                })
                .then(function (data) {
                    if (data.success) {
                        if (maintenanceModalInstance) {
                            maintenanceModalInstance.hide();
                        }
                        showAlert(data.message, 'success');
                        setTimeout(reloadPage, 600);
                        if (onSuccess) onSuccess();
                    } else {
                        errEl.textContent = data.message || 'Request failed.';
                        errEl.classList.remove('d-none');
                    }
                })
                .catch(function (err) {
                    errEl.textContent = 'Request failed: ' + err.message;
                    errEl.classList.remove('d-none');
                });
        }

        document.getElementById('btnRestoreSlot').addEventListener('click', function () {
            if (!confirm('Restore this slot to AVAILABLE? It will be open for bookings again.')) return;
            const btn = this;
            const originalText = btn.innerHTML;
            btn.disabled = true;
            btn.innerHTML = '<span class="spinner-border spinner-border-sm me-1"></span> Restoring...';
            postSlotAction('restore', null, null).finally(function () {
                btn.disabled = false;
                btn.innerHTML = originalText;
            });
        });

        document.getElementById('btnViewToMaint').addEventListener('click', function () {
            if (!pendingMaintSlot) return;
            const viewModal = bootstrap.Modal.getInstance(document.getElementById('viewSlotModal'));
            if (viewModal) viewModal.hide();
            openMaintenanceModal(pendingMaintSlot.id, pendingMaintSlot.start, pendingMaintSlot.end, '', false);
        });

        document.querySelectorAll('.slot-action-maint').forEach(btn => {
            btn.addEventListener('click', function (e) {
                e.stopPropagation();
                openMaintenanceModal(
                    this.dataset.slotId,
                    this.dataset.start,
                    this.dataset.end,
                    '',
                    false
                );
            });
        });

        document.getElementById('maintenanceForm').addEventListener('submit', function (e) {
            e.preventDefault();
            submitMaintenanceForm();
        });

        document.getElementById('maintSubmitBtn').addEventListener('click', function (e) {
            e.preventDefault();
            submitMaintenanceForm();
        });

        document.querySelectorAll('.slot-card').forEach(card => {
            const status = card.dataset.status;
            const slotId = card.dataset.slotId;

            card.addEventListener('click', function (e) {
                if (e.target.closest('.slot-action-maint')) return;

                if (status === 'UNAVAILABLE') {
                    openBookingModal(slotId);
                } else if (status === 'MAINTENANCE') {
                    openMaintenanceModal(slotId, card.dataset.start, card.dataset.end, card.dataset.note || '', true);
                } else {
                    pendingMaintSlot = { id: slotId, start: card.dataset.start, end: card.dataset.end };
                    document.getElementById('viewStart').textContent = card.dataset.start;
                    document.getElementById('viewEnd').textContent = card.dataset.end;
                    document.getElementById('viewStatus').textContent = status;
                    document.getElementById('btnViewToMaint').classList.remove('d-none');
                    new bootstrap.Modal(document.getElementById('viewSlotModal')).show();
                }
            });
        });

        function openBookingModal(slotId) {
            const modal = new bootstrap.Modal(document.getElementById('bookingModal'));
            document.getElementById('bookingLoading').classList.remove('d-none');
            document.getElementById('bookingContent').classList.add('d-none');
            document.getElementById('bookingError').classList.add('d-none');
            modal.show();

            fetch(APP_CONTEXT + '/TimeSlotController?action=booking&slotId=' + slotId)
                .then(r => r.json())
                .then(data => {
                    document.getElementById('bookingLoading').classList.add('d-none');
                    if (data.success) {
                        document.getElementById('bookingContent').classList.remove('d-none');
                        document.getElementById('bkId').textContent = data.data.bookingId;
                        document.getElementById('bkStatus').textContent = data.data.status;
                        document.getElementById('bkCustomer').textContent = data.data.customerName;
                        document.getElementById('bkService').textContent = data.data.service;
                        document.getElementById('bkVehicle').textContent = data.data.vehicleInfo + ' · ' + data.data.licensePlate;
                        document.getElementById('bkTime').textContent = data.data.bookingTime;
                    } else {
                        const errEl = document.getElementById('bookingError');
                        errEl.textContent = data.message;
                        errEl.classList.remove('d-none');
                    }
                });
        }
    </script>
</body>
</html>