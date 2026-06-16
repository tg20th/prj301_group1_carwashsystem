/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import dbutils.DBUtils;
import dto.VehicleType;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author ASUS
 */
public class VehicleTypeDAO {

    public List<VehicleType> getAllVehicleType() {
        List<VehicleType> list = new ArrayList<>();
        Connection cn = null;
        try {
            cn = DBUtils.getConnection();
            String sql = "SELECT [VehicleTypeID]\n"
                    + "      ,[TypeName]\n"
                    + "  FROM [AutoWashProDB].[dbo].[VehicleTypes]";
            PreparedStatement st = cn.prepareStatement(sql);
            ResultSet table = st.executeQuery();
            
            while (table.next()) {
                int id = table.getInt("VehicleTypeID");
                String name = table.getString("TypeName");
                
                VehicleType v = new VehicleType(id, name);
                list.add(v);
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
    //tung 14/6 : them func lay vehicle da active
    public List<VehicleType> getAllActiveVehicleType() {
    List<VehicleType> list = new ArrayList<>();
    Connection cn = null;

    try {
        cn = DBUtils.getConnection();

        String sql = "SELECT [VehicleTypeID], [TypeName] "
                + "FROM [dbo].[VehicleTypes] "
                + "WHERE [IsActive] = ?";

        PreparedStatement st = cn.prepareStatement(sql);
        st.setBoolean(1, true);

        ResultSet table = st.executeQuery();

        while (table.next()) {
            int id = table.getInt("VehicleTypeID");
            String name = table.getString("TypeName");

            VehicleType v = new VehicleType(id, name);
            list.add(v);
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
    
    
}
