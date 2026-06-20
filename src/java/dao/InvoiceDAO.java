package dao;

import dbutils.DBUtils;
import dto.InvoiceBillingDetail;
import dto.InvoiceHistoryDetail;
import dto.InvoiceHistorySummary;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import service.InvoiceHistoryHelper;

public class InvoiceDAO {

    public int createPendingInvoice(int customerId, long subTotal, String note, Connection cn)
            throws SQLException {
        String sql = "INSERT INTO Invoices "
                + "(CustomerID, SubTotal, DiscountAmount, FinalAmount, PaymentStatus, PaymentMethod, Note) "
                + "VALUES (?, ?, 0, ?, 'Unpaid', NULL, ?)";
        PreparedStatement st = cn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
        st.setInt(1, customerId);
        st.setLong(2, subTotal);
        st.setLong(3, subTotal);
        st.setString(4, note);
        int result = st.executeUpdate();
        if (result <= 0) {
            return -1;
        }
        ResultSet keys = st.getGeneratedKeys();
        if (keys.next()) {
            return keys.getInt(1);
        }
        return -1;
    }

    public int createPendingInvoiceWithDiscount(int customerId, long subTotal, long discountAmount,
            long finalAmount, Integer promotionId, Integer customerRewardId, String note, Connection cn)
            throws SQLException {
        String sql = "INSERT INTO Invoices "
                + "(CustomerID, PromotionID, CustomerRewardID, SubTotal, DiscountAmount, FinalAmount, "
                + "PaymentStatus, PaymentMethod, Note) "
                + "VALUES (?, ?, ?, ?, ?, ?, 'Unpaid', NULL, ?)";
        PreparedStatement st = cn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
        st.setInt(1, customerId);
        if (promotionId != null && promotionId > 0) {
            st.setInt(2, promotionId);
        } else {
            st.setNull(2, java.sql.Types.INTEGER);
        }
        if (customerRewardId != null && customerRewardId > 0) {
            st.setInt(3, customerRewardId);
        } else {
            st.setNull(3, java.sql.Types.INTEGER);
        }
        st.setLong(4, subTotal);
        st.setLong(5, discountAmount);
        st.setLong(6, finalAmount);
        st.setString(7, note);
        int result = st.executeUpdate();
        if (result <= 0) {
            return -1;
        }
        ResultSet keys = st.getGeneratedKeys();
        if (keys.next()) {
            return keys.getInt(1);
        }
        return -1;
    }

    public List<InvoiceHistorySummary> getInvoiceHistorySummaries(int customerId) {
        List<InvoiceHistorySummary> summaries = new ArrayList<>();
        Map<Integer, List<String>> statusesByInvoice = loadBookingStatusesByCustomer(customerId);
        Connection cn = null;
        try {
            cn = DBUtils.getConnection();
            String sql = "SELECT i.InvoiceID, i.InvoiceDate, i.SubTotal, i.DiscountAmount, i.FinalAmount, "
                    + "i.PaymentStatus, i.PaymentMethod, p.PromotionName, "
                    + "COUNT(b.BookingID) AS BookingCount, "
                    + "MIN(t.StartTime) AS ScheduleStart, MAX(t.EndTime) AS ScheduleEnd, "
                    + "MIN(s.ServiceName) AS ServiceName "
                    + "FROM Invoices i "
                    + "LEFT JOIN Promotions p ON i.PromotionID = p.PromotionID "
                    + "LEFT JOIN Bookings b ON b.InvoiceID = i.InvoiceID "
                    + "LEFT JOIN TimeSlots t ON b.TimeSlotID = t.TimeSlotID "
                    + "LEFT JOIN Services s ON b.ServiceID = s.ServiceID "
                    + "WHERE i.CustomerID = ? "
                    + "GROUP BY i.InvoiceID, i.InvoiceDate, i.SubTotal, i.DiscountAmount, i.FinalAmount, "
                    + "i.PaymentStatus, i.PaymentMethod, p.PromotionName "
                    + "ORDER BY i.InvoiceDate DESC, i.InvoiceID DESC";
            PreparedStatement st = cn.prepareStatement(sql);
            st.setInt(1, customerId);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                summaries.add(mapInvoiceSummaryRow(rs, statusesByInvoice));
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeQuietly(cn);
        }
        return summaries;
    }

    public InvoiceHistoryDetail getInvoiceHistoryDetail(int invoiceId, int customerId) {
        if (!isInvoiceOwnedByCustomer(invoiceId, customerId)) {
            return null;
        }
        return loadInvoiceHistoryDetail(invoiceId);
    }

    public InvoiceHistoryDetail getInvoiceHistoryDetailForAdmin(int invoiceId) {
        return loadInvoiceHistoryDetail(invoiceId);
    }

    public List<InvoiceHistorySummary> getAllInvoiceSummariesForAdmin() {
        return loadAdminInvoiceSummaries(false);
    }

    public List<InvoiceHistorySummary> getTodayInvoiceSummariesForAdmin() {
        return loadAdminInvoiceSummaries(true);
    }

    private List<InvoiceHistorySummary> loadAdminInvoiceSummaries(boolean todayOnly) {
        List<InvoiceHistorySummary> summaries = new ArrayList<>();
        Map<Integer, List<String>> statusesByInvoice = todayOnly
                ? loadTodayBookingStatusesByInvoice()
                : loadAllBookingStatusesByInvoice();
        Connection cn = null;
        try {
            cn = DBUtils.getConnection();
            String sql = "SELECT i.InvoiceID, i.InvoiceDate, i.SubTotal, i.DiscountAmount, i.FinalAmount, "
                    + "i.PaymentStatus, i.PaymentMethod, p.PromotionName, "
                    + "a.LastName + ' ' + a.FirstName AS CustomerName, "
                    + "COUNT(b.BookingID) AS BookingCount, "
                    + "MIN(t.StartTime) AS ScheduleStart, MAX(t.EndTime) AS ScheduleEnd, "
                    + "MIN(s.ServiceName) AS ServiceName "
                    + "FROM Invoices i "
                    + "JOIN Bookings b ON b.InvoiceID = i.InvoiceID "
                    + "JOIN TimeSlots t ON b.TimeSlotID = t.TimeSlotID "
                    + "JOIN Services s ON b.ServiceID = s.ServiceID "
                    + "JOIN Customers c ON c.CustomerID = i.CustomerID "
                    + "JOIN Accounts a ON a.AccountID = c.AccountID "
                    + "LEFT JOIN Promotions p ON i.PromotionID = p.PromotionID ";
            if (todayOnly) {
                sql += "WHERE t.SlotDate = CAST(GETDATE() AS DATE) "
                        + "AND b.Status NOT IN ('Cancelled', 'NoShow') ";
            }
            sql += "GROUP BY i.InvoiceID, i.InvoiceDate, i.SubTotal, i.DiscountAmount, i.FinalAmount, "
                    + "i.PaymentStatus, i.PaymentMethod, p.PromotionName, "
                    + "a.LastName, a.FirstName ";
            if (todayOnly) {
                sql += "ORDER BY MIN(t.StartTime), i.InvoiceID";
            } else {
                sql += "ORDER BY i.InvoiceDate DESC, i.InvoiceID DESC";
            }
            PreparedStatement st = cn.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                InvoiceHistorySummary summary = mapInvoiceSummaryRow(rs, statusesByInvoice);
                summary.setCustomerName(rs.getString("CustomerName"));
                summaries.add(summary);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeQuietly(cn);
        }
        return summaries;
    }

    private InvoiceHistoryDetail loadInvoiceHistoryDetail(int invoiceId) {
        Connection cn = null;
        try {
            cn = DBUtils.getConnection();
            String sql = "SELECT i.InvoiceID, i.InvoiceDate, i.SubTotal, i.DiscountAmount, i.FinalAmount, "
                    + "i.PaymentStatus, i.PaymentMethod, i.Note, p.PromotionName, "
                    + "a.LastName + ' ' + a.FirstName AS CustomerName "
                    + "FROM Invoices i "
                    + "LEFT JOIN Promotions p ON i.PromotionID = p.PromotionID "
                    + "JOIN Customers c ON c.CustomerID = i.CustomerID "
                    + "JOIN Accounts a ON a.AccountID = c.AccountID "
                    + "WHERE i.InvoiceID = ?";
            PreparedStatement st = cn.prepareStatement(sql);
            st.setInt(1, invoiceId);
            ResultSet rs = st.executeQuery();
            if (!rs.next()) {
                return null;
            }
            InvoiceHistoryDetail detail = new InvoiceHistoryDetail();
            detail.setInvoiceId(rs.getInt("InvoiceID"));
            Timestamp invoiceDate = rs.getTimestamp("InvoiceDate");
            if (invoiceDate != null) {
                detail.setInvoiceDate(invoiceDate.toLocalDateTime());
            }
            detail.setSubTotal(rs.getLong("SubTotal"));
            detail.setDiscountAmount(rs.getLong("DiscountAmount"));
            detail.setFinalAmount(rs.getLong("FinalAmount"));
            detail.setPaymentStatus(rs.getString("PaymentStatus"));
            detail.setPaymentMethod(rs.getString("PaymentMethod"));
            detail.setNote(rs.getString("Note"));
            detail.setPromotionName(rs.getString("PromotionName"));
            detail.setCustomerName(rs.getString("CustomerName"));
            List<dto.Booking> bookings = new BookingDAO().getBookingsByInvoiceId(invoiceId);
            detail.setBookings(bookings);
            detail.setBookingStatus(InvoiceHistoryHelper.deriveBookingStatus(bookings));
            return detail;
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeQuietly(cn);
        }
        return null;
    }

    private InvoiceHistorySummary mapInvoiceSummaryRow(ResultSet rs,
            Map<Integer, List<String>> statusesByInvoice) throws SQLException {
        InvoiceHistorySummary summary = new InvoiceHistorySummary();
        int invoiceId = rs.getInt("InvoiceID");
        summary.setInvoiceId(invoiceId);
        Timestamp invoiceDate = rs.getTimestamp("InvoiceDate");
        if (invoiceDate != null) {
            summary.setInvoiceDate(invoiceDate.toLocalDateTime());
        }
        summary.setSubTotal(rs.getLong("SubTotal"));
        summary.setDiscountAmount(rs.getLong("DiscountAmount"));
        summary.setFinalAmount(rs.getLong("FinalAmount"));
        summary.setPaymentStatus(rs.getString("PaymentStatus"));
        summary.setPaymentMethod(rs.getString("PaymentMethod"));
        summary.setPromotionName(rs.getString("PromotionName"));
        summary.setBookingCount(rs.getInt("BookingCount"));
        Timestamp scheduleStart = rs.getTimestamp("ScheduleStart");
        if (scheduleStart != null) {
            summary.setScheduleStart(scheduleStart.toLocalDateTime());
        }
        Timestamp scheduleEnd = rs.getTimestamp("ScheduleEnd");
        if (scheduleEnd != null) {
            summary.setScheduleEnd(scheduleEnd.toLocalDateTime());
        }
        String serviceName = rs.getString("ServiceName");
        int bookingCount = summary.getBookingCount();
        if (bookingCount > 1) {
            summary.setServiceSummary(
                    (serviceName != null ? serviceName : "Service") + " · " + bookingCount + " vehicles");
        } else {
            summary.setServiceSummary(serviceName != null ? serviceName : "Service");
        }
        summary.setBookingStatus(deriveStatusFromStrings(statusesByInvoice.get(invoiceId)));
        return summary;
    }

    private Map<Integer, List<String>> loadAllBookingStatusesByInvoice() {
        Map<Integer, List<String>> statusesByInvoice = new HashMap<>();
        Connection cn = null;
        try {
            cn = DBUtils.getConnection();
            String sql = "SELECT InvoiceID, Status FROM Bookings "
                    + "WHERE InvoiceID IS NOT NULL "
                    + "ORDER BY InvoiceID";
            PreparedStatement st = cn.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                int invoiceId = rs.getInt("InvoiceID");
                statusesByInvoice.computeIfAbsent(invoiceId, key -> new ArrayList<>())
                        .add(rs.getString("Status"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeQuietly(cn);
        }
        return statusesByInvoice;
    }

    private Map<Integer, List<String>> loadTodayBookingStatusesByInvoice() {
        Map<Integer, List<String>> statusesByInvoice = new HashMap<>();
        Connection cn = null;
        try {
            cn = DBUtils.getConnection();
            String sql = "SELECT b.InvoiceID, b.Status FROM Bookings b "
                    + "JOIN TimeSlots t ON b.TimeSlotID = t.TimeSlotID "
                    + "WHERE t.SlotDate = CAST(GETDATE() AS DATE) "
                    + "AND b.InvoiceID IS NOT NULL "
                    + "AND b.Status NOT IN ('Cancelled', 'NoShow') "
                    + "ORDER BY b.InvoiceID";
            PreparedStatement st = cn.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                int invoiceId = rs.getInt("InvoiceID");
                statusesByInvoice.computeIfAbsent(invoiceId, key -> new ArrayList<>())
                        .add(rs.getString("Status"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeQuietly(cn);
        }
        return statusesByInvoice;
    }

    private Map<Integer, List<String>> loadBookingStatusesByCustomer(int customerId) {
        Map<Integer, List<String>> statusesByInvoice = new HashMap<>();
        Connection cn = null;
        try {
            cn = DBUtils.getConnection();
            String sql = "SELECT InvoiceID, Status FROM Bookings "
                    + "WHERE CustomerID = ? AND InvoiceID IS NOT NULL "
                    + "ORDER BY InvoiceID";
            PreparedStatement st = cn.prepareStatement(sql);
            st.setInt(1, customerId);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                int invoiceId = rs.getInt("InvoiceID");
                statusesByInvoice.computeIfAbsent(invoiceId, key -> new ArrayList<>())
                        .add(rs.getString("Status"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeQuietly(cn);
        }
        return statusesByInvoice;
    }

    private String deriveStatusFromStrings(List<String> statuses) {
        if (statuses == null || statuses.isEmpty()) {
            return "Pending";
        }
        List<dto.Booking> bookings = new ArrayList<>();
        for (String status : statuses) {
            dto.Booking booking = new dto.Booking();
            booking.setStatus(status);
            bookings.add(booking);
        }
        return InvoiceHistoryHelper.deriveBookingStatus(bookings);
    }

    public InvoiceBillingDetail getInvoiceBillingDetail(int invoiceId) {
        Connection cn = null;
        try {
            cn = DBUtils.getConnection();
            String sql = "SELECT i.InvoiceID, i.SubTotal, i.DiscountAmount, i.FinalAmount, "
                    + "i.PromotionID, p.PromotionName "
                    + "FROM Invoices i "
                    + "LEFT JOIN Promotions p ON i.PromotionID = p.PromotionID "
                    + "WHERE i.InvoiceID = ?";
            PreparedStatement st = cn.prepareStatement(sql);
            st.setInt(1, invoiceId);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                InvoiceBillingDetail detail = new InvoiceBillingDetail();
                detail.setInvoiceId(rs.getInt("InvoiceID"));
                detail.setSubTotal(rs.getLong("SubTotal"));
                detail.setDiscountAmount(rs.getLong("DiscountAmount"));
                detail.setFinalAmount(rs.getLong("FinalAmount"));
                int promoId = rs.getInt("PromotionID");
                if (!rs.wasNull()) {
                    detail.setPromotionId(promoId);
                }
                detail.setPromotionName(rs.getString("PromotionName"));
                return detail;
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeQuietly(cn);
        }
        return null;
    }

    public List<Integer> findExpiredUnpaidInvoiceIds(int timeoutMinutes) {
        List<Integer> invoiceIds = new ArrayList<>();
        Connection cn = null;
        try {
            cn = DBUtils.getConnection();
            String sql = "SELECT i.InvoiceID "
                    + "FROM Invoices i "
                    + "WHERE i.PaymentStatus = 'Unpaid' "
                    + "AND i.InvoiceDate <= DATEADD(MINUTE, ?, GETDATE()) "
                    + "AND EXISTS ("
                    + "  SELECT 1 FROM Bookings b "
                    + "  WHERE b.InvoiceID = i.InvoiceID AND b.Status = 'Pending'"
                    + ") "
                    + "ORDER BY i.InvoiceID";
            PreparedStatement st = cn.prepareStatement(sql);
            st.setInt(1, -timeoutMinutes);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                invoiceIds.add(rs.getInt("InvoiceID"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeQuietly(cn);
        }
        return invoiceIds;
    }

    public boolean isExpiredUnpaidInvoice(int invoiceId, int timeoutMinutes) {
        Connection cn = null;
        try {
            cn = DBUtils.getConnection();
            String sql = "SELECT 1 FROM Invoices "
                    + "WHERE InvoiceID = ? "
                    + "AND PaymentStatus = 'Unpaid' "
                    + "AND InvoiceDate <= DATEADD(MINUTE, ?, GETDATE())";
            PreparedStatement st = cn.prepareStatement(sql);
            st.setInt(1, invoiceId);
            st.setInt(2, -timeoutMinutes);
            ResultSet rs = st.executeQuery();
            return rs.next();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeQuietly(cn);
        }
        return false;
    }

    public boolean isInvoiceOwnedByCustomer(int invoiceId, int customerId) {
        Connection cn = null;
        try {
            cn = DBUtils.getConnection();
            String sql = "SELECT 1 FROM Invoices WHERE InvoiceID = ? AND CustomerID = ?";
            PreparedStatement st = cn.prepareStatement(sql);
            st.setInt(1, invoiceId);
            st.setInt(2, customerId);
            ResultSet rs = st.executeQuery();
            return rs.next();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeQuietly(cn);
        }
        return false;
    }

    public Integer getPromotionId(int invoiceId, Connection cn) throws SQLException {
        String sql = "SELECT PromotionID FROM Invoices WHERE InvoiceID = ?";
        PreparedStatement st = cn.prepareStatement(sql);
        st.setInt(1, invoiceId);
        ResultSet rs = st.executeQuery();
        if (rs.next()) {
            int promoId = rs.getInt("PromotionID");
            if (!rs.wasNull()) {
                return promoId;
            }
        }
        return null;
    }

    public long getInvoiceFinalAmount(int invoiceId, Connection cn) throws SQLException {
        String sql = "SELECT FinalAmount FROM Invoices WHERE InvoiceID = ?";
        PreparedStatement st = cn.prepareStatement(sql);
        st.setInt(1, invoiceId);
        ResultSet rs = st.executeQuery();
        if (rs.next()) {
            return rs.getLong("FinalAmount");
        }
        return -1;
    }

    public int markInvoicePaid(int invoiceId, String paymentMethod, Connection cn) throws SQLException {
        String sql = "UPDATE Invoices SET PaymentStatus = 'Paid', PaymentMethod = ? WHERE InvoiceID = ?";
        PreparedStatement st = cn.prepareStatement(sql);
        st.setString(1, paymentMethod);
        st.setInt(2, invoiceId);
        return st.executeUpdate();
    }

    public int cancelInvoice(int invoiceId, Connection cn) throws SQLException {
        return updatePaymentStatus(invoiceId, "Cancelled", cn);
    }

    private void closeQuietly(Connection cn) {
        if (cn != null) {
            try {
                cn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    public int createPaidInvoice(int customerId, long finalAmount, String paymentMethod,
            int bookingId, Connection cn) throws SQLException {
        String sql = "INSERT INTO Invoices "
                + "(CustomerID, SubTotal, DiscountAmount, FinalAmount, PaymentStatus, PaymentMethod, Note) "
                + "VALUES (?, ?, 0, ?, 'Paid', ?, ?)";
        PreparedStatement st = cn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
        st.setInt(1, customerId);
        st.setLong(2, finalAmount);
        st.setLong(3, finalAmount);
        st.setString(4, paymentMethod);
        st.setString(5, "Payment for booking #" + bookingId);
        int result = st.executeUpdate();
        if (result <= 0) {
            return -1;
        }
        ResultSet keys = st.getGeneratedKeys();
        if (keys.next()) {
            return keys.getInt(1);
        }
        return -1;
    }

    public String getPaymentStatus(int invoiceId, Connection cn) throws SQLException {
        String sql = "SELECT PaymentStatus FROM Invoices WHERE InvoiceID = ?";
        PreparedStatement st = cn.prepareStatement(sql);
        st.setInt(1, invoiceId);
        ResultSet rs = st.executeQuery();
        if (rs.next()) {
            return rs.getString("PaymentStatus");
        }
        return null;
    }

    public int updatePaymentStatus(int invoiceId, String paymentStatus, Connection cn) throws SQLException {
        String sql = "UPDATE Invoices SET PaymentStatus = ? WHERE InvoiceID = ?";
        PreparedStatement st = cn.prepareStatement(sql);
        st.setString(1, paymentStatus);
        st.setInt(2, invoiceId);
        return st.executeUpdate();
    }

    public int getTotalRevenueDay() {
        int total = 0;
        Connection cn = null;

        try {
            cn = DBUtils.getConnection();
            String sql = "SELECT SUM([FinalAmount]) AS RevenueDay\n"
                    + "FROM [dbo].[Invoices] WHERE PaymentStatus = 'Paid' AND [InvoiceDate] >= CAST(GETDATE() AS DATE) \n"
                    + "AND [InvoiceDate] < CAST(DATEADD(day, 1, GETDATE()) AS DATE);";

            PreparedStatement st = cn.prepareStatement(sql);

            ResultSet table = st.executeQuery();
            while (table.next()) {
                total = table.getInt("RevenueDay");
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (cn != null) {
                    cn.close();
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        return total;
    }

    public int getTotalRevenueMonth() {
        int total = 0;
        Connection cn = null;

        try {
            cn = DBUtils.getConnection();
            String sql = "SELECT \n"
                    + "    SUM(FinalAmount) AS RevenueMonth\n"
                    + "FROM [dbo].[Invoices]\n"
                    + "WHERE PaymentStatus = 'Paid'\n"
                    + "  AND MONTH(InvoiceDate) = MONTH(GETDATE())\n"
                    + "  AND YEAR(InvoiceDate) = YEAR(GETDATE());";

            PreparedStatement st = cn.prepareStatement(sql);

            ResultSet table = st.executeQuery();
            while (table.next()) {
                total = table.getInt("RevenueMonth");
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (cn != null) {
                    cn.close();
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        return total;
    }
}
