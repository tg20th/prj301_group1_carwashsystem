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
    private static Boolean schemaReady = null;
    private String lastError = null;

    public String getLastError() {
        return lastError;
    }

    public String ensureSchema() {
        Connection cn = null;
        try {
            cn = DBUtils.getConnection();
            if (columnExists(cn, "SlotDate") && columnExists(cn, "Status")) {
                schemaReady = true;
                return null;
            }
            if (!columnExists(cn, "IsAvailable")) {
                lastError = "TimeSlots table is missing required columns. Run sql/migration_timeslots_status.sql";
                return lastError;
            }
            executeUpdate(cn, "ALTER TABLE TimeSlots ADD SlotDate DATE NULL");
            executeUpdate(cn, "ALTER TABLE TimeSlots ADD Status VARCHAR(20) NULL");
            if (!columnExists(cn, "MaintenanceNote")) {
                executeUpdate(cn, "ALTER TABLE TimeSlots ADD MaintenanceNote NVARCHAR(500) NULL");
            }
            executeUpdate(cn,
                    "UPDATE TimeSlots SET SlotDate = CAST(StartTime AS DATE), "
                    + "Status = CASE WHEN IsAvailable = 1 THEN 'AVAILABLE' ELSE 'UNAVAILABLE' END "
                    + "WHERE SlotDate IS NULL OR Status IS NULL");
            executeUpdate(cn, "ALTER TABLE TimeSlots ALTER COLUMN SlotDate DATE NOT NULL");
            executeUpdate(cn, "ALTER TABLE TimeSlots ALTER COLUMN Status VARCHAR(20) NOT NULL");
            if (!constraintExists(cn, "CK_TimeSlots_Status")) {
                executeUpdate(cn,
                        "ALTER TABLE TimeSlots ADD CONSTRAINT CK_TimeSlots_Status "
                        + "CHECK (Status IN ('AVAILABLE', 'UNAVAILABLE', 'MAINTENANCE'))");
            }
            dropDefaultConstraint(cn, "IsAvailable");
            if (columnExists(cn, "IsAvailable")) {
                executeUpdate(cn, "ALTER TABLE TimeSlots DROP COLUMN IsAvailable");
            }
            schemaReady = true;
            return null;
        } catch (Exception e) {
            e.printStackTrace();
            lastError = "Database schema migration failed: " + e.getMessage();
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
        List<TimeSlotDTO> list = new ArrayList<>();
        prepareSchema();
        Connection cn = null;
        try {
            cn = DBUtils.getConnection();
            String sql = "SELECT TimeSlotID, SlotDate, StartTime, EndTime, Status, MaintenanceNote "
                    + "FROM TimeSlots WHERE SlotDate = ? ORDER BY StartTime";
            PreparedStatement st = cn.prepareStatement(sql);
            st.setDate(1, Date.valueOf(date));
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                list.add(mapRow(rs));
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
            String sql = "SELECT TimeSlotID, SlotDate, StartTime, EndTime, Status, MaintenanceNote "
                    + "FROM TimeSlots WHERE TimeSlotID = ?";
            PreparedStatement st = cn.prepareStatement(sql);
            st.setInt(1, slotId);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                slot = mapRow(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeConnection(cn);
        }
        return slot;
    }

    public int createSlot(TimeSlotDTO slot) {
        int result = 0;
        Connection cn = null;
        try {
            if (!validateSlot(slot, -1)) {
                return -1;
            }
            cn = DBUtils.getConnection();
            String sql = "INSERT INTO TimeSlots (SlotDate, StartTime, EndTime, Status, MaintenanceNote) "
                    + "VALUES (?, ?, ?, ?, ?)";
            PreparedStatement st = cn.prepareStatement(sql);
            st.setDate(1, Date.valueOf(slot.getSlotDate()));
            st.setTimestamp(2, Timestamp.valueOf(slot.getStartTime()));
            st.setTimestamp(3, Timestamp.valueOf(slot.getEndTime()));
            st.setString(4, slot.getStatus());
            st.setString(5, slot.getMaintenanceNote());
            result = st.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeConnection(cn);
        }
        return result;
    }

    public int updateSlot(TimeSlotDTO slot) {
        int result = 0;
        Connection cn = null;
        try {
            if (!validateSlot(slot, slot.getSlotId())) {
                return -1;
            }
            cn = DBUtils.getConnection();
            String sql = "UPDATE TimeSlots SET SlotDate = ?, StartTime = ?, EndTime = ?, "
                    + "Status = ?, MaintenanceNote = ? WHERE TimeSlotID = ?";
            PreparedStatement st = cn.prepareStatement(sql);
            st.setDate(1, Date.valueOf(slot.getSlotDate()));
            st.setTimestamp(2, Timestamp.valueOf(slot.getStartTime()));
            st.setTimestamp(3, Timestamp.valueOf(slot.getEndTime()));
            st.setString(4, slot.getStatus());
            st.setString(5, slot.getMaintenanceNote());
            st.setInt(6, slot.getSlotId());
            result = st.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeConnection(cn);
        }
        return result;
    }

    public int deleteSlot(int slotId) {
        int result = 0;
        Connection cn = null;
        try {
            TimeSlotDTO existing = getSlotById(slotId);
            if (existing == null) {
                return 0;
            }
            if (TimeSlotDTO.UNAVAILABLE.equals(existing.getStatus())) {
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
                    String sql = "INSERT INTO TimeSlots (SlotDate, StartTime, EndTime, Status) "
                            + "VALUES (?, ?, ?, ?)";
                    PreparedStatement st = cn.prepareStatement(sql);
                    st.setDate(1, Date.valueOf(date));
                    st.setTimestamp(2, Timestamp.valueOf(cursor));
                    st.setTimestamp(3, Timestamp.valueOf(slotEnd));
                    st.setString(4, TimeSlotDTO.AVAILABLE);
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
            String deleteSql = "DELETE FROM TimeSlots WHERE SlotDate = ? AND Status = ?";
            PreparedStatement deleteSt = cn.prepareStatement(deleteSql);
            deleteSt.setDate(1, Date.valueOf(date));
            deleteSt.setString(2, TimeSlotDTO.AVAILABLE);
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

    public Booking getBookingBySlotId(int slotId) {
        Booking booking = null;
        Connection cn = null;
        try {
            cn = DBUtils.getConnection();
            String sql = "SELECT b.BookingID, b.Status, b.BookingDate, "
                    + "a.LastName + ' ' + a.FirstName AS FullName, "
                    + "v.LicensePlate, vb.BrandName + ' ' + vm.ModelName AS VehicleName, "
                    + "vt.TypeName, s.ServiceName, t.StartTime, t.EndTime "
                    + "FROM Bookings b "
                    + "JOIN TimeSlots t ON b.TimeSlotID = t.TimeSlotID "
                    + "JOIN Customers c ON c.CustomerID = b.CustomerID "
                    + "JOIN Accounts a ON a.AccountID = c.AccountID "
                    + "JOIN Vehicles v ON v.VehicleID = b.VehicleID "
                    + "JOIN Services s ON s.ServiceID = b.ServiceID "
                    + "JOIN VehicleModels vm ON v.ModelID = vm.ModelID "
                    + "JOIN VehicleBrands vb ON vb.BrandID = vm.BrandID "
                    + "JOIN VehicleTypes vt ON vt.VehicleTypeID = vm.VehicleTypeID "
                    + "WHERE b.TimeSlotID = ? AND b.Status NOT IN ('Cancelled', 'NoShow')";
            PreparedStatement st = cn.prepareStatement(sql);
            st.setInt(1, slotId);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                int bookingId = rs.getInt("BookingID");
                String status = rs.getString("Status");
                String customerName = rs.getString("FullName");
                String licensePlate = rs.getString("LicensePlate");
                String vehicleName = rs.getString("VehicleName");
                String vehicleType = rs.getString("TypeName");
                String service = rs.getString("ServiceName");
                LocalDateTime start = rs.getTimestamp("StartTime").toLocalDateTime();
                LocalDateTime end = rs.getTimestamp("EndTime").toLocalDateTime();

                booking = new Booking(bookingId, status, customerName, licensePlate, service,
                        new dto.TimeSlot(String.valueOf(slotId), start, end, TimeSlotDTO.UNAVAILABLE),
                        vehicleType, vehicleName);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeConnection(cn);
        }
        return booking;
    }

    public int updateSlotStatus(int slotId, String status) {
        int result = 0;
        Connection cn = null;
        try {
            cn = DBUtils.getConnection();
            String sql = "UPDATE TimeSlots SET Status = ? WHERE TimeSlotID = ?";
            PreparedStatement st = cn.prepareStatement(sql);
            st.setString(1, status);
            st.setInt(2, slotId);
            result = st.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeConnection(cn);
        }
        return result;
    }

    public int markSlotAsMaintenance(int slotId, String note) {
        TimeSlotDTO slot = getSlotById(slotId);
        if (slot == null) {
            lastError = "Time slot not found.";
            return 0;
        }
        if (TimeSlotDTO.UNAVAILABLE.equals(slot.getStatus())) {
            lastError = "Cannot change status. This slot is already booked.";
            return -2;
        }
        if (note == null || note.trim().isEmpty()) {
            lastError = "Maintenance reason is required.";
            return -3;
        }
        return updateMaintenanceNote(slotId, note.trim());
    }

    public int restoreSlotToAvailable(int slotId) {
        TimeSlotDTO slot = getSlotById(slotId);
        if (slot == null) {
            lastError = "Time slot not found.";
            return 0;
        }
        if (TimeSlotDTO.UNAVAILABLE.equals(slot.getStatus())) {
            lastError = "Cannot restore. This slot is already booked.";
            return -2;
        }
        if (!TimeSlotDTO.MAINTENANCE.equals(slot.getStatus())) {
            lastError = "Only maintenance slots can be restored to available.";
            return -4;
        }

        int result = 0;
        Connection cn = null;
        try {
            cn = DBUtils.getConnection();
            String sql = "UPDATE TimeSlots SET Status = ?, MaintenanceNote = NULL WHERE TimeSlotID = ?";
            PreparedStatement st = cn.prepareStatement(sql);
            st.setString(1, TimeSlotDTO.AVAILABLE);
            st.setInt(2, slotId);
            result = st.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
            lastError = e.getMessage();
        } finally {
            closeConnection(cn);
        }
        return result;
    }

    public int updateMaintenanceNote(int slotId, String note) {
        int result = 0;
        Connection cn = null;
        try {
            cn = DBUtils.getConnection();
            String sql = "UPDATE TimeSlots SET MaintenanceNote = ?, Status = ? WHERE TimeSlotID = ?";
            PreparedStatement st = cn.prepareStatement(sql);
            st.setString(1, note);
            st.setString(2, TimeSlotDTO.MAINTENANCE);
            st.setInt(3, slotId);
            result = st.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
            lastError = e.getMessage();
        } finally {
            closeConnection(cn);
        }
        return result;
    }

    public boolean validateSlot(TimeSlotDTO slot, int excludeSlotId) {
        if (slot.getSlotDate() == null) {
            return false;
        }
        if (slot.getStartTime() == null || slot.getEndTime() == null) {
            return false;
        }
        if (!slot.getEndTime().isAfter(slot.getStartTime())) {
            return false;
        }
        if (slot.getStatus() == null || slot.getStatus().trim().isEmpty()) {
            return false;
        }
        if (!isValidStatus(slot.getStatus())) {
            return false;
        }
        Connection cn = null;
        try {
            cn = DBUtils.getConnection();
            return !hasOverlap(slot.getSlotDate(), slot.getStartTime(), slot.getEndTime(), excludeSlotId, cn);
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        } finally {
            closeConnection(cn);
        }
    }

    public String getValidationError(TimeSlotDTO slot, int excludeSlotId) {
        if (slot.getSlotDate() == null) {
            return "Date is required.";
        }
        if (slot.getStartTime() == null || slot.getEndTime() == null) {
            return "Start time and end time are required.";
        }
        if (!slot.getEndTime().isAfter(slot.getStartTime())) {
            return "End time must be greater than start time.";
        }
        if (slot.getStatus() == null || slot.getStatus().trim().isEmpty()) {
            return "Status is required.";
        }
        if (!isValidStatus(slot.getStatus())) {
            return "Invalid status. Allowed: AVAILABLE, UNAVAILABLE, MAINTENANCE.";
        }
        Connection cn = null;
        try {
            cn = DBUtils.getConnection();
            if (hasOverlap(slot.getSlotDate(), slot.getStartTime(), slot.getEndTime(), excludeSlotId, cn)) {
                return "This time slot overlaps with an existing slot.";
            }
        } catch (Exception e) {
            e.printStackTrace();
            return "Validation error: " + e.getMessage();
        } finally {
            closeConnection(cn);
        }
        return null;
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

    private boolean isValidStatus(String status) {
        return TimeSlotDTO.AVAILABLE.equals(status)
                || TimeSlotDTO.UNAVAILABLE.equals(status)
                || TimeSlotDTO.MAINTENANCE.equals(status);
    }

    private TimeSlotDTO mapRow(ResultSet rs) throws Exception {
        return new TimeSlotDTO(
                rs.getInt("TimeSlotID"),
                rs.getDate("SlotDate").toLocalDate(),
                rs.getTimestamp("StartTime").toLocalDateTime(),
                rs.getTimestamp("EndTime").toLocalDateTime(),
                rs.getString("Status"),
                rs.getString("MaintenanceNote")
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

    private boolean constraintExists(Connection cn, String constraintName) throws Exception {
        String sql = "SELECT COUNT(*) AS Total FROM sys.check_constraints WHERE name = ?";
        PreparedStatement st = cn.prepareStatement(sql);
        st.setString(1, constraintName);
        ResultSet rs = st.executeQuery();
        if (rs.next()) {
            return rs.getInt("Total") > 0;
        }
        return false;
    }

    private void executeUpdate(Connection cn, String sql) throws Exception {
        PreparedStatement st = cn.prepareStatement(sql);
        st.executeUpdate();
    }

    private void dropDefaultConstraint(Connection cn, String columnName) throws Exception {
        String sql = "SELECT dc.name FROM sys.default_constraints dc "
                + "JOIN sys.columns c ON dc.parent_object_id = c.object_id AND dc.parent_column_id = c.column_id "
                + "WHERE dc.parent_object_id = OBJECT_ID('TimeSlots') AND c.name = ?";
        PreparedStatement st = cn.prepareStatement(sql);
        st.setString(1, columnName);
        ResultSet rs = st.executeQuery();
        if (rs.next()) {
            String constraintName = rs.getString("name");
            executeUpdate(cn, "ALTER TABLE TimeSlots DROP CONSTRAINT " + constraintName);
        }
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