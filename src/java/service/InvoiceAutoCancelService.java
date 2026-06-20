package service;

import dao.BookingDAO;
import dao.InvoiceDAO;
import java.util.List;

public class InvoiceAutoCancelService {

    public static final int PENDING_TIMEOUT_MINUTES = 15;

    public int cancelExpiredPendingInvoices() {
        return cancelExpiredPendingInvoices(PENDING_TIMEOUT_MINUTES);
    }

    public int cancelExpiredPendingInvoices(int timeoutMinutes) {
        if (timeoutMinutes <= 0) {
            return 0;
        }
        InvoiceDAO invoiceDAO = new InvoiceDAO();
        BookingDAO bookingDAO = new BookingDAO();
        List<Integer> expiredIds = invoiceDAO.findExpiredUnpaidInvoiceIds(timeoutMinutes);
        int cancelled = 0;
        for (int invoiceId : expiredIds) {
            if (bookingDAO.cancelInvoiceBookings(invoiceId) > 0) {
                cancelled++;
            }
        }
        return cancelled;
    }

    public boolean isInvoiceExpired(int invoiceId) {
        return isInvoiceExpired(invoiceId, PENDING_TIMEOUT_MINUTES);
    }

    public boolean isInvoiceExpired(int invoiceId, int timeoutMinutes) {
        return new InvoiceDAO().isExpiredUnpaidInvoice(invoiceId, timeoutMinutes);
    }
}