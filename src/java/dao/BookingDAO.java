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
            String sql = "UPDATE Bookings SET Status = ? WHERE BookingID = ?";

            PreparedStatement st = cn.prepareStatement(sql);
            st.setString(1, status);
            st.setInt(2, id);

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
        Integer slotId = getTimeSlotIdByBooking(bookingId);
        int result = updateStatusOfBooking(bookingId, "Cancelled");
        if (result > 0 && slotId != null) {
            new TimeSlotDAO().syncSlotFullness(slotId);
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
}