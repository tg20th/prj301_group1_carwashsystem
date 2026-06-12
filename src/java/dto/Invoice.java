
package dto;

import java.sql.Date;

public class Invoice {
    private int id;
    private int cusID;
    private int vehicleID;
    private int washbayID;
    private int promotionID;
    private int cusRewardID;
    private Date date;
    private Date appointTime;
    private String status;
    private String payMethod;
    private int subTotal;
    private int discountAmount;
    private int finalTotal;
    private String note;

    public Invoice() {
    }

    public Invoice(int id, int cusID, int vehicleID, int washbayID, int promotionID, int cusRewardID, Date date, Date appointTime, String status, String payMethod, int subTotal, int discountAmount, int finalTotal, String note) {
        this.id = id;
        this.cusID = cusID;
        this.vehicleID = vehicleID;
        this.washbayID = washbayID;
        this.promotionID = promotionID;
        this.cusRewardID = cusRewardID;
        this.date = date;
        this.appointTime = appointTime;
        this.status = status;
        this.payMethod = payMethod;
        this.subTotal = subTotal;
        this.discountAmount = discountAmount;
        this.finalTotal = finalTotal;
        this.note = note;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getCusID() {
        return cusID;
    }

    public void setCusID(int cusID) {
        this.cusID = cusID;
    }

    public int getVehicleID() {
        return vehicleID;
    }

    public void setVehicleID(int vehicleID) {
        this.vehicleID = vehicleID;
    }

    public int getWashbayID() {
        return washbayID;
    }

    public void setWashbayID(int washbayID) {
        this.washbayID = washbayID;
    }

    public int getPromotionID() {
        return promotionID;
    }

    public void setPromotionID(int promotionID) {
        this.promotionID = promotionID;
    }

    public int getCusRewardID() {
        return cusRewardID;
    }

    public void setCusRewardID(int cusRewardID) {
        this.cusRewardID = cusRewardID;
    }

    public Date getDate() {
        return date;
    }

    public void setDate(Date date) {
        this.date = date;
    }

    public Date getAppointTime() {
        return appointTime;
    }

    public void setAppointTime(Date appointTime) {
        this.appointTime = appointTime;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getPayMethod() {
        return payMethod;
    }

    public void setPayMethod(String payMethod) {
        this.payMethod = payMethod;
    }

    public int getSubTotal() {
        return subTotal;
    }

    public void setSubTotal(int subTotal) {
        this.subTotal = subTotal;
    }

    public int getDiscountAmount() {
        return discountAmount;
    }

    public void setDiscountAmount(int discountAmount) {
        this.discountAmount = discountAmount;
    }

    public int getFinalTotal() {
        return finalTotal;
    }

    public void setFinalTotal(int finalTotal) {
        this.finalTotal = finalTotal;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }
     
}
