package dao;

import dbutils.DBUtils;
import dto.Vehicle;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

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
                + "Status,"
                + "CreatedAt"
                + ") "
                + "VALUES(?,?,?,?,?,?,?,?)";
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
            st.setTimestamp(8, new java.sql.Timestamp(System.currentTimeMillis()));
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

    public int updateVehicle(Vehicle v){
        int result = 0;
        String sql = "UPDATE Vehicles "
                + "SET ModelID = ?, "
                + "LicensePlate = ?, "
                + "Color = ?, "
                + "ManufactureYear = ?, "
                + "ImageURL = ?, "
                + "Status = ? "
                + "WHERE VehicleID = ?";
        try {
            Connection cn = DBUtils.getConnection();
            PreparedStatement st = cn.prepareStatement(sql);
            st.setInt(1, v.getModelID());
            st.setString(2, v.getLicensePlate());
            st.setString(3, v.getColor());
            if (v.getManufactureYear() != null) {
                st.setInt(4, v.getManufactureYear());
            } else {
                st.setNull(4, java.sql.Types.INTEGER);
            }
            st.setString(5, v.getImageURL());
            st.setString(6, v.getStatus());
            st.setInt(7, v.getVehicleID());
            result = st.executeUpdate();
            cn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }

    public int deleteVehicle(int vehicleID) {
        String sql
                = "UPDATE Vehicles "
                + "SET Status = 'Frozen' "
                + "WHERE VehicleID = ? "
                + "AND (Status = 'Active' "
                + "OR Status = 'Pending')";
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

    public List<Vehicle> getVehiclesByCustomerID(int cusID) {
        String sql = "SELECT v.*, vm.ModelName, vb.BrandName\n"
                + "FROM Vehicles v\n"
                + "JOIN VehicleModels vm ON v.ModelID = vm.ModelID\n"
                + "JOIN VehicleBrands vb ON vm.BrandID = vb.BrandID\n"
                + "WHERE v.CustomerID = ? AND v.Status <> 'Frozen'";
        List<Vehicle> list = new ArrayList<>();

        try ( Connection con = DBUtils.getConnection()) {
            PreparedStatement st = con.prepareStatement(sql);
            st.setInt(1, cusID);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                Vehicle v = new Vehicle();
                v.setVehicleID(rs.getInt("VehicleID"));
                v.setCustomerID(rs.getInt("CustomerID"));
                v.setModelID(rs.getInt("ModelID"));
                v.setLicensePlate(rs.getString("LicensePlate"));
                v.setColor(rs.getString("Color"));
                int year = rs.getInt("ManufactureYear");
                v.setManufactureYear(year);
                v.setImageURL(rs.getString("ImageURL"));
                v.setStatus(rs.getString("Status"));
                v.setBrandName(rs.getString("BrandName"));
                v.setModelName(rs.getString("ModelName"));
                list.add(v);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
<<<<<<< HEAD
=======

>>>>>>> 05091a098f8c2a0615752cea531209c3d2549bd5
}
