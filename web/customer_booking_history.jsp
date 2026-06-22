<%@page import="java.util.List"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="java.time.LocalDateTime"%>
<%@page import="dto.InvoiceHistorySummary"%>
<%@page import="dto.Account"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    Account acc = (Account) session.getAttribute("ACCOUNT");
    if (acc == null) {
        response.sendRedirect("MainController?action=home");
        return;
    }
    List<InvoiceHistorySummary> invoices = (List<InvoiceHistorySummary>) request.getAttribute("INVOICES");
    Integer activeCount = (Integer) request.getAttribute("ACTIVE_COUNT");
    String errorMsg = (String) request.getAttribute("ERROR_MSG");
    String successMsg = (String) request.getAttribute("SUCCESS_MSG");
    DateTimeFormatter timeFmt = DateTimeFormatter.ofPattern("HH:mm");
    DateTimeFormatter dateFmt = DateTimeFormatter.ofPattern("dd/MM/yyyy");
    DateTimeFormatter dateTimeFmt = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Invoices | Elite Auto</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link href="css/style.css" rel="stylesheet">
    <style>
        .filter-btn.active { background: #212529 !important; color: #fff !important; }
        .invoice-row { transition: background-color 0.2s ease; cursor: pointer; }
        .invoice-row:hover { background-color: #f8f9fa; }
    </style>
</head>
<body class="invoice-history-compact" style="background-color: var(--bg-card);">
    <nav class="navbar navbar-expand-lg py-3 bg-white sticky-top shadow-sm border-bottom">
        <div class="container">
            <a class="navbar-brand fw-bold" href="MainController?action=customer_dashboard"><i class="bi bi-vinyl-fill me-2"></i>EliteAuto</a>
            <div class="d-flex gap-2">
                <a href="MainController?action=customerbooking" class="btn btn-dark rounded-pill btn-sm"><i class="bi bi-plus-lg me-1"></i>Book Service</a>
                <a href="MainController?action=customer_dashboard" class="btn btn-outline-dark rounded-pill btn-sm">Back to Dashboard</a>
            </div>
        </div>
    </nav>

    <div class="container py-4">
        <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-end mb-4">
            <div>
                <h2 class="fw-bold mb-1">Invoice History</h2>
                <p class="text-muted small mb-0">View invoices, discounts, and booking details.</p>
            </div>
            <div class="mt-3 mt-md-0">
                <span class="badge bg-dark rounded-pill px-3 py-2">
                    <i class="bi bi-lightning-charge me-1"></i><%= activeCount != null ? activeCount : 0 %> active bookings
                </span>
            </div>
        </div>

        <% if (errorMsg != null) { %>
        <div class="alert alert-danger rounded-4 border-0 shadow-sm"><%= errorMsg %></div>
        <% } %>
        <% if (successMsg != null) { %>
        <div class="alert alert-success rounded-4 border-0 shadow-sm"><%= successMsg %></div>
        <% } %>

        <div class="bg-white rounded-4 shadow-sm border p-3 p-md-4">
            <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center mb-4 pb-3 border-bottom">
                <h5 class="fw-bold mb-3 mb-md-0"><i class="bi bi-receipt me-2 text-muted"></i>All Invoices</h5>
                <ul class="nav nav-pills bg-light p-1 rounded-pill border mb-0" id="statusFilters">
                    <li class="nav-item"><button type="button" class="nav-link filter-btn rounded-pill px-3 small fw-medium text-dark active" data-filter="ALL" onclick="filterTable('ALL', this)">All</button></li>
                    <li class="nav-item"><button type="button" class="nav-link filter-btn rounded-pill px-3 small fw-medium text-dark" data-filter="Pending" onclick="filterTable('Pending', this)">Pending</button></li>
                    <li class="nav-item"><button type="button" class="nav-link filter-btn rounded-pill px-3 small fw-medium text-dark" data-filter="Confirmed" onclick="filterTable('Confirmed', this)">Confirmed</button></li>
                    <li class="nav-item"><button type="button" class="nav-link filter-btn rounded-pill px-3 small fw-medium text-dark" data-filter="InProgress" onclick="filterTable('InProgress', this)">In Progress</button></li>
                    <li class="nav-item"><button type="button" class="nav-link filter-btn rounded-pill px-3 small fw-medium text-dark" data-filter="Completed" onclick="filterTable('Completed', this)">Completed</button></li>
                    <li class="nav-item"><button type="button" class="nav-link filter-btn rounded-pill px-3 small fw-medium text-dark" data-filter="Cancelled" onclick="filterTable('Cancelled', this)">Cancelled</button></li>
                </ul>
            </div>

            <% if (invoices == null || invoices.isEmpty()) { %>
            <div class="text-center py-5">
                <div class="bg-light rounded-circle d-inline-flex align-items-center justify-content-center mb-3" style="width: 80px; height: 80px;">
                    <i class="bi bi-receipt text-muted fs-1"></i>
                </div>
                <h5 class="fw-bold">No invoices yet</h5>
                <p class="text-muted small mb-4">Book your first car wash to see invoices here.</p>
                <a href="MainController?action=customerbooking" class="btn btn-dark rounded-pill px-4">Book Service</a>
            </div>
            <% } else { %>
            <div class="table-responsive">
                <table class="table align-middle table-hover mb-0">
                    <thead class="table-light text-muted small text-uppercase">
                        <tr>
                            <th class="py-3">Invoice</th>
                            <th class="py-3">Service</th>
                            <th class="py-3">Schedule</th>
                            <th class="py-3 text-end">Subtotal</th>
                            <th class="py-3 text-end">Discount</th>
                            <th class="py-3 text-end">Total</th>
                            <th class="py-3 text-center">Payment</th>
                            <th class="py-3 text-center">Status</th>
                            <th class="py-3 text-end">Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (InvoiceHistorySummary inv : invoices) {
                            String status = inv.getBookingStatus() != null ? inv.getBookingStatus() : "Pending";
                            String paymentStatus = inv.getPaymentStatus() != null ? inv.getPaymentStatus() : "Unpaid";
                            String startTime = "N/A", endTime = "N/A", dateStr = "", createdStr = "";
                            LocalDateTime scheduleStart = inv.getScheduleStart();
                            LocalDateTime scheduleEnd = inv.getScheduleEnd();
                            if (scheduleStart != null) {
                                startTime = scheduleStart.format(timeFmt);
                                dateStr = scheduleStart.format(dateFmt);
                            }
                            if (scheduleEnd != null) {
                                endTime = scheduleEnd.format(timeFmt);
                            }
                            if (inv.getInvoiceDate() != null) {
                                createdStr = inv.getInvoiceDate().format(dateTimeFmt);
                            }
                            boolean canCancel = !"Cancelled".equalsIgnoreCase(status)
                                    && !"Completed".equalsIgnoreCase(status)
                                    && ("Pending".equalsIgnoreCase(status) || "Confirmed".equalsIgnoreCase(status));
                            boolean canPay = "Unpaid".equalsIgnoreCase(paymentStatus)
                                    && !"Cancelled".equalsIgnoreCase(status);
                        %>
                        <tr class="invoice-row" data-status="<%= status %>"
                            onclick="openInvoiceDetail('MainController?action=viewcustomerhistory', <%= inv.getInvoiceId() %>)">
                            <td>
                                <div class="fw-semibold font-monospace">#<%= inv.getInvoiceId() %></div>
                                <div class="text-muted small"><%= createdStr %></div>
                            </td>
                            <td>
                                <div class="fw-semibold text-dark"><%= inv.getServiceSummary() != null ? inv.getServiceSummary() : "Service" %></div>
                                <div class="text-muted small"><%= inv.getBookingCount() %> booking<%= inv.getBookingCount() == 1 ? "" : "s" %></div>
                            </td>
                            <td>
                                <div class="fw-semibold"><%= startTime %> - <%= endTime %></div>
                                <div class="text-muted small"><%= dateStr %></div>
                            </td>
                            <td class="text-end text-muted"><%= String.format("%,d", inv.getSubTotal()) %></td>
                            <td class="text-end text-success">
                                <% if (inv.getDiscountAmount() > 0) { %>
                                -<%= String.format("%,d", inv.getDiscountAmount()) %>
                                <% if (inv.getPromotionName() != null) { %>
                                <div class="small"><%= inv.getPromotionName() %></div>
                                <% } %>
                                <% } else { %>
                                <span class="text-muted">—</span>
                                <% } %>
                            </td>
                            <td class="text-end fw-bold"><%= String.format("%,d", inv.getFinalAmount()) %> VND</td>
                            <td class="text-center">
                                <% if ("Paid".equalsIgnoreCase(paymentStatus)) { %>
                                <span class="badge bg-success-subtle text-success border border-success-subtle rounded-pill px-3 py-2">Paid</span>
                                <% } else if ("Cancelled".equalsIgnoreCase(paymentStatus)) { %>
                                <span class="badge bg-secondary-subtle text-secondary border rounded-pill px-3 py-2">Cancelled</span>
                                <% } else { %>
                                <span class="badge bg-warning-subtle text-warning border border-warning-subtle rounded-pill px-3 py-2">Unpaid</span>
                                <% } %>
                            </td>
                            <td class="text-center">
                                <% if ("Completed".equalsIgnoreCase(status)) { %>
                                <span class="badge bg-success-subtle text-success border border-success-subtle rounded-pill px-3 py-2">Completed</span>
                                <% } else if ("InProgress".equalsIgnoreCase(status)) { %>
                                <span class="badge bg-info-subtle text-info border border-info-subtle rounded-pill px-3 py-2">In Progress</span>
                                <% } else if ("Confirmed".equalsIgnoreCase(status)) { %>
                                <span class="badge bg-primary-subtle text-primary border border-primary-subtle rounded-pill px-3 py-2">Confirmed</span>
                                <% } else if ("Pending".equalsIgnoreCase(status)) { %>
                                <span class="badge bg-warning-subtle text-warning border border-warning-subtle rounded-pill px-3 py-2">Pending</span>
                                <% } else if ("Cancelled".equalsIgnoreCase(status)) { %>
                                <span class="badge bg-secondary-subtle text-secondary border rounded-pill px-3 py-2">Cancelled</span>
                                <% } else { %>
                                <span class="badge bg-light text-dark border rounded-pill px-3 py-2"><%= status %></span>
                                <% } %>
                            </td>
                            <td class="text-end text-nowrap" onclick="event.stopPropagation();">
                                <button type="button" class="btn btn-sm btn-outline-dark rounded-pill"
                                        onclick="openInvoiceDetail('MainController?action=viewcustomerhistory', <%= inv.getInvoiceId() %>)"
                                        title="Details">
                                    <i class="bi bi-eye"></i>
                                </button>
                                <button type="button" class="btn btn-sm btn-outline-secondary rounded-pill ms-1"
                                        onclick="printInvoice(<%= inv.getInvoiceId() %>)"
                                        title="Print invoice">
                                    <i class="bi bi-printer"></i>
                                </button>
                                <% if (canPay) { %>
                                <a href="MainController?action=customer_payment&invoiceId=<%= inv.getInvoiceId() %>"
                                   class="btn btn-sm btn-dark rounded-pill ms-1">Pay</a>
                                <% } %>
                                <% if (canCancel) { %>
                                <form action="MainController" method="post" class="d-inline ms-1"
                                      onsubmit="return confirm('Cancel invoice #<%= inv.getInvoiceId() %> and related bookings?');">
                                    <input type="hidden" name="action" value="viewcustomerhistory">
                                    <input type="hidden" name="op" value="cancelInvoice">
                                    <input type="hidden" name="invoiceId" value="<%= inv.getInvoiceId() %>">
                                    <button type="submit" class="btn btn-sm btn-outline-danger rounded-pill">Cancel</button>
                                </form>
                                <% } %>
                            </td>
                        </tr>
                        <% } %>
                        <tr id="noDataRow" style="display: none;">
                            <td colspan="9" class="text-center py-5 text-muted">No invoices match this filter.</td>
                        </tr>
                    </tbody>
                </table>
            </div>
            <% } %>
        </div>
    </div>

    <script>
        window.invoicePrintBase = 'MainController?action=customer_invoice_print';
    </script>
    <%@ include file="includes/invoice_history_modal.jsp" %>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function filterTable(status, btn) {
            document.querySelectorAll('.filter-btn').forEach(b => b.classList.remove('active'));
            btn.classList.add('active');
            let visible = 0;
            document.querySelectorAll('.invoice-row').forEach(row => {
                const show = status === 'ALL' || row.getAttribute('data-status') === status;
                row.style.display = show ? '' : 'none';
                if (show) visible++;
            });
            const noData = document.getElementById('noDataRow');
            if (noData) noData.style.display = visible === 0 ? '' : 'none';
        }
    </script>
</body>
</html>