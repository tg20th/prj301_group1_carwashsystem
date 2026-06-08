package dao;

import dbutils.DBUtils;
import dto.Vehicle;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
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

    public Vehicle getVeByPlate(String licensePlate) {
        if (licensePlate == null || licensePlate.trim().isEmpty()) {
            return null;
        }

        String sql = "SELECT v.VehicleID, v.CustomerID, v.ModelID, v.LicensePlate, v.Color, "
                + "v.ManufactureYear, v.ImageURL, v.Status, v.CreatedAt, "
                + "b.BrandName, m.ModelName "
                + "FROM Vehicles v "
                + "INNER JOIN VehicleModels m ON v.ModelID = m.ModelID "
                + "INNER JOIN VehicleBrands b ON m.BrandID = b.BrandID "
                + "WHERE v.LicensePlate = ?";

        try (Connection con = DBUtils.getConnection();
             PreparedStatement st = con.prepareStatement(sql)) {

            st.setString(1, licensePlate.trim().toUpperCase());
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToVehicle(rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public int reactivateVehicle(Vehicle v) {
        if (v == null || v.getLicensePlate() == null) {
            return 0;
        }

        StringBuilder sql = new StringBuilder("UPDATE Vehicles SET Status = 'Active'");
        boolean hasModel = v.getModelID() > 0;
        boolean hasColor = v.getColor() != null && !v.getColor().trim().isEmpty();
        boolean hasYear = v.getManufactureYear() != null;
        boolean hasImg = v.getImageURL() != null;

        if (hasModel) {
            sql.append(", ModelID = ?");
        }
        if (hasColor) {
            sql.append(", Color = ?");
        }
        if (hasYear) {
            sql.append(", ManufactureYear = ?");
        }
        if (hasImg) {
            sql.append(", ImageURL = ?");
        }
        sql.append(" WHERE LicensePlate = ?");

        if (v.getCustomerID() > 0) {
            sql.append(" AND CustomerID = ?");
        }

        try (Connection con = DBUtils.getConnection();
             PreparedStatement st = con.prepareStatement(sql.toString())) {

            int idx = 1;
            if (hasModel) {
                st.setInt(idx++, v.getModelID());
            }
            if (hasColor) {
                st.setString(idx++, v.getColor().trim());
            }
            if (hasYear) {
                st.setInt(idx++, v.getManufactureYear());
            }
            if (hasImg) {
                st.setString(idx++, v.getImageURL());
            }
            st.setString(idx++, v.getLicensePlate().trim().toUpperCase());

            if (v.getCustomerID() > 0) {
                st.setInt(idx++, v.getCustomerID());
            }

            return st.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public Vehicle getVehicleByID(int vehicleID) {
        String sql = "SELECT v.VehicleID, v.CustomerID, v.ModelID, v.LicensePlate, v.Color, "
                + "v.ManufactureYear, v.ImageURL, v.Status, v.CreatedAt, "
                + "b.BrandName, m.ModelName "
                + "FROM Vehicles v "
                + "INNER JOIN VehicleModels m ON v.ModelID = m.ModelID "
                + "INNER JOIN VehicleBrands b ON m.BrandID = b.BrandID "
                + "WHERE v.VehicleID = ?";

        try (Connection con = DBUtils.getConnection();
             PreparedStatement st = con.prepareStatement(sql)) {

            st.setInt(1, vehicleID);
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToVehicle(rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Vehicle> getVehiclesByCustomerID(int customerID) {
        List<Vehicle> list = new ArrayList<>();
        // Only return non-Frozen vehicles for the customer's dashboard list
        String sql = "SELECT v.VehicleID, v.CustomerID, v.ModelID, v.LicensePlate, v.Color, "
                + "v.ManufactureYear, v.ImageURL, v.Status, v.CreatedAt, "
                + "b.BrandName, m.ModelName "
                + "FROM Vehicles v "
                + "INNER JOIN VehicleModels m ON v.ModelID = m.ModelID "
                + "INNER JOIN VehicleBrands b ON m.BrandID = b.BrandID "
                + "WHERE v.CustomerID = ? AND v.Status <> 'Frozen' "
                + "ORDER BY v.CreatedAt DESC";

        try (Connection con = DBUtils.getConnection();
             PreparedStatement st = con.prepareStatement(sql)) {

            st.setInt(1, customerID);
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToVehicle(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public int deleteVehicle(int vehicleID) {
        // Soft delete: mark as Frozen so it can be reactivated later by the same customer
        String sql = "UPDATE Vehicles SET Status = 'Frozen' WHERE VehicleID = ?";
        try (Connection con = DBUtils.getConnection();
             PreparedStatement st = con.prepareStatement(sql)) {
            st.setInt(1, vehicleID);
            return st.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int updateVehicle(Vehicle v) {
        if (v == null || v.getVehicleID() <= 0) return 0;

        StringBuilder sql = new StringBuilder("UPDATE Vehicles SET LicensePlate = ?");
        List<Object> params = new ArrayList<>();
        params.add(v.getLicensePlate() != null ? v.getLicensePlate().trim().toUpperCase() : null);

        // Color
        sql.append(", Color = ?");
        params.add(v.getColor());

        int resolvedModelID = 0;
        if (v.getModel() != null && v.getBrand() != null &&
            !v.getModel().trim().isEmpty() && !v.getBrand().trim().isEmpty()) {
            resolvedModelID = findModelIDByBrandAndModel(v.getBrand().trim(), v.getModel().trim());
        }

        int modelIDToUse = (v.getModelID() > 0) ? v.getModelID() : resolvedModelID;
        if (modelIDToUse > 0) {
            sql.append(", ModelID = ?");
            params.add(modelIDToUse);
        }

        if (v.getManufactureYear() != null) {
            sql.append(", ManufactureYear = ?");
            params.add(v.getManufactureYear());
        }
        if (v.getImageURL() != null) {
            sql.append(", ImageURL = ?");
            params.add(v.getImageURL());
        }

        sql.append(" WHERE VehicleID = ?");
        params.add(v.getVehicleID());

        try (Connection con = DBUtils.getConnection();
             PreparedStatement st = con.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                Object p = params.get(i);
                if (p instanceof Integer) {
                    st.setInt(i + 1, (Integer) p);
                } else if (p instanceof String) {
                    st.setString(i + 1, (String) p);
                } else if (p == null) {
                    st.setNull(i + 1, java.sql.Types.VARCHAR);
                }
            }
            return st.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    // Public helper: resolve brand name + model name to ModelID (used by add/update flows)
    public int getModelIDByNames(String brandName, String modelName) {
        if (brandName == null || modelName == null) return 0;
        String sql = "SELECT m.ModelID FROM VehicleModels m "
                + "INNER JOIN VehicleBrands b ON m.BrandID = b.BrandID "
                + "WHERE b.BrandName = ? AND m.ModelName = ?";
        try (Connection con = DBUtils.getConnection();
             PreparedStatement st = con.prepareStatement(sql)) {
            st.setString(1, brandName.trim());
            st.setString(2, modelName.trim());
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    // Helper: resolve brand name + model name to ModelID (for update flow that sends text names)
    private int findModelIDByBrandAndModel(String brandName, String modelName) {
        return getModelIDByNames(brandName, modelName);
    }

    // Common mapper for SELECT queries that join brand/model
    private Vehicle mapResultSetToVehicle(ResultSet rs) throws SQLException {
        Vehicle v = new Vehicle();
        v.setVehicleID(rs.getInt("VehicleID"));
        v.setCustomerID(rs.getInt("CustomerID"));
        v.setModelID(rs.getInt("ModelID"));
        v.setLicensePlate(rs.getString("LicensePlate"));
        v.setColor(rs.getString("Color"));

        int year = rs.getInt("ManufactureYear");
        if (rs.wasNull()) {
            v.setManufactureYear(null);
        } else {
            v.setManufactureYear(year);
        }

        v.setImageURL(rs.getString("ImageURL"));
        v.setStatus(rs.getString("Status"));

        java.sql.Timestamp ts = rs.getTimestamp("CreatedAt");
        if (ts != null) {
            v.setCreatedAt(ts);
        }

        v.setBrandName(rs.getString("BrandName"));
        v.setModelName(rs.getString("ModelName"));
        return v;
    }
}
