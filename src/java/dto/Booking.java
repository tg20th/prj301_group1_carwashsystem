
package dto;

import java.sql.Date;
import java.time.LocalDateTime;

public class Booking {
    private int bookingID;
    private int customerID;
    private String cusName;
    private String licensePlate;
    private String service;
    private Date bookingDate;
    private LocalDateTime appointmentTime;
    private String status;
    private int washBayId;
    private Integer timeSlotID;

    // Additional fields for createBooking
    private int vehicleID;
    private int serviceID;
    private int invoiceID;
    private int quantity;
    private double priceAtOrder;
    private int durationAtOrder;
    private String notes;

    public Booking(int id, String cusName, String licensePlate, String service, Date bookingDate, LocalDateTime appointmentTime, String status) {
        this.bookingID = id;
        this.cusName = cusName;
        this.licensePlate = licensePlate;
        this.service = service;
        this.bookingDate = bookingDate;
        this.appointmentTime = appointmentTime;
        this.status = status;
    }
    
    

    public Booking(int id, String cusName, String licensePlate, String service, LocalDateTime appointmentTime, String status, int washBayId) {
        this.bookingID = id;
        this.cusName = cusName;
        this.licensePlate = licensePlate;
        this.service = service;
        this.appointmentTime = appointmentTime;
        this.status = status;
        this.washBayId = washBayId;
    }

    public Booking() {
    }

    public Date getBookingDate() {
        return bookingDate;
    }

    public void setBookingDate(Date bookingDate) {
        this.bookingDate = bookingDate;
    }

    public Booking(int id, String cusName, String licensePlate, String service, String status) {
        this.bookingID = id;
        this.cusName = cusName;
        this.licensePlate = licensePlate;
        this.service = service;
        this.status = status;
    }

    public Booking(int id, String cusName, String licensePlate, String service, LocalDateTime appointmentTime, String status) {
        this.bookingID = id;
        this.cusName = cusName;
        this.licensePlate = licensePlate;
        this.service = service;
        this.appointmentTime = appointmentTime;
        this.status = status;
    }
    
    

    public int getId() {
        return bookingID;
    }

    public void setId(int id) {
        this.bookingID = id;
    }

    public String getCusName() {
        return cusName;
    }

    public void setCusName(String cusName) {
        this.cusName = cusName;
    }

    public String getLicensePlate() {
        return licensePlate;
    }

    public void setLicensePlate(String licensePlate) {
        this.licensePlate = licensePlate;
    }

    public String getService() {
        return service;
    }

    public void setService(String service) {
        this.service = service;
    }

    public LocalDateTime getAppointmentTime() {
        return appointmentTime;
    }

    public void setAppointmentTime(LocalDateTime appointmentTime) {
        this.appointmentTime = appointmentTime;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public int getWashBayId() {
        return washBayId;
    }

    public void setWashBayId(int washBayId) {
        this.washBayId = washBayId;
    }

    public Integer getTimeSlotID() {
        return timeSlotID;
    }

    public void setTimeSlotID(Integer timeSlotID) {
        this.timeSlotID = timeSlotID;
    }

    // Getters/Setters for createBooking and full entity support
    public int getCustomerID() {
        return customerID;
    }

    public void setCustomerID(int customerID) {
        this.customerID = customerID;
    }

    public int getVehicleID() {
        return vehicleID;
    }

    public void setVehicleID(int vehicleID) {
        this.vehicleID = vehicleID;
    }

    public int getServiceID() {
        return serviceID;
    }

    public void setServiceID(int serviceID) {
        this.serviceID = serviceID;
    }

    public int getInvoiceID() {
        return invoiceID;
    }

    public void setInvoiceID(int invoiceID) {
        this.invoiceID = invoiceID;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public double getPriceAtOrder() {
        return priceAtOrder;
    }

    public void setPriceAtOrder(double priceAtOrder) {
        this.priceAtOrder = priceAtOrder;
    }

    public int getDurationAtOrder() {
        return durationAtOrder;
    }

    public void setDurationAtOrder(int durationAtOrder) {
        this.durationAtOrder = durationAtOrder;
    }

    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
    }
    
}



