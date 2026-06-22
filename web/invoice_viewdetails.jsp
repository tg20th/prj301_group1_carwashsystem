<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page import="java.util.List" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.time.LocalDateTime" %>
<%@ page import="dto.InvoiceHistorySummary" %>

<c:if test="${empty sessionScope.ACCOUNT}">
    <jsp:forward page="index.jsp"/>
</c:if>

<%
    List<InvoiceHistorySummary> invoices = (List<InvoiceHistorySummary>) request.getAttribute("INVOICES");
    String activeScope = (String) request.getAttribute("ACTIVE_SCOPE");
    if (activeScope == null || activeScope.isEmpty()) {
        activeScope = "all";
    }
    boolean isTodayScope = "today".equalsIgnoreCase(activeScope);
    DateTimeFormatter timeFmt = DateTimeFormatter.ofPattern("HH:mm");
    DateTimeFormatter dateFmt = DateTimeFormatter.ofPattern("dd/MM/yyyy");
    DateTimeFormatter dateTimeFmt = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Booking Management | Elite Auto</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
        <link href="css/admin.css?v=1.1" rel="stylesheet">
        <link href="css/style.css" rel="stylesheet">
        <style>
            body { background-color: #f4f7fe; font-family: 'Inter', sans-serif; color: #334155; }
            .tracking-tight { letter-spacing: -0.025em; }
            .invoice-row { transition: background-color 0.3s ease; cursor: pointer; }
            .invoice-row:hover { background-color: #f8fafc; }
            .scope-tab { transition: all 0.3s ease; border: 1px solid transparent; font-size: 0.8rem; padding: 0.35rem 1rem; text-decoration: none; }
            .scope-tab:hover { background-color: #f1f5f9; color: #0f172a !important; }
            .scope-tab.active { background-color: #0f172a !important; color: white !important; box-shadow: 0 4px 6px -1px rgba(15, 23, 42, 0.2); border-color: #0f172a; }
            .status-filter-btn { transition: all 0.3s ease; border: 1px solid transparent; font-size: 0.72rem; padding: 0.25rem 0.75rem; }
            .status-filter-btn:hover { background-color: #f1f5f9; color: #0f172a !important; }
            .status-filter-btn.active { background-color: #0f172a !important; color: white !important; box-shadow: 0 4px 6px -1px rgba(15, 23, 42, 0.2); border-color: #0f172a; }
            .btn-dark-custom { background-color: #0f172a; color: white; border: none; }
            .btn-dark-custom:hover { background-color: #1e293b; color: white; }
        </style>
    </head>
    <body class="admin-body invoice-history-compact">

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

            <div class="d-flex flex-column flex-lg-row justify-content-between align-items-lg-end mb-4 pb-2 gap-3">
                <div>
                    <h2 class="fw-bolder tracking-tight mb-1 text-dark">Booking Management</h2>
                    <p class="text-secondary fw-medium mb-0 small">
                        <%= isTodayScope ? "Invoices with bookings scheduled today" : "All invoices and bookings" %>
                    </p>
                    <ul class="nav nav-pills bg-white p-1 rounded-pill shadow-sm border mt-3 mb-0 d-inline-flex">
                        <li class="nav-item">
                            <a href="ManageBookingsController?scope=all"
                               class="nav-link scope-tab rounded-pill fw-bold text-nowrap <%= isTodayScope ? "text-muted" : "active" %>">All</a>
                        </li>
                        <li class="nav-item">
                            <a href="ManageBookingsController?scope=today"
                               class="nav-link scope-tab rounded-pill fw-bold text-nowrap <%= isTodayScope ? "active" : "text-muted" %>">Today</a>
                        </li>
                    </ul>
                </div>
                <div class="d-flex gap-2 align-items-center overflow-x-auto" style="scrollbar-width: none;">
                    <ul class="nav nav-pills bg-white p-1 rounded-pill shadow-sm border mb-0 d-inline-flex flex-nowrap" id="statusFilters">
                        <li class="nav-item"><button class="nav-link status-filter-btn rounded-pill fw-bold text-muted text-nowrap active" data-filter="ALL" onclick="filterTable('ALL', this)">All statuses</button></li>
                        <li class="nav-item"><button class="nav-link status-filter-btn rounded-pill fw-bold text-muted text-nowrap" data-filter="Upcoming" onclick="filterTable('Upcoming', this)">Upcoming</button></li>
                        <li class="nav-item"><button class="nav-link status-filter-btn rounded-pill fw-bold text-muted text-nowrap" data-filter="InProgress" onclick="filterTable('InProgress', this)">Washing</button></li>
                        <li class="nav-item"><button class="nav-link status-filter-btn rounded-pill fw-bold text-muted text-nowrap" data-filter="Completed" onclick="filterTable('Completed', this)">Completed</button></li>
                        <li class="nav-item"><button class="nav-link status-filter-btn rounded-pill fw-bold text-muted text-nowrap" data-filter="Cancelled" onclick="filterTable('Cancelled', this)">Cancelled</button></li>
                        <li class="nav-item"><button class="nav-link status-filter-btn rounded-pill fw-bold text-muted text-nowrap" data-filter="NoShow" onclick="filterTable('NoShow', this)">No Show</button></li>
                    </ul>
                </div>
            </div>

            <div class="bg-white p-3 rounded-4 shadow-sm border border-light h-100 d-flex flex-column">

                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h5 class="fw-bolder m-0 text-dark tracking-tight"><i class="bi bi-receipt me-2 text-primary"></i>Invoice List</h5>
                    <span class="badge bg-primary bg-opacity-10 text-primary border border-primary border-opacity-25 rounded-pill px-3 py-1 shadow-sm">
                        Total: <%= invoices == null ? 0 : invoices.size() %>
                    </span>
                </div>

                <% if (invoices == null || invoices.isEmpty()) { %>
                <div class="d-flex flex-column justify-content-center align-items-center flex-grow-1 py-5">
                    <div class="gradient-primary rounded-circle d-inline-flex align-items-center justify-content-center mb-3 shadow" style="width: 80px; height: 80px;">
                        <i class="bi bi-inbox fs-1 text-white"></i>
                    </div>
                    <h4 class="fw-bold text-dark">No Invoices Found</h4>
                    <p class="text-muted small"><%= isTodayScope ? "There are no invoices for today." : "No invoices found in the system." %></p>
                </div>
                <% } else { %>
                <div class="table-responsive flex-grow-1">
                    <table class="table table-borderless table-hover mb-0 align-middle">
                        <thead class="table-light">
                            <tr class="border-bottom border-light text-nowrap">
                                <th class="text-muted fw-bold small text-uppercase py-2 ps-3">Invoice</th>
                                <th class="text-muted fw-bold small text-uppercase py-2">Customer</th>
                                <th class="text-muted fw-bold small text-uppercase py-2">Service</th>
                                <th class="text-muted fw-bold small text-uppercase py-2">Schedule</th>
                                <th class="text-muted fw-bold small text-uppercase py-2 text-end">Subtotal</th>
                                <th class="text-muted fw-bold small text-uppercase py-2 text-end">Discount</th>
                                <th class="text-muted fw-bold small text-uppercase py-2 text-end">Total</th>
                                <th class="text-muted fw-bold small text-uppercase py-2 text-center">Payment</th>
                                <th class="text-muted fw-bold small text-uppercase py-2 text-center">Status</th>
                                <th class="text-muted fw-bold small text-uppercase py-2 text-end pe-3">Action</th>
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
                            %>
                            <tr class="border-bottom border-light invoice-row" data-status="<%= status %>"
                                onclick="openInvoiceDetail('ManageBookingsController', <%= inv.getInvoiceId() %>)">
                                <td class="ps-3">
                                    <div class="fw-semibold font-monospace">#<%= inv.getInvoiceId() %></div>
                                    <div class="text-muted small"><%= createdStr %></div>
                                </td>
                                <td>
                                    <div class="fw-bold text-dark"><%= inv.getCustomerName() != null ? inv.getCustomerName() : "—" %></div>
                                    <div class="text-muted small"><%= inv.getBookingCount() %> booking<%= inv.getBookingCount() == 1 ? "" : "s" %></div>
                                </td>
                                <td>
                                    <span class="text-primary fw-semibold"><%= inv.getServiceSummary() != null ? inv.getServiceSummary() : "Service" %></span>
                                </td>
                                <td>
                                    <div class="fw-semibold"><%= startTime %> - <%= endTime %></div>
                                    <div class="text-muted small"><%= dateStr %></div>
                                </td>
                                <td class="text-end text-muted"><%= String.format("%,d", inv.getSubTotal()) %></td>
                                <td class="text-end text-success">
                                    <% if (inv.getDiscountAmount() > 0) { %>
                                    -<%= String.format("%,d", inv.getDiscountAmount()) %>
                                    <% } else { %>
                                    <span class="text-muted">—</span>
                                    <% } %>
                                </td>
                                <td class="text-end fw-bold"><%= String.format("%,d", inv.getFinalAmount()) %></td>
                                <td class="text-center">
                                    <% if ("Paid".equalsIgnoreCase(paymentStatus)) { %>
                                    <span class="badge bg-success-subtle text-success border rounded-pill">Paid</span>
                                    <% } else if ("Cancelled".equalsIgnoreCase(paymentStatus)) { %>
                                    <span class="badge bg-secondary-subtle text-secondary border rounded-pill">Cancelled</span>
                                    <% } else { %>
                                    <span class="badge bg-warning-subtle text-warning border rounded-pill">Unpaid</span>
                                    <% } %>
                                </td>
                                <td class="text-center">
                                    <span class="badge bg-light text-dark border rounded-pill"><%= status %></span>
                                </td>
                                <td class="text-end pe-3 text-nowrap" onclick="event.stopPropagation();">
                                    <button type="button" class="btn btn-sm btn-outline-dark rounded-pill"
                                            onclick="openInvoiceDetail('ManageBookingsController', <%= inv.getInvoiceId() %>)">
                                        <i class="bi bi-eye"></i>
                                    </button>
                                    <button type="button" class="btn btn-sm btn-dark-custom rounded-pill ms-1"
                                            onclick="printInvoice(<%= inv.getInvoiceId() %>)">
                                        <i class="bi bi-printer"></i>
                                    </button>
                                </td>
                            </tr>
                            <% } %>
                            <tr id="noDataRow" style="display: none;">
                                <td colspan="10" class="text-center py-5 text-muted small">No invoices match this filter.</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                <% } %>
            </div>
        </main>

        <%@ include file="includes/invoice_history_modal.jsp" %>

        <script>
            window.invoiceHistoryAdminMode = true;
            window.adminInvoiceScope = '<%= activeScope %>';
        </script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            document.addEventListener("DOMContentLoaded", function () {
                let savedFilter = sessionStorage.getItem('adminInvoiceStatusFilter') || 'ALL';
                let activeBtn = document.querySelector('.status-filter-btn[data-filter="' + savedFilter + '"]');
                if (activeBtn) {
                    filterTable(savedFilter, activeBtn, false);
                } else {
                    document.querySelector('.status-filter-btn[data-filter="ALL"]').classList.add('active');
                }

                setTimeout(function () {
                    document.querySelectorAll('.auto-dismiss-alert').forEach(function (alert) {
                        alert.style.transition = "opacity 0.5s ease-out";
                        alert.style.opacity = "0";
                        setTimeout(function () {
                            if (alert.parentNode) alert.parentNode.removeChild(alert);
                        }, 500);
                    });
                }, 4000);
            });

            function filterTable(status, btnElement, saveToSession) {
                if (saveToSession !== false) {
                    sessionStorage.setItem('adminInvoiceStatusFilter', status);
                }
                document.querySelectorAll('.status-filter-btn').forEach(function (btn) {
                    btn.classList.remove('active');
                });
                btnElement.classList.add('active');

                let visibleCount = 0;
                document.querySelectorAll('.invoice-row').forEach(function (row) {
                    let rowStatus = row.getAttribute('data-status');
                    let isVisible = status === 'ALL'
                        || rowStatus === status
                        || (status === 'Upcoming' && (rowStatus === 'Pending' || rowStatus === 'Confirmed'));
                    row.style.display = isVisible ? "" : "none";
                    if (isVisible) visibleCount++;
                });

                let noDataRow = document.getElementById('noDataRow');
                if (noDataRow) {
                    noDataRow.style.display = visibleCount === 0 ? "" : "none";
                }
            }
        </script>
    </body>
</html>