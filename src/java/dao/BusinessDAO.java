package dao;

import dbutils.DBUtils;
import dto.Business;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class BusinessDAO {

    public int creatBussiness(Business b) {
        int result = 0;
        Connection cn = null;

        try {
            cn = DBUtils.getConnection();
            String sql = "  INSERT INTO BusinessCustomers "
                    + "([CustomerID], [CompanyName], [TaxCode], [CompanyAddress]) "
                    + "VALUES (?, ?, ?, ?)";

            PreparedStatement st = cn.prepareStatement(sql);
            st.setInt(1, b.getId());
            st.setString(2, b.getBusinessName());
            st.setString(3, b.getTaxCode());
            st.setString(4, b.getCompanyAddress());

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

    private Business getBussinessField(String sql, String value) {
        Connection cn = null;
        Business result = null;
        try {
            cn = DBUtils.getConnection();
            if (cn != null) {
                PreparedStatement st = cn.prepareStatement(sql);
                st.setString(1, value);

                ResultSet table = st.executeQuery();
                while (table.next()) {
                    int busID = table.getInt("CustomerID");
                    String busName = table.getString("CompanyName");
                    String taxCode = table.getString("TaxCode");
                    String address = table.getString("CompanyAddress");

                    result = new Business(busID, busName, taxCode, address);
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
        return result;
    }

    public Business getBussinessByID(String id) {
        Business result = null;
        String sql = "SELECT [CompanyName]\n"
                + "      ,[TaxCode]\n"
                + "      ,[CompanyAddress]\n"
                + "  FROM [AutoWashProDB].[dbo].[BusinessCustomers] \n"
                + "  WHERE [CustomerID] = ?";

        result = getBussinessField(sql, id);
        return result;
    }

    public Business getBussinessByName(String name) {
        Business result = null;
        String sql = "SELECT [CustomerID]\n"
                + "      ,[TaxCode]\n"
                + "      ,[CompanyAddress]\n"
                + "  FROM [AutoWashProDB].[dbo].[BusinessCustomers] \n"
                + "  WHERE [CompanyName] = ?";

        result = getBussinessField(sql, name);
        return result;
    }
    
    public Business getBussinessByTax(String tax) {
        Business result = null;
        String sql = "SELECT [CustomerID]\n"
                + "      ,[CompanyName]\n"
                + "      ,[CompanyAddress]\n"
                + "  FROM [AutoWashProDB].[dbo].[BusinessCustomers] \n"
                + "  WHERE [TaxCode] = ?";

        result = getBussinessField(sql, tax);
        return result;
    }

    public int updateBussiness(int id, String name, String tax, String address) {
        int result = 0;
        Connection cn = null;

        try {
            cn = DBUtils.getConnection();
            String sql = "  UPDATE BusinessCustomers\n"
                    + "      SET [CompanyName] = ?\n"
                    + "      ,[TaxCode] = ?\n"
                    + "      ,[CompanyAddress] = ?\n"
                    + "      WHERE CustomerID = ?";

            PreparedStatement st = cn.prepareStatement(sql);
            st.setString(1, name);
            st.setString(2, tax);
            st.setString(3, address);
            st.setInt(4, id);

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
