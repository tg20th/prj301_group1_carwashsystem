package dao;

import dbutils.DBUtils;
import dto.Booking;
import dto.DiscountRequest;
import dto.DiscountResult;
import dto.ServicePrices;
import dto.TimeSlot;
import dto.TimeSlotDTO;
import service.DiscountEngine;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import dto.WashBaySlotDTO;

public class BookingDAO {

    public static class BusinessBookingResult {
        private final int invoiceId;
        private final int leaderBookingId;
        private final List<Integer> bookingIds;
        private final long totalAmount;

        public BusinessBookingResult(int invoiceId, int leaderBookingId,
                List<Integer> bookingIds, long totalAmount) {
            this.invoiceId = invoiceId;
            this.leaderBookingId = leaderBookingId;
            this.bookingIds = bookingIds;
            this.totalAmount = totalAmount;
        }

        public int getInvoiceId() {
            return invoiceId;
        }

        public int getLeaderBookingId() {
            return leaderBookingId;
        }

        public List<Integer> getBookingIds() {
            return bookingIds;
        }

        public long getTotalAmount() {
            return totalAmount;
        }
    }

    public static class CustomerBookingResult {
        private final int invoiceId;
        private final int bookingId;
        private final long finalAmount;

        public CustomerBookingResult(int invoiceId, int bookingId, long finalAmount) {
            this.invoiceId = invoiceId;
            this.bookingId = bookingId;
            this.finalAmount = finalAmount;
        }

        public int getInvoiceId() {
            return invoiceId;
        }

        public int getBookingId() {
            return bookingId;
        }

        public long getFinalAmount() {
            return finalAmount;
        }
    }

    public static class InvoicePaymentSummary {
        private int invoiceId;
        private int customerId;
        private int leaderBookingId;
        private long totalAmount;
        private String invoicePaymentStatus;
        private String leaderPaymentStatus;
        private long paymentOrderCode;
        private String paymentLinkId;
        private int bookingCount;
        private String leaderBookingStatus;

        public int getInvoiceId() {
            return invoiceId;
        }

        public int getCustomerId() {
            return customerId;
        }

        public int getLeaderBookingId() {
            return leaderBookingId;
        }

        public long getTotalAmount() {
            return totalAmount;
        }

        public String getInvoicePaymentStatus() {
            return invoicePaymentStatus;
        }

        public String getLeaderPaymentStatus() {
            return leaderPaymentStatus;
        }

        public long getPaymentOrderCode() {
            return paymentOrderCode;
        }

        public String getPaymentLinkId() {
            return paymentLinkId;
        }

        public int getBookingCount() {
            return bookingCount;
        }

        public String getLeaderBookingStatus() {
            return leaderBookingStatus;
        }
    }

    public int createCustomerBooking(Booking b) {
        if (b.getTimeSlotID() == null || b.getWashBayId() <= 0) {
            return -1;
        }

        TimeSlotDAO slotDao = new TimeSlotDAO();
        WashBayDAO bayDao = new WashBayDAO();
        TimeSlotDTO slot = slotDao.getSlotById(b.getTimeSlotID());

        if (slot == null) {
            return -1;
        }
        if (slot.isFull()) {
            return -2;
        }
        if (!bayDao.isWashBayBookableInSlot(b.getWashBayId(), b.getTimeSlotID())) {
            return -4;
        }

        Connection cn = null;
        try {
            cn = DBUtils.getConnection();
            cn.setAutoCommit(false);

            String sql = "INSERT INTO Bookings "
                    + "(CustomerID, VehicleID, ServiceID, WashBayID, TimeSlotID, InvoiceID, "
                    + "Quantity, PriceAtOrder, DurationAtOrder, BookingDate, Status, Notes) "
                    + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

            PreparedStatement st = cn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            st.setInt(1, b.getCustomerID());
            st.setInt(2, b.getVehicleID());
            st.setInt(3, b.getServiceID());
            st.setInt(4, b.getWashBayId());
            st.setInt(5, b.getTimeSlotID());
            if (b.getInvoiceID() > 0) {
                st.setInt(6, b.getInvoiceID());
            } else {
                st.setNull(6, java.sql.Types.INTEGER);
            }
            st.setInt(7, b.getQuantity());
            st.setDouble(8, b.getPriceAtOrder());
            st.setInt(9, b.getDurationAtOrder());
            if (slot.getStartTime() != null) {
                st.setTimestamp(10, Timestamp.valueOf(slot.getStartTime()));
            } else {
                st.setTimestamp(10, Timestamp.valueOf(LocalDateTime.now()));
            }
            st.setString(11, b.getStatus() != null ? b.getStatus() : "Pending");
            st.setString(12, b.getNotes());

            int result = st.executeUpdate();
            if (result <= 0) {
                cn.rollback();
                return 0;
            }

            ResultSet keys = st.getGeneratedKeys();
            if (keys.next()) {
                b.setBookingID(keys.getInt(1));
            }

            slotDao.syncSlotFullness(b.getTimeSlotID(), cn);
            cn.commit();
            return result;
        } catch (SQLException e) {
            if (cn != null) {
                try {
                    cn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            if (e.getMessage() != null && e.getMessage().contains("UQ_Bookings_Bay_Slot_Active")) {
                return -4;
            }
            e.printStackTrace();
            return 0;
        } catch (Exception e) {
            if (cn != null) {
                try {
                    cn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            e.printStackTrace();
            return 0;
        } finally {
            if (cn != null) {
                try {
                    cn.setAutoCommit(true);
                    cn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    public CustomerBookingResult createCustomerBookingWithInvoice(Booking b, int tierId, Integer promotionId) {
        if (b.getTimeSlotID() == null || b.getWashBayId() <= 0) {
            return null;
        }

        TimeSlotDAO slotDao = new TimeSlotDAO();
        WashBayDAO bayDao = new WashBayDAO();
        TimeSlotDTO slot = slotDao.getSlotById(b.getTimeSlotID());

        if (slot == null) {
            return null;
        }
        if (!slotDao.isSlotBookable(slot)) {
            return null;
        }
        if (slot.isFull()) {
            return null;
        }
        if (!bayDao.isWashBayBookableInSlot(b.getWashBayId(), b.getTimeSlotID())) {
            return null;
        }

        long subTotal = Math.round(b.getPriceAtOrder() * b.getQuantity());
        DiscountEngine discountEngine = new DiscountEngine();
        DiscountResult pricing = discountEngine.calculate(
                new DiscountRequest(b.getCustomerID(), tierId, subTotal, promotionId));

        Connection cn = null;
        try {
            cn = DBUtils.getConnection();
            cn.setAutoCommit(false);

            InvoiceDAO invoiceDAO = new InvoiceDAO();
            String invoiceNote = "Customer booking";
            int invoiceId = invoiceDAO.createPendingInvoiceWithDiscount(
                    b.getCustomerID(),
                    pricing.getSubTotal(),
                    pricing.getDiscountAmount(),
                    pricing.getFinalAmount(),
                    pricing.getAppliedPromotionId(),
                    null,
                    invoiceNote,
                    cn);
            if (invoiceId <= 0) {
                cn.rollback();
                return null;
            }

            if (pricing.getAppliedPromotionId() != null && pricing.getAppliedPromotionId() > 0) {
                PromotionDAO promotionDAO = new PromotionDAO();
                if (!promotionDAO.consumePromotionUsage(
                        pricing.getAppliedPromotionId(), b.getCustomerID(), cn)) {
                    cn.rollback();
                    return null;
                }
            }

            String sql = "INSERT INTO Bookings "
                    + "(CustomerID, VehicleID, ServiceID, WashBayID, TimeSlotID, InvoiceID, "
                    + "Quantity, PriceAtOrder, DurationAtOrder, BookingDate, Status, Notes) "
                    + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

            PreparedStatement st = cn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            st.setInt(1, b.getCustomerID());
            st.setInt(2, b.getVehicleID());
            st.setInt(3, b.getServiceID());
            st.setInt(4, b.getWashBayId());
            st.setInt(5, b.getTimeSlotID());
            st.setInt(6, invoiceId);
            st.setInt(7, b.getQuantity());
            st.setDouble(8, b.getPriceAtOrder());
            st.setInt(9, b.getDurationAtOrder());
            if (slot.getStartTime() != null) {
                st.setTimestamp(10, Timestamp.valueOf(slot.getStartTime()));
            } else {
                st.setTimestamp(10, Timestamp.valueOf(LocalDateTime.now()));
            }
            st.setString(11, b.getStatus() != null ? b.getStatus() : "Pending");
            st.setString(12, b.getNotes());

            if (st.executeUpdate() <= 0) {
                cn.rollback();
                return null;
            }

            ResultSet keys = st.getGeneratedKeys();
            int bookingId = 0;
            if (keys.next()) {
                bookingId = keys.getInt(1);
                b.setBookingID(bookingId);
                b.setInvoiceID(invoiceId);
            } else {
                cn.rollback();
                return null;
            }

            slotDao.syncSlotFullness(b.getTimeSlotID(), cn);
            cn.commit();
            return new CustomerBookingResult(invoiceId, bookingId, pricing.getFinalAmount());
        } catch (SQLException e) {
            if (cn != null) {
                try {
                    cn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            if (e.getMessage() != null && e.getMessage().contains("UQ_Bookings_Bay_Slot_Active")) {
                return null;
            }
            e.printStackTrace();
            return null;
        } catch (Exception e) {
            if (cn != null) {
                try {
                    cn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            e.printStackTrace();
            return null;
        } finally {
            if (cn != null) {
                try {
                    cn.setAutoCommit(true);
                    cn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    public List<Booking> getAllBookToday() {
        List<Booking> list = new ArrayList<>();
        Connection cn = null;

        try {
            cn = DBUtils.getConnection();
            String sql = "SELECT b.BookingID, a.LastName + ' ' + a.FirstName AS FullName, "
                    + "v.LicensePlate, vb.BrandName + ' ' + vm.ModelName AS VehicleName, "
                    + "vt.TypeName, s.ServiceName, t.TimeSlotID, t.StartTime, t.EndTime, "
                    + "t.IsFull, b.Status, wb.BayName "
                    + "FROM Bookings b "
                    + "JOIN TimeSlots t ON b.TimeSlotID = t.TimeSlotID "
                    + "JOIN WashBays wb ON wb.WashBayID = b.WashBayID "
                    + "JOIN Customers c ON c.CustomerID = b.CustomerID "
                    + "JOIN Accounts a ON a.AccountID = c.AccountID "
                    + "JOIN Vehicles v ON v.VehicleID = b.VehicleID "
                    + "JOIN Services s ON s.ServiceID = b.ServiceID "
                    + "JOIN VehicleModels vm ON v.ModelID = vm.ModelID "
                    + "JOIN VehicleBrands vb ON vb.BrandID = vm.BrandID "
                    + "JOIN VehicleTypes vt ON vt.VehicleTypeID = vm.VehicleTypeID "
                    + "WHERE (t.SlotDate = CAST(GETDATE() AS DATE) AND b.Status <> 'Cancelled') "
                    + "OR (t.SlotDate > CAST(GETDATE() AS DATE) "
                    + "AND b.Status IN ('Pending', 'Confirmed', 'InProgress')) "
                    + "ORDER BY t.SlotDate, t.StartTime, wb.BayName";

            PreparedStatement st = cn.prepareStatement(sql);
            ResultSet table = st.executeQuery();

            while (table.next()) {
                int id = table.getInt("BookingID");
                String name = table.getString("FullName");
                String licensePlate = table.getString("LicensePlate");
                String vehicleName = table.getString("VehicleName");
                String typeName = table.getString("TypeName");
                String service = table.getString("ServiceName");
                LocalDateTime startTime = table.getTimestamp("StartTime").toLocalDateTime();
                LocalDateTime endTime = table.getTimestamp("EndTime").toLocalDateTime();
                String timeSlotID = table.getString("TimeSlotID");
                String status = table.getString("Status");
                boolean isFull = table.getBoolean("IsFull");

                TimeSlot t = new TimeSlot(timeSlotID, startTime, endTime, isFull);
                Booking booking = new Booking(id, status, name, licensePlate, service, t, typeName, vehicleName);
                list.add(booking);
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
        return list;
    }

    public int updateStatusOfBooking(int id, String status) {
        int result = 0;
        Connection cn = null;

        try {
            cn = DBUtils.getConnection();
            result = updateStatusOfBooking(id, status, cn);
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

        return result;
    }

    private int updateStatusOfBooking(int id, String status, Connection cn) throws SQLException {
        String sql = "UPDATE Bookings SET Status = ? WHERE BookingID = ?";
        PreparedStatement st = cn.prepareStatement(sql);
        st.setString(1, status);
        st.setInt(2, id);
        return st.executeUpdate();
    }

    /**
     * Checkout + payment: create invoice, award loyalty points (1,000 VND = 1
     * point).
     *
     * @return points earned on success (may be 0), negative code on failure
     */
    public int completeBookingWithPayment(int bookingId, String paymentMethod) {
        if (paymentMethod == null || paymentMethod.trim().isEmpty()) {
            paymentMethod = "Cash";
        }

        Connection cn = null;
        try {
            cn = DBUtils.getConnection();
            cn.setAutoCommit(false);

            Booking booking = getBookingEntityById(bookingId, cn);
            if (booking == null) {
                cn.rollback();
                return -1;
            }
            if ("Completed".equalsIgnoreCase(booking.getStatus())) {
                cn.rollback();
                return -2;
            }
            if ("Cancelled".equalsIgnoreCase(booking.getStatus())
                    || "NoShow".equalsIgnoreCase(booking.getStatus())) {
                cn.rollback();
                return -3;
            }

            if ("Paid".equalsIgnoreCase(booking.getPaymentStatus())) {
                updateStatusOfBooking(bookingId, "Completed", cn);
                cn.commit();
                return 0;
            }

            long finalAmount = Math.round(booking.getPriceAtOrder() * booking.getQuantity());
            InvoiceDAO invoiceDAO = new InvoiceDAO();
            PointTransactionDAO pointDAO = new PointTransactionDAO();
            int invoiceId = booking.getInvoiceID();

            if (invoiceId > 0) {
                String payStatus = invoiceDAO.getPaymentStatus(invoiceId, cn);
                if (!"Paid".equalsIgnoreCase(payStatus)) {
                    invoiceDAO.updatePaymentStatus(invoiceId, "Paid", cn);
                }
            } else {
                invoiceId = invoiceDAO.createPaidInvoice(
                        booking.getCustomerID(), finalAmount, paymentMethod, bookingId, cn);
                if (invoiceId <= 0) {
                    cn.rollback();
                    return -4;
                }
                linkBookingToInvoice(bookingId, invoiceId, cn);
            }

            int points = 0;
            if (pointDAO.getNetPointsByInvoice(invoiceId, cn) <= 0) {
                points = pointDAO.earnPointsForPayment(
                        booking.getCustomerID(), invoiceId, finalAmount, bookingId, cn);
            }

            updateStatusOfBooking(bookingId, "Completed", cn);
            cn.commit();
            return points;
        } catch (Exception e) {
            if (cn != null) {
                try {
                    cn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            e.printStackTrace();
            return -4;
        } finally {
            if (cn != null) {
                try {
                    cn.setAutoCommit(true);
                    cn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    private void linkBookingToInvoice(int bookingId, int invoiceId, Connection cn) throws SQLException {
        String sql = "UPDATE Bookings SET InvoiceID = ? WHERE BookingID = ?";
        PreparedStatement st = cn.prepareStatement(sql);
        st.setInt(1, invoiceId);
        st.setInt(2, bookingId);
        st.executeUpdate();
    }

    public Booking getBookingForPayment(int bookingId) {
        Connection cn = null;
        try {
            cn = DBUtils.getConnection();
            return getBookingEntityById(bookingId, cn);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        } finally {
            closeQuietly(cn);
        }
    }

    public Booking getByPaymentOrderCode(long orderCode) {
        Connection cn = null;
        try {
            cn = DBUtils.getConnection();
            String sql = "SELECT BookingID, CustomerID, InvoiceID, Quantity, PriceAtOrder, Status, "
                    + "PaymentOrderCode, PaymentLinkId, PaymentStatus "
                    + "FROM Bookings WHERE PaymentOrderCode = ?";
            PreparedStatement st = cn.prepareStatement(sql);
            st.setLong(1, orderCode);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return mapBookingEntity(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeQuietly(cn);
        }
        return null;
    }

    public boolean updatePaymentInfo(int bookingId, long orderCode, String paymentLinkId,
            java.time.LocalDateTime expiredAt) {
        Connection cn = null;
        try {
            cn = DBUtils.getConnection();
            String sql = "UPDATE Bookings SET PaymentOrderCode = ?, PaymentLinkId = ?, "
                    + "PaymentStatus = 'Unpaid', PaymentExpiredAt = ? WHERE BookingID = ?";
            PreparedStatement st = cn.prepareStatement(sql);
            st.setLong(1, orderCode);
            st.setString(2, paymentLinkId);
            st.setTimestamp(3, Timestamp.valueOf(expiredAt));
            st.setInt(4, bookingId);
            return st.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        } finally {
            closeQuietly(cn);
        }
    }

    public boolean confirmAfterPayment(int bookingId, int paidAmount) {
        Connection cn = null;
        try {
            cn = DBUtils.getConnection();
            cn.setAutoCommit(false);

            Booking booking = getBookingEntityById(bookingId, cn);
            if (booking == null) {
                cn.rollback();
                return false;
            }
            if ("Paid".equalsIgnoreCase(booking.getPaymentStatus())) {
                cn.commit();
                return true;
            }
            if (paidAmount != (int) Math.round(booking.getPriceAtOrder() * booking.getQuantity())) {
                cn.rollback();
                return false;
            }

            InvoiceDAO invoiceDAO = new InvoiceDAO();
            PointTransactionDAO pointDAO = new PointTransactionDAO();
            int invoiceId = booking.getInvoiceID();
            if (invoiceId <= 0) {
                invoiceId = invoiceDAO.createPaidInvoice(
                        booking.getCustomerID(), paidAmount, "BankTransfer", bookingId, cn);
                if (invoiceId <= 0) {
                    cn.rollback();
                    return false;
                }
                linkBookingToInvoice(bookingId, invoiceId, cn);
            } else {
                invoiceDAO.updatePaymentStatus(invoiceId, "Paid", cn);
            }

            if (pointDAO.getNetPointsByInvoice(invoiceId, cn) <= 0) {
                pointDAO.earnPointsForPayment(
                        booking.getCustomerID(), invoiceId, paidAmount, bookingId, cn);
            }

            String sql = "UPDATE Bookings SET Status = 'Confirmed', PaymentStatus = 'Paid' WHERE BookingID = ?";
            PreparedStatement st = cn.prepareStatement(sql);
            st.setInt(1, bookingId);
            if (st.executeUpdate() <= 0) {
                cn.rollback();
                return false;
            }

            cn.commit();
            return true;
        } catch (Exception e) {
            if (cn != null) {
                try {
                    cn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            e.printStackTrace();
            return false;
        } finally {
            if (cn != null) {
                try {
                    cn.setAutoCommit(true);
                    cn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    private Booking getBookingEntityById(int bookingId, Connection cn) throws SQLException {
        String sql = "SELECT BookingID, CustomerID, InvoiceID, Quantity, PriceAtOrder, Status, "
                + "PaymentOrderCode, PaymentLinkId, PaymentStatus "
                + "FROM Bookings WHERE BookingID = ?";
        PreparedStatement st = cn.prepareStatement(sql);
        st.setInt(1, bookingId);
        ResultSet rs = st.executeQuery();
        if (rs.next()) {
            return mapBookingEntity(rs);
        }
        return null;
    }

    private Booking mapBookingEntity(ResultSet rs) throws SQLException {
        Booking booking = new Booking();
        booking.setBookingID(rs.getInt("BookingID"));
        booking.setCustomerID(rs.getInt("CustomerID"));
        int invoiceId = rs.getInt("InvoiceID");
        booking.setInvoiceID(rs.wasNull() ? 0 : invoiceId);
        booking.setQuantity(rs.getInt("Quantity"));
        booking.setPriceAtOrder(rs.getDouble("PriceAtOrder"));
        booking.setStatus(rs.getString("Status"));
        long orderCode = rs.getLong("PaymentOrderCode");
        booking.setPaymentOrderCode(rs.wasNull() ? 0L : orderCode);
        booking.setPaymentLinkId(rs.getString("PaymentLinkId"));
        booking.setPaymentStatus(rs.getString("PaymentStatus"));
        return booking;
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

    public int confirmBooking(int bookingId) {
        return updateStatusOfBooking(bookingId, "Confirmed");
    }

    public int checkInBooking(int bookingId) {
        Connection cn = null;
        try {
            cn = DBUtils.getConnection();
            Booking booking = getBookingEntityById(bookingId, cn);
            if (booking == null) {
                return -1;
            }
            if (!"Confirmed".equalsIgnoreCase(booking.getStatus())) {
                return -2;
            }
            return updateStatusOfBooking(bookingId, "InProgress", cn);
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        } finally {
            closeQuietly(cn);
        }
    }

    public List<Booking> getBookingsByCustomerId(int customerId) {
        List<Booking> list = new ArrayList<>();
        Connection cn = null;

        try {
            cn = DBUtils.getConnection();
            String sql = "SELECT b.BookingID, b.InvoiceID, b.Status, b.PriceAtOrder, b.DurationAtOrder, b.Notes, "
                    + "v.LicensePlate, vb.BrandName + ' ' + vm.ModelName AS VehicleName, "
                    + "vt.TypeName, s.ServiceName, t.TimeSlotID, t.StartTime, t.EndTime, "
                    + "t.IsFull, wb.BayName "
                    + "FROM Bookings b "
                    + "JOIN TimeSlots t ON b.TimeSlotID = t.TimeSlotID "
                    + "JOIN WashBays wb ON wb.WashBayID = b.WashBayID "
                    + "JOIN Vehicles v ON v.VehicleID = b.VehicleID "
                    + "JOIN Services s ON s.ServiceID = b.ServiceID "
                    + "JOIN VehicleModels vm ON v.ModelID = vm.ModelID "
                    + "JOIN VehicleBrands vb ON vb.BrandID = vm.BrandID "
                    + "JOIN VehicleTypes vt ON vt.VehicleTypeID = vm.VehicleTypeID "
                    + "WHERE b.CustomerID = ? "
                    + "ORDER BY t.StartTime DESC, b.BookingID DESC";

            PreparedStatement st = cn.prepareStatement(sql);
            st.setInt(1, customerId);
            ResultSet rs = st.executeQuery();

            while (rs.next()) {
                int id = rs.getInt("BookingID");
                String licensePlate = rs.getString("LicensePlate");
                String vehicleName = rs.getString("VehicleName");
                String typeName = rs.getString("TypeName");
                String service = rs.getString("ServiceName");
                LocalDateTime startTime = rs.getTimestamp("StartTime").toLocalDateTime();
                LocalDateTime endTime = rs.getTimestamp("EndTime").toLocalDateTime();
                String timeSlotID = rs.getString("TimeSlotID");
                String status = rs.getString("Status");
                boolean isFull = rs.getBoolean("IsFull");

                TimeSlot slot = new TimeSlot(timeSlotID, startTime, endTime, isFull);
                Booking booking = new Booking(id, status, null, licensePlate, service, slot, typeName, vehicleName);
                int invoiceId = rs.getInt("InvoiceID");
                booking.setInvoiceID(rs.wasNull() ? 0 : invoiceId);
                booking.setPriceAtOrder(rs.getDouble("PriceAtOrder"));
                booking.setDurationAtOrder(rs.getInt("DurationAtOrder"));
                booking.setNotes(rs.getString("Notes"));
                booking.setBayName(rs.getString("BayName"));
                list.add(booking);
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
        return list;
    }

    public int countActiveBookingsByCustomerId(int customerId) {
        Connection cn = null;
        try {
            cn = DBUtils.getConnection();
            String sql = "SELECT COUNT(*) AS Total "
                    + "FROM Bookings "
                    + "WHERE CustomerID = ? "
                    + "AND Status IN ('Pending', 'Confirmed', 'InProgress')";
            PreparedStatement st = cn.prepareStatement(sql);
            st.setInt(1, customerId);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return rs.getInt("Total");
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
        return 0;
    }

    public boolean isBookingOwnedByCustomer(int bookingId, int customerId) {
        Connection cn = null;
        try {
            cn = DBUtils.getConnection();
            String sql = "SELECT 1 FROM Bookings WHERE BookingID = ? AND CustomerID = ?";
            PreparedStatement st = cn.prepareStatement(sql);
            st.setInt(1, bookingId);
            st.setInt(2, customerId);
            ResultSet rs = st.executeQuery();
            return rs.next();
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
        return false;
    }

    public int cancelBooking(int bookingId) {
        Connection cn = null;
        try {
            cn = DBUtils.getConnection();
            cn.setAutoCommit(false);

            Booking booking = getBookingEntityById(bookingId, cn);
            if (booking == null) {
                cn.rollback();
                return 0;
            }
            if ("Cancelled".equalsIgnoreCase(booking.getStatus())) {
                cn.rollback();
                return 0;
            }

            if ("Unpaid".equalsIgnoreCase(booking.getPaymentStatus())
                    && booking.getPaymentLinkId() != null
                    && !booking.getPaymentLinkId().isEmpty()) {
                new service.PayOSService().cancelPaymentLink(booking.getPaymentLinkId());
            }

            if (booking.getInvoiceID() > 0) {
                InvoiceDAO invoiceDAO = new InvoiceDAO();
                PointTransactionDAO pointDAO = new PointTransactionDAO();
                Integer promoId = invoiceDAO.getPromotionId(booking.getInvoiceID(), cn);
                if (promoId != null && promoId > 0) {
                    new PromotionDAO().restorePromotionUsage(
                            promoId, booking.getCustomerID(), cn);
                }
                String payStatus = invoiceDAO.getPaymentStatus(booking.getInvoiceID(), cn);
                if ("Paid".equalsIgnoreCase(payStatus)) {
                    pointDAO.reversePointsForInvoice(
                            booking.getCustomerID(), booking.getInvoiceID(), bookingId, cn);
                    invoiceDAO.updatePaymentStatus(booking.getInvoiceID(), "Cancelled", cn);
                }
            }

            String sql = "UPDATE Bookings SET Status = 'Cancelled', "
                    + "PaymentStatus = CASE WHEN PaymentStatus = 'Paid' THEN PaymentStatus ELSE 'Cancelled' END "
                    + "WHERE BookingID = ?";
            PreparedStatement cancelSt = cn.prepareStatement(sql);
            cancelSt.setInt(1, bookingId);
            int result = cancelSt.executeUpdate();
            if (result <= 0) {
                cn.rollback();
                return 0;
            }

            cn.commit();

            Integer slotId = getTimeSlotIdByBooking(bookingId);
            if (slotId != null) {
                new TimeSlotDAO().syncSlotFullness(slotId);
            }
            return result;
        } catch (Exception e) {
            if (cn != null) {
                try {
                    cn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            e.printStackTrace();
            return 0;
        } finally {
            if (cn != null) {
                try {
                    cn.setAutoCommit(true);
                    cn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    public int markNoShowBookings() {
        int result = 0;
        Connection cn = null;

        try {
            cn = DBUtils.getConnection();
            String sql = "UPDATE b "
                    + "SET b.Status = 'NoShow' "
                    + "FROM Bookings b JOIN TimeSlots t "
                    + "ON b.TimeSlotID = t.TimeSlotID "
                    + "WHERE DATEADD(MINUTE, 15, t.StartTime) <= GETDATE() "
                    + "AND b.Status = 'Confirmed'";

            PreparedStatement st = cn.prepareStatement(sql);
            result = st.executeUpdate();

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

        return result;
    }

    /**
     * Creates one booking per vehicle, shared service/slot, single unpaid invoice.
     *
     * @return result on success; null on failure (check logs)
     */
    public BusinessBookingResult createBusinessBookings(int customerId, int tierId, int slotId, int serviceId,
            List<Integer> vehicleIds, String notes, Integer promotionId) {
        if (vehicleIds == null || vehicleIds.isEmpty()) {
            return null;
        }

        Set<Integer> uniqueVehicleIds = new HashSet<>(vehicleIds);
        if (uniqueVehicleIds.size() != vehicleIds.size()) {
            return null;
        }

        TimeSlotDAO slotDao = new TimeSlotDAO();
        WashBayDAO bayDao = new WashBayDAO();
        VehicleDAO vehicleDAO = new VehicleDAO();
        ServicePricesDAO priceDAO = new ServicePricesDAO();
        TimeSlotDTO slot = slotDao.getSlotById(slotId);

        if (slot == null) {
            return null;
        }
        if (!slotDao.isSlotBookable(slot)) {
            return null;
        }

        List<WashBaySlotDTO> availableBays = bayDao.getAvailableWashBaysForTimeSlot(slotId);
        if (availableBays.size() < vehicleIds.size()) {
            return null;
        }

        for (int vehicleId : vehicleIds) {
            if (!vehicleDAO.isVehicleOwnedByCustomer(vehicleId, customerId)) {
                return null;
            }
        }

        Connection cn = null;
        try {
            cn = DBUtils.getConnection();
            cn.setAutoCommit(false);

            long totalAmount = 0;
            List<Booking> pending = new ArrayList<>();
            for (int i = 0; i < vehicleIds.size(); i++) {
                int vehicleId = vehicleIds.get(i);
                Integer vehicleTypeId = vehicleDAO.getVehicleTypeIdByVehicleId(vehicleId);
                ServicePrices price = priceDAO.getPriceByServiceAndVehicleType(serviceId, vehicleTypeId);
                if (price == null) {
                    cn.rollback();
                    return null;
                }

                Booking booking = new Booking();
                booking.setCustomerID(customerId);
                booking.setVehicleID(vehicleId);
                booking.setServiceID(serviceId);
                booking.setWashBayId(availableBays.get(i).getWashBayID());
                booking.setTimeSlotID(slotId);
                booking.setQuantity(1);
                booking.setPriceAtOrder(price.getPrice().doubleValue());
                booking.setDurationAtOrder(price.getDurations());
                booking.setStatus("Pending");
                booking.setNotes(notes);
                pending.add(booking);
                totalAmount += Math.round(price.getPrice().doubleValue());
            }

            DiscountEngine discountEngine = new DiscountEngine();
            DiscountResult pricing = discountEngine.calculate(
                    new DiscountRequest(customerId, tierId, totalAmount, promotionId));

            InvoiceDAO invoiceDAO = new InvoiceDAO();
            String invoiceNote = "Business batch booking: " + vehicleIds.size() + " vehicle(s)";
            int invoiceId = invoiceDAO.createPendingInvoiceWithDiscount(
                    customerId,
                    pricing.getSubTotal(),
                    pricing.getDiscountAmount(),
                    pricing.getFinalAmount(),
                    pricing.getAppliedPromotionId(),
                    null,
                    invoiceNote,
                    cn);
            if (invoiceId <= 0) {
                cn.rollback();
                return null;
            }

            if (pricing.getAppliedPromotionId() != null && pricing.getAppliedPromotionId() > 0) {
                PromotionDAO promotionDAO = new PromotionDAO();
                if (!promotionDAO.consumePromotionUsage(
                        pricing.getAppliedPromotionId(), customerId, cn)) {
                    cn.rollback();
                    return null;
                }
            }

            List<Integer> bookingIds = new ArrayList<>();
            String insertSql = "INSERT INTO Bookings "
                    + "(CustomerID, VehicleID, ServiceID, WashBayID, TimeSlotID, InvoiceID, "
                    + "Quantity, PriceAtOrder, DurationAtOrder, BookingDate, Status, Notes) "
                    + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

            for (Booking booking : pending) {
                booking.setInvoiceID(invoiceId);
                PreparedStatement st = cn.prepareStatement(insertSql, Statement.RETURN_GENERATED_KEYS);
                st.setInt(1, booking.getCustomerID());
                st.setInt(2, booking.getVehicleID());
                st.setInt(3, booking.getServiceID());
                st.setInt(4, booking.getWashBayId());
                st.setInt(5, booking.getTimeSlotID());
                st.setInt(6, invoiceId);
                st.setInt(7, booking.getQuantity());
                st.setDouble(8, booking.getPriceAtOrder());
                st.setInt(9, booking.getDurationAtOrder());
                if (slot.getStartTime() != null) {
                    st.setTimestamp(10, Timestamp.valueOf(slot.getStartTime()));
                } else {
                    st.setTimestamp(10, Timestamp.valueOf(LocalDateTime.now()));
                }
                st.setString(11, booking.getStatus());
                st.setString(12, booking.getNotes());

                if (st.executeUpdate() <= 0) {
                    cn.rollback();
                    return null;
                }
                ResultSet keys = st.getGeneratedKeys();
                if (keys.next()) {
                    bookingIds.add(keys.getInt(1));
                } else {
                    cn.rollback();
                    return null;
                }
            }

            slotDao.syncSlotFullness(slotId, cn);
            cn.commit();

            int leaderBookingId = bookingIds.get(0);
            return new BusinessBookingResult(invoiceId, leaderBookingId, bookingIds, pricing.getFinalAmount());
        } catch (SQLException e) {
            if (cn != null) {
                try {
                    cn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            if (e.getMessage() != null && e.getMessage().contains("UQ_Bookings_Bay_Slot_Active")) {
                return null;
            }
            e.printStackTrace();
            return null;
        } catch (Exception e) {
            if (cn != null) {
                try {
                    cn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            e.printStackTrace();
            return null;
        } finally {
            if (cn != null) {
                try {
                    cn.setAutoCommit(true);
                    cn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    public InvoicePaymentSummary getInvoicePaymentSummary(int invoiceId) {
        Connection cn = null;
        try {
            cn = DBUtils.getConnection();
            String sql = "SELECT i.InvoiceID, i.CustomerID, i.FinalAmount, i.PaymentStatus AS InvoicePaymentStatus, "
                    + "COUNT(b.BookingID) AS BookingCount, "
                    + "MIN(b.BookingID) AS LeaderBookingId "
                    + "FROM Invoices i "
                    + "JOIN Bookings b ON b.InvoiceID = i.InvoiceID "
                    + "WHERE i.InvoiceID = ? "
                    + "GROUP BY i.InvoiceID, i.CustomerID, i.FinalAmount, i.PaymentStatus";
            PreparedStatement st = cn.prepareStatement(sql);
            st.setInt(1, invoiceId);
            ResultSet rs = st.executeQuery();
            if (!rs.next()) {
                return null;
            }

            InvoicePaymentSummary summary = new InvoicePaymentSummary();
            summary.invoiceId = rs.getInt("InvoiceID");
            summary.customerId = rs.getInt("CustomerID");
            summary.totalAmount = rs.getLong("FinalAmount");
            summary.invoicePaymentStatus = rs.getString("InvoicePaymentStatus");
            summary.bookingCount = rs.getInt("BookingCount");
            summary.leaderBookingId = rs.getInt("LeaderBookingId");

            Booking leader = getBookingEntityById(summary.leaderBookingId, cn);
            if (leader != null) {
                summary.leaderPaymentStatus = leader.getPaymentStatus();
                summary.paymentOrderCode = leader.getPaymentOrderCode();
                summary.paymentLinkId = leader.getPaymentLinkId();
                summary.leaderBookingStatus = leader.getStatus();
            }
            return summary;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        } finally {
            closeQuietly(cn);
        }
    }

    public boolean updateInvoicePaymentInfo(int invoiceId, long orderCode, String paymentLinkId,
            java.time.LocalDateTime expiredAt) {
        InvoicePaymentSummary summary = getInvoicePaymentSummary(invoiceId);
        if (summary == null || summary.leaderBookingId <= 0) {
            return false;
        }
        return updatePaymentInfo(summary.leaderBookingId, orderCode, paymentLinkId, expiredAt);
    }

    public boolean confirmInvoiceAfterPayment(int invoiceId, int paidAmount) {
        Connection cn = null;
        try {
            cn = DBUtils.getConnection();
            cn.setAutoCommit(false);

            InvoiceDAO invoiceDAO = new InvoiceDAO();
            long expectedAmount = invoiceDAO.getInvoiceFinalAmount(invoiceId, cn);
            if (expectedAmount < 0) {
                cn.rollback();
                return false;
            }
            if (paidAmount != (int) expectedAmount) {
                cn.rollback();
                return false;
            }

            String payStatus = invoiceDAO.getPaymentStatus(invoiceId, cn);
            if ("Paid".equalsIgnoreCase(payStatus)) {
                cn.commit();
                return true;
            }

            List<Integer> bookingIds = getBookingIdsByInvoice(invoiceId, cn);
            if (bookingIds.isEmpty()) {
                cn.rollback();
                return false;
            }

            int customerId = getCustomerIdByInvoice(invoiceId, cn);
            if (customerId <= 0) {
                cn.rollback();
                return false;
            }

            invoiceDAO.markInvoicePaid(invoiceId, "BankTransfer", cn);

            PointTransactionDAO pointDAO = new PointTransactionDAO();
            int leaderBookingId = bookingIds.get(0);
            if (pointDAO.getNetPointsByInvoice(invoiceId, cn) <= 0) {
                pointDAO.earnPointsForPayment(customerId, invoiceId, paidAmount, leaderBookingId, cn);
            }

            String updateSql = "UPDATE Bookings SET Status = 'Confirmed', PaymentStatus = 'Paid' "
                    + "WHERE InvoiceID = ? AND Status = 'Pending'";
            PreparedStatement updateSt = cn.prepareStatement(updateSql);
            updateSt.setInt(1, invoiceId);
            if (updateSt.executeUpdate() <= 0) {
                cn.rollback();
                return false;
            }

            cn.commit();
            return true;
        } catch (Exception e) {
            if (cn != null) {
                try {
                    cn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            e.printStackTrace();
            return false;
        } finally {
            if (cn != null) {
                try {
                    cn.setAutoCommit(true);
                    cn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    public int cancelInvoiceBookings(int invoiceId) {
        Connection cn = null;
        try {
            cn = DBUtils.getConnection();
            cn.setAutoCommit(false);

            List<Integer> bookingIds = getBookingIdsByInvoice(invoiceId, cn);
            if (bookingIds.isEmpty()) {
                cn.rollback();
                return 0;
            }

            Booking leader = getBookingEntityById(bookingIds.get(0), cn);
            if (leader != null && "Unpaid".equalsIgnoreCase(leader.getPaymentStatus())
                    && leader.getPaymentLinkId() != null
                    && !leader.getPaymentLinkId().isEmpty()) {
                new service.PayOSService().cancelPaymentLink(leader.getPaymentLinkId());
            }

            InvoiceDAO invoiceDAO = new InvoiceDAO();
            String invoicePayStatus = invoiceDAO.getPaymentStatus(invoiceId, cn);
            int customerId = getCustomerIdByInvoice(invoiceId, cn);
            Integer promoId = invoiceDAO.getPromotionId(invoiceId, cn);
            if (promoId != null && promoId > 0 && customerId > 0) {
                new PromotionDAO().restorePromotionUsage(promoId, customerId, cn);
            }
            if ("Paid".equalsIgnoreCase(invoicePayStatus) && leader != null) {
                PointTransactionDAO pointDAO = new PointTransactionDAO();
                pointDAO.reversePointsForInvoice(
                        leader.getCustomerID(), invoiceId, leader.getBookingID(), cn);
            }
            invoiceDAO.cancelInvoice(invoiceId, cn);

            String sql = "UPDATE Bookings SET Status = 'Cancelled', "
                    + "PaymentStatus = CASE WHEN PaymentStatus = 'Paid' THEN PaymentStatus ELSE 'Cancelled' END "
                    + "WHERE InvoiceID = ? AND Status NOT IN ('Cancelled', 'Completed')";
            PreparedStatement cancelSt = cn.prepareStatement(sql);
            cancelSt.setInt(1, invoiceId);
            int result = cancelSt.executeUpdate();
            if (result <= 0) {
                cn.rollback();
                return 0;
            }

            cn.commit();

            Set<Integer> slotIds = getTimeSlotIdsByInvoice(invoiceId);
            TimeSlotDAO slotDao = new TimeSlotDAO();
            for (int slotId : slotIds) {
                slotDao.syncSlotFullness(slotId);
            }
            return result;
        } catch (Exception e) {
            if (cn != null) {
                try {
                    cn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            e.printStackTrace();
            return 0;
        } finally {
            if (cn != null) {
                try {
                    cn.setAutoCommit(true);
                    cn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    public List<Booking> getBookingsByInvoiceId(int invoiceId) {
        List<Booking> list = new ArrayList<>();
        Connection cn = null;
        try {
            cn = DBUtils.getConnection();
            String sql = "SELECT b.BookingID, b.Status, b.PriceAtOrder, b.DurationAtOrder, b.Notes, "
                    + "v.LicensePlate, vb.BrandName + ' ' + vm.ModelName AS VehicleName, "
                    + "s.ServiceName, wb.BayName, t.TimeSlotID, t.StartTime, t.EndTime, t.IsFull "
                    + "FROM Bookings b "
                    + "JOIN Vehicles v ON v.VehicleID = b.VehicleID "
                    + "JOIN Services s ON s.ServiceID = b.ServiceID "
                    + "JOIN WashBays wb ON wb.WashBayID = b.WashBayID "
                    + "JOIN TimeSlots t ON b.TimeSlotID = t.TimeSlotID "
                    + "JOIN VehicleModels vm ON v.ModelID = vm.ModelID "
                    + "JOIN VehicleBrands vb ON vb.BrandID = vm.BrandID "
                    + "WHERE b.InvoiceID = ? "
                    + "ORDER BY b.BookingID";
            PreparedStatement st = cn.prepareStatement(sql);
            st.setInt(1, invoiceId);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                Booking booking = new Booking();
                booking.setBookingID(rs.getInt("BookingID"));
                booking.setStatus(rs.getString("Status"));
                booking.setPriceAtOrder(rs.getDouble("PriceAtOrder"));
                booking.setDurationAtOrder(rs.getInt("DurationAtOrder"));
                booking.setNotes(rs.getString("Notes"));
                booking.setLicensePlate(rs.getString("LicensePlate"));
                booking.setVehicleName(rs.getString("VehicleName"));
                booking.setService(rs.getString("ServiceName"));
                booking.setBayName(rs.getString("BayName"));
                booking.setInvoiceID(invoiceId);
                LocalDateTime startTime = rs.getTimestamp("StartTime").toLocalDateTime();
                LocalDateTime endTime = rs.getTimestamp("EndTime").toLocalDateTime();
                String timeSlotId = rs.getString("TimeSlotID");
                boolean isFull = rs.getBoolean("IsFull");
                booking.setTimeslot(new TimeSlot(timeSlotId, startTime, endTime, isFull));
                list.add(booking);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeQuietly(cn);
        }
        return list;
    }

    private List<Integer> getBookingIdsByInvoice(int invoiceId, Connection cn) throws SQLException {
        List<Integer> ids = new ArrayList<>();
        String sql = "SELECT BookingID FROM Bookings WHERE InvoiceID = ? ORDER BY BookingID";
        PreparedStatement st = cn.prepareStatement(sql);
        st.setInt(1, invoiceId);
        ResultSet rs = st.executeQuery();
        while (rs.next()) {
            ids.add(rs.getInt("BookingID"));
        }
        return ids;
    }

    private int getCustomerIdByInvoice(int invoiceId, Connection cn) throws SQLException {
        String sql = "SELECT CustomerID FROM Invoices WHERE InvoiceID = ?";
        PreparedStatement st = cn.prepareStatement(sql);
        st.setInt(1, invoiceId);
        ResultSet rs = st.executeQuery();
        if (rs.next()) {
            return rs.getInt("CustomerID");
        }
        return 0;
    }

    private Set<Integer> getTimeSlotIdsByInvoice(int invoiceId) {
        Set<Integer> slotIds = new HashSet<>();
        Connection cn = null;
        try {
            cn = DBUtils.getConnection();
            String sql = "SELECT DISTINCT TimeSlotID FROM Bookings WHERE InvoiceID = ?";
            PreparedStatement st = cn.prepareStatement(sql);
            st.setInt(1, invoiceId);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                slotIds.add(rs.getInt("TimeSlotID"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeQuietly(cn);
        }
        return slotIds;
    }

private Integer getTimeSlotIdByBooking(int bookingId) {
    Connection cn = null;
    try {
        cn = DBUtils.getConnection();
        String sql = "SELECT TimeSlotID FROM Bookings WHERE BookingID = ?";
        PreparedStatement st = cn.prepareStatement(sql);
        st.setInt(1, bookingId);

        ResultSet rs = st.executeQuery();
        if (rs.next()) {
            int slotId = rs.getInt("TimeSlotID");
            return rs.wasNull() ? null : slotId;
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
    return null;
}
}
