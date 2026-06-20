package dao;

import java.sql.*;
import java.util.*;
import dbutils.DBUtils;
import dto.Promotion;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

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
        LinkedHashMap<Integer, Promotion> merged = new LinkedHashMap<>();
        for (Promotion p : fetchAllAndTierPromotions(customerID, tierID)) {
            merged.put(p.getPromotionID(), p);
        }
        for (Promotion p : fetchCustomerTargetPromotions(customerID)) {
            merged.putIfAbsent(p.getPromotionID(), p);
        }
        return applyQuotaLimits(new ArrayList<>(merged.values()), customerID);
    }

    private List<Promotion> fetchAllAndTierPromotions(int customerID, int tierID) {
        List<Promotion> list = new ArrayList<>();
        String sql = "SELECT DISTINCT p.PromotionID, p.PromotionName, p.Description, "
                + "p.DiscountPercent, p.StartDate, p.EndDate "
                + "FROM Promotions p "
                + "LEFT JOIN PromotionTiers pt ON p.PromotionID = pt.PromotionID "
                + "WHERE p.IsActive = 1 "
                + "AND (p.StartDate IS NULL OR CAST(GETDATE() AS DATE) >= p.StartDate) "
                + "AND (p.EndDate IS NULL OR CAST(GETDATE() AS DATE) <= p.EndDate) "
                + "AND (p.TargetType = 'All' "
                + "     OR (p.TargetType = 'Tier' AND pt.TierID = ?)) "
                + "ORDER BY p.EndDate ASC";
        try ( Connection con = DBUtils.getConnection();  PreparedStatement st = con.prepareStatement(sql)) {
            st.setInt(1, tierID);
            try ( ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    list.add(mapPromotionRow(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    private List<Promotion> fetchCustomerTargetPromotions(int customerID) {
        List<Promotion> list = new ArrayList<>();
        String sql = "SELECT DISTINCT p.PromotionID, p.PromotionName, p.Description, "
                + "p.DiscountPercent, p.StartDate, p.EndDate "
                + "FROM Promotions p "
                + "INNER JOIN PromotionCustomers pc ON p.PromotionID = pc.PromotionID AND pc.CustomerID = ? "
                + "WHERE p.IsActive = 1 "
                + "AND p.TargetType = 'Customer' "
                + "AND (p.StartDate IS NULL OR CAST(GETDATE() AS DATE) >= p.StartDate) "
                + "AND (p.EndDate IS NULL OR CAST(GETDATE() AS DATE) <= p.EndDate) "
                + "ORDER BY p.EndDate ASC";
        try ( Connection con = DBUtils.getConnection();  PreparedStatement st = con.prepareStatement(sql)) {
            st.setInt(1, customerID);
            try ( ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    list.add(mapPromotionRow(rs));
                }
            }
        } catch (Exception e) {
            // PromotionCustomers table may not exist yet on some environments.
        }
        return list;
    }

    private Promotion mapPromotionRow(ResultSet rs) throws SQLException {
        Promotion p = new Promotion();
        p.setPromotionID(rs.getInt("PromotionID"));
        p.setPromotionName(rs.getString("PromotionName"));
        p.setDescription(rs.getString("Description"));
        p.setDiscountPercent(rs.getInt("DiscountPercent"));
        p.setStartDate(rs.getDate("StartDate"));
        p.setEndDate(rs.getDate("EndDate"));
        p.setRemainingUses(999);
        return p;
    }

    private List<Promotion> applyQuotaLimits(List<Promotion> promotions, int customerID) {
        Map<Integer, int[]> quotaByPromotion = loadQuotaMap(customerID);
        List<Promotion> filtered = new ArrayList<>();
        for (Promotion p : promotions) {
            int[] quota = quotaByPromotion.get(p.getPromotionID());
            if (quota == null) {
                p.setMaxUses(0);
                p.setUsedCount(0);
                p.setRemainingUses(999);
                filtered.add(p);
                continue;
            }
            int maxUses = quota[0];
            int usedCount = quota[1];
            int remaining = maxUses - usedCount;
            if (remaining <= 0) {
                continue;
            }
            p.setMaxUses(maxUses);
            p.setUsedCount(usedCount);
            p.setRemainingUses(remaining);
            filtered.add(p);
        }
        return filtered;
    }

    private Map<Integer, int[]> loadQuotaMap(int customerID) {
        Map<Integer, int[]> quotaMap = new HashMap<>();
        String sql = "SELECT PromotionID, MaxUses, UsedCount FROM PromotionCustomers WHERE CustomerID = ?";
        try ( Connection con = DBUtils.getConnection();  PreparedStatement st = con.prepareStatement(sql)) {
            st.setInt(1, customerID);
            try ( ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    quotaMap.put(rs.getInt("PromotionID"),
                            new int[]{rs.getInt("MaxUses"), rs.getInt("UsedCount")});
                }
            }
        } catch (Exception e) {
            // Quota table unavailable: promotions still visible as unlimited.
        }
        return quotaMap;
    }

    public boolean consumePromotionUsage(int promotionId, int customerId, Connection cn) throws SQLException {
        String updateSql = "UPDATE PromotionCustomers SET UsedCount = UsedCount + 1 "
                + "WHERE PromotionID = ? AND CustomerID = ? AND UsedCount < MaxUses";
        PreparedStatement updateSt = cn.prepareStatement(updateSql);
        updateSt.setInt(1, promotionId);
        updateSt.setInt(2, customerId);
        if (updateSt.executeUpdate() > 0) {
            return true;
        }
        if (!hasQuotaRow(promotionId, customerId, cn)) {
            return true;
        }
        return false;
    }

    public boolean restorePromotionUsage(int promotionId, int customerId, Connection cn) throws SQLException {
        if (!hasQuotaRow(promotionId, customerId, cn)) {
            return true;
        }
        String sql = "UPDATE PromotionCustomers SET UsedCount = UsedCount - 1 "
                + "WHERE PromotionID = ? AND CustomerID = ? AND UsedCount > 0";
        PreparedStatement st = cn.prepareStatement(sql);
        st.setInt(1, promotionId);
        st.setInt(2, customerId);
        return st.executeUpdate() > 0;
    }

    private boolean hasQuotaRow(int promotionId, int customerId, Connection cn) throws SQLException {
        String sql = "SELECT 1 FROM PromotionCustomers WHERE PromotionID = ? AND CustomerID = ?";
        PreparedStatement st = cn.prepareStatement(sql);
        st.setInt(1, promotionId);
        st.setInt(2, customerId);
        try (ResultSet rs = st.executeQuery()) {
            return rs.next();
        }
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
