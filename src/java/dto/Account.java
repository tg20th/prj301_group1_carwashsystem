
package dto;

import java.sql.Date;

public class Account {
    private int accountID;
    private int roleID;
    private String firstName;
    private String lastName;
    private String password;
    private String phone;
    private String email;
    private String status;
    private Date createAt;

    public Account() {
    }

    public Account(int accountID, String firstName, String lastName, String password, String phone, String email) {
        this.accountID = accountID;
        this.firstName = firstName;
        this.lastName = lastName;
        this.password = password;
        this.phone = phone;
        this.email = email;
    }

    public Account(int accountID, String firstName, String lastName, String password, String phone, String email, Date createAt) {
        this.accountID = accountID;
        this.firstName = firstName;
        this.lastName = lastName;
        this.password = password;
        this.phone = phone;
        this.email = email;
        this.createAt = createAt;
    }
    

    public Account(int accountID, int roleID, String firstName, String lastName, String password, String phone, String email, String status, Date createAt) {
        this.accountID = accountID;
        this.roleID = roleID;
        this.firstName = firstName;
        this.lastName = lastName;
        this.password = password;
        this.phone = phone;
        this.email = email;
        this.status = status;
        this.createAt = createAt;
    }

    public Account(int roleID, String firstName, String lastName, String password, String phone, String email, String status, Date createAt) {
        this.roleID = roleID;
        this.firstName = firstName;
        this.lastName = lastName;
        this.password = password;
        this.phone = phone;
        this.email = email;
        this.status = status;
        this.createAt = createAt;
    }

    public Account(String firstName, String lastName, String password, String phone, String email, String status, Date createAt) {
        this.firstName = firstName;
        this.lastName = lastName;
        this.password = password;
        this.phone = phone;
        this.email = email;
        this.status = status;
        this.createAt = createAt;
    }

    public Account(String firstName, String lastName, String password, String phone, String email) {
        this.firstName = firstName;
        this.lastName = lastName;
        this.password = password;
        this.phone = phone;
        this.email = email;
    }

    public Account(String firstName, String lastName, String password, String phone, String email, Date createAt) {
        this.firstName = firstName;
        this.lastName = lastName;
        this.password = password;
        this.phone = phone;
        this.email = email;
        this.createAt = createAt;
    }

    public int getAccountID() {
        return accountID;
    }

    public void setAccountID(int accountID) {
        this.accountID = accountID;
    }

    public int getRoleID() {
        return roleID;
    }

    public void setRoleID(int roleID) {
        this.roleID = roleID;
    }

    public String isStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Date getCreateAt() {
        return createAt;
    }

    public void setCreateAt(Date createAt) {
        this.createAt = createAt;
    }

    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public String getLastName() {
        return lastName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }
    
}
