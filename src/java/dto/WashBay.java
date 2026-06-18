/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dto;

/**
 *
 * @author Admin
 */
public class WashBay {

    private int washBayID;
    private String bayName;
    private String description;
    private String status;
    public static final String AVAILABLE = "Available";
    public static final String UNAVAILABLE = "Unavailable";
    public static final String MAINTENANCE = "Maintenance";

    public WashBay() {
    }

    public WashBay(int washBayId, String bayName, String description, String status) {
        this.washBayID = washBayId;
        this.bayName = bayName;
        this.description = description;
        this.status = status;
    }

    public WashBay(String bayName, String description, String status) {
        this.bayName = bayName;
        this.description = description;
        this.status = status;
    }

    public int getWashBayID() {
        return washBayID;
    }

    public void setWashBayID(int washBayId) {
        this.washBayID = washBayId;
    }

    public String getBayName() {
        return bayName;
    }

    public void setBayName(String bayName) {
        this.bayName = bayName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
    
    public boolean isAvailable() {
        return AVAILABLE.equalsIgnoreCase(status);
    }
    
    public boolean isMaintenance() {
        return MAINTENANCE.equalsIgnoreCase(status);
    }

    public boolean isUnavailable() {
        return UNAVAILABLE.equalsIgnoreCase(status);
    }
    

    

}
