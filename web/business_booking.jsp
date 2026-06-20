<%@page import="java.util.List"%>
<%@page import="dto.Service"%>
<%@page import="dto.Vehicle"%>
<%@page import="dto.Account"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    Account acc = (Account) session.getAttribute("ACCOUNT");
    if (acc == null) {
        response.sendRedirect("MainController?action=home");
        return;
    }
    List<Vehicle> vehicles = (List<Vehicle>) request.getAttribute("VEHICLES");
    List<Service> services = (List<Service>) request.getAttribute("SERVICES");
    String errorMsg = (String) request.getAttribute("ERROR_MSG");
    String businessName = (String) request.getAttribute("BUSINESS_NAME");
    Integer maxBookingDays = (Integer) request.getAttribute("MAX_BOOKING_DAYS");
    String tierName = (String) request.getAttribute("TIER_NAME");
    if (maxBookingDays == null || maxBookingDays < 1) maxBookingDays = 3;
    if (tierName == null) tierName = "Member";
    pageContext.setAttribute("busNavActive", "booking");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Business Booking | Elite Auto</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="css/style.css" rel="stylesheet">
    <link href="css/business.css" rel="stylesheet">
    <style>
        :root {
            --booking-accent: #212529;
            --booking-bg: #f3f4f6;
            --booking-border: #e5e7eb;
        }
        body { font-family: 'Inter', sans-serif; background: var(--booking-bg); min-height: 100vh; }
        .booking-wrap { max-width: 1140px; margin: 0 auto; padding: 2rem 1rem 3rem; }
        .booking-card {
            background: #fff; border-radius: 16px; border: 1px solid var(--booking-border);
            box-shadow: 0 4px 24px rgba(15, 23, 42, 0.06); padding: 1.75rem 2rem;
        }
        .panel-title { font-size: 1.35rem; font-weight: 700; margin-bottom: 0.5rem; }
        .date-pills { display: flex; gap: 0.5rem; overflow-x: auto; margin-bottom: 1.5rem; }
        .date-pill {
            flex: 0 0 auto; min-width: 58px; padding: 0.55rem 0.5rem; border: none;
            border-radius: 10px; background: #f1f5f9; color: #475569; text-align: center; cursor: pointer;
        }
        .date-pill.active { background: var(--booking-accent); color: #fff; }
        .date-pill .day-name { font-size: 0.65rem; font-weight: 600; display: block; }
        .date-pill .day-num { font-size: 1rem; font-weight: 700; display: block; }
        .time-btn {
            padding: 0.5rem 1rem; border: 1px solid #e2e8f0; border-radius: 8px;
            background: #f8fafc; font-size: 0.82rem; cursor: pointer;
        }
        .time-btn.active { background: var(--booking-accent); border-color: var(--booking-accent); color: #fff; }
        .vehicle-check {
            border: 1px solid #e2e8f0; border-radius: 10px; padding: 0.75rem 1rem;
            margin-bottom: 0.5rem; cursor: pointer; transition: all 0.15s;
        }
        .vehicle-check:hover { border-color: #cbd5e1; background: #f8fafc; }
        .vehicle-check.selected { border-color: var(--booking-accent); background: #f8fafc; }
        .vehicle-check input { margin-right: 0.75rem; }
        .summary-panel { position: sticky; top: 1.5rem; }
        .price-line { display: flex; justify-content: space-between; font-size: 0.82rem; padding: 0.35rem 0; }
        .total-amount { font-size: 1.75rem; font-weight: 800; }
        .btn-proceed {
            width: 100%; margin-top: 1.25rem; padding: 0.85rem; background: var(--booking-accent);
            color: #fff; border: none; border-radius: 10px; font-weight: 700;
        }
        .btn-proceed:disabled { background: #cbd5e1; cursor: not-allowed; }
        .booking-select {
            width: 100%; border: 1px solid #e2e8f0; border-radius: 10px;
            padding: 0.65rem 0.9rem; font-size: 0.88rem;
        }
        .booking-textarea {
            width: 100%; border: 1px solid #e2e8f0; border-radius: 10px;
            padding: 0.65rem 0.9rem; font-size: 0.88rem;
        }
        .bay-hint { font-size: 0.8rem; color: #64748b; }
        .bay-hint.ok { color: #16a34a; }
        .bay-hint.warn { color: #dc2626; }
    </style>
</head>
<body class="bus-page">
    <%@ include file="includes/business_nav.jsp" %>
    <div class="bus-booking-wrap">
        <% if (errorMsg != null) { %>
        <div class="alert alert-danger rounded-3 border-0 shadow-sm mb-3"><%= errorMsg %></div>
        <% } %>

        <% if (vehicles == null || vehicles.isEmpty()) { %>
        <div class="bus-booking-card text-center py-5">
            <i class="bi bi-truck fs-1 text-muted mb-3 d-block"></i>
            <h5 class="fw-bold">No active vehicles</h5>
            <p class="text-muted small mb-3">Add and get vehicles approved before booking.</p>
            <a href="MainController?action=AddBusinessVehicle_page" class="btn btn-black rounded-pill px-4">Add Vehicles</a>
        </div>
        <% } else { %>

        <form id="bookingForm" action="BusinessBookingController" method="post">
            <input type="hidden" name="action" value="submit">
            <input type="hidden" name="slotId" id="slotId">
            <input type="hidden" id="bookingDate">

            <div class="row g-4">
                <div class="col-lg-7">
                    <div class="bus-booking-card">
                        <h1 class="panel-title">Business Fleet Booking</h1>
                        <p class="text-muted small mb-4">
                            <i class="bi bi-building me-1"></i>
                            <%= businessName != null ? businessName : "Business" %> —
                            book multiple vehicles, one shared service, single payment.
                        </p>

                        <div class="small text-muted mb-2" id="dateMonthLabel">Select Date</div>
                        <div class="small text-muted mb-2">
                            <span class="badge bg-light text-dark border"><%= tierName %></span>
                            Book up to <strong><%= maxBookingDays %></strong> days ahead
                        </div>
                        <div class="date-pills" id="datePills"></div>

                        <div class="small fw-semibold text-muted mb-2">Select Time</div>
                        <div class="d-flex flex-wrap gap-2 mb-3" id="slotContainer">
                            <span class="text-muted small">Loading slots...</span>
                        </div>

                        <div class="mb-3">
                            <div class="small fw-semibold text-muted mb-2">
                                <i class="bi bi-droplet"></i> Service Package <span class="text-danger">*</span>
                            </div>
                            <select name="serviceId" id="serviceId" class="booking-select" required>
                                <option value="">Choose a wash service (shared for all vehicles)</option>
                                <% if (services != null) {
                                    for (Service s : services) {
                                        if (s.isStatus()) { %>
                                <option value="<%= s.getId() %>"><%= s.getName() %></option>
                                <% }}} %>
                            </select>
                        </div>

                        <div class="mb-3">
                            <div class="small fw-semibold text-muted mb-2">
                                <i class="bi bi-truck"></i> Select Vehicles <span class="text-danger">*</span>
                            </div>
                            <div id="vehicleList">
                                <% for (Vehicle v : vehicles) { %>
                                <label class="vehicle-check d-flex align-items-center w-100" data-id="<%= v.getVehicleID() %>">
                                    <input type="checkbox" name="vehicleIds" value="<%= v.getVehicleID() %>"
                                           data-plate="<%= v.getLicensePlate() %>"
                                           data-brand="<%= v.getBrandName() %>"
                                           data-model="<%= v.getModelName() %>">
                                    <div>
                                        <div class="fw-semibold"><%= v.getLicensePlate() %></div>
                                        <div class="small text-muted"><%= v.getBrandName() %> <%= v.getModelName() %></div>
                                    </div>
                                </label>
                                <% } %>
                            </div>
                            <div class="bay-hint mt-2" id="bayHint">Select vehicles to check bay availability.</div>
                        </div>

                        <div class="mb-0">
                            <div class="small fw-semibold text-muted mb-2">Notes (optional)</div>
                            <textarea name="notes" class="booking-textarea" rows="2"
                                      placeholder="Fleet instructions, contact person on site..."></textarea>
                        </div>
                    </div>
                </div>

                <div class="col-lg-5">
                    <div class="bus-booking-card summary-panel">
                        <h2 class="h5 fw-bold mb-3">Booking Summary</h2>

                        <div class="mb-3">
                            <div class="small text-muted text-uppercase fw-bold">Service</div>
                            <div class="fw-semibold" id="sumService">—</div>
                            <div class="small text-muted" id="sumDuration"></div>
                        </div>

                        <div class="mb-3">
                            <div class="small text-muted text-uppercase fw-bold">Date &amp; Time</div>
                            <div class="fw-semibold" id="sumDateTime">—</div>
                        </div>

                        <div class="mb-3">
                            <div class="small text-muted text-uppercase fw-bold">Vehicles</div>
                            <div id="sumVehicles" class="small text-muted">None selected</div>
                        </div>

                        <div class="mb-3" id="priceBreakdown"></div>

                        <div class="border-top pt-3">
                            <div class="small text-muted">Total (1 invoice)</div>
                            <div class="total-amount" id="sumTotal">—</div>
                            <div class="small text-muted mt-1">
                                <i class="bi bi-receipt me-1"></i>
                                Each vehicle = 1 booking, combined into one payment
                            </div>
                        </div>

                        <button type="submit" id="submitBtn" class="btn-proceed" disabled>Confirm &amp; Pay Now</button>
                    </div>
                </div>
            </div>
        </form>
        <% } %>
    </div>

    <script>
        const ctx = '<%= request.getContextPath() %>';
        const maxBookingDays = <%= maxBookingDays %>;
        const slotContainer = document.getElementById('slotContainer');
        const datePillsEl = document.getElementById('datePills');
        const dateInput = document.getElementById('bookingDate');
        const slotIdInput = document.getElementById('slotId');
        const submitBtn = document.getElementById('submitBtn');
        const serviceSelect = document.getElementById('serviceId');
        const bayHint = document.getElementById('bayHint');

        let selectedDate = new Date();
        let selectedSlotLabel = '';
        let priceData = null;
        let baysEnough = false;

        const DAY_NAMES = ['SUN','MON','TUE','WED','THU','FRI','SAT'];
        const MONTH_NAMES = ['January','February','March','April','May','June','July','August','September','October','November','December'];

        function pad(n) { return String(n).padStart(2, '0'); }
        function toIso(d) {
            return d.getFullYear() + '-' + pad(d.getMonth() + 1) + '-' + pad(d.getDate());
        }

        function getSelectedVehicleIds() {
            return Array.from(document.querySelectorAll('input[name="vehicleIds"]:checked'))
                .map(cb => cb.value);
        }

        function getSelectedVehicleCount() {
            return getSelectedVehicleIds().length;
        }

        document.querySelectorAll('.vehicle-check').forEach(label => {
            const cb = label.querySelector('input');
            cb.addEventListener('change', () => {
                label.classList.toggle('selected', cb.checked);
                onSelectionChanged();
            });
        });

        function onSelectionChanged() {
            checkBays();
            loadPrices();
        }

        serviceSelect.addEventListener('change', () => {
            loadPrices();
            updateSummary();
        });

        function buildDatePills() {
            const today = new Date();
            today.setHours(0, 0, 0, 0);
            datePillsEl.innerHTML = '';
            for (let i = 0; i < maxBookingDays; i++) {
                const d = new Date(today);
                d.setDate(today.getDate() + i);
                const btn = document.createElement('button');
                btn.type = 'button';
                btn.className = 'date-pill' + (i === 0 ? ' active' : '');
                btn.dataset.date = toIso(d);
                btn.innerHTML = '<span class="day-name">' + DAY_NAMES[d.getDay()] + '</span><span class="day-num">' + pad(d.getDate()) + '</span>';
                btn.addEventListener('click', function () {
                    document.querySelectorAll('.date-pill').forEach(p => p.classList.remove('active'));
                    btn.classList.add('active');
                    selectedDate = d;
                    dateInput.value = btn.dataset.date;
                    updateDateLabel();
                    loadSlots();
                });
                datePillsEl.appendChild(btn);
            }
            selectedDate = today;
            dateInput.value = toIso(today);
            updateDateLabel();
        }

        function updateDateLabel() {
            const label = document.getElementById('dateMonthLabel');
            if (label && selectedDate) {
                label.textContent = 'Select Date — ' + MONTH_NAMES[selectedDate.getMonth()] + ' ' + selectedDate.getFullYear();
            }
        }

        function formatSummaryDateTime() {
            if (!selectedSlotLabel || !selectedDate) return '—';
            const days = ['Sun','Mon','Tue','Wed','Thu','Fri','Sat'];
            const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
            return selectedSlotLabel + ' ' + days[selectedDate.getDay()] + ', ' + pad(selectedDate.getDate()) + ' ' + months[selectedDate.getMonth()] + ' ' + selectedDate.getFullYear();
        }

        function updateSummary() {
            const svcOpt = serviceSelect.options[serviceSelect.selectedIndex];
            document.getElementById('sumService').textContent = svcOpt && svcOpt.value ? svcOpt.text : '—';
            document.getElementById('sumDuration').textContent = priceData ? ('Est. up to ' + priceData.maxDuration + ' min per vehicle') : '';
            document.getElementById('sumDateTime').textContent = formatSummaryDateTime();

            const checked = document.querySelectorAll('input[name="vehicleIds"]:checked');
            const sumVehicles = document.getElementById('sumVehicles');
            const priceBreakdown = document.getElementById('priceBreakdown');
            if (checked.length === 0) {
                sumVehicles.textContent = 'None selected';
                priceBreakdown.innerHTML = '';
            } else {
                sumVehicles.innerHTML = checked.length + ' vehicle(s) selected';
                if (priceData && priceData.items) {
                    priceBreakdown.innerHTML = priceData.items.map(item =>
                        '<div class="price-line"><span>' + item.plate + '</span><span>' + Number(item.price).toLocaleString('vi-VN') + ' VND</span></div>'
                    ).join('');
                }
            }

            document.getElementById('sumTotal').textContent = priceData
                ? Number(priceData.total).toLocaleString('vi-VN') + ' VND'
                : '—';

            updateSubmitState();
        }

        function updateSubmitState() {
            const count = getSelectedVehicleCount();
            const ready = slotIdInput.value && count > 0 && serviceSelect.value && priceData && baysEnough;
            submitBtn.disabled = !ready;
        }

        function loadSlots() {
            slotIdInput.value = '';
            selectedSlotLabel = '';
            baysEnough = false;
            slotContainer.innerHTML = '<span class="text-muted small">Loading slots...</span>';
            updateSummary();

            fetch(ctx + '/BusinessBookingController?action=slots&date=' + dateInput.value)
                .then(r => r.json())
                .then(data => {
                    if (!data.success) {
                        slotContainer.innerHTML = '<span class="text-danger small">' + data.message + '</span>';
                        return;
                    }
                    if (!data.slots || data.slots.length === 0) {
                        slotContainer.innerHTML = '<span class="text-muted small">No available slots.</span>';
                        return;
                    }
                    slotContainer.innerHTML = '';
                    data.slots.forEach(slot => {
                        const btn = document.createElement('button');
                        btn.type = 'button';
                        btn.className = 'time-btn';
                        btn.textContent = slot.start + ' - ' + slot.end;
                        btn.title = slot.availableBays + ' bays available';
                        btn.dataset.slotId = slot.slotId;
                        btn.dataset.label = slot.start + ' - ' + slot.end;
                        btn.addEventListener('click', function () {
                            document.querySelectorAll('.time-btn').forEach(b => b.classList.remove('active'));
                            btn.classList.add('active');
                            slotIdInput.value = slot.slotId;
                            selectedSlotLabel = btn.dataset.label;
                            checkBays();
                            updateSummary();
                        });
                        slotContainer.appendChild(btn);
                    });
                })
                .catch(() => {
                    slotContainer.innerHTML = '<span class="text-danger small">Failed to load slots.</span>';
                });
        }

        function checkBays() {
            const count = getSelectedVehicleCount();
            if (!slotIdInput.value || count === 0) {
                baysEnough = false;
                bayHint.textContent = count === 0 ? 'Select vehicles to check bay availability.' : 'Select a time slot first.';
                bayHint.className = 'bay-hint mt-2';
                updateSubmitState();
                return;
            }
            bayHint.textContent = 'Checking available bays...';
            bayHint.className = 'bay-hint mt-2';
            fetch(ctx + '/BusinessBookingController?action=bays&slotId=' + slotIdInput.value + '&vehicleCount=' + count)
                .then(r => r.json())
                .then(data => {
                    if (!data.success) {
                        baysEnough = false;
                        bayHint.textContent = data.message || 'Could not check bays.';
                        bayHint.className = 'bay-hint warn mt-2';
                    } else if (data.enough) {
                        baysEnough = true;
                        bayHint.textContent = data.availableCount + ' bays available — enough for ' + count + ' vehicle(s). Bays auto-assigned.';
                        bayHint.className = 'bay-hint ok mt-2';
                    } else {
                        baysEnough = false;
                        bayHint.textContent = 'Only ' + data.availableCount + ' bay(s) available, but ' + count + ' vehicle(s) selected.';
                        bayHint.className = 'bay-hint warn mt-2';
                    }
                    updateSubmitState();
                })
                .catch(() => {
                    baysEnough = false;
                    bayHint.textContent = 'Failed to check bay availability.';
                    bayHint.className = 'bay-hint warn mt-2';
                    updateSubmitState();
                });
        }

        function loadPrices() {
            priceData = null;
            const ids = getSelectedVehicleIds();
            if (!serviceSelect.value || ids.length === 0) {
                updateSummary();
                return;
            }
            const params = new URLSearchParams();
            params.append('action', 'prices');
            params.append('serviceId', serviceSelect.value);
            ids.forEach(id => params.append('vehicleIds', id));

            fetch(ctx + '/BusinessBookingController?' + params.toString())
                .then(r => r.json())
                .then(data => {
                    priceData = data.success ? data : null;
                    updateSummary();
                })
                .catch(() => {
                    priceData = null;
                    updateSummary();
                });
        }

        if (datePillsEl) {
            buildDatePills();
            loadSlots();
        }
    </script>
</body>
</html>