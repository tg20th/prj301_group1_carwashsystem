package dao;

import dbutils.DBUtils;
import dto.Booking;
import dto.TimeSlotDTO;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;

public class TimeSlotDAO {

    private static final LocalTime OPEN_TIME = LocalTime.of(8, 0);
    private static final LocalTime CLOSE_TIME = LocalTime.of(20, 0);
    private static final int SLOT_MINUTES = 30;
    public static final int BOOKING_LEAD_MINUTES = 15;
    private static Boolean schemaReady = null;
    private String lastError = null;

    public String getLastError() {
        return lastError;
    }

    public String ensureSchema() {
        Connection cn = null;
        try {
            cn = DBUtils.getConnection();
            if (columnExists(cn, "SlotDate") && columnExists(cn, "IsFull")) {
                schemaReady = true;
                return null;
            }
            lastError = "TimeSlots schema is outdated. Re-run sql/AutoWashProDB.sql and sql/Data.sql";
            return lastError;
        } catch (Exception e) {
            e.printStackTrace();
            lastError = "Database schema check failed: " + e.getMessage();
            return lastError;
        } finally {
            closeConnection(cn);
        }
    }

    private void prepareSchema() {
        if (schemaReady == null || !schemaReady) {
            ensureSchema();
        }
    }

    public List<TimeSlotDTO> getAllSlotsByDate(LocalDate date) {
        return querySlotsByDate(date, false);
    }

    public List<TimeSlotDTO> getAvailableSlotsByDate(LocalDate date) {
        return querySlotsByDate(date, true);
    }

    public boolean isSlotBookable(TimeSlotDTO slot) {
        if (slot == null || slot.getStartTime() == null) {
            return false;
        }
        LocalDateTime earliestStart = LocalDateTime.now().plusMinutes(BOOKING_LEAD_MINUTES);
        return !slot.getStartTime().isBefore(earliestStart);
    }

    private List<TimeSlotDTO> querySlotsByDate(LocalDate date, boolean onlyAvailable) {
        List<TimeSlotDTO> list = new ArrayList<>();
        prepareSchema();
        Connection cn = null;
        try {
            cn = DBUtils.getConnection();
            String sql = "SELECT TimeSlotID, SlotDate, StartTime, EndTime, IsFull "
                    + "FROM TimeSlots WHERE SlotDate = ? "
                    + (onlyAvailable ? "AND IsFull = 0 " : "");
            if (onlyAvailable && LocalDate.now().equals(date)) {
                sql += "AND StartTime >= DATEADD(MINUTE, " + BOOKING_LEAD_MINUTES + ", GETDATE()) ";
            }
            sql += "ORDER BY StartTime";
            PreparedStatement st = cn.prepareStatement(sql);
            st.setDate(1, Date.valueOf(date));
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                TimeSlotDTO slot = mapRow(rs);
                enrichSlotCounts(slot, cn);
                if (!onlyAvailable || isSlotBookable(slot)) {
                    list.add(slot);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            lastError = e.getMessage();
        } finally {
            closeConnection(cn);
        }
        return list;
    }

    public TimeSlotDTO getSlotById(int slotId) {
        TimeSlotDTO slot = null;
        Connection cn = null;
        try {
            cn = DBUtils.getConnection();
            String sql = "SELECT TimeSlotID, SlotDate, StartTime, EndTime, IsFull "
                    + "FROM TimeSlots WHERE TimeSlotID = ?";
            PreparedStatement st = cn.prepareStatement(sql);
            st.setInt(1, slotId);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                slot = mapRow(rs);
                enrichSlotCounts(slot, cn);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeConnection(cn);
        }
        return slot;
    }

    public int countAvailableBaysInSlot(int slotId, Connection cn) throws Exception {
        String sql = "SELECT COUNT(*) AS Total FROM WashBays wb "
                + "WHERE wb.Status = 'Available' "
                + "AND NOT EXISTS ("
                + "  SELECT 1 FROM Bookings b "
                + "  WHERE b.WashBayID = wb.WashBayID "
                + "    AND b.TimeSlotID = ? "
                + "    AND b.Status NOT IN ('Cancelled', 'NoShow')"
                + ")";
        PreparedStatement st = cn.prepareStatement(sql);
        st.setInt(1, slotId);
        ResultSet rs = st.executeQuery();
        if (rs.next()) {
            return rs.getInt("Total");
        }
        return 0;
    }

    public int countBookedBaysInSlot(int slotId, Connection cn) throws Exception {
        String sql = "SELECT COUNT(DISTINCT b.WashBayID) AS Total "
                + "FROM Bookings b "
                + "JOIN WashBays wb ON wb.WashBayID = b.WashBayID "
                + "WHERE b.TimeSlotID = ? "
                + "AND wb.Status = 'Available' "
                + "AND b.Status NOT IN ('Cancelled', 'NoShow')";
        PreparedStatement st = cn.prepareStatement(sql);
        st.setInt(1, slotId);
        ResultSet rs = st.executeQuery();
        if (rs.next()) {
            return rs.getInt("Total");
        }
        return 0;
    }

    /** Số bay có thể nhận booking (Status = Available), không tính Maintenance/Unavailable. */
    public int countBookableWashBays(Connection cn) throws Exception {
        String sql = "SELECT COUNT(*) AS Total FROM WashBays WHERE Status = 'Available'";
        PreparedStatement st = cn.prepareStatement(sql);
        ResultSet rs = st.executeQuery();
        if (rs.next()) {
            return rs.getInt("Total");
        }
        return 0;
    }

    public void syncSlotFullness(int slotId) {
        Connection cn = null;
        try {
            cn = DBUtils.getConnection();
            syncSlotFullness(slotId, cn);
        } catch (Exception e) {
            e.printStackTrace();
            lastError = e.getMessage();
        } finally {
            closeConnection(cn);
        }
    }

    public void syncSlotFullness(int slotId, Connection cn) throws Exception {
        int remaining = countAvailableBaysInSlot(slotId, cn);
        String sql = "UPDATE TimeSlots SET IsFull = ? WHERE TimeSlotID = ?";
        PreparedStatement st = cn.prepareStatement(sql);
        st.setBoolean(1, remaining == 0);
        st.setInt(2, slotId);
        st.executeUpdate();
    }

    public int generateDefaultSlots(LocalDate date) {
        int created = 0;
        prepareSchema();
        Connection cn = null;
        try {
            cn = DBUtils.getConnection();
            LocalDateTime cursor = LocalDateTime.of(date, OPEN_TIME);
            LocalDateTime dayEnd = LocalDateTime.of(date, CLOSE_TIME);

            while (cursor.isBefore(dayEnd)) {
                LocalDateTime slotEnd = cursor.plusMinutes(SLOT_MINUTES);
                if (!hasOverlap(date, cursor, slotEnd, -1, cn)) {
                    String sql = "INSERT INTO TimeSlots (SlotDate, StartTime, EndTime, IsFull) "
                            + "VALUES (?, ?, ?, 0)";
                    PreparedStatement st = cn.prepareStatement(sql);
                    st.setDate(1, Date.valueOf(date));
                    st.setTimestamp(2, Timestamp.valueOf(cursor));
                    st.setTimestamp(3, Timestamp.valueOf(slotEnd));
                    created += st.executeUpdate();
                }
                cursor = slotEnd;
            }
        } catch (Exception e) {
            e.printStackTrace();
            lastError = e.getMessage();
        } finally {
            closeConnection(cn);
        }
        return created;
    }

    public int regenerateDefaultSlots(LocalDate date) {
        int result = 0;
        Connection cn = null;
        try {
            cn = DBUtils.getConnection();
            String deleteSql = "DELETE FROM TimeSlots WHERE SlotDate = ? AND IsFull = 0 "
                    + "AND NOT EXISTS ("
                    + "  SELECT 1 FROM Bookings b WHERE b.TimeSlotID = TimeSlots.TimeSlotID "
                    + "  AND b.Status NOT IN ('Cancelled', 'NoShow')"
                    + ")";
            PreparedStatement deleteSt = cn.prepareStatement(deleteSql);
            deleteSt.setDate(1, Date.valueOf(date));
            deleteSt.executeUpdate();
            result = generateDefaultSlots(date);
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeConnection(cn);
        }
        return result;
    }

    public int countSlotsByDate(LocalDate date) {
        int count = 0;
        prepareSchema();
        Connection cn = null;
        try {
            cn = DBUtils.getConnection();
            String sql = "SELECT COUNT(*) AS Total FROM TimeSlots WHERE SlotDate = ?";
            PreparedStatement st = cn.prepareStatement(sql);
            st.setDate(1, Date.valueOf(date));
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                count = rs.getInt("Total");
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeConnection(cn);
        }
        return count;
    }

    public List<Booking> getBookingsBySlotId(int slotId) {
        List<Booking> list = new ArrayList<>();
        Connection cn = null;
        try {
            cn = DBUtils.getConnection();
            String sql = "SELECT b.BookingID, b.Status, b.WashBayID, "
                    + "a.LastName + ' ' + a.FirstName AS FullName, "
                    + "v.LicensePlate, vb.BrandName + ' ' + vm.ModelName AS VehicleName, "
                    + "vt.TypeName, s.ServiceName, wb.BayName, t.StartTime, t.EndTime, t.IsFull "
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
                    + "WHERE b.TimeSlotID = ? AND b.Status NOT IN ('Cancelled', 'NoShow') "
                    + "ORDER BY wb.BayName";
            PreparedStatement st = cn.prepareStatement(sql);
            st.setInt(1, slotId);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                int bookingId = rs.getInt("BookingID");
                String status = rs.getString("Status");
                String customerName = rs.getString("FullName");
                String licensePlate = rs.getString("LicensePlate");
                String vehicleName = rs.getString("VehicleName");
                String vehicleType = rs.getString("TypeName");
                String service = rs.getString("ServiceName");
                LocalDateTime start = rs.getTimestamp("StartTime").toLocalDateTime();
                LocalDateTime end = rs.getTimestamp("EndTime").toLocalDateTime();
                boolean isFull = rs.getBoolean("IsFull");

                Booking booking = new Booking(bookingId, status, customerName, licensePlate, service,
                        new dto.TimeSlot(String.valueOf(slotId), start, end, isFull),
                        vehicleType, vehicleName);
                booking.setWashBayId(rs.getInt("WashBayID"));
                list.add(booking);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeConnection(cn);
        }
        return list;
    }

    public Booking getBookingBySlotId(int slotId) {
        List<Booking> bookings = getBookingsBySlotId(slotId);
        return bookings.isEmpty() ? null : bookings.get(0);
    }

    public int deleteSlot(int slotId) {
        int result = 0;
        Connection cn = null;
        try {
            TimeSlotDTO existing = getSlotById(slotId);
            if (existing == null) {
                return 0;
            }
            if (existing.getBookedCount() > 0) {
                return -2;
            }
            cn = DBUtils.getConnection();
            String sql = "DELETE FROM TimeSlots WHERE TimeSlotID = ?";
            PreparedStatement st = cn.prepareStatement(sql);
            st.setInt(1, slotId);
            result = st.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeConnection(cn);
        }
        return result;
    }

    private void enrichSlotCounts(TimeSlotDTO slot, Connection cn) throws Exception {
        int bookableBays = countBookableWashBays(cn);
        int booked = countBookedBaysInSlot(slot.getSlotId(), cn);
        int free = countAvailableBaysInSlot(slot.getSlotId(), cn);
        slot.setTotalBayCount(bookableBays);
        slot.setBookedCount(booked);
        slot.setAvailableBayCount(free);
        slot.setFull(bookableBays > 0 && free == 0);
    }

    private boolean hasOverlap(LocalDate date, LocalDateTime start, LocalDateTime end,
            int excludeSlotId, Connection cn) throws Exception {
        String sql = "SELECT COUNT(*) AS Total FROM TimeSlots "
                + "WHERE SlotDate = ? AND TimeSlotID <> ? "
                + "AND StartTime < ? AND EndTime > ?";
        PreparedStatement st = cn.prepareStatement(sql);
        st.setDate(1, Date.valueOf(date));
        st.setInt(2, excludeSlotId < 0 ? 0 : excludeSlotId);
        st.setTimestamp(3, Timestamp.valueOf(end));
        st.setTimestamp(4, Timestamp.valueOf(start));
        ResultSet rs = st.executeQuery();
        if (rs.next()) {
            return rs.getInt("Total") > 0;
        }
        return false;
    }

    private TimeSlotDTO mapRow(ResultSet rs) throws Exception {
        return new TimeSlotDTO(
                rs.getInt("TimeSlotID"),
                rs.getDate("SlotDate").toLocalDate(),
                rs.getTimestamp("StartTime").toLocalDateTime(),
                rs.getTimestamp("EndTime").toLocalDateTime(),
                rs.getBoolean("IsFull")
        );
    }

    private boolean columnExists(Connection cn, String columnName) throws Exception {
        String sql = "SELECT COUNT(*) AS Total FROM INFORMATION_SCHEMA.COLUMNS "
                + "WHERE TABLE_NAME = 'TimeSlots' AND COLUMN_NAME = ?";
        PreparedStatement st = cn.prepareStatement(sql);
        st.setString(1, columnName);
        ResultSet rs = st.executeQuery();
        if (rs.next()) {
            return rs.getInt("Total") > 0;
        }
        return false;
    }

    private void closeConnection(Connection cn) {
        try {
            if (cn != null) {
                cn.close();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}