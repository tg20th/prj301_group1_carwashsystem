package dao;

import dbutils.DBUtils;
import dto.VehicleBrand;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;


public class VehicleBrandDAO {

    public ArrayList<VehicleBrand> getAllBrands() {

        ArrayList<VehicleBrand> list = new ArrayList<>();
        Connection cn = null;
        String sql = "SELECT * FROM VehicleBrands WHERE IsActive = 1";

        try {
            cn = DBUtils.getConnection();

            PreparedStatement st = cn.prepareStatement(sql);

            ResultSet rs = st.executeQuery();

            while (rs.next()) {

                VehicleBrand b = new VehicleBrand();

                b.setBrandID(rs.getInt("BrandID"));
                b.setBrandName(rs.getString("BrandName"));

                list.add(b);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
}