/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dto;

/**
 *
 * @author ASUS
 */
public class VehicleType {
    private int vehicleTypeID;
    private String typeName;
    private boolean isActive;

    public VehicleType() {
    }

    public VehicleType(int vehicleTypeID, String typeName) {
        this.vehicleTypeID = vehicleTypeID;
        this.typeName = typeName;
    }

    public VehicleType(int vehicleTypeID, String typeName, boolean isActive) {
        this.vehicleTypeID = vehicleTypeID;
        this.typeName = typeName;
        this.isActive = isActive;
    }

    public boolean isIsActive() {
        return isActive;
    }

    public void setIsActive(boolean isActive) {
        this.isActive = isActive;
    }

    
    
    public int getVehicleTypeID() {
        return vehicleTypeID;
    }

    public void setVehicleTypeID(int vehicleTypeID) {
        this.vehicleTypeID = vehicleTypeID;
    }

    public String getTypeName() {
        return typeName;
    }

    public void setTypeName(String typeName) {
        this.typeName = typeName;
    }
    
    
}
