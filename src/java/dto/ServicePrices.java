/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dto;

import java.math.BigDecimal;

/**
 *
 * @author ASUS
 */
public class ServicePrices {
    private int serviceID;
    private int vehicleTypeID;
    private BigDecimal price;
    private int durations;

    public ServicePrices() {
    }

    public ServicePrices(int serviceID, int vehicleTypeID, BigDecimal price, int durations) {
        this.serviceID = serviceID;
        this.vehicleTypeID = vehicleTypeID;
        this.price = price;
        this.durations = durations;
    }

    public int getServiceID() {
        return serviceID;
    }

    public void setServiceID(int serviceID) {
        this.serviceID = serviceID;
    }

    public int getVehicleTypeID() {
        return vehicleTypeID;
    }

    public void setVehicleTypeID(int vehicleTypeID) {
        this.vehicleTypeID = vehicleTypeID;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    public int getDurations() {
        return durations;
    }

    public void setDurations(int durations) {
        this.durations = durations;
    }
    
    
    
}
