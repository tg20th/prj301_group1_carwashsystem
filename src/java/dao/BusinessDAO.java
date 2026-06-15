package dao;

import dbutils.DBUtils;
import dto.Business;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

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
            st.setInt(1, b.getCusID());
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

    public Business getBussinessByCusID(int id) {
        Connection cn = null;
        Business result = null;
        try {
            cn = DBUtils.getConnection();
            if (cn != null) {
                String sql = "SELECT a.AccountID, Email ,[Phone],[Password],\n"
                        + "       [LastName] +' ' + [FirstName] AS FullName,[Status],\n"
                        + "       b.CompanyName, b.TaxCode, b.CompanyAddress\n"
                        + "  FROM [dbo].[Accounts] a JOIN Customers c\n"
                        + "  ON c.AccountID = a.AccountID\n"
                        + "  JOIN BusinessCustomers b ON b.CustomerID = c.CustomerID\n"
                        + "  WHERE c.CustomerID = ?";
                PreparedStatement st = cn.prepareStatement(sql);
                st.setInt(1, id);

                ResultSet table = st.executeQuery();
                while (table.next()) {
                    String email = table.getString("Email");
                    String phone = table.getString("Phone");
                    String password = table.getString("Password");
                    String cusName = table.getString("FullName");
                    String busName = table.getString("CompanyName");
                    String taxCode = table.getString("TaxCode");
                    String address = table.getString("CompanyAddress");

                    result = new Business(cusName, email, phone, busName, taxCode, address);
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

    public Business getBussinessByName(String name) {
        Business result = null;
        String sql = "SELECT [CustomerID]\n"
                + "      ,[TaxCode], [CompanyName]\n"
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
                + "      ,[TaxCode]\n"
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

    public List<Business> getAllPendingBus() {
        List<Business> list = new ArrayList<>();
        Connection cn = null;
        try {
            cn = DBUtils.getConnection();
            String sql = "SELECT a.AccountID, Email ,[Phone],[Password],\n"
                    + "       [LastName] +' ' + [FirstName] AS FullName,[Status],\n"
                    + "       b.CompanyName, b.TaxCode, b.CompanyAddress\n"
                    + "  FROM [dbo].[Accounts] a JOIN Customers c\n"
                    + "  ON c.AccountID = a.AccountID\n"
                    + "  JOIN BusinessCustomers b ON b.CustomerID = c.CustomerID\n"
                    + "  WHERE [Status] = 'Pending'";

            PreparedStatement st = cn.prepareStatement(sql);
            ResultSet table = st.executeQuery();

            while (table.next()) {
                int id = table.getInt("AccountID");
                String name = table.getString("FullName");
                String email = table.getString("Email");
                String phone = table.getString("Phone");
                String companyName = table.getString("CompanyName");
                String tax = table.getString("TaxCode");
                String address = table.getString("CompanyAddress");
                String status = table.getString("Status");

                Business b = new Business(id, name, email, phone, status, companyName, tax, address);
                list.add(b);
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
