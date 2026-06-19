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
    String successMsg = (String) request.getAttribute("SUCCESS_MSG");
    Integer maxBookingDays = (Integer) request.getAttribute("MAX_BOOKING_DAYS");
    String tierName = (String) request.getAttribute("TIER_NAME");
    if (maxBookingDays == null || maxBookingDays < 1) maxBookingDays = 3;
    if (tierName == null) tierName = "Member";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Book Car Wash | Elite Auto</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="css/style.css" rel="stylesheet">
    <style>
        :root {
            --booking-accent: #212529;
            --booking-accent-hover: #000000;
            --booking-bg: #f3f4f6;
            --booking-card: #ffffff;
            --booking-muted: #94a3b8;
            --booking-border: #e5e7eb;
        }

        body.booking-page {
            font-family: 'Inter', sans-serif;
            background: var(--booking-bg);
            min-height: 100vh;
            position: relative;
            overflow-x: hidden;
        }

        .booking-decor {
            position: fixed;
            border-radius: 50%;
            pointer-events: none;
            z-index: 0;
        }
        .booking-decor-1 {
            width: 280px; height: 280px;
            background: radial-gradient(circle, rgba(0,0,0,0.04) 0%, transparent 70%);
            top: -60px; left: -80px;
        }
        .booking-decor-2 {
            width: 320px; height: 320px;
            background: radial-gradient(circle, rgba(0,0,0,0.03) 0%, transparent 70%);
            bottom: 10%; right: -100px;
        }

        .booking-wrap {
            position: relative;
            z-index: 1;
            max-width: 1140px;
            margin: 0 auto;
            padding: 2rem 1rem 3rem;
        }

        .booking-card {
            background: var(--booking-card);
            border-radius: 16px;
            border: 1px solid var(--booking-border);
            box-shadow: 0 4px 24px rgba(15, 23, 42, 0.06);
            padding: 1.75rem 2rem;
        }

        .booking-back {
            color: #334155;
            text-decoration: none;
            font-size: 0.9rem;
            display: inline-flex;
            align-items: center;
            gap: 0.35rem;
            margin-bottom: 1.25rem;
        }
        .booking-back:hover { color: var(--booking-accent); }

        .panel-title {
            font-size: 1.35rem;
            font-weight: 700;
            color: #0f172a;
            margin-bottom: 1.5rem;
        }

        .section-label {
            font-size: 0.8rem;
            font-weight: 600;
            color: #64748b;
            margin-bottom: 0.75rem;
            text-transform: none;
        }

        .tier-booking-hint {
            font-size: 0.78rem;
            color: #64748b;
            margin: -0.75rem 0 1rem;
            display: flex;
            align-items: center;
            gap: 0.4rem;
            flex-wrap: wrap;
        }
        .tier-booking-badge {
            display: inline-flex;
            align-items: center;
            gap: 0.25rem;
            background: #f1f5f9;
            border: 1px solid #e2e8f0;
            color: #212529;
            font-size: 0.72rem;
            font-weight: 700;
            padding: 0.2rem 0.55rem;
            border-radius: 999px;
        }

        .date-pills {
            display: flex;
            gap: 0.5rem;
            overflow-x: auto;
            padding-bottom: 0.25rem;
            margin-bottom: 1.5rem;
        }
        .date-pill {
            flex: 0 0 auto;
            min-width: 58px;
            padding: 0.55rem 0.5rem;
            border: none;
            border-radius: 10px;
            background: #f1f5f9;
            color: #475569;
            text-align: center;
            cursor: pointer;
            transition: all 0.2s ease;
        }
        .date-pill .day-name { font-size: 0.65rem; font-weight: 600; text-transform: uppercase; display: block; }
        .date-pill .day-num { font-size: 1rem; font-weight: 700; display: block; line-height: 1.2; }
        .date-pill:hover { background: #e2e8f0; }
        .date-pill.active {
            background: var(--booking-accent);
            color: #fff;
        }

        .time-grid {
            display: flex;
            flex-wrap: wrap;
            gap: 0.5rem;
            margin-bottom: 1.5rem;
        }
        .time-btn, .bay-btn {
            padding: 0.5rem 1rem;
            border: 1px solid #e2e8f0;
            border-radius: 8px;
            background: #f8fafc;
            color: #475569;
            font-size: 0.82rem;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.2s ease;
        }
        .time-btn:hover, .bay-btn:hover { border-color: #cbd5e1; background: #f1f5f9; }
        .time-btn.active, .bay-btn.active {
            background: var(--booking-accent);
            border-color: var(--booking-accent);
            color: #fff;
        }
        .time-btn:disabled { opacity: 0.45; cursor: not-allowed; }

        .field-block {
            margin-bottom: 1.25rem;
        }
        .field-label {
            font-size: 0.85rem;
            font-weight: 600;
            color: #334155;
            margin-bottom: 0.5rem;
            display: flex;
            align-items: center;
            gap: 0.4rem;
        }
        .field-label i { color: var(--booking-muted); font-size: 1rem; }

        .booking-select, .booking-input, .booking-textarea {
            width: 100%;
            border: 1px solid #e2e8f0;
            border-radius: 10px;
            padding: 0.65rem 0.9rem;
            font-size: 0.88rem;
            color: #334155;
            background: #fafbfc;
            transition: border-color 0.2s;
        }
        .booking-select:focus, .booking-input:focus, .booking-textarea:focus {
            outline: none;
            border-color: var(--booking-accent);
            box-shadow: 0 0 0 3px rgba(33, 37, 41, 0.1);
            background: #fff;
        }

        .summary-panel { position: sticky; top: 1.5rem; }
        .summary-title {
            font-size: 1.2rem;
            font-weight: 700;
            color: #0f172a;
            margin-bottom: 1.25rem;
        }
        .summary-row {
            padding: 0.85rem 0;
            border-bottom: 1px solid #f1f5f9;
        }
        .summary-row:last-of-type { border-bottom: none; }
        .summary-head {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 0.35rem;
        }
        .summary-head span {
            font-size: 0.72rem;
            font-weight: 700;
            color: #94a3b8;
            text-transform: uppercase;
            letter-spacing: 0.04em;
        }
        .summary-edit {
            font-size: 0.78rem;
            color: var(--booking-accent);
            text-decoration: none;
            font-weight: 600;
            cursor: pointer;
            border: none;
            background: none;
            padding: 0;
        }
        .summary-edit:hover { text-decoration: underline; }
        .summary-value {
            font-size: 0.9rem;
            font-weight: 600;
            color: #1e293b;
        }
        .summary-sub {
            font-size: 0.8rem;
            color: #64748b;
            margin-top: 0.15rem;
        }
        .summary-check {
            font-size: 0.78rem;
            color: #16a34a;
            margin-top: 0.35rem;
            display: flex;
            align-items: center;
            gap: 0.3rem;
        }

        .total-block {
            margin-top: 1rem;
            padding-top: 1rem;
            border-top: 2px solid #f1f5f9;
        }
        .total-label { font-size: 0.85rem; color: #64748b; font-weight: 500; }
        .total-amount {
            font-size: 1.75rem;
            font-weight: 800;
            color: #0f172a;
            letter-spacing: -0.02em;
        }

        .btn-proceed {
            width: 100%;
            margin-top: 1.25rem;
            padding: 0.85rem;
            background: var(--booking-accent);
            color: #fff;
            border: none;
            border-radius: 10px;
            font-size: 0.95rem;
            font-weight: 700;
            transition: background 0.2s;
        }
        .btn-proceed:hover:not(:disabled) { background: var(--booking-accent-hover); color: #fff; }
        .btn-proceed:disabled {
            background: #cbd5e1;
            cursor: not-allowed;
        }

        .help-box {
            margin-top: 1.25rem;
            padding: 1rem;
            background: #f8fafc;
            border-radius: 12px;
            border: 1px solid #f1f5f9;
        }
        .help-box p { font-size: 0.78rem; color: #64748b; margin: 0.35rem 0 0.75rem; }
        .btn-chat {
            font-size: 0.8rem;
            font-weight: 600;
            color: var(--booking-accent);
            border: 1px solid var(--booking-accent);
            background: #fff;
            border-radius: 8px;
            padding: 0.4rem 1rem;
            text-decoration: none;
            display: inline-block;
        }
        .btn-chat:hover { background: var(--booking-accent); color: #fff; }

        .empty-state {
            text-align: center;
            padding: 3rem 2rem;
        }

        @media (max-width: 991px) {
            .summary-panel { position: static; margin-top: 1rem; }
            .booking-card { padding: 1.25rem 1.25rem; }
        }
    </style>
</head>
<body class="booking-page">
    <div class="booking-decor booking-decor-1"></div>
    <div class="booking-decor booking-decor-2"></div>

    <div class="booking-wrap">
        <% if (errorMsg != null) { %>
        <div class="alert alert-danger rounded-3 border-0 shadow-sm mb-3"><%= errorMsg %></div>
        <% } %>
        <% if (successMsg != null) { %>
        <div class="alert alert-success rounded-3 border-0 shadow-sm mb-3"><%= successMsg %></div>
        <% } %>

        <% if (vehicles == null || vehicles.isEmpty()) { %>
        <div class="booking-card empty-state">
            <i class="bi bi-car-front fs-1 text-muted mb-3 d-block"></i>
            <h5 class="fw-bold">No vehicle registered</h5>
            <p class="text-muted small mb-3">Add a vehicle before booking a car wash service.</p>
            <a href="MainController?action=AddVehicle_page" class="btn btn-proceed" style="width:auto;padding:0.6rem 2rem;">Add Vehicle</a>
        </div>
        <% } else { %>

        <form id="bookingForm" action="CustomerBookingController" method="post">
            <input type="hidden" name="action" value="submit">
            <input type="hidden" name="slotId" id="slotId">
            <input type="hidden" name="washBayId" id="washBayId">
            <input type="hidden" id="bookingDate" name="bookingDateHidden">

            <div class="row g-4">
                <!-- LEFT: Select a Slot -->
                <div class="col-lg-7">
                    <div class="booking-card">
                        <a href="CustomerDashBoardController" class="booking-back">
                            <i class="bi bi-arrow-left"></i> Back
                        </a>
                        <h1 class="panel-title">Select a Slot</h1>

                        <div class="section-label" id="dateMonthLabel">Select Date</div>
                        <div class="tier-booking-hint">
                            <span class="tier-booking-badge"><i class="bi bi-shield-check"></i> <%= tierName %></span>
                            <span>Book up to <strong><%= maxBookingDays %></strong> day<%= maxBookingDays > 1 ? "s" : "" %> ahead</span>
                        </div>
                        <div class="date-pills" id="datePills"></div>

                        <div class="section-label">Select Time</div>
                        <div class="time-grid" id="slotContainer">
                            <span class="text-muted small">Loading available slots...</span>
                        </div>

                        <div class="field-block" id="baySection" style="display:none;">
                            <div class="field-label"><i class="bi bi-geo-alt"></i> Select Wash Bay</div>
                            <div class="time-grid" id="bayContainer"></div>
                        </div>

                        <div class="field-block">
                            <div class="field-label"><i class="bi bi-car-front"></i> Your Vehicle <span class="text-danger">*</span></div>
                            <select name="vehicleId" id="vehicleId" class="booking-select" required>
                                <option value="">Choose your vehicle</option>
                                <% for (Vehicle v : vehicles) { %>
                                <option value="<%= v.getVehicleID() %>"
                                        data-plate="<%= v.getLicensePlate() %>"
                                        data-brand="<%= v.getBrandName() %>"
                                        data-model="<%= v.getModelName() %>">
                                    <%= v.getLicensePlate() %> — <%= v.getBrandName() %> <%= v.getModelName() %>
                                </option>
                                <% } %>
                            </select>
                        </div>

                        <div class="field-block">
                            <div class="field-label"><i class="bi bi-droplet"></i> Service Package <span class="text-danger">*</span></div>
                            <select name="serviceId" id="serviceId" class="booking-select" required>
                                <option value="">Choose a wash service</option>
                                <% if (services != null) {
                                    for (Service s : services) {
                                        if (s.isStatus()) { %>
                                <option value="<%= s.getId() %>"><%= s.getName() %></option>
                                <% }}} %>
                            </select>
                        </div>

                        <div class="field-block">
                            <div class="field-label"><i class="bi bi-telephone"></i> Contact Number</div>
                            <input type="text" class="booking-input" value="<%= acc.getPhone() != null ? acc.getPhone() : "" %>" readonly>
                            <div class="summary-sub mt-1">Booking confirmation will be sent to this number.</div>
                        </div>

                        <div class="field-block mb-0">
                            <div class="field-label"><i class="bi bi-chat-left-text"></i> Special Requests (optional)</div>
                            <textarea name="notes" id="notes" class="booking-textarea" rows="2" placeholder="Any special instructions for your wash..."></textarea>
                        </div>
                    </div>
                </div>

                <!-- RIGHT: Booking Details -->
                <div class="col-lg-5">
                    <div class="booking-card summary-panel">
                        <h2 class="summary-title">Booking Details</h2>

                        <div class="summary-row">
                            <div class="summary-head">
                                <span>Service Added</span>
                                <button type="button" class="summary-edit" onclick="focusField('serviceId')">Edit</button>
                            </div>
                            <div class="summary-value" id="sumService">—</div>
                            <div class="summary-sub" id="sumDuration"></div>
                        </div>

                        <div class="summary-row">
                            <div class="summary-head">
                                <span>Wash Center</span>
                                <button type="button" class="summary-edit" onclick="focusBay()">Change</button>
                            </div>
                            <div class="summary-value">Elite Auto Wash</div>
                            <div class="summary-sub">Premium car care center — Ho Chi Minh City</div>
                            <div class="summary-value mt-2" id="sumBay">—</div>
                            <div class="summary-check" id="sumBayCheck" style="display:none;">
                                <i class="bi bi-check-circle-fill"></i> Wash bay confirmed
                            </div>
                        </div>

                        <div class="summary-row">
                            <div class="summary-head">
                                <span>Date &amp; Time</span>
                                <button type="button" class="summary-edit" onclick="document.getElementById('datePills').scrollIntoView({behavior:'smooth'})">Edit</button>
                            </div>
                            <div class="summary-value" id="sumDateTime">—</div>
                        </div>

                        <div class="summary-row">
                            <div class="summary-head">
                                <span>Booked For</span>
                                <button type="button" class="summary-edit" onclick="focusField('vehicleId')">Edit</button>
                            </div>
                            <div class="summary-value" id="sumVehicle">—</div>
                            <div class="summary-sub" id="sumPlate"></div>
                        </div>

                        <div class="total-block">
                            <div class="total-label">Total Amount</div>
                            <div class="total-amount" id="sumTotal">—</div>
                        </div>

                        <button type="submit" id="submitBtn" class="btn-proceed" disabled>Confirm &amp; Pay Now</button>

                        <div class="help-box">
                            <div class="field-label mb-1" style="font-size:0.82rem;"><i class="bi bi-headset"></i> We can help you</div>
                            <p>Call us <strong>0901 234 567</strong> or chat with our customer support team.</p>
                            <a href="CustomerDashBoardController" class="btn-chat">Back to Dashboard</a>
                        </div>
                    </div>
                </div>
            </div>
        </form>
        <% } %>
    </div>

    <script>
        const ctx = '<%= request.getContextPath() %>';
        const maxBookingDays = <%= maxBookingDays %>;
        const tierName = '<%= tierName.replace("'", "\\'") %>';
        const slotContainer = document.getElementById('slotContainer');
        const bayContainer = document.getElementById('bayContainer');
        const baySection = document.getElementById('baySection');
        const datePillsEl = document.getElementById('datePills');
        const dateInput = document.getElementById('bookingDate');
        const slotIdInput = document.getElementById('slotId');
        const washBayIdInput = document.getElementById('washBayId');
        const submitBtn = document.getElementById('submitBtn');
        const vehicleSelect = document.getElementById('vehicleId');
        const serviceSelect = document.getElementById('serviceId');

        let selectedDate = new Date();
        let selectedSlotLabel = '';
        let selectedBayName = '';
        let priceData = null;
        let slotsCache = [];

        const DAY_NAMES = ['SUN','MON','TUE','WED','THU','FRI','SAT'];
        const MONTH_NAMES = ['January','February','March','April','May','June','July','August','September','October','November','December'];

        function pad(n) { return String(n).padStart(2, '0'); }
        function toIso(d) {
            return d.getFullYear() + '-' + pad(d.getMonth() + 1) + '-' + pad(d.getDate());
        }

        function focusField(id) {
            const el = document.getElementById(id);
            if (el) { el.focus(); el.scrollIntoView({ behavior: 'smooth', block: 'center' }); }
        }
        function focusBay() {
            if (baySection.style.display !== 'none') {
                baySection.scrollIntoView({ behavior: 'smooth', block: 'center' });
            } else {
                slotContainer.scrollIntoView({ behavior: 'smooth', block: 'center' });
            }
        }

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
            const vehOpt = vehicleSelect.options[vehicleSelect.selectedIndex];

            document.getElementById('sumService').textContent = svcOpt && svcOpt.value ? svcOpt.text : '—';
            document.getElementById('sumDuration').textContent = priceData ? ('Est. ' + priceData.duration + ' minutes') : '';
            document.getElementById('sumDateTime').textContent = formatSummaryDateTime();
            document.getElementById('sumBay').textContent = selectedBayName || '—';
            document.getElementById('sumBayCheck').style.display = selectedBayName ? 'flex' : 'none';

            if (vehOpt && vehOpt.value) {
                document.getElementById('sumVehicle').textContent = vehOpt.dataset.brand + ' ' + vehOpt.dataset.model;
                document.getElementById('sumPlate').textContent = vehOpt.dataset.plate;
            } else {
                document.getElementById('sumVehicle').textContent = '—';
                document.getElementById('sumPlate').textContent = '';
            }

            document.getElementById('sumTotal').textContent = priceData
                ? Number(priceData.price).toLocaleString('vi-VN') + ' VND'
                : '—';

            updateSubmitState();
        }

        function updateSubmitState() {
            const ready = slotIdInput.value && washBayIdInput.value && vehicleSelect.value && serviceSelect.value && priceData;
            submitBtn.disabled = !ready;
        }

        function resetBays() {
            washBayIdInput.value = '';
            selectedBayName = '';
            baySection.style.display = 'none';
            bayContainer.innerHTML = '';
            updateSummary();
        }

        function resetSlots() {
            slotIdInput.value = '';
            selectedSlotLabel = '';
            slotContainer.innerHTML = '<span class="text-muted small">Loading slots...</span>';
            resetBays();
            updateSummary();
        }

        function loadSlots() {
            resetSlots();
            fetch(ctx + '/CustomerBookingController?action=slots&date=' + dateInput.value)
                .then(r => r.json())
                .then(data => {
                    if (!data.success) {
                        slotContainer.innerHTML = '<span class="text-danger small">' + data.message + '</span>';
                        return;
                    }
                    if (!data.slots || data.slots.length === 0) {
                        slotContainer.innerHTML = '<span class="text-muted small">No available slots for this date.</span>';
                        return;
                    }
                    slotsCache = data.slots;
                    slotContainer.innerHTML = '';
                    data.slots.forEach(slot => {
                        const btn = document.createElement('button');
                        btn.type = 'button';
                        btn.className = 'time-btn';
                        btn.textContent = slot.start + ' - ' + slot.end;
                        btn.title = slot.availableBays + ' of ' + slot.totalBays + ' bays available';
                        btn.dataset.slotId = slot.slotId;
                        btn.dataset.label = slot.start + ' - ' + slot.end;
                        btn.addEventListener('click', function () {
                            document.querySelectorAll('.time-btn').forEach(b => b.classList.remove('active'));
                            btn.classList.add('active');
                            slotIdInput.value = slot.slotId;
                            selectedSlotLabel = btn.dataset.label;
                            loadBays(slot.slotId);
                            updateSummary();
                        });
                        slotContainer.appendChild(btn);
                    });
                })
                .catch(() => {
                    slotContainer.innerHTML = '<span class="text-danger small">Failed to load time slots.</span>';
                });
        }

        function loadBays(slotId) {
            baySection.style.display = 'block';
            bayContainer.innerHTML = '<span class="text-muted small">Loading bays...</span>';
            washBayIdInput.value = '';
            selectedBayName = '';
            fetch(ctx + '/CustomerBookingController?action=bays&slotId=' + slotId)
                .then(r => r.json())
                .then(data => {
                    if (!data.success || !data.bays || data.bays.length === 0) {
                        bayContainer.innerHTML = '<span class="text-muted small">No available wash bays.</span>';
                        updateSummary();
                        return;
                    }
                    bayContainer.innerHTML = '';
                    data.bays.forEach(bay => {
                        const btn = document.createElement('button');
                        btn.type = 'button';
                        btn.className = 'bay-btn';
                        btn.textContent = bay.bayName;
                        btn.title = bay.description || '';
                        btn.dataset.bayId = bay.washBayId;
                        btn.addEventListener('click', function () {
                            document.querySelectorAll('.bay-btn').forEach(b => b.classList.remove('active'));
                            btn.classList.add('active');
                            washBayIdInput.value = bay.washBayId;
                            selectedBayName = bay.bayName;
                            updateSummary();
                        });
                        bayContainer.appendChild(btn);
                    });
                    updateSummary();
                })
                .catch(() => {
                    bayContainer.innerHTML = '<span class="text-danger small">Failed to load wash bays.</span>';
                });
        }

        function loadPrice() {
            priceData = null;
            if (!vehicleSelect.value || !serviceSelect.value) {
                updateSummary();
                return;
            }
            fetch(ctx + '/CustomerBookingController?action=price&vehicleId=' + vehicleSelect.value + '&serviceId=' + serviceSelect.value)
                .then(r => r.json())
                .then(data => {
                    if (data.success) {
                        priceData = { price: data.price, duration: data.duration };
                    } else {
                        priceData = null;
                    }
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
            vehicleSelect.addEventListener('change', loadPrice);
            serviceSelect.addEventListener('change', loadPrice);
        }
    </script>
</body>
</html>