<%@page import="java.util.List"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="dto.Booking"%>
<%@page import="dto.InvoiceHistoryDetail"%>
<%@page import="dto.TimeSlot"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    InvoiceHistoryDetail inv = (InvoiceHistoryDetail) request.getAttribute("INVOICE");
    if (inv == null) {
        response.sendError(404);
        return;
    }
    DateTimeFormatter dateTimeFmt = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
    DateTimeFormatter timeFmt = DateTimeFormatter.ofPattern("HH:mm");
    DateTimeFormatter dateFmt = DateTimeFormatter.ofPattern("dd/MM/yyyy");
    String invoiceDateStr = inv.getInvoiceDate() != null ? inv.getInvoiceDate().format(dateTimeFmt) : "—";
    List<Booking> bookings = inv.getBookings();
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Invoice #<%= inv.getInvoiceId() %> | Elite Auto</title>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: 'Segoe UI', Tahoma, sans-serif; font-size: 12px; color: #1a1a1a; padding: 24px; }
        .header { display: flex; justify-content: space-between; align-items: flex-start; border-bottom: 2px solid #111; padding-bottom: 12px; margin-bottom: 16px; }
        .brand { font-size: 20px; font-weight: 700; }
        .brand span { font-size: 11px; font-weight: 400; color: #666; display: block; margin-top: 2px; }
        .invoice-meta { text-align: right; }
        .invoice-meta h1 { font-size: 16px; margin-bottom: 4px; }
        .info-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 12px; margin-bottom: 16px; }
        .info-box { border: 1px solid #ddd; border-radius: 6px; padding: 10px; }
        .info-box label { font-size: 10px; text-transform: uppercase; color: #666; font-weight: 600; display: block; margin-bottom: 4px; }
        table { width: 100%; border-collapse: collapse; margin-bottom: 16px; }
        th, td { border: 1px solid #ddd; padding: 6px 8px; text-align: left; }
        th { background: #f5f5f5; font-size: 10px; text-transform: uppercase; }
        .text-end { text-align: right; }
        .totals { margin-left: auto; width: 260px; }
        .totals .row { display: flex; justify-content: space-between; padding: 4px 0; }
        .totals .total { font-weight: 700; font-size: 14px; border-top: 2px solid #111; padding-top: 6px; margin-top: 4px; }
        .discount { color: #198754; }
        .footer { margin-top: 24px; text-align: center; font-size: 10px; color: #888; }
        .no-print { margin-bottom: 12px; }
        @media print {
            .no-print { display: none; }
            body { padding: 0; }
        }
    </style>
</head>
<body>
    <div class="no-print">
        <button onclick="window.print()" style="padding:8px 16px;cursor:pointer;border:1px solid #111;background:#111;color:#fff;border-radius:4px;">
            Print Invoice
        </button>
        <button onclick="window.close()" style="padding:8px 16px;cursor:pointer;border:1px solid #ccc;background:#fff;border-radius:4px;margin-left:8px;">
            Close
        </button>
    </div>

    <div class="header">
        <div class="brand">
            Elite Auto
            <span>Professional Car Wash Service</span>
        </div>
        <div class="invoice-meta">
            <h1>INVOICE #<%= inv.getInvoiceId() %></h1>
            <div>Date: <%= invoiceDateStr %></div>
        </div>
    </div>

    <div class="info-grid">
        <div class="info-box">
            <label>Customer</label>
            <div><strong><%= inv.getCustomerName() != null ? inv.getCustomerName() : "—" %></strong></div>
        </div>
        <div class="info-box">
            <label>Payment</label>
            <div><strong><%= inv.getPaymentStatus() != null ? inv.getPaymentStatus() : "—" %></strong></div>
            <% if (inv.getPaymentMethod() != null && !inv.getPaymentMethod().isEmpty()) { %>
            <div>Method: <%= inv.getPaymentMethod() %></div>
            <% } %>
            <div>Booking status: <%= inv.getBookingStatus() != null ? inv.getBookingStatus() : "—" %></div>
        </div>
    </div>

    <table>
        <thead>
            <tr>
                <th>#</th>
                <th>Service</th>
                <th>Vehicle</th>
                <th>Plate</th>
                <th>Schedule</th>
                <th>Bay</th>
                <th class="text-end">Price</th>
                <th>Status</th>
            </tr>
        </thead>
        <tbody>
            <% if (bookings != null) {
                for (Booking b : bookings) {
                    String start = "—", end = "—", date = "—";
                    TimeSlot slot = b.getTimeslot();
                    if (slot != null) {
                        if (slot.getStart() != null) {
                            start = slot.getStart().format(timeFmt);
                            date = slot.getStart().format(dateFmt);
                        }
                        if (slot.getEnd() != null) {
                            end = slot.getEnd().format(timeFmt);
                        }
                    }
            %>
            <tr>
                <td><%= b.getBookingID() %></td>
                <td><%= b.getService() != null ? b.getService() : "—" %><br><small><%= b.getDurationAtOrder() %> min</small></td>
                <td><%= b.getVehicleName() != null ? b.getVehicleName() : "—" %></td>
                <td><%= b.getLicensePlate() != null ? b.getLicensePlate() : "—" %></td>
                <td><%= date %> <%= start %> - <%= end %></td>
                <td><%= b.getBayName() != null ? b.getBayName() : "—" %></td>
                <td class="text-end"><%= String.format("%,d", Math.round(b.getPriceAtOrder())) %></td>
                <td><%= b.getStatus() != null ? b.getStatus() : "—" %></td>
            </tr>
            <%  }
               } %>
        </tbody>
    </table>

    <div class="totals">
        <div class="row">
            <span>Subtotal</span>
            <span><%= String.format("%,d", inv.getSubTotal()) %> VND</span>
        </div>
        <% if (inv.getDiscountAmount() > 0) { %>
        <div class="row discount">
            <span>Discount<% if (inv.getPromotionName() != null) { %> (<%= inv.getPromotionName() %>)<% } %></span>
            <span>-<%= String.format("%,d", inv.getDiscountAmount()) %> VND</span>
        </div>
        <% } %>
        <div class="row total">
            <span>Total</span>
            <span><%= String.format("%,d", inv.getFinalAmount()) %> VND</span>
        </div>
    </div>

    <% if (inv.getNote() != null && !inv.getNote().isEmpty()) { %>
    <p style="margin-top:12px;font-size:11px;color:#666;">Note: <%= inv.getNote() %></p>
    <% } %>

    <div class="footer">Thank you for choosing Elite Auto. This is a computer-generated invoice.</div>

    <script>
        window.addEventListener('load', function () {
            setTimeout(function () { window.print(); }, 300);
        });
    </script>
</body>
</html>