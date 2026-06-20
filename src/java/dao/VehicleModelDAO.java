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

    public Integer getModelIDByBrandAndModel(String brandName, String modelName) {
        String sql = "SELECT vm.ModelID "
                + "FROM VehicleModels vm "
                + "INNER JOIN VehicleBrands vb ON vm.BrandID = vb.BrandID "
                + "WHERE vb.BrandName = ? AND vm.ModelName = ? "
                + "AND vm.IsActive = 1 AND vb.IsActive = 1";

        try (Connection cn = DBUtils.getConnection();
                PreparedStatement st = cn.prepareStatement(sql)) {
            st.setString(1, brandName.trim());
            st.setString(2, modelName.trim());
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("ModelID");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public ArrayList<VehicleModel> getAllModels() {
        ArrayList<VehicleModel> list = new ArrayList<>();
        Connection cn = null;
        String sql = "SELECT * FROM VehicleModels WHERE IsActive = 1";

        try {
            cn = DBUtils.getConnection();

            PreparedStatement st = cn.prepareStatement(sql);

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
