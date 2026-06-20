package service;

import dto.Booking;
import dto.InvoiceHistoryDetail;
import dto.TimeSlot;
import java.time.format.DateTimeFormatter;

public final class InvoiceHistoryJsonBuilder {

    private static final DateTimeFormatter DATE_TIME_FMT = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
    private static final DateTimeFormatter TIME_FMT = DateTimeFormatter.ofPattern("HH:mm");

    private InvoiceHistoryJsonBuilder() {
    }

    public static String buildDetailJson(InvoiceHistoryDetail detail) {
        if (detail == null) {
            return "{\"success\":false,\"message\":\"Invoice not found.\"}";
        }
        StringBuilder json = new StringBuilder("{\"success\":true,\"invoice\":{");
        json.append("\"invoiceId\":").append(detail.getInvoiceId()).append(",");
        json.append("\"invoiceDate\":\"").append(escape(formatDateTime(detail.getInvoiceDate()))).append("\",");
        json.append("\"subTotal\":").append(detail.getSubTotal()).append(",");
        json.append("\"discountAmount\":").append(detail.getDiscountAmount()).append(",");
        json.append("\"finalAmount\":").append(detail.getFinalAmount()).append(",");
        json.append("\"paymentStatus\":\"").append(escape(detail.getPaymentStatus())).append("\",");
        json.append("\"paymentMethod\":\"").append(escape(detail.getPaymentMethod())).append("\",");
        json.append("\"promotionName\":\"").append(escape(detail.getPromotionName())).append("\",");
        json.append("\"note\":\"").append(escape(detail.getNote())).append("\",");
        json.append("\"bookingStatus\":\"").append(escape(detail.getBookingStatus())).append("\",");
        json.append("\"bookings\":[");
        for (int i = 0; i < detail.getBookings().size(); i++) {
            if (i > 0) {
                json.append(",");
            }
            json.append(buildBookingJson(detail.getBookings().get(i)));
        }
        json.append("]}}");
        return json.toString();
    }

    private static String buildBookingJson(Booking booking) {
        String start = "";
        String end = "";
        String date = "";
        TimeSlot slot = booking.getTimeslot();
        if (slot != null) {
            if (slot.getStart() != null) {
                start = slot.getStart().format(TIME_FMT);
                date = slot.getStart().format(DateTimeFormatter.ofPattern("dd/MM/yyyy"));
            }
            if (slot.getEnd() != null) {
                end = slot.getEnd().format(TIME_FMT);
            }
        }
        return "{"
                + "\"bookingId\":" + booking.getBookingID() + ","
                + "\"status\":\"" + escape(booking.getStatus()) + "\","
                + "\"service\":\"" + escape(booking.getService()) + "\","
                + "\"vehicleName\":\"" + escape(booking.getVehicleName()) + "\","
                + "\"licensePlate\":\"" + escape(booking.getLicensePlate()) + "\","
                + "\"bayName\":\"" + escape(booking.getBayName()) + "\","
                + "\"priceAtOrder\":" + Math.round(booking.getPriceAtOrder()) + ","
                + "\"durationAtOrder\":" + booking.getDurationAtOrder() + ","
                + "\"notes\":\"" + escape(booking.getNotes()) + "\","
                + "\"scheduleDate\":\"" + escape(date) + "\","
                + "\"scheduleStart\":\"" + escape(start) + "\","
                + "\"scheduleEnd\":\"" + escape(end) + "\""
                + "}";
    }

    private static String formatDateTime(java.time.LocalDateTime value) {
        return value != null ? value.format(DATE_TIME_FMT) : "";
    }

    private static String escape(String value) {
        if (value == null) {
            return "";
        }
        return value.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r");
    }
}