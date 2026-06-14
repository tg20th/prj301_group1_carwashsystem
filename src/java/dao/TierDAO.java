package dao;

import dbutils.DBUtils;
import dto.Tier;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class TierDAO {

    public Tier getTier(int id) {
        Tier result = null;
        Connection cn = null;
        try {
            cn = DBUtils.getConnection();
            String sql = "SELECT [TierName]\n"
                    + "  FROM [AutoWashProDB].[dbo].[LoyaltyTiers] where [TierID] = ?";
            PreparedStatement st = cn.prepareStatement(sql);
            st.setInt(1, id);
            ResultSet table = st.executeQuery();
            while (table.next()) {
                String name = table.getString("TierName");
                result = new Tier();
                result.setTierName(name);
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
}
