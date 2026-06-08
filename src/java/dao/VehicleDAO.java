package dao;

import dbutils.DBUtils;
import dto.Vehicle;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class VehicleDAO {

    public boolean isLicensePlateExists(String plate) {

        String sql = "SELECT VehicleID FROM Vehicles WHERE LicensePlate = ?";

        try {
            Connection con = DBUtils.getConnection();

            PreparedStatement st = con.prepareStatement(sql);

            st.setString(1, plate);

            ResultSet rs = st.executeQuery();

            return rs.next();

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public int createVehicle(Vehicle v) {

        String sql = "INSERT INTO Vehicles("
                + "CustomerID,"
                + "ModelID,"
                + "LicensePlate,"
                + "Color,"
                + "ManufactureYear,"
                + "ImageURL,"
                + "Status"
                + ") "
                + "VALUES(?,?,?,?,?,?,?)";

        try {
            Connection con = DBUtils.getConnection();

            PreparedStatement st = con.prepareStatement(sql);

            st.setInt(1, v.getCustomerID());
            st.setInt(2, v.getModelID());
            st.setString(3, v.getLicensePlate());
            st.setString(4, v.getColor());

            if (v.getManufactureYear() == null) {
                st.setNull(5, java.sql.Types.INTEGER);
            } else {
                st.setInt(5, v.getManufactureYear());
            }

            st.setString(6, v.getImageURL());
            st.setString(7, v.getStatus());

            return st.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }

        return 0;
    }

}
