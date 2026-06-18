package dao;

import dbutils.DBUtils;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class InvoiceDAO {

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
