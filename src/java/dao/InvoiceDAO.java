package dao;

import dbutils.DBUtils;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class InvoiceDAO {

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
