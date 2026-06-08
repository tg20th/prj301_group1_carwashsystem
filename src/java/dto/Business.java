
package dto;

public class Business {
    private int id;
    private String businessName;
    private String taxCode;
    private String companyAddress;

    public Business() {
    }

    public Business(int id, String businessName, String taxCode, String companyAddress) {
        this.id = id;
        this.businessName = businessName;
        this.taxCode = taxCode;
        this.companyAddress = companyAddress;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
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

   
    
}
