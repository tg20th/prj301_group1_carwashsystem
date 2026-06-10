
package dto;

import java.sql.Date;
import java.time.LocalDateTime;

public class Booking {
    private int id;
    private String cusName;
    private String licensePlate;
    private String service;
    private Date bookingDate;
    private LocalDateTime appointmentTime;
    private String status;
    private int washBayId;

    public Booking(int id, String cusName, String licensePlate, String service, Date bookingDate, LocalDateTime appointmentTime, String status) {
        this.id = id;
        this.cusName = cusName;
        this.licensePlate = licensePlate;
        this.service = service;
        this.bookingDate = bookingDate;
        this.appointmentTime = appointmentTime;
        this.status = status;
    }
    
    

    public Booking(int id, String cusName, String licensePlate, String service, LocalDateTime appointmentTime, String status, int washBayId) {
        this.id = id;
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
        this.id = id;
        this.cusName = cusName;
        this.licensePlate = licensePlate;
        this.service = service;
        this.status = status;
    }

    public Booking(int id, String cusName, String licensePlate, String service, LocalDateTime appointmentTime, String status) {
        this.id = id;
        this.cusName = cusName;
        this.licensePlate = licensePlate;
        this.service = service;
        this.appointmentTime = appointmentTime;
        this.status = status;
    }
    
    

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
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
    
    
    
}



