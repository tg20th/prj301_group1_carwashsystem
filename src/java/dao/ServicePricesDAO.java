/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import dbutils.DBUtils;
import dto.ServicePrices;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author ASUS
 */
public class ServicePricesDAO {

    public int createServicePrice(ServicePrices sp) {
        int result = 0;
        Connection cn = null;

        try {
            cn = DBUtils.getConnection();

            String sql = "INSERT INTO [dbo].[ServicePrices] "
                    + "([ServiceID], [VehicleTypeID], [Price], [DurationMinutes]) "
                    + "VALUES (?, ?, ?, ?)";

            PreparedStatement st = cn.prepareStatement(sql);

            st.setInt(1, sp.getServiceID());
            st.setInt(2, sp.getVehicleTypeID());
            st.setBigDecimal(3, sp.getPrice());
            st.setInt(4, sp.getDurations());

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

    public List<ServicePrices> getPricesByServiceID(int serviceID) {
        List<ServicePrices> list = new ArrayList<>();
        Connection cn = null;

        try {
            cn = DBUtils.getConnection();

            String sql = "SELECT [ServiceID], [VehicleTypeID], [Price], [DurationMinutes] "
                    + "FROM [dbo].[ServicePrices] "
                    + "WHERE [ServiceID] = ?";

            PreparedStatement st = cn.prepareStatement(sql);
            st.setInt(1, serviceID);

            ResultSet table = st.executeQuery();

            while (table.next()) {
                ServicePrices sp = new ServicePrices();
                sp.setServiceID(table.getInt("ServiceID"));
                sp.setVehicleTypeID(table.getInt("VehicleTypeID"));
                sp.setPrice(table.getBigDecimal("Price"));
                sp.setDurations(table.getInt("DurationMinutes"));

                list.add(sp);
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

    public int updateServicePrice(ServicePrices sp) {
        int result = 0;
        Connection cn = null;

        try {
            cn = DBUtils.getConnection();

            String sql = "UPDATE [dbo].[ServicePrices] "
                    + "SET [Price] = ?, "
                    + "    [DurationMinutes] = ? "
                    + "WHERE [ServiceID] = ? "
                    + "AND [VehicleTypeID] = ?";

            PreparedStatement st = cn.prepareStatement(sql);

            st.setBigDecimal(1, sp.getPrice());
            st.setInt(2, sp.getDurations());
            st.setInt(3, sp.getServiceID());
            st.setInt(4, sp.getVehicleTypeID());

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
