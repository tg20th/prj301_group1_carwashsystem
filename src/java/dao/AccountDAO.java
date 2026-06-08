package dao;

import dbutils.DBUtils;
import dto.Account;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class AccountDAO {

    public int createAccount(Account a) {
        int result = 0;
        Connection cn = null;

        try {
            cn = DBUtils.getConnection();
            String sql = "insert into Accounts ([RoleID], "
                    + "[Password],"
                    + "[FirstName],[LastName],"
                    + "[Phone],[Email],"
                    + "[IsActive],[CreatedAt]) \n"
                    + "values (?,?,?,?,?,?,?,?)";

            PreparedStatement st = cn.prepareStatement(sql);
            st.setInt(1, 2);
            st.setString(2, a.getPassword());
            st.setString(3, a.getFirstName());
            st.setString(4, a.getLastName());
            st.setString(5, a.getPhone());
            st.setString(6, a.getEmail());
            st.setBoolean(7, true);
            st.setDate(8, new Date(System.currentTimeMillis()));

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

    private Account getAccountField(String sql, String value) {
        Connection cn = null;
        Account result = null;
        try {
            cn = DBUtils.getConnection();
            if (cn != null) {
                PreparedStatement st = cn.prepareStatement(sql);
                st.setString(1, value);

                ResultSet table = st.executeQuery();
                while (table.next()) {
                    int accID = table.getInt("AccountID");
                    String password = table.getString("Password");
                    String phone = table.getString("Phone");
                    String email = table.getString("Email");
                    String firstName = table.getString("FirstName");
                    String lastName = table.getString("LastName");
                    Date createAt = table.getDate("CreatedAt");

                    result = new Account(accID, firstName, lastName, password, phone, email, createAt);
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

    public Account getAccountByEmail(String email) {
        String sql = "select [AccountID], "
                + "[FirstName], [LastName], "
                + "[Password], [Phone],"
                + "[Email],[CreatedAt]\n"
                + "from Accounts where Email = ?";

        return getAccountField(sql, email);
    }

    public Account getAccountByPhone(String phone) {
        String sql = "select [AccountID], "
                + "[FirstName], [LastName], "
                + "[Password], [Phone],"
                + "[Email],[CreatedAt]\n"
                + "from Accounts where Phone = ?";

        return getAccountField(sql, phone);
    }

    public int updateAccount(int accID, String firstName, String lastName, 
            String email, String phone, String password) {
        int result = 0;
        Connection cn = null;
        
        try {
            cn = DBUtils.getConnection();
            if (cn != null) {
                String sql = "UPDATE Accounts "
                        + "SET [FirstName] = ?, "
                        + "[LastName] = ?, "
                        + "[Phone] = ?, "
                        + "[Email] = ?, "
                        + "[Password] = ? "
                        + "WHERE [AccountID] = ?";
                PreparedStatement st = cn.prepareStatement(sql);
                st.setString(1, firstName);
                st.setString(2, lastName);
                st.setString(3, phone);
                st.setString(4, email);
                st.setString(5, password);
                st.setInt(6, accID);
                
                result = st.executeUpdate();
            }
        }catch(Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (cn != null) {
                    cn.close();
                }
            } catch(Exception e) {
                e.printStackTrace();
            }
        }
        return result;
    }

    public Account login(String email, String password) {
        Account result = null;
        Connection cn = null;

        try {
            cn = DBUtils.getConnection();

            String sql = "select [AccountID], [RoleID], "
                    + "[FirstName], [LastName], [Password], [Phone], "
                    + "[Email], [IsActive], [CreatedAt] "
                    + "from Accounts "
                    + "where Email = ? and Password = ? and IsActive = 1";

            PreparedStatement st = cn.prepareStatement(sql);
            st.setString(1, email);
            st.setString(2, password);

            ResultSet table = st.executeQuery();

            if (table.next()) {
                result = new Account(
                        table.getInt("AccountID"),
                        table.getInt("RoleID"),
                        table.getString("FirstName"),
                        table.getString("LastName"),
                        table.getString("Password"),
                        table.getString("Phone"),
                        table.getString("Email"),
                        table.getString("IsActive"),
                        table.getDate("CreatedAt")
                );
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
