package dao;

import dbutils.DBUtils;
import dto.Booking;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

public class BookingDAO {

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
