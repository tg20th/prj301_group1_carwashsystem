package dao;

import dbutils.DBUtils;
import dto.Customer;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class CustomerDAO {

    public int createCustomer(Customer c) {
        int result = 0;
        Connection cn = null;
        try {
            cn = DBUtils.getConnection();
            String sql = "insert into Customers([AccountID], [TierID], [JoinedAt]) \n"
                    + "values(?,?,?)";
            PreparedStatement st = cn.prepareStatement(sql);
            st.setInt(1, c.getAccID());
            st.setInt(2, 1);
            st.setDate(3, c.getJoinedAt());

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

    public Customer getCustomerByAccountID(int accountID) {
        String sql = "SELECT * FROM Customers WHERE AccountID = ?";

        try (
                 Connection conn = DBUtils.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, accountID);

            try ( ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Customer customer = new Customer();

                    customer.setCusID(rs.getInt("CustomerID"));
                    customer.setAccID(rs.getInt("AccountID"));
                    customer.setTierID(rs.getInt("TierID"));
                    customer.setJoinedAt(rs.getDate("JoinedAt"));
                    customer.setTotalPoint(rs.getInt("TotalPoints"));

                    return customer;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    public int getPointBalance(int accountId) {
        int pointBalance = 0;
        Connection cn = null;
        try {
            cn = DBUtils.getConnection();
            String sql = "SELECT [TotalPoints]\n"
                    + "FROM [dbo].[Customers]\n"
                    + "WHERE [AccountID] = ?";

            PreparedStatement st = cn.prepareStatement(sql);
            st.setInt(1, accountId);
            ResultSet table = st.executeQuery();

            if (table.next()) {
                pointBalance = (Integer) table.getInt("TotalPoints");
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
        return pointBalance;
    }
}
