package service;

import dto.Booking;
import java.util.List;

public final class InvoiceHistoryHelper {

    private InvoiceHistoryHelper() {
    }

    public static String deriveBookingStatus(List<Booking> bookings) {
        if (bookings == null || bookings.isEmpty()) {
            return "Pending";
        }
        boolean allCancelled = true;
        boolean allCompleted = true;
        boolean anyInProgress = false;
        boolean anyConfirmed = false;
        for (Booking booking : bookings) {
            String status = booking.getStatus() != null ? booking.getStatus() : "Pending";
            if (!"Cancelled".equalsIgnoreCase(status)) {
                allCancelled = false;
            }
            if (!"Completed".equalsIgnoreCase(status)) {
                allCompleted = false;
            }
            if ("InProgress".equalsIgnoreCase(status)) {
                anyInProgress = true;
            }
            if ("Confirmed".equalsIgnoreCase(status)) {
                anyConfirmed = true;
            }
        }
        if (allCancelled) {
            return "Cancelled";
        }
        if (anyInProgress) {
            return "InProgress";
        }
        if (allCompleted) {
            return "Completed";
        }
        if (anyConfirmed) {
            return "Confirmed";
        }
        return "Pending";
    }

    public static boolean canCancelInvoice(List<Booking> bookings) {
        if (bookings == null || bookings.isEmpty()) {
            return false;
        }
        for (Booking booking : bookings) {
            String status = booking.getStatus() != null ? booking.getStatus() : "Pending";
            if ("Pending".equalsIgnoreCase(status) || "Confirmed".equalsIgnoreCase(status)) {
                return true;
            }
        }
        return false;
    }
}