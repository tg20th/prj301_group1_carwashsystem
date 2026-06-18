package dao;

import dbutils.DBUtils;
import dto.Tier;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class TierDAO {

    public Tier getTier(int id) {
        Tier result = null;
        Connection cn = null;
        try {
            cn = DBUtils.getConnection();
            String sql = "SELECT [TierID], [TierName], [MaxBookingDaysAhead] "
                    + "FROM [dbo].[LoyaltyTiers] WHERE [TierID] = ? AND [IsActive] = 1";
            PreparedStatement st = cn.prepareStatement(sql);
            st.setInt(1, id);
            ResultSet table = st.executeQuery();
            if (table.next()) {
                result = new Tier();
                result.setTierID(table.getInt("TierID"));
                result.setTierName(table.getString("TierName"));
                result.setMaxBookingDaysAhead(table.getInt("MaxBookingDaysAhead"));
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
        return result;
    }

    public int getMaxBookingDaysAhead(int tierId) {
        Tier tier = getTier(tierId);
        if (tier != null && tier.getMaxBookingDaysAhead() > 0) {
            return tier.getMaxBookingDaysAhead();
        }
        return defaultMaxBookingDays(tierId);
    }

    private int defaultMaxBookingDays(int tierId) {
        switch (tierId) {
            case 4:
                return 30;
            case 3:
                return 14;
            case 2:
                return 7;
            default:
                return 3;
        }
    }
    
    public List<Tier> getAllTier() {
        List<Tier> list = new ArrayList<>();
        Connection cn = null;

        try {
            cn = DBUtils.getConnection();
            String sql = "SELECT t.[TierID], t.[TierName], [MinSpend]\n"
                    + ",[PointMultiplier]\n"
                    + ",[BenefitDescription]\n"
                    + ",[IsActive], ISNULL(COUNT(c.CustomerID), 0) AS NumOfCus\n"
                    + "FROM [dbo].[LoyaltyTiers] t LEFT JOIN [dbo].[Customers] c\n"
                    + "ON t.TierID = c.TierID\n"
                    + "GROUP BY t.TierID, t.TierName, [MinSpend]\n"
                    + ",[PointMultiplier]\n"
                    + ",[BenefitDescription]\n"
                    + ",[IsActive]";

            PreparedStatement st = cn.prepareStatement(sql);
            ResultSet table = st.executeQuery();

            while (table.next()) {
                int id = table.getInt("TierID");
                String name = table.getString("TierName");
                int minSpend = table.getInt("MinSpend");
                double pointMultiplier = table.getDouble("PointMultiplier");
                String description = table.getString("BenefitDescription");
                boolean status = table.getBoolean("IsActive");
                int totalCus = table.getInt("NumOfCus");

                Tier t = new Tier(id, name, minSpend, pointMultiplier, description, status, totalCus);
                list.add(t);
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

    public int createTier(Tier t) {
        int result = 0;
        Connection cn = null;
        try {
            cn = DBUtils.getConnection();
            String sql = "INSERT INTO [dbo].[LoyaltyTiers] ([TierName], [MinSpend], "
                    + "[PointMultiplier], [BenefitDescription],[IsActive])\n"
                    + "VALUES (?, ?, ?, ?, ?)";

            PreparedStatement st = cn.prepareStatement(sql);
            st.setString(1, t.getTierName());
            st.setInt(2, t.getMinSpend());
            st.setDouble(3, t.getPointRate());
            st.setString(4, t.getDesciption());
            st.setBoolean(5, true);
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

    public int updateTier(int id, String name, int minSpend, double point, String des, boolean status) {
        int result = 0;
        Connection cn = null;
        try {
            cn = DBUtils.getConnection();
            String sql = "UPDATE [dbo].[LoyaltyTiers] SET [TierName] = ?,[MinSpend] = ?, [PointMultiplier] = ?,\n"
                    + "[BenefitDescription] = ?, [IsActive] = ?\n"
                    + "WHERE [TierID] = ?";

            PreparedStatement st = cn.prepareStatement(sql);
            st.setString(1, name);
            st.setInt(2, minSpend);
            st.setDouble(3, point);
            st.setString(4, des);
            st.setBoolean(5, status);
            st.setInt(6, id);

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
    
    public int removeTierByID(int id) {
        int result = 0;
        Connection cn = null;
        try {
            cn = DBUtils.getConnection();
            String sql = "UPDATE LoyaltyTiers SET [IsActive] = ?\n"
                    + "WHERE [TierID] = ?";

            PreparedStatement st = cn.prepareStatement(sql);
            st.setBoolean(1, false);
            st.setInt(2, id);

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
