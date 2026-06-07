package dao;

import dbutils.DBUtils;
import dto.Reward;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class RewardDAO {

    public RewardDAO() {
    }

    public Reward getNextReward(int currentPoints) {

        String sql
                = "SELECT TOP 1 * "
                + "FROM Rewards "
                + "WHERE PointsRequired > ? "
                + "AND IsActive = 1 "
                + "AND StockQuantity > 0 "
                + "ORDER BY PointsRequired ASC";

        try (
                 Connection conn = DBUtils.getConnection();  PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, currentPoints);

            try ( ResultSet rs = pstmt.executeQuery()) {

                if (rs.next()) {

                    Reward reward = new Reward();

                    reward.setRewardId(rs.getInt("RewardID"));
                    reward.setRewardName(rs.getString("RewardName"));
                    reward.setDescription(rs.getString("Description"));
                    reward.setPointsRequired(rs.getInt("PointsRequired"));
                    reward.setRewardType(rs.getString("RewardType"));

                    reward.setDiscountAmount(
                            rs.getBigDecimal("DiscountAmount")
                    );

                    reward.setStockQuantity(
                            rs.getInt("StockQuantity")
                    );

                    reward.setActive(
                            rs.getBoolean("IsActive")
                    );

                    reward.setCreatedAt(
                            rs.getTimestamp("CreatedAt")
                    );

                    return reward;
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }
}
