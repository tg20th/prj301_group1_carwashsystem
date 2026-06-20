package dao;

import dbutils.DBUtils;
import dto.Payment;
import dto.Revenue;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class RevenueDAO {

    public List<Revenue> getMonthlyRevenueByYear(int year) {
        List<Revenue> list = new ArrayList<>();
        Connection cn = null;
        try {
            cn = DBUtils.getConnection();
            String sql = "WITH Months AS ( "
                    + "    SELECT 1 AS Month UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 "
                    + "    UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 "
                    + "    UNION SELECT 9 UNION SELECT 10 UNION SELECT 11 UNION SELECT 12 "
                    + "), "
                    + "RevCTE AS ( "
                    + "    SELECT MONTH(InvoiceDate) AS Month, SUM(FinalAmount) AS Revenue "
                    + "    FROM Invoices WHERE PaymentStatus = 'Paid' AND YEAR(InvoiceDate) = ? "
                    + "    GROUP BY MONTH(InvoiceDate) "
                    + "), "
                    + "BkgCTE AS ( "
                    + "    SELECT MONTH(BookingDate) AS Month, COUNT(BookingID) AS BookingCount "
                    + "    FROM Bookings WHERE Status NOT IN ('Cancelled', 'NoShow') AND YEAR(BookingDate) = ? "
                    + "    GROUP BY MONTH(BookingDate) "
                    + ") "
                    + "SELECT M.Month, ISNULL(R.Revenue, 0) AS TotalRevenue, ISNULL(B.BookingCount, 0) AS TotalBookings "
                    + "FROM Months M "
                    + "LEFT JOIN RevCTE R ON M.Month = R.Month "
                    + "LEFT JOIN BkgCTE B ON M.Month = B.Month ORDER BY M.Month";

            PreparedStatement st = cn.prepareStatement(sql);
            st.setInt(1, year);
            st.setInt(2, year);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                Revenue v = new Revenue(rs.getInt("Month"), rs.getLong("TotalRevenue"), rs.getInt("TotalBookings"));
                list.add(v);
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

    public List<Payment> getPaymentStatsByYear(int year) {
        List<Payment> list = new ArrayList<>();
        Connection cn = null;
        try {
            cn = DBUtils.getConnection();
            String sql = "SELECT ISNULL(PaymentMethod, 'N/A') AS Method, SUM(FinalAmount) AS Total "
                    + "FROM Invoices WHERE PaymentStatus = 'Paid' AND YEAR(InvoiceDate) = ? "
                    + "GROUP BY ISNULL(PaymentMethod, 'N/A') ORDER BY Total DESC";
            PreparedStatement st = cn.prepareStatement(sql);
            st.setInt(1, year);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                list.add(new Payment(rs.getString("Method"), rs.getLong("Total")));
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

    public List<Integer> getAvailableYears() {
        List<Integer> years = new ArrayList<>();
        Connection cn = null;
        try {
            cn = DBUtils.getConnection();
            String sql = "SELECT DISTINCT YEAR(InvoiceDate) AS Year FROM Invoices WHERE InvoiceDate IS NOT NULL "
                    + "UNION SELECT DISTINCT YEAR(BookingDate) AS Year FROM Bookings WHERE BookingDate IS NOT NULL "
                    + "ORDER BY Year DESC";
            PreparedStatement st = cn.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                years.add(rs.getInt("Year"));
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
        return years;
    }

}
