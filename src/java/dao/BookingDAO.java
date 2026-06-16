package dao;

import dbutils.DBUtils;
import dto.Booking;
import dto.TimeSlot;
import dto.TimeSlotDTO;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class BookingDAO {

    public int createBooking(Booking b) {
        if (b.getTimeSlotID() != null) {
            TimeSlotDAO slotDao = new TimeSlotDAO();
            TimeSlotDTO slot = slotDao.getSlotById(b.getTimeSlotID());
            if (slot == null) {
                return -1;
            }
            if (!TimeSlotDTO.AVAILABLE.equals(slot.getStatus())) {
                return -2;
            }
        }

        String sql = "INSERT INTO Bookings "
                + "(BookingID, CustomerID, VehicleID, ServiceID, "
                + "WashBayID, TimeSlotID, InvoiceID, Quantity, PriceAtOrder, "
                + "DurationAtOrder, BookingDate, AppointmentTime, "
                + "Status, Notes) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try ( Connection cn = DBUtils.getConnection();  PreparedStatement st = cn.prepareStatement(sql)) {

            st.setInt(1, b.getBookingID());
            st.setInt(2, b.getCustomerID());
            st.setInt(3, b.getVehicleID());
            st.setInt(4, b.getServiceID());
            st.setInt(5, b.getWashBayId());
            if (b.getTimeSlotID() != null) {
                st.setInt(6, b.getTimeSlotID());
            } else {
                st.setNull(6, java.sql.Types.INTEGER);
            }
            st.setInt(7, b.getInvoiceID());
            st.setInt(8, b.getQuantity());
            st.setDouble(9, b.getPriceAtOrder());
            st.setInt(10, b.getDurationAtOrder());
            st.setDate(11, b.getBookingDate());
            st.setTimestamp(12, Timestamp.valueOf(b.getAppointmentTime()));
            st.setString(13, b.getStatus());
            st.setString(14, b.getNotes());

            int result = st.executeUpdate();

            if (result > 0 && b.getTimeSlotID() != null
                    && ("Confirmed".equalsIgnoreCase(b.getStatus()) || "Pending".equalsIgnoreCase(b.getStatus()))) {
                new TimeSlotDAO().updateSlotStatus(b.getTimeSlotID(), TimeSlotDTO.UNAVAILABLE);
            }

            return result;

        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
            return 0;
        }
    }

    public List<Booking> getAllBookToday() {
        List<Booking> list = new ArrayList<>();
        Connection cn = null;

        try {
            cn = DBUtils.getConnection();
            String sql = "SELECT b.BookingID, a.LastName + ' ' + a.FirstName AS FullName, \n"
                    + "v.LicensePlate, vb.BrandName + ' ' + vm.ModelName AS VehicleName,\n"
                    + "vt.TypeName, s.ServiceName, t.TimeSlotID, t.StartTime, t.EndTime, b.Status\n"
                    + "FROM Bookings b JOIN TimeSlots t \n"
                    + "ON b.TimeSlotID = t.TimeSlotID\n"
                    + "JOIN Customers c ON c.CustomerID = b.CustomerID\n"
                    + "JOIN Accounts a ON a.AccountID = c.AccountID\n"
                    + "JOIN Vehicles v ON v.VehicleID = b.VehicleID\n"
                    + "JOIN Services s ON s.ServiceID = b.ServiceID\n"
                    + "JOIN VehicleModels vm ON v.ModelID = vm.ModelID\n"
                    + "JOIN VehicleBrands vb ON vb.BrandID = vm.BrandID\n"
                    + "JOIN VehicleTypes vt ON vt.VehicleTypeID = vm.VehicleTypeID\n"
                    + "WHERE t.Status = 'UNAVAILABLE' AND\n"
                    + "t.SlotDate = CAST(GETDATE() AS DATE)";

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

                TimeSlot t = new TimeSlot(timeSlotID, startTime, endTime, TimeSlotDTO.UNAVAILABLE);
                Booking b = new Booking(id, status, name, licensePlate, service, t, typeName, vehicleName);

                list.add(b);

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
        int result = updateStatusOfBooking(bookingId, "Confirmed");
        if (result > 0) {
            Integer slotId = getTimeSlotIdByBooking(bookingId);
            if (slotId != null) {
                new TimeSlotDAO().updateSlotStatus(slotId, TimeSlotDTO.UNAVAILABLE);
            }
        }
        return result;
    }

    public int cancelBooking(int bookingId) {
        int result = updateStatusOfBooking(bookingId, "Cancelled");
        if (result > 0) {
            Integer slotId = getTimeSlotIdByBooking(bookingId);
            if (slotId != null) {
                new TimeSlotDAO().updateSlotStatus(slotId, TimeSlotDTO.AVAILABLE);
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

}
