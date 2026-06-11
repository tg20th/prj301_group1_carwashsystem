package dao;

import dbutils.DBUtils;
import dto.Booking;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class BookingDAO {

    public int createBooking(Booking b) {
        String sql = "INSERT INTO Bookings "
                + "(BookingID, CustomerID, VehicleID, ServiceID, "
                + "WashBayID, TimeSlotID, InvoiceID, Quantity, PriceAtOrder, "
                + "DurationAtOrder, BookingDate, AppointmentTime, "
                + "Status, Notes) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try ( Connection cn = DBUtils.getConnection();  PreparedStatement st = cn.prepareStatement(sql)) {

            st.setInt(1, b.getId());
            st.setInt(2, b.getCustomerID());
            st.setInt(3, b.getVehicleID());
            st.setInt(4, b.getServiceID());
            st.setInt(5, b.getWashBayId());
            st.setInt(7, b.getInvoiceID());
            st.setInt(8, b.getQuantity());
            st.setDouble(9, b.getPriceAtOrder());
            st.setInt(10, b.getDurationAtOrder());
            st.setDate(11, b.getBookingDate());
            st.setTimestamp(12, Timestamp.valueOf(b.getAppointmentTime()));
            st.setString(13, b.getStatus());
            st.setString(14, b.getNotes());

            return st.executeUpdate();

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
            String sql = "SELECT b.BookingID, a.FirstName + ' ' + a.LastName AS FullName, \n"
                    + "v.LicensePlate, s.ServiceName, b.AppointmentTime,b.Status, b. BookingDate\n"
                    + "FROM [dbo].[Bookings] b\n"
                    + "JOIN [dbo].[Customers] c ON b.[CustomerID] = c.CustomerID\n"
                    + "JOIN Vehicles v ON v.VehicleID = b.VehicleID\n"
                    + "JOIN BookingDetails bd ON bd.BookingID = b.BookingID\n"
                    + "JOIN Services s ON s.ServiceID = bd.ServiceID\n"
                    + "JOIN Accounts a ON c.AccountID = a.AccountID\n"
                    + "WHERE b.BookingDate >= CAST(GETDATE() AS DATE)\n"
                    + "AND b.BookingDate < DATEADD(DAY, 1, CAST(GETDATE() AS DATE))";

            PreparedStatement st = cn.prepareStatement(sql);
            ResultSet table = st.executeQuery();

            while (table.next()) {
                int id = table.getInt("BookingID");
                String name = table.getString("FullName");
                String licensePlate = table.getString("LicensePlate");
                String service = table.getString("ServiceName");
                LocalDateTime appointmentTime
                        = table.getTimestamp("AppointmentTime").toLocalDateTime();
                Date bookingDate = table.getDate("BookingDate");
                String status = table.getString("Status");

                Booking b = new Booking(id, name, licensePlate, service, bookingDate, appointmentTime, status);

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
}
