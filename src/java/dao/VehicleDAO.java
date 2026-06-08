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

    public Vehicle getVeByPlate(String plate) {
        String sql = "SELECT v.*, b.BrandName, m.ModelName "
                + "FROM Vehicles v "
                + "JOIN VehicleModels m ON v.ModelID = m.ModelID "
                + "JOIN VehicleBrands b ON m.BrandID = b.BrandID "
                + "WHERE v.LicensePlate = ?";
        try ( Connection con = DBUtils.getConnection();  PreparedStatement st = con.prepareStatement(sql)) {
            st.setString(1, plate);
            try ( ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    Vehicle v = new Vehicle();
                    v.setVehicleID(rs.getInt("VehicleID"));
                    v.setCustomerID(rs.getInt("CustomerID"));
                    v.setModelID(rs.getInt("ModelID"));
                    v.setLicensePlate(rs.getString("LicensePlate"));
                    v.setColor(rs.getString("Color"));
                    int year = rs.getInt("ManufactureYear");
                    if (!rs.wasNull()) {
                        v.setManufactureYear(year);
                    }
                    v.setImageURL(rs.getString("ImageURL"));
                    v.setStatus(rs.getString("Status"));
                    v.setBrandName(rs.getString("BrandName"));
                    v.setModelName(rs.getString("ModelName"));
                    return v;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public int reactivateVehicle(Vehicle v) {
        String sql = "UPDATE Vehicles SET "
                + "ModelID = ?, "
                + "Color = ?, "
                + "ManufactureYear = ?, "
                + "ImageURL = ?, "
                + "Status = 'Active' "
                + "WHERE LicensePlate = ? AND CustomerID = ?";
        try ( Connection con = DBUtils.getConnection();  PreparedStatement st = con.prepareStatement(sql)) {
            st.setInt(1, v.getModelID());
            st.setString(2, v.getColor());
            if (v.getManufactureYear() == null) {
                st.setNull(3, java.sql.Types.INTEGER);
            } else {
                st.setInt(3, v.getManufactureYear());
            }
            st.setString(4, v.getImageURL());
            st.setString(5, v.getLicensePlate());
            st.setInt(6, v.getCustomerID());
            return st.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public boolean isLicensePlateExistsForOther(String plate, int vehicleID) {
        String sql = "SELECT VehicleID "
                + "FROM Vehicles "
                + "WHERE LicensePlate = ? "
                + "AND VehicleID <> ?";
        try {
            Connection con = DBUtils.getConnection();
            PreparedStatement st = con.prepareStatement(sql);
            st.setString(1, plate);
            st.setInt(2, vehicleID);
            ResultSet rs = st.executeQuery();
            return rs.next();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public int updateVehicle(Vehicle v) {
        String sql;
        if (v.getImageURL() != null) {
            sql = "UPDATE Vehicles "
                    + "SET "
                    + "ModelID = ?, "
                    + "LicensePlate = ?, "
                    + "Color = ?, "
                    + "ManufactureYear = ?, "
                    + "ImageURL = ? "
                    + "WHERE VehicleID = ?";
        } else {
            sql
                    = "UPDATE Vehicles "
                    + "SET "
                    + "ModelID = ?, "
                    + "LicensePlate = ?, "
                    + "Color = ?, "
                    + "ManufactureYear = ? "
                    + "WHERE VehicleID = ?";
        }
        try {
            Connection con = DBUtils.getConnection();
            PreparedStatement st = con.prepareStatement(sql);
            st.setInt(1, v.getModelID());
            st.setString(2, v.getLicensePlate());
            st.setString(3, v.getColor());
            if (v.getManufactureYear() == null) {
                st.setNull(4, java.sql.Types.INTEGER);
            } else {
                st.setInt(4, v.getManufactureYear());
            }
            if (v.getImageURL() != null) {
                st.setString(5, v.getImageURL());
                st.setInt(6, v.getVehicleID());
            } else {
                st.setInt(5, v.getVehicleID());
            }
            return st.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public Vehicle getVehicleByID(int vehicleID) {
        String sql = "SELECT v.*, " + "vm.ModelName, " + "vb.BrandName " + "FROM Vehicles v " + "JOIN VehicleModels vm " + "ON v.ModelID = vm.ModelID " + "JOIN VehicleBrands vb " + "ON vm.BrandID = vb.BrandID " + "WHERE v.VehicleID = ?";
        try {
            Connection con = DBUtils.getConnection();
            PreparedStatement st = con.prepareStatement(sql);
            st.setInt(1, vehicleID);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                Vehicle v = new Vehicle();
                v.setVehicleID(rs.getInt("VehicleID"));
                v.setCustomerID(rs.getInt("CustomerID"));
                v.setModelID(rs.getInt("ModelID"));
                v.setLicensePlate(rs.getString("LicensePlate"));
                v.setColor(rs.getString("Color"));
                int year = rs.getInt("ManufactureYear");
                if (!rs.wasNull()) {
                    v.setManufactureYear(year);
                }
                v.setImageURL(rs.getString("ImageURL"));
                v.setStatus(rs.getString("Status"));
                v.setBrandName(rs.getString("BrandName"));
                v.setModelName(rs.getString("ModelName"));
                return v;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public int deleteVehicle(int vehicleID) {
        String sql
                = "UPDATE Vehicles "
                + "SET Status = 'Frozen' "
                + "WHERE VehicleID = ?";
        try {
            Connection con = DBUtils.getConnection();
            PreparedStatement st = con.prepareStatement(sql);
            st.setInt(1, vehicleID);
            return st.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

}
