package dao;

import dbutils.DBUtils;
import dto.Service;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ServicesDAO {

    public List<Service> getAllServices() {
        List<Service> list = new ArrayList<>();
        Connection cn = null;

        try {
            cn = DBUtils.getConnection();
            String sql = "SELECT [ServiceID] ,[ServiceName] ,[Description] , [IsActive]\n"
                    + "  FROM [dbo].[Services]";

            PreparedStatement st = cn.prepareStatement(sql);
            ResultSet table = st.executeQuery();

            while (table.next()) {
                int id = table.getInt("ServiceID");
                String name = table.getString("ServiceName");
                String description = table.getString("Description");
                boolean status = table.getBoolean("IsActive");

                Service t = new Service(id, name, description, status);
                list.add(t);
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

    public Service getServiceByID(int id) {
        Service result = null;
        Connection cn = null;

        try {
            cn = DBUtils.getConnection();
            String sql = "SELECT [ServiceID]\n"
                    + "      ,[ServiceName]\n"
                    + "      ,[Description]\n"
                    + "      ,[IsActive]\n"
                    + "  FROM [AutoWashProDB].[dbo].[Services]"
                    + " Where [ServiceID] = ?";

            PreparedStatement st = cn.prepareStatement(sql);
            st.setInt(1, id);
            ResultSet table = st.executeQuery();
            if (table.next()) {
                result = new Service();
                result.setId(table.getInt("ServiceID")); 
                result.setName(table.getString("ServiceName"));
                result.setDescription(table.getString("Description"));
                result.setStatus(table.getBoolean("IsActive"));
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

    public int createService(Service service) {
        int newServiceID = 0;
        Connection cn = null;

        try {
            cn = DBUtils.getConnection();

            String sql = "INSERT INTO [dbo].[Services]\n"
                    + "       ([ServiceName]\n"
                    + "      ,[Description]\n"
                    + "      ,[IsActive])"
                    + " VALUES(?,?,?)";

            PreparedStatement st = cn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS);
            st.setString(1, service.getName());
            st.setString(2, service.getDescription());
            st.setBoolean(3, true);

            int affectedRows = st.executeUpdate();
            
            if (affectedRows > 0) {
                ResultSet generatedKey = st.getGeneratedKeys();
                
                if (generatedKey.next()) {
                    newServiceID = generatedKey.getInt(1);
                }
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
        return newServiceID;
    }

    public int updateService(Service s) {
        int result = 0;
        Connection cn = null;

        try {
            cn = DBUtils.getConnection();
            String sql = "UPDATE [dbo].[Services]  "
                    + "SET [ServiceName] = ?\n"
                    + "      ,[Description] = ?\n"
                    + "      ,[IsActive] = ?\n"
                    + "WHERE [ServiceID] = ?";
            PreparedStatement st = cn.prepareStatement(sql);
            st.setString(1, s.getName());
            st.setString(2, s.getDescription());
            st.setBoolean(3, s.isStatus());
            st.setInt(4, s.getId());
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

    public int deactiveService(int serviceID) {
        int result = 0;
        Connection cn = null;

        try {
            cn = DBUtils.getConnection();
            String sql = "UPDATE [dbo].[Services]\n"
                    + "SET [IsActive] = ?\n"
                    + "WHERE [ServiceID] = ?";
            PreparedStatement st = cn.prepareStatement(sql);
            st.setBoolean(1, false);
            st.setInt(2, serviceID);
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

    public int activeService(int serviceID) {
        int result = 0;
        Connection cn = null;

        try {
            cn = DBUtils.getConnection();
            String sql = "UPDATE [dbo].[Services] \n"
                    + "SET [IsActive] = ?\n"
                    + "WHERE [ServiceID] = ?";
            PreparedStatement st = cn.prepareStatement(sql);
            st.setBoolean(1, true);
            st.setInt(2, serviceID);
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
