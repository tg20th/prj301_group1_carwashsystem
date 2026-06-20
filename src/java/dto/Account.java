
package dto;

import java.sql.Date;
import java.sql.Timestamp;

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
    private java.sql.Timestamp lastLoginAt; 
    private String reasonRejected;
    
    private String typeUser; //dung de phan biet loai khach hang

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

    public Account(int accountID, String firstName, String lastName, String password, String phone, String email, String status) {
        this.accountID = accountID;
        this.firstName = firstName;
        this.lastName = lastName;
        this.password = password;
        this.phone = phone;
        this.email = email;
        this.status = status;
    }

    public Account(int accountID, String firstName, String lastName, String phone, String email, String status, Timestamp lastLoginAt, String typeUser) {
        this.accountID = accountID;
        this.firstName = firstName;
        this.lastName = lastName;
        this.phone = phone;
        this.email = email;
        this.status = status;
        this.lastLoginAt = lastLoginAt;
        this.typeUser = typeUser;
    }

    public String getReasonRejected() {
        return reasonRejected;
    }

    public void setReasonRejected(String reasonRejected) {
        this.reasonRejected = reasonRejected;
    }

    public String getTypeUser() {
        return typeUser;
    }

    public void setTypeUser(String typeUser) {
        this.typeUser = typeUser;
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

    public String getStatus() {
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

    public Timestamp getLastLoginAt() {
        return lastLoginAt;
    }

    public void setLastLoginAt(Timestamp lastLoginAt) {
        this.lastLoginAt = lastLoginAt;
    }
    
}
