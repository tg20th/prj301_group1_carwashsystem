package dao;

import dbutils.DBUtils;
import dto.Vehicle;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class VehicleDAO {

    public int createVehicle(Vehicle v) {
        int result = 0;
        Connection cn = null;
        try {
            cn = DBUtils.getConnection();
            String sql = "insert into Vehicles\n"
                    + "      ([CustomerID]\n"
                    + "     ,[LicensePlate]\n"
                    + "     ,[Brand]\n"
                    + "     ,[Model]\n"
                    + "     ,[Color]\n"
                    + "     ,[IsActive])\n"
                    + "     values (?,?,?,?,?,?)";
            PreparedStatement st = cn.prepareStatement(sql);
            st.setInt(1, v.getCustomerID());
            st.setString(2, v.getLicensePlate());
            st.setString(3, v.getBrand());
            st.setString(4, v.getModel());
            st.setString(5, v.getColor());
            st.setBoolean(6, v.isActive());

            result = st.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();;
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

    public Vehicle getVeByPlate(String licensePlate) {
        Vehicle v = null;
        Connection cn = null;
        try {
            cn = DBUtils.getConnection();
            String sql = "select [VehicleID]\n"
                    + "      ,[CustomerID]\n"
                    + "      ,[LicensePlate]\n"
                    + "      ,[Brand]\n"
                    + "      ,[Model]\n"
                    + "      ,[Color]\n"
                    + "      ,[IsActive]\n"
                    + "  from Vehicles\n"
                    + "  where LicensePlate = ? ";
            PreparedStatement st = cn.prepareStatement(sql);
            st.setString(1, licensePlate);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                int vehicleID = rs.getInt("VehicleID");
                int customerID = rs.getInt("CustomerID");
                String brand = rs.getString("Brand");
                String model = rs.getString("Model");
                String color = rs.getString("Color");
                boolean isActive = rs.getBoolean("IsActive");
                v = new Vehicle(vehicleID, customerID, licensePlate, brand, model, color, isActive);
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
        return v;
    }

    public int reactivateVehicle(Vehicle v) {
        int result = 0;
        Connection cn = null;
        try {
            cn = DBUtils.getConnection();
            String sql = "UPDATE Vehicles "
                    + "SET Brand = ?, "
                    + "Model = ?, "
                    + "Color = ?, "
                    + "IsActive = ? "
                    + "WHERE LicensePlate = ? "
                    + "AND CustomerID = ?";
            PreparedStatement st = cn.prepareStatement(sql);
            st.setString(1, v.getBrand());
            st.setString(2, v.getModel());
            st.setString(3, v.getColor());
            st.setBoolean(4, true);
            st.setString(5, v.getLicensePlate());
            st.setInt(6, v.getCustomerID());

            result = st.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();;
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

    public List<Vehicle> getVehiclesByCustomerID(int customerID) {
        List<Vehicle> list = new ArrayList<>();

        String sql = "SELECT * FROM Vehicles WHERE CustomerID = ? AND IsActive = 1";

        try (
                 Connection conn = DBUtils.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, customerID);

            try ( ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Vehicle vehicle = new Vehicle();

                    vehicle.setVehicleID(rs.getInt("VehicleID"));
                    vehicle.setCustomerID(rs.getInt("CustomerID"));
                    vehicle.setLicensePlate(rs.getString("LicensePlate"));
                    vehicle.setBrand(rs.getString("Brand"));
                    vehicle.setModel(rs.getString("Model"));
                    vehicle.setColor(rs.getString("Color"));
                    vehicle.setActive(rs.getBoolean("IsActive"));

                    list.add(vehicle);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public int deleteVehicle(int vehicleId) {
        int result = 0;
        Connection cn = null;
        try {
            cn = DBUtils.getConnection();
            String sql = "update Vehicles "
                    + "set IsActive = 0\n"
                    + "where VehicleID = ?\n";
            PreparedStatement st = cn.prepareStatement(sql);
            st.setInt(1, vehicleId);
            result = st.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();;
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

    public int updateVehicle(Vehicle v) {
        int result = 0;
        Connection cn = null;
        try {
            cn = DBUtils.getConnection();
            String sql = "UPDATE Vehicles "
                    + "SET LicensePlate = ?, "
                    + "Brand = ?, "
                    + "Model = ?, "
                    + "Color = ? "
                    + "WHERE VehicleID = ?";
            PreparedStatement st = cn.prepareStatement(sql);

            st.setString(1, v.getLicensePlate());
            st.setString(2, v.getBrand());
            st.setString(3, v.getModel());
            st.setString(4, v.getColor());
            st.setInt(5, v.getVehicleID());

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

    public Vehicle getVehicleByID(int vehicleID) {
        Vehicle v = null;
        Connection cn = null;
        try {
            cn = DBUtils.getConnection();
            String sql = "select [VehicleID]\n"
                    + "      ,[CustomerID]\n"
                    + "      ,[LicensePlate]\n"
                    + "      ,[Brand]\n"
                    + "      ,[Model]\n"
                    + "      ,[Color]\n"
                    + "      ,[IsActive]\n"
                    + "  from Vehicles\n"
                    + "  where VehicleID = ? ";
            PreparedStatement st = cn.prepareStatement(sql);
            st.setInt(1, vehicleID);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                int customerID = rs.getInt("CustomerID");
                String licensePlate = rs.getString("LicensePlate");
                String brand = rs.getString("Brand");
                String model = rs.getString("Model");
                String color = rs.getString("Color");
                boolean isActive = rs.getBoolean("IsActive");
                v = new Vehicle(vehicleID, customerID, licensePlate, brand, model, color, isActive);
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
        return v;
    }

    public boolean isLPExist(String lp, int veID) {
        boolean result = false;
        Connection cn = null;
        try {
            cn = DBUtils.getConnection();
            String sql = "select VehicleID \n"
                    + "from Vehicles\n"
                    + "where LicensePlate= ? \n"
                    + "and VehicleID != ?";
            PreparedStatement st = cn.prepareStatement(sql);
            st.setString(1, lp);
            st.setInt(2, veID);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                result = true;
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
            return result;
        }
    }
    
    public int getTotalVehicle() {
        int result = 0;
        Connection cn = null;

        try {
            cn = DBUtils.getConnection();
            String sql = "SELECT ISNULL(COUNT(*), 0) AS NumOfVehicle\n"
                    + "  FROM [AutoWashProDB].[dbo].[Vehicles]";

            PreparedStatement st = cn.prepareStatement(sql);

            ResultSet table = st.executeQuery();
            while (table.next()) {
                result = table.getInt("NumOfVehicle");
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
    
    public int getTotalVehiclePending() {
        int result = 0;
        Connection cn = null;

        try {
            cn = DBUtils.getConnection();
            String sql = "SELECT ISNULL(COUNT(*), 0) AS NumOfVehicle\n"
                    + "  FROM [AutoWashProDB].[dbo].[Vehicles] WHERE Status = 'Pending'";

            PreparedStatement st = cn.prepareStatement(sql);

            ResultSet table = st.executeQuery();
            while (table.next()) {
                result = table.getInt("NumOfVehicle");
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
