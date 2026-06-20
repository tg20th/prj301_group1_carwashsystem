package dao;

import dbutils.DBUtils;
import dto.Account;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

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
                    + "[Status],[CreatedAt]) \n"
                    + "values (?,?,?,?,?,?,?,?)";

            PreparedStatement st = cn.prepareStatement(sql);
            st.setInt(1, 2);
            st.setString(2, a.getPassword());
            st.setString(3, a.getFirstName());
            st.setString(4, a.getLastName());
            st.setString(5, a.getPhone());
            st.setString(6, a.getEmail());
            st.setString(7, a.getStatus());
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
                    int roleID = table.getInt("RoleID");
                    String password = table.getString("Password");
                    String phone = table.getString("Phone");
                    String email = table.getString("Email");
                    String firstName = table.getString("FirstName");
                    String lastName = table.getString("LastName");
                    Date createAt = table.getDate("CreatedAt");

                    result = new Account(accID, firstName, lastName, password, phone, email, createAt);
                    result.setRoleID(roleID);

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
        String sql = "select [AccountID], [RoleID],"
                + "[FirstName], [LastName], "
                + "[Password], [Phone],"
                + "[Email],[CreatedAt]\n"
                + "from Accounts where Email = ?";

        return getAccountField(sql, email);
    }

    public Account getAccountByPhone(String phone) {
        String sql = "select [AccountID],[RoleID], "
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

    public Account getFullAccountByEmail(String email) {
        Account result = null;
        Connection cn = null;

        try {
            cn = DBUtils.getConnection();
            if (cn != null) {
                String sql = "SELECT [AccountID], [RoleID], "
                        + "[FirstName], [LastName], [Password], [Phone], "
                        + "[Email], [Status], [CreatedAt], [LastLoginAt] "
                        + "FROM Accounts WHERE Email = ?";

                PreparedStatement st = cn.prepareStatement(sql);
                st.setString(1, email);

                ResultSet rs = st.executeQuery();

                if (rs.next()) {
                    result = new Account(
                            rs.getInt("AccountID"),
                            rs.getInt("RoleID"),
                            rs.getString("FirstName"),
                            rs.getString("LastName"),
                            rs.getString("Password"),
                            rs.getString("Phone"),
                            rs.getString("Email"),
                            rs.getString("Status"),
                            rs.getDate("CreatedAt")
                    );
                    result.setLastLoginAt(rs.getTimestamp("LastLoginAt"));
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

    public int updateLastLogin(int accountID) {
        int result = 0;
        Connection cn = null;

        try {
            cn = DBUtils.getConnection();
            if (cn != null) {
                // Dùng GETDATE() của SQL Server để lấy thời gian chính xác trên DB server
                String sql = "UPDATE Accounts SET [LastLoginAt] = GETDATE() WHERE [AccountID] = ?";
                PreparedStatement st = cn.prepareStatement(sql);
                st.setInt(1, accountID);

                result = st.executeUpdate();
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
                        table.getString("Status"),
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

    public int getTotalPendingAccount() {
        int result = 0;
        Connection cn = null;

        try {
            cn = DBUtils.getConnection();
            String sql = "SELECT ISNULL(COUNT(*), 0) AS [NumOfPending]\n"
                    + "FROM [AutoWashProDB].[dbo].[Accounts] WHERE [Status] = 'Pending'";

            PreparedStatement st = cn.prepareStatement(sql);

            ResultSet table = st.executeQuery();
            while (table.next()) {
                result = table.getInt("NumOfPending");
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

    public int updateStatusOfAccount(int id, String status, String reason) {
        int result = 0;
        Connection cn = null;

        try {
            cn = DBUtils.getConnection();
            String sql = "  UPDATE Accounts SET Status = ?, [RejectReason] = ? WHERE AccountID = ?";

            PreparedStatement st = cn.prepareStatement(sql);
            st.setString(1, status);
            st.setString(2, reason);
            st.setInt(3, id);

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

    public List<Account> getAllUser() {
        List<Account> list = new ArrayList<>();
        Connection cn = null;
        try {
            cn = DBUtils.getConnection();

            String sql = "SELECT\n"
                    + "    a.AccountID,\n"
                    + "    a.FirstName,\n"
                    + "    a.LastName,\n"
                    + "    a.Email,\n"
                    + "    a.Phone,\n"
                    + "    a.LastLoginAt,\n"
                    + "    a.Status,\n"
                    + "    CASE\n"
                    + "        WHEN a.RoleID = 1 THEN 'Admin'\n"
                    + "        WHEN bc.CustomerID IS NOT NULL THEN 'Business'\n"
                    + "        ELSE 'Customer'\n"
                    + "    END AS UserType\n"
                    + "FROM Accounts a\n"
                    + "LEFT JOIN Customers c\n"
                    + "    ON a.AccountID = c.AccountID\n"
                    + "LEFT JOIN BusinessCustomers bc\n"
                    + "    ON c.CustomerID = bc.CustomerID\n"
                    + "WHERE a.RoleID IN (1, 2) AND status IN ('Active','Frozen')";

            PreparedStatement st = cn.prepareStatement(sql);
            ResultSet table = st.executeQuery();

            while (table.next()) {
                Account a = new Account(table.getInt("AccountID"),
                        table.getString("FirstName"),
                        table.getString("LastName"),
                        table.getString("Phone"),
                        table.getString("Email"),
                        table.getString("Status"),
                        table.getTimestamp("LastLoginAt"),
                        table.getString("UserType"));

                list.add(a);
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

    public List<Account> getUserByStatus(String status) {
        List<Account> list = new ArrayList<>();
        Connection cn = null;
        try {
            cn = DBUtils.getConnection();

            String sql = "SELECT\n"
                    + "    a.AccountID,\n"
                    + "    a.FirstName,\n"
                    + "    a.LastName,\n"
                    + "    a.Email,\n"
                    + "    a.Phone,\n"
                    + "    a.LastLoginAt,\n"
                    + "    a.Status,\n"
                    + "    CASE\n"
                    + "        WHEN a.RoleID = 1 THEN 'Admin'\n"
                    + "        WHEN bc.CustomerID IS NOT NULL THEN 'Business'\n"
                    + "        ELSE 'Customer'\n"
                    + "    END AS UserType\n"
                    + "FROM Accounts a\n"
                    + "LEFT JOIN Customers c\n"
                    + "    ON a.AccountID = c.AccountID\n"
                    + "LEFT JOIN BusinessCustomers bc\n"
                    + "    ON c.CustomerID = bc.CustomerID\n"
                    + "WHERE a.RoleID IN (1, 2) AND status = ?";

            PreparedStatement st = cn.prepareStatement(sql);
            st.setString(1, status);
            ResultSet table = st.executeQuery();

            while (table.next()) {
                Account a = new Account(table.getInt("AccountID"),
                        table.getString("FirstName"),
                        table.getString("LastName"),
                        table.getString("Phone"),
                        table.getString("Email"),
                        table.getString("Status"),
                        table.getTimestamp("LastLoginAt"),
                        table.getString("UserType"));

                list.add(a);
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

    public List<Account> filterUsers(String status, String userType, String search, int page, int pageSize) {
        List<Account> list = new ArrayList<>();
        Connection cn = null;

        try {
            cn = DBUtils.getConnection();

            String sql
                    = "SELECT "
                    + "a.AccountID, "
                    + "a.FirstName, "
                    + "a.LastName, "
                    + "a.Email, "
                    + "a.Phone, "
                    + "a.LastLoginAt, "
                    + "a.Status, "
                    + "CASE "
                    + "WHEN a.RoleID = 1 THEN 'Admin' "
                    + "WHEN bc.CustomerID IS NOT NULL THEN 'Business' "
                    + "ELSE 'Customer' "
                    + "END AS UserType "
                    + "FROM Accounts a "
                    + "LEFT JOIN Customers c "
                    + "ON a.AccountID = c.AccountID "
                    + "LEFT JOIN BusinessCustomers bc "
                    + "ON c.CustomerID = bc.CustomerID "
                    + "WHERE a.RoleID IN (1,2) AND a.Status IN ('Active','Frozen')";

            if (!"ALL".equals(status)) {
                sql += " AND a.Status = ? ";
            }

            if (!"ALL".equals(userType)) {
                sql += " AND (CASE "
                        + "WHEN a.RoleID = 1 THEN 'Admin' "
                        + "WHEN bc.CustomerID IS NOT NULL THEN 'Business' "
                        + "ELSE 'Customer' "
                        + "END) = ? ";
            }

            if (!search.trim().isEmpty()) {
                sql += " AND ("
                        + "a.FirstName LIKE ? "
                        + "OR a.LastName LIKE ? "
                        + "OR a.Email LIKE ? "
                        + "OR a.Phone LIKE ? "
                        + ") ";
            }

            sql += " ORDER BY a.AccountID DESC "
                    + " OFFSET ? ROWS "
                    + " FETCH NEXT ? ROWS ONLY ";

            PreparedStatement st = cn.prepareStatement(sql);
            int index = 1;

            if (!"ALL".equals(status)) {
                st.setString(index++, status);
            }

            if (!"ALL".equals(userType)) {
                st.setString(index++, userType);
            }

            if (!search.trim().isEmpty()) {
                String keyword = "%" + search.trim() + "%";

                st.setString(index++, keyword);
                st.setString(index++, keyword);
                st.setString(index++, keyword);
                st.setString(index++, keyword);
            }

            st.setInt(index++, (page - 1) * pageSize);
            st.setInt(index++, pageSize);

            ResultSet table = st.executeQuery();

            while (table.next()) {
                Account acc = new Account();

                acc.setAccountID(table.getInt("AccountID"));
                acc.setFirstName(table.getString("FirstName"));
                acc.setLastName(table.getString("LastName"));
                acc.setEmail(table.getString("Email"));
                acc.setPhone(table.getString("Phone"));
                acc.setLastLoginAt(table.getTimestamp("LastLoginAt"));
                acc.setStatus(table.getString("Status"));
                acc.setTypeUser(table.getString("UserType"));

                list.add(acc);
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (cn != null) {
                    cn.close();
                }
            } catch (Exception e) {
            }
        }
        return list;
    }
    

    public int getTotalFilteredUsers(String status, String userType, String search) {
        int result = 0;
        Connection cn = null;

        try {
            cn = DBUtils.getConnection();

            String sql = "SELECT COUNT(*) AS Total "
                    + "FROM Accounts a "
                    + "LEFT JOIN Customers c ON a.AccountID = c.AccountID "
                    + "LEFT JOIN BusinessCustomers bc ON c.CustomerID = bc.CustomerID "
                    + "WHERE a.RoleID IN (1,2) AND a.Status IN ('Active','Frozen')";

            // Filter theo Status
            if (!"ALL".equals(status)) {
                sql += " AND a.Status = ? ";
            }

            // Filter theo UserType 
            if (!"ALL".equals(userType)) {
                sql += " AND (CASE "
                        + "WHEN a.RoleID = 1 THEN 'Admin' "
                        + "WHEN bc.CustomerID IS NOT NULL THEN 'Business' "
                        + "ELSE 'Customer' "
                        + "END) = ? ";
            }

            // Filter theo Search
            if (search != null && !search.trim().isEmpty()) {
                sql += " AND ("
                        + "a.FirstName LIKE ? "
                        + "OR a.LastName LIKE ? "
                        + "OR a.Email LIKE ? "
                        + "OR a.Phone LIKE ? "
                        + ") ";
            }

            PreparedStatement st = cn.prepareStatement(sql);
            int index = 1;

            if (!"ALL".equals(status)) {
                st.setString(index++, status);
            }

            if (!"ALL".equals(userType)) {
                st.setString(index++, userType);
            }

            if (search != null && !search.trim().isEmpty()) {
                String keyword = "%" + search.trim() + "%";
                st.setString(index++, keyword);
                st.setString(index++, keyword);
                st.setString(index++, keyword);
                st.setString(index++, keyword);
            }

            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                result = rs.getInt("Total");
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
