package dao;

import java.sql.*;
import java.util.*;
import dbutils.DBUtils;
import dto.Promotion;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class PromotionDAO {

    public List<Promotion> getAllPromotionActive() {
        List<Promotion> list = new ArrayList<>();
        Connection cn = null;

        try {
            cn = DBUtils.getConnection();
            String sql = "SELECT PromotionName, EndDate, Description "
                    + "FROM Promotions "
                    + "WHERE IsActive = 1 "
                    + "ORDER BY EndDate ASC";

            PreparedStatement st = cn.prepareStatement(sql);
            ResultSet table = st.executeQuery();

            while (table.next()) {
                String name = table.getString("PromotionName");
                Date endDate = table.getDate("EndDate");
                String descrip = table.getString("Description");

                Promotion p = new Promotion(name, endDate, descrip);
                list.add(p);

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

    public List<Promotion> getApplicablePromotions(int customerID, int tierID) {
        List<Promotion> list = new ArrayList<>();

        String sql = "SELECT DISTINCT p.PromotionID, p.PromotionName, p.Description, "
                + "ISNULL(p.DiscountPercent, 0) AS DiscountPercent, "
                + "ISNULL(p.DiscountAmount, 0) AS DiscountAmount, "
                + "p.StartDate, p.EndDate "
                + "FROM Promotions p "
                + "LEFT JOIN PromotionTiers pt ON p.PromotionID = pt.PromotionID "
                + "LEFT JOIN PromotionCustomers pc ON p.PromotionID = pc.PromotionID "
                + "WHERE p.IsActive = 1 "
                + "AND GETDATE() BETWEEN p.StartDate AND p.EndDate "
                + "AND (p.TargetType = 'All' "
                + "     OR (p.TargetType = 'Tier' AND pt.TierID = ?) "
                + "     OR (p.TargetType = 'Customer' AND pc.CustomerID = ?))";
        try ( Connection con = DBUtils.getConnection();  PreparedStatement st = con.prepareStatement(sql)) {
            st.setInt(1, tierID);
            st.setInt(2, customerID);
            try ( ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    Promotion p = new Promotion();
                    p.setPromotionID(rs.getInt("PromotionID"));
                    p.setPromotionName(rs.getString("PromotionName"));
                    p.setDescription(rs.getString("Description"));
                    p.setDiscountPercent(rs.getInt("DiscountPercent"));
                    p.setDiscountAmount(rs.getDouble("DiscountAmount"));
                    p.setStartDate(rs.getDate("StartDate"));
                    p.setEndDate(rs.getDate("EndDate"));
                    list.add(p);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Promotion> getAllPromotion(String status, String search, String targetType, int page, int pageSize) {
        List<Promotion> list = new ArrayList<>();
        Connection cn = null;

        try {
            cn = DBUtils.getConnection();
            String sql = "SELECT PromotionID, PromoCode, PromotionName, TargetType, "
                    + "DiscountPercent, StartDate, EndDate, Description, IsActive "
                    + "FROM Promotions WHERE 1=1";

            // STATUS
            if (!"ALL".equalsIgnoreCase(status)) {
                sql += " AND IsActive = ? ";
            }

            // TARGET TYPE
            if (targetType != null && !"ALL".equals(targetType)) {
                sql += " AND TargetType = ? ";
            }

            // SEARCH
            if (search != null && !search.trim().isEmpty()) {
                sql += " AND (PromoCode LIKE ? OR PromotionName LIKE ?) ";
            }

            sql += " ORDER BY PromotionID DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

            PreparedStatement st = cn.prepareStatement(sql);
            int index = 1;

            // Set parameters
            if (!"ALL".equalsIgnoreCase(status)) {
                st.setBoolean(index++, "1".equals(status));
            }

            if (targetType != null && !targetType.equals("ALL")) {
                st.setString(index++, targetType);
            }

            if (search != null && !search.trim().isEmpty()) {
                String keyword = "%" + search.trim() + "%";
                st.setString(index++, keyword);
                st.setString(index++, keyword);
            }

            st.setInt(index++, (page - 1) * pageSize);
            st.setInt(index++, pageSize);

            ResultSet rs = st.executeQuery();

            while (rs.next()) {
                Promotion p = new Promotion();
                p.setPromotionID(rs.getInt("PromotionID"));
                p.setPromoCode(rs.getString("PromoCode"));
                p.setPromotionName(rs.getString("PromotionName"));
                p.setTargetType(rs.getString("TargetType"));
                p.setDiscountPercent(rs.getInt("DiscountPercent"));
                p.setStartDate(rs.getDate("StartDate"));
                p.setEndDate(rs.getDate("EndDate"));
                p.setDescription(rs.getString("Description"));
                p.setActive(rs.getBoolean("IsActive"));
                list.add(p);
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

    public int getTotalPromotion() {
        int total = 0;
        Connection cn = null;

        try {
            cn = DBUtils.getConnection();

            String sql = "SELECT COUNT(*) AS Total FROM Promotions";

            PreparedStatement st = cn.prepareStatement(sql);
            ResultSet rs = st.executeQuery();

            if (rs.next()) {
                total = rs.getInt("Total");
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

    public int getTotalPromotionByStatus(boolean status) {
        int total = 0;
        Connection cn = null;

        try {
            cn = DBUtils.getConnection();
            String sql = "SELECT COUNT(*) AS Total FROM Promotions WHERE IsActive = ? ";

            PreparedStatement st = cn.prepareStatement(sql);
            st.setBoolean(1, status);

            ResultSet rs = st.executeQuery();

            if (rs.next()) {
                total = rs.getInt("Total");
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

    public int getTotalPromotion(String status, String search, String targetType) {
        int total = 0;
        Connection cn = null;

        try {
            cn = DBUtils.getConnection();
            String sql = "SELECT COUNT(*) AS Total FROM Promotions WHERE 1=1 ";

            if (!"ALL".equalsIgnoreCase(status)) {
                sql += " AND IsActive = ? ";
            }

            if (targetType != null && !"ALL".equals(targetType)) {
                sql += " AND TargetType = ? ";
            }

            if (search != null && !search.trim().isEmpty()) {
                sql += " AND (PromoCode LIKE ? OR PromotionName LIKE ?) ";
            }

            PreparedStatement st = cn.prepareStatement(sql);
            int index = 1;

            if (!"ALL".equalsIgnoreCase(status)) {
                st.setBoolean(index++, "1".equals(status));
            }

            if (targetType != null && !"ALL".equals(targetType)) {
                st.setString(index++, targetType);
            }

            if (search != null && !search.trim().isEmpty()) {
                String keyword = "%" + search.trim() + "%";
                st.setString(index++, keyword);
                st.setString(index++, keyword);
            }

            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                total = rs.getInt("Total");
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

    public int autoUpdateStatus() {
        int result = 0;
        Connection cn = null;

        try {
            cn = DBUtils.getConnection();
            String sql = "UPDATE Promotions SET IsActive = 0 WHERE EndDate < GETDATE()";

            PreparedStatement st = cn.prepareStatement(sql);
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
}
