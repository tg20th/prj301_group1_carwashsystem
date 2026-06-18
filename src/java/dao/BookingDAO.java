package dao;

import dbutils.DBUtils;
import dto.Booking;
import dto.TimeSlot;
import dto.TimeSlotDTO;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class BookingDAO {

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
                    + "WHERE t.SlotDate = CAST(GETDATE() AS DATE) "
                    + "AND b.Status NOT IN ('Cancelled', 'NoShow') "
                    + "ORDER BY t.StartTime, wb.BayName";

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
     * Checkout + payment: create invoice, award loyalty points (1,000 VND = 1 point).
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

    public List<Booking> getBookingsByCustomerId(int customerId) {
        List<Booking> list = new ArrayList<>();
        Connection cn = null;

        try {
            cn = DBUtils.getConnection();
            String sql = "SELECT b.BookingID, b.Status, b.PriceAtOrder, b.DurationAtOrder, b.Notes, "
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
