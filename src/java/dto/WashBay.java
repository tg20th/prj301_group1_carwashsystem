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
    private boolean isActive;

    public WashBay() {
    }

    public WashBay(int washBayId, String bayName, String description, boolean isActive) {
        this.washBayID = washBayId;
        this.bayName = bayName;
        this.description = description;
        this.isActive = isActive;
    }

    public WashBay(String bayName, String description, boolean isActive) {
        this.bayName = bayName;
        this.description = description;
        this.isActive = isActive;
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

    public boolean isIsActive() {
        return isActive;
    }

    public void setIsActive(boolean isActive) {
        this.isActive = isActive;
    }
    
    
}
