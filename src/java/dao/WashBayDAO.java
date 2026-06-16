/*
     * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
     * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import dto.WashBay;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import dbutils.DBUtils;
import java.util.List;

public class WashBayDAO {

    public List<WashBay> getAllWashBays() {

        List<WashBay> wbList = new ArrayList<>();
        Connection cn = null;

        try {
            cn = DBUtils.getConnection();
            String sql = "SELECT [WashBayID]\n"
                    + "      ,[BayName]\n"
                    + "      ,[Description]\n"
                    + "      ,[IsActive]\n"
                    + "  FROM [AutoWashProDB].[dbo].[WashBays]";

            PreparedStatement st = cn.prepareStatement(sql);
            ResultSet table = st.executeQuery();

            while (table.next()) {
                int wbID = table.getInt("washBayID");
                String bayName = table.getString("bayName");
                String description = table.getString("description");
                boolean isActive = table.getBoolean("isActive");

                WashBay wb = new WashBay(wbID, bayName, description, isActive);
                wbList.add(wb);

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

        return wbList;
    } // end func

    public WashBay getWashBayByID(int id) {
        WashBay result = null;
        Connection cn = null;

        try {
            cn = DBUtils.getConnection();
            String sql = "SELECT [WashBayID]\n"
                    + "      ,[BayName]\n"
                    + "      ,[Description]\n"
                    + "      ,[IsActive]\n"
                    + "  FROM [AutoWashProDB].[dbo].[WashBays]\n"
                    + "  WHERE [WashBayID] = ?";

            PreparedStatement st = cn.prepareStatement(sql);
            st.setInt(1, id);
            ResultSet table = st.executeQuery();

            if (table.next()) {
                int wbID = table.getInt("washBayID");
                String bayName = table.getString("bayName");
                String description = table.getString("description");
                boolean isActive = table.getBoolean("isActive");

                result = new WashBay(wbID, bayName, description, isActive);
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
    } // end func

    public boolean updateWashBay(WashBay wb) {
        boolean result = false;
        Connection cn = null;
        try {
            cn = DBUtils.getConnection();
            String sql = "UPDATE [AutoWashProDB].[dbo].[WashBays]\n"
                    + "      SET [BayName] = ?\n"
                    + "      ,[Description] = ?\n"
                    + "      ,[IsActive] = ?\n"
                    + "      WHERE [WashBayID] = ?";

            PreparedStatement st = cn.prepareStatement(sql);
            st.setString(1, wb.getBayName());
            st.setString(2, wb.getDescription());
            st.setBoolean(3, wb.isIsActive());
            st.setInt(4, wb.getWashBayID());

            int row = st.executeUpdate();

            if (row > 0) {
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
        }

        return result;
    }// end func

}
