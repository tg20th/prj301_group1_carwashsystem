package dto;

public class Vehicle {
    private int vehicleID;
    private int customerID;
    private String licensePlate;
    private String brand;
    private String model;
    private String color;
    private boolean active;

    public Vehicle() {
    }

    public Vehicle(int vehicleID, int customerID, String licensePlate, String brand, String model, String color, boolean active) {
        this.vehicleID = vehicleID;
        this.customerID = customerID;
        this.licensePlate = licensePlate;
        this.brand = brand;
        this.model = model;
        this.color = color;
        this.active = active;
    }

    public Vehicle(int customerID, String licensePlate, String brand, String model, String color, boolean active) {
        this.customerID = customerID;
        this.licensePlate = licensePlate;
        this.brand = brand;
        this.model = model;
        this.color = color;
        this.active = active;
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

    public String getLicensePlate() {
        return licensePlate;
    }

    public void setLicensePlate(String licensePlate) {
        this.licensePlate = licensePlate;
    }

    public String getBrand() {
        return brand;
    }

    public void setBrand(String brand) {
        this.brand = brand;
    }

    public String getModel() {
        return model;
    }

    public void setModel(String model) {
        this.model = model;
    }

    public String getColor() {
        return color;
    }

    public void setColor(String color) {
        this.color = color;
    }

    public boolean isActive() {
        return active;
    }

    public boolean getIsActive() {
        return active;
    }

    public void setActive(boolean active) {
        this.active = active;
    }

    public void setIsActive(boolean active) {
        this.active = active;
    }
    
    
}