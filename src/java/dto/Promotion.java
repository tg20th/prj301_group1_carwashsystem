package dto;

import java.sql.Date;

public class Promotion {

    private int promotionID;
    private String promoCode;
    private String promotionName;
    private String targetType;
    private int discountPercent; // Dùng int, xử lý mặc định 0 từ SQL
    private double discountAmount; // Dùng double để tính toán chính xác
    private Date startDate;
    private Date endDate;
    private String description;
    private boolean isActive;

    public Promotion() {
    }

    public Promotion(int promotionID, String promoCode, String promotionName, String targetType, int discountPercent, double discountAmount, Date startDate, Date endDate, String description, boolean isActive) {
        this.promotionID = promotionID;
        this.promoCode = promoCode;
        this.promotionName = promotionName;
        this.targetType = targetType;
        this.discountPercent = discountPercent;
        this.discountAmount = discountAmount;
        this.startDate = startDate;
        this.endDate = endDate;
        this.description = description;
        this.isActive = isActive;
    }

    public Promotion(String promotionName, Date endDate, String description) {
        this.promotionName = promotionName;
        this.endDate = endDate;
        this.description = description;
    }


    public int getPromotionID() {
        return promotionID;
    }

    public void setPromotionID(int promotionID) {
        this.promotionID = promotionID;
    }

    public String getPromoCode() {
        return promoCode;
    }

    public void setPromoCode(String promoCode) {
        this.promoCode = promoCode;
    }

    public String getPromotionName() {
        return promotionName;
    }

    public void setPromotionName(String promotionName) {
        this.promotionName = promotionName;
    }

    public String getTargetType() {
        return targetType;
    }

    public void setTargetType(String targetType) {
        this.targetType = targetType;
    }

    public int getDiscountPercent() {
        return discountPercent;
    }

    public void setDiscountPercent(int discountPercent) {
        this.discountPercent = discountPercent;
    }

    public double getDiscountAmount() {
        return discountAmount;
    }

    public void setDiscountAmount(double discountAmount) {
        this.discountAmount = discountAmount;
    }

    public Date getStartDate() {
        return startDate;
    }

    public void setStartDate(Date startDate) {
        this.startDate = startDate;
    }

    public Date getEndDate() {
        return endDate;
    }

    public void setEndDate(Date endDate) {
        this.endDate = endDate;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public boolean isActive() {
        return isActive;
    }

    public void setActive(boolean active) {
        this.isActive = active;
    }
}
