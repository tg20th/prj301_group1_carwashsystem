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
                    + "      ,[Status] \n"
                    + "  FROM [AutoWashProDB].[dbo].[WashBays]";

            PreparedStatement st = cn.prepareStatement(sql);
            ResultSet table = st.executeQuery();

            while (table.next()) {
                int wbID = table.getInt("washBayID");
                String bayName = table.getString("bayName");
                String description = table.getString("description");
                String status = table.getString("status");

                WashBay wb = new WashBay(wbID, bayName, description, status);
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

    // lay tat ca nhung wash dang la AVAILABLE
    public List<WashBay> getAvailableWashBays() {

        List<WashBay> wbList = new ArrayList<>();
        Connection cn = null;

        try {
            cn = DBUtils.getConnection();
            String sql = "SELECT [WashBayID]\n"
                    + "      ,[BayName]\n"
                    + "      ,[Description]\n"
                    + "      ,[Status] \n"
                    + "  FROM [AutoWashProDB].[dbo].[WashBays]"
                    + "  WHERE [Status] = 'Available' ";

            PreparedStatement st = cn.prepareStatement(sql);
            ResultSet table = st.executeQuery();

            while (table.next()) {
                int wbID = table.getInt("washBayID");
                String bayName = table.getString("bayName");
                String description = table.getString("description");
                String status = table.getString("status");

                WashBay wb = new WashBay(wbID, bayName, description, status);
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
    }
    
    // lay ds trang thai cua wb
    public List<WashBay> getWashBayByStatus(String s) {

        List<WashBay> wbList = new ArrayList<>();
        Connection cn = null;

        try {
            cn = DBUtils.getConnection();
            String sql = "SELECT [WashBayID]\n"
                    + "      ,[BayName]\n"
                    + "      ,[Description]\n"
                    + "      ,[Status] \n"
                    + "  FROM [AutoWashProDB].[dbo].[WashBays]"
                    + "  WHERE [Status] = ? ";

            PreparedStatement st = cn.prepareStatement(sql);
            st.setString(1, s);
            ResultSet table = st.executeQuery();

            while (table.next()) {
                int wbID = table.getInt("washBayID");
                String bayName = table.getString("bayName");
                String description = table.getString("description");
                String status = table.getString("status");

                WashBay wb = new WashBay(wbID, bayName, description, status);
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
    }

    public WashBay getWashBayByID(int id) {
        WashBay result = null;
        Connection cn = null;

        try {
            cn = DBUtils.getConnection();
            String sql = "SELECT [WashBayID]\n"
                    + "      ,[BayName]\n"
                    + "      ,[Description]\n"
                    + "      ,[Status] \n"
                    + "  FROM [AutoWashProDB].[dbo].[WashBays]\n"
                    + "  WHERE [WashBayID] = ?";

            PreparedStatement st = cn.prepareStatement(sql);
            st.setInt(1, id);
            ResultSet table = st.executeQuery();

            if (table.next()) {
                int wbID = table.getInt("washBayID");
                String bayName = table.getString("bayName");
                String description = table.getString("description");
                String status = table.getString("status");

                result = new WashBay(wbID, bayName, description, status);
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

    public boolean isWashBayAvailable(int id) {
        WashBay wb = getWashBayByID(id);
        if (wb == null) { // ktra du phong neu db sai
            return false;
        }
        return wb.isAvailable();
    }
    
    private static final String SLOT_STATUS_SQL =
            "CASE "
            + "WHEN wb.Status = 'Maintenance' THEN 'Maintenance' "
            + "WHEN wb.Status = 'Unavailable' THEN 'Unavailable' "
            + "WHEN EXISTS ("
            + "  SELECT 1 FROM Bookings b "
            + "  WHERE b.WashBayID = wb.WashBayID "
            + "    AND b.TimeSlotID = ? "
            + "    AND b.Status NOT IN ('Cancelled', 'NoShow')"
            + ") THEN 'Unavailable' "
            + "ELSE 'Available' END";

    public List<dto.WashBaySlotDTO> getWashBaysForTimeSlot(int timeSlotId) {
        List<dto.WashBaySlotDTO> list = new ArrayList<>();
        Connection cn = null;
        try {
            cn = DBUtils.getConnection();
            String sql = "SELECT wb.WashBayID, wb.BayName, wb.Description, wb.Status AS BaseStatus, "
                    + SLOT_STATUS_SQL + " AS SlotStatus "
                    + "FROM WashBays wb ORDER BY wb.BayName";
            PreparedStatement st = cn.prepareStatement(sql);
            st.setInt(1, timeSlotId);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                list.add(new dto.WashBaySlotDTO(
                        rs.getInt("WashBayID"),
                        rs.getString("BayName"),
                        rs.getString("Description"),
                        rs.getString("BaseStatus"),
                        rs.getString("SlotStatus")
                ));
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

    public List<dto.WashBaySlotDTO> getAvailableWashBaysForTimeSlot(int timeSlotId) {
        List<dto.WashBaySlotDTO> all = getWashBaysForTimeSlot(timeSlotId);
        List<dto.WashBaySlotDTO> available = new ArrayList<>();
        for (dto.WashBaySlotDTO bay : all) {
            if (bay.isSelectable()) {
                available.add(bay);
            }
        }
        return available;
    }

    public boolean isWashBayBookableInSlot(int washBayId, int timeSlotId) {
        Connection cn = null;
        try {
            cn = DBUtils.getConnection();
            String sql = "SELECT " + SLOT_STATUS_SQL + " AS SlotStatus "
                    + "FROM WashBays wb WHERE wb.WashBayID = ?";
            PreparedStatement st = cn.prepareStatement(sql);
            st.setInt(1, timeSlotId);
            st.setInt(2, washBayId);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return WashBay.AVAILABLE.equalsIgnoreCase(rs.getString("SlotStatus"));
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
        return false;
    }

    public boolean updateWashBay(WashBay wb) {
        boolean result = false;
        Connection cn = null;
        try {
            cn = DBUtils.getConnection();
            String sql = "UPDATE [AutoWashProDB].[dbo].[WashBays]\n"
                    + "      SET [BayName] = ?\n"
                    + "      ,[Description] = ?\n"
                    + "      ,[Status] = ?\n"
                    + "      WHERE [WashBayID] = ?";

            PreparedStatement st = cn.prepareStatement(sql);
            st.setString(1, wb.getBayName());
            st.setString(2, wb.getDescription());
            st.setString(3, wb.getStatus());
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
