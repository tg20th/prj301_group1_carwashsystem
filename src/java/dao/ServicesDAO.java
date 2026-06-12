package dao;

import dbutils.DBUtils;
import dto.Service;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class ServicesDAO {

    public List<Service> getAllServices() {
        List<Service> list = new ArrayList<>();
        Connection cn = null;

        try {
            cn = DBUtils.getConnection();
            String sql = "SELECT [ServiceID] ,[ServiceName] ,[IsActive]\n"
                    + "  FROM [dbo].[Services]";

            PreparedStatement st = cn.prepareStatement(sql);
            ResultSet table = st.executeQuery();

            while (table.next()) {
                int id = table.getInt("ServiceID");
                String name = table.getString("ServiceName");
                boolean status = table.getBoolean("IsActive");

                Service t = new Service(id, name, status);
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
}
