package dto;

import java.sql.Timestamp;

public class Vehicle {

    private int vehicleID;
    private int customerID;
    private int modelID;
    private String licensePlate;
    private String color;
    private Integer manufactureYear;
    private String imageURL;
    private String status;
    private Timestamp createdAt;
    // ====== thêm field để hiển thị (JOIN) ======
    private String brandName;
    private String modelName;

    public Vehicle() {
    }
    public Vehicle(int customerID, int modelID,
                   String licensePlate, String color,
                   Integer manufactureYear, String imageURL,
                   String status) {
        this.customerID = customerID;
        this.modelID = modelID;
        this.licensePlate = licensePlate;
        this.color = color;
        this.manufactureYear = manufactureYear;
        this.imageURL = imageURL;
        this.status = status;
    }

    public Vehicle(int vehicleID, int customerID, int modelID, String licensePlate, String color, Integer manufactureYear, String imageURL, String status) {
        this.vehicleID = vehicleID;
        this.customerID = customerID;
        this.modelID = modelID;
        this.licensePlate = licensePlate;
        this.color = color;
        this.manufactureYear = manufactureYear;
        this.imageURL = imageURL;
        this.status = status;
    }


    public int getVehicleID() {
        return vehicleID;
    }

    public void setVehicleID(int vehicleID) {
        this.vehicleID = vehicleID;
    }

    public int getCustomerID() {
        return customerID;
    }

    public void setCustomerID(int customerID) {
        this.customerID = customerID;
    }

    public int getModelID() {
        return modelID;
    }

    public void setModelID(int modelID) {
        this.modelID = modelID;
    }

    public String getLicensePlate() {
        return licensePlate;
    }

    public void setLicensePlate(String licensePlate) {
        this.licensePlate = licensePlate;
    }

    public String getColor() {
        return color;
    }

    public void setColor(String color) {
        this.color = color;
    }

    public Integer getManufactureYear() {
        return manufactureYear;
    }

    public void setManufactureYear(Integer manufactureYear) {
        this.manufactureYear = manufactureYear;
    }

    public String getImageURL() {
        return imageURL;
    }

    public void setImageURL(String imageURL) {
        this.imageURL = imageURL;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public String getBrandName() {
        return brandName;
    }

    public void setBrandName(String brandName) {
        this.brandName = brandName;
    }

    public String getModelName() {
        return modelName;
    }

    public void setModelName(String modelName) {
        this.modelName = modelName;
    }

    // ====== Convenience methods for JSP / Controller compatibility ======
    public String getBrand() {
        return brandName;
    }

    public void setBrand(String brand) {
        this.brandName = brand;
    }

    public String getModel() {
        return modelName;
    }

    public void setModel(String model) {
        this.modelName = model;
    }

    public boolean isActive() {
        return "Active".equalsIgnoreCase(status);
    }
}