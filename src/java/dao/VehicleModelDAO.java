package dao;

import dbutils.DBUtils;
import dto.VehicleModel;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

public class VehicleModelDAO {

    public ArrayList<VehicleModel> getModelsByBrand(int brandID) {

        ArrayList<VehicleModel> list = new ArrayList<>();
        Connection cn = null;
        String sql = "SELECT * FROM VehicleModels "
                + "WHERE BrandID = ? "
                + "AND IsActive = 1";

        try {
            cn = DBUtils.getConnection();

            PreparedStatement st = cn.prepareStatement(sql);

            st.setInt(1, brandID);

            ResultSet rs = st.executeQuery();

            while (rs.next()) {

                VehicleModel m = new VehicleModel();

                m.setModelID(rs.getInt("ModelID"));
                m.setBrandID(rs.getInt("BrandID"));
                m.setModelName(rs.getString("ModelName"));

                list.add(m);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
}
