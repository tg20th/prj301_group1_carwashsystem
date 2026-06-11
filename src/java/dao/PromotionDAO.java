package dao;

import dbutils.DBUtils;
import dto.Promotion;
import java.sql.*;
import java.util.*;

public class PromotionDAO {

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
}
