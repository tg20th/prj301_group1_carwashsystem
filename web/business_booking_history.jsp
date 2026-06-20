<%@page import="java.util.List"%>
<%@page import="java.util.HashSet"%>
<%@page import="java.util.Set"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="java.time.LocalDateTime"%>
<%@page import="dto.Booking"%>
<%@page import="dto.TimeSlot"%>
<%@page import="dto.Account"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    Account acc = (Account) session.getAttribute("ACCOUNT");
    if (acc == null || session.getAttribute("BUS") == null) {
        response.sendRedirect("MainController?action=home");
        return;
    }
    List<Booking> bookings = (List<Booking>) request.getAttribute("BOOKINGS");
    Integer activeCount = (Integer) request.getAttribute("ACTIVE_COUNT");
    String businessName = (String) request.getAttribute("BUSINESS_NAME");
    String errorMsg = (String) request.getAttribute("ERROR_MSG");
    String successMsg = (String) request.getAttribute("SUCCESS_MSG");
    DateTimeFormatter timeFmt = DateTimeFormatter.ofPattern("HH:mm");
    DateTimeFormatter dateFmt = DateTimeFormatter.ofPattern("dd/MM/yyyy");

    Set<Integer> pendingInvoiceIds = new HashSet<>();
    if (bookings != null) {
        for (Booking b : bookings) {
            if (b.getInvoiceID() > 0 && "Pending".equalsIgnoreCase(b.getStatus())) {
                pendingInvoiceIds.add(b.getInvoiceID());
            }
        }
    }
    pageContext.setAttribute("busNavActive", "history");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Fleet Booking History | Elite Auto</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="css/style.css" rel="stylesheet">
    <link href="css/business.css" rel="stylesheet">
</head>
<body class="bus-page">
    <%@ include file="includes/business_nav.jsp" %>

    <div class="container py-5">
        <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-end mb-4">
            <div>
                <h2 class="fw-bold mb-1">Fleet Booking History</h2>
                <p class="text-muted small mb-0">Track fleet appointments, invoices and service status.</p>
            </div>
            <div class="mt-3 mt-md-0">
                <span class="badge bg-dark rounded-pill px-3 py-2">
                    <i class="bi bi-lightning-charge me-1"></i><%= activeCount != null ? activeCount : 0 %> active
                </span>
            </div>
        </div>

        <% if (errorMsg != null) { %>
        <div class="alert alert-danger rounded-4 border-0 shadow-sm"><%= errorMsg %></div>
        <% } %>
        <% if (successMsg != null) { %>
        <div class="alert alert-success rounded-4 border-0 shadow-sm"><%= successMsg %></div>
        <% } %>

        <div class="bus-card p-4 p-md-5">
            <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center mb-4 pb-3 border-bottom">
                <h5 class="fw-bold mb-3 mb-md-0"><i class="bi bi-journal-text me-2 text-muted"></i>All Bookings</h5>
                <ul class="nav nav-pills bg-light p-1 rounded-pill border mb-0" id="statusFilters">
                    <li class="nav-item"><button type="button" class="nav-link bus-filter-btn rounded-pill px-3 small fw-medium text-dark active" data-filter="ALL" onclick="filterTable('ALL', this)">All</button></li>
                    <li class="nav-item"><button type="button" class="nav-link bus-filter-btn rounded-pill px-3 small fw-medium text-dark" data-filter="Pending" onclick="filterTable('Pending', this)">Pending</button></li>
                    <li class="nav-item"><button type="button" class="nav-link bus-filter-btn rounded-pill px-3 small fw-medium text-dark" data-filter="Confirmed" onclick="filterTable('Confirmed', this)">Confirmed</button></li>
                    <li class="nav-item"><button type="button" class="nav-link bus-filter-btn rounded-pill px-3 small fw-medium text-dark" data-filter="InProgress" onclick="filterTable('InProgress', this)">In Progress</button></li>
                    <li class="nav-item"><button type="button" class="nav-link bus-filter-btn rounded-pill px-3 small fw-medium text-dark" data-filter="Completed" onclick="filterTable('Completed', this)">Completed</button></li>
                    <li class="nav-item"><button type="button" class="nav-link bus-filter-btn rounded-pill px-3 small fw-medium text-dark" data-filter="Cancelled" onclick="filterTable('Cancelled', this)">Cancelled</button></li>
                </ul>
            </div>

            <% if (bookings == null || bookings.isEmpty()) { %>
            <div class="text-center py-5">
                <div class="bg-light rounded-circle d-inline-flex align-items-center justify-content-center mb-3" style="width: 80px; height: 80px;">
                    <i class="bi bi-calendar-x text-muted fs-1"></i>
                </div>
                <h5 class="fw-bold">No bookings yet</h5>
                <p class="text-muted small mb-4">Book your fleet to see appointments here.</p>
                <a href="BusinessBookingController" class="btn btn-black rounded-pill px-4">Book Fleet Wash</a>
            </div>
            <% } else { %>
            <div class="table-responsive">
                <table class="table align-middle table-hover mb-0 bus-table">
                    <thead class="table-light text-muted small text-uppercase">
                        <tr>
                            <th class="py-3">ID</th>
                            <th class="py-3">Invoice</th>
                            <th class="py-3">Service</th>
                            <th class="py-3">Vehicle</th>
                            <th class="py-3">Schedule</th>
                            <th class="py-3">Bay</th>
                            <th class="py-3 text-end">Price</th>
                            <th class="py-3 text-center">Status</th>
                            <th class="py-3 text-end">Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (Booking b : bookings) {
                            String status = b.getStatus() != null ? b.getStatus() : "Pending";
                            String startTime = "N/A", endTime = "N/A", dateStr = "";
                            TimeSlot slot = b.getTimeslot();
                            if (slot != null) {
                                LocalDateTime start = slot.getStart();
                                LocalDateTime end = slot.getEnd();
                                if (start != null) {
                                    startTime = start.format(timeFmt);
                                    dateStr = start.format(dateFmt);
                                }
                                if (end != null) {
                                    endTime = end.format(timeFmt);
                                }
                            }
                            boolean canCancel = "Pending".equalsIgnoreCase(status) || "Confirmed".equalsIgnoreCase(status);
                            int invoiceId = b.getInvoiceID();
                            boolean showInvoiceCancel = invoiceId > 0 && pendingInvoiceIds.contains(invoiceId)
                                    && "Pending".equalsIgnoreCase(status);
                        %>
                        <tr class="bus-booking-row" data-status="<%= status %>">
                            <td class="text-muted small font-monospace">#<%= b.getBookingID() %></td>
                            <td>
                                <% if (invoiceId > 0) { %>
                                <span class="badge bg-light text-dark border font-monospace small">INV-<%= invoiceId %></span>
                                <% } else { %>
                                <span class="text-muted small">—</span>
                                <% } %>
                            </td>
                            <td>
                                <div class="fw-semibold text-dark"><%= b.getService() %></div>
                                <div class="text-muted small"><%= b.getDurationAtOrder() %> min</div>
                            </td>
                            <td>
                                <div class="fw-semibold"><%= b.getVehicleName() %></div>
                                <span class="badge bg-light text-dark border font-monospace small"><%= b.getLicensePlate() %></span>
                            </td>
                            <td>
                                <div class="fw-semibold"><%= startTime %> - <%= endTime %></div>
                                <div class="text-muted small"><%= dateStr %></div>
                            </td>
                            <td><span class="badge bg-light text-dark border"><%= b.getBayName() != null ? b.getBayName() : "N/A" %></span></td>
                            <td class="text-end fw-semibold"><%= String.format("%,.0f", b.getPriceAtOrder()) %> VND</td>
                            <td class="text-center">
                                <% if ("Completed".equalsIgnoreCase(status)) { %>
                                <span class="badge bg-success-subtle text-success border border-success-subtle rounded-pill px-3 py-2"><i class="bi bi-check-circle me-1"></i>Completed</span>
                                <% } else if ("InProgress".equalsIgnoreCase(status)) { %>
                                <span class="badge bg-info-subtle text-info border border-info-subtle rounded-pill px-3 py-2"><i class="bi bi-droplet-half me-1"></i>In Progress</span>
                                <% } else if ("Confirmed".equalsIgnoreCase(status)) { %>
                                <span class="badge bg-primary-subtle text-primary border border-primary-subtle rounded-pill px-3 py-2"><i class="bi bi-patch-check me-1"></i>Confirmed</span>
                                <% } else if ("Pending".equalsIgnoreCase(status)) { %>
                                <span class="badge bg-warning-subtle text-warning border border-warning-subtle rounded-pill px-3 py-2"><i class="bi bi-clock me-1"></i>Pending</span>
                                <% } else if ("Cancelled".equalsIgnoreCase(status)) { %>
                                <span class="badge bg-secondary-subtle text-secondary border border-secondary-subtle rounded-pill px-3 py-2"><i class="bi bi-x-circle me-1"></i>Cancelled</span>
                                <% } else { %>
                                <span class="badge bg-light text-dark border rounded-pill px-3 py-2"><%= status %></span>
                                <% } %>
                            </td>
                            <td class="text-end">
                                <% if (canCancel) { %>
                                <form action="BusinessBookingHistoryController" method="post" class="d-inline" onsubmit="return confirm('Cancel this booking?');">
                                    <input type="hidden" name="action" value="cancel">
                                    <input type="hidden" name="bookingId" value="<%= b.getBookingID() %>">
                                    <button type="submit" class="btn btn-sm btn-outline-danger rounded-pill">Cancel</button>
                                </form>
                                <% if (showInvoiceCancel) { %>
                                <form action="BusinessBookingHistoryController" method="post" class="d-inline ms-1"
                                      onsubmit="return confirm('Cancel entire invoice #<%= invoiceId %> and all pending bookings?');">
                                    <input type="hidden" name="action" value="cancelInvoice">
                                    <input type="hidden" name="invoiceId" value="<%= invoiceId %>">
                                    <button type="submit" class="btn btn-sm btn-outline-secondary rounded-pill" title="Cancel whole invoice batch">Cancel INV</button>
                                </form>
                                <% } %>
                                <% } else { %>
                                <span class="text-muted small">—</span>
                                <% } %>
                            </td>
                        </tr>
                        <% } %>
                        <tr id="noDataRow" style="display: none;">
                            <td colspan="9" class="text-center py-5 text-muted">No bookings match this filter.</td>
                        </tr>
                    </tbody>
                </table>
            </div>
            <% } %>
        </div>
    </div>

    <script>
        function filterTable(status, btn) {
            document.querySelectorAll('.bus-filter-btn').forEach(b => b.classList.remove('active'));
            btn.classList.add('active');
            let visible = 0;
            document.querySelectorAll('.bus-booking-row').forEach(row => {
                const show = status === 'ALL' || row.getAttribute('data-status') === status;
                row.style.display = show ? '' : 'none';
                if (show) visible++;
            });
            const noData = document.getElementById('noDataRow');
            if (noData) noData.style.display = visible === 0 ? '' : 'none';
        }
    </script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>