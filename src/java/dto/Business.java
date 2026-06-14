
package dto;

public class Business {
    private int accountId;
    private int cusID;
    private String contractName;
    private String email;
    private String phone;
    private String status;
    private String businessName;
    private String taxCode;
    private String companyAddress;
    
    //trường hợp admin reject business
    private String rejectedDescription;

    public Business() {
    }

    public Business(String contractName, String email, String phone, String businessName, String taxCode, String companyAddress) {
        this.contractName = contractName;
        this.email = email;
        this.phone = phone;
        this.businessName = businessName;
        this.taxCode = taxCode;
        this.companyAddress = companyAddress;
    }
    
    

    public Business(int accountId, int cusID, String contractName, String email, String phone, String status, String businessName, String taxCode, String companyAddress) {
        this.accountId = accountId;
        this.cusID = cusID;
        this.contractName = contractName;
        this.email = email;
        this.phone = phone;
        this.status = status;
        this.businessName = businessName;
        this.taxCode = taxCode;
        this.companyAddress = companyAddress;
    }

    public Business(int cusID, String contractName, String businessName, String taxCode, String companyAddress) {
        this.cusID = cusID;
        this.contractName = contractName;
        this.businessName = businessName;
        this.taxCode = taxCode;
        this.companyAddress = companyAddress;
    }

    public Business(int cusID, String businessName, String taxCode, String companyAddress) {
        this.cusID = cusID;
        this.businessName = businessName;
        this.taxCode = taxCode;
        this.companyAddress = companyAddress;
    }
    
    

    public Business(int accountId, String contractName, String email, String phone, String status, String businessName, String taxCode, String companyAddress) {
        this.accountId = accountId;
        this.contractName = contractName;
        this.email = email;
        this.phone = phone;
        this.status = status;
        this.businessName = businessName;
        this.taxCode = taxCode;
        this.companyAddress = companyAddress;
    }

    

    public String getContractName() {
        return contractName;
    }

    public void setContractName(String contractName) {
        this.contractName = contractName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getBusinessName() {
        return businessName;
    }

    public void setBusinessName(String businessName) {
        this.businessName = businessName;
    }

    public String getTaxCode() {
        return taxCode;
    }

    public void setTaxCode(String taxCode) {
        this.taxCode = taxCode;
    }

    public String getCompanyAddress() {
        return companyAddress;
    }

    public void setCompanyAddress(String companyAddress) {
        this.companyAddress = companyAddress;
    }

    public int getAccountId() {
        return accountId;
    }

    public void setAccountId(int accountId) {
        this.accountId = accountId;
    }

    public int getCusID() {
        return cusID;
    }

    public void setCusID(int cusID) {
        this.cusID = cusID;
    }

   
    
}
