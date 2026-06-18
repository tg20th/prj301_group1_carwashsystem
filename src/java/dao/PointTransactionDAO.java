package dao;

import dbutils.DBUtils;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class PointTransactionDAO {

    public static final int VND_PER_POINT = 1000;

    public int calculatePointsFromAmount(long amountVnd) {
        if (amountVnd <= 0) {
            return 0;
        }
        return (int) (amountVnd / VND_PER_POINT);
    }

    public int insertTransaction(int customerId, Integer invoiceId, int pointChange,
            String transactionType, String note, Connection cn) throws SQLException {
        String sql = "INSERT INTO PointTransactions "
                + "(CustomerID, InvoiceID, PointChange, TransactionType, Note) "
                + "VALUES (?, ?, ?, ?, ?)";
        PreparedStatement st = cn.prepareStatement(sql);
        st.setInt(1, customerId);
        if (invoiceId != null && invoiceId > 0) {
            st.setInt(2, invoiceId);
        } else {
            st.setNull(2, java.sql.Types.INTEGER);
        }
        st.setInt(3, pointChange);
        st.setString(4, transactionType);
        st.setString(5, note);
        return st.executeUpdate();
    }

    public int earnPointsForPayment(int customerId, int invoiceId, long finalAmount,
            int bookingId, Connection cn) throws SQLException {
        int points = calculatePointsFromAmount(finalAmount);
        if (points <= 0) {
            return 0;
        }
        insertTransaction(customerId, invoiceId, points, "Earn",
                "Payment for booking #" + bookingId + " (" + finalAmount + " VND)", cn);
        return points;
    }

    public int reversePointsForInvoice(int customerId, int invoiceId, int bookingId, Connection cn)
            throws SQLException {
        int netPoints = getNetPointsByInvoice(invoiceId, cn);
        if (netPoints <= 0) {
            return 0;
        }
        insertTransaction(customerId, invoiceId, -netPoints, "Adjust",
                "Reversed points for cancelled booking #" + bookingId, cn);
        return netPoints;
    }

    public int getNetPointsByInvoice(int invoiceId, Connection cn) throws SQLException {
        String sql = "SELECT ISNULL(SUM(PointChange), 0) AS NetPoints "
                + "FROM PointTransactions WHERE InvoiceID = ?";
        PreparedStatement st = cn.prepareStatement(sql);
        st.setInt(1, invoiceId);
        ResultSet rs = st.executeQuery();
        if (rs.next()) {
            return rs.getInt("NetPoints");
        }
        return 0;
    }

    public int getNetPointsByInvoice(int invoiceId) {
        Connection cn = null;
        try {
            cn = DBUtils.getConnection();
            return getNetPointsByInvoice(invoiceId, cn);
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        } finally {
            closeQuietly(cn);
        }
    }

    private void closeQuietly(Connection cn) {
        if (cn != null) {
            try {
                cn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}