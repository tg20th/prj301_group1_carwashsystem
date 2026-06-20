package dto;

public class DiscountResult {

    private long subTotal;
    private long discountAmount;
    private long finalAmount;
    private Integer appliedPromotionId;
    private String promotionName;
    private int discountPercent;

    public DiscountResult() {
    }

    public DiscountResult(long subTotal, long discountAmount, long finalAmount) {
        this.subTotal = subTotal;
        this.discountAmount = discountAmount;
        this.finalAmount = finalAmount;
    }

    public long getSubTotal() {
        return subTotal;
    }

    public void setSubTotal(long subTotal) {
        this.subTotal = subTotal;
    }

    public long getDiscountAmount() {
        return discountAmount;
    }

    public void setDiscountAmount(long discountAmount) {
        this.discountAmount = discountAmount;
    }

    public long getFinalAmount() {
        return finalAmount;
    }

    public void setFinalAmount(long finalAmount) {
        this.finalAmount = finalAmount;
    }

    public Integer getAppliedPromotionId() {
        return appliedPromotionId;
    }

    public void setAppliedPromotionId(Integer appliedPromotionId) {
        this.appliedPromotionId = appliedPromotionId;
    }

    public String getPromotionName() {
        return promotionName;
    }

    public void setPromotionName(String promotionName) {
        this.promotionName = promotionName;
    }

    public int getDiscountPercent() {
        return discountPercent;
    }

    public void setDiscountPercent(int discountPercent) {
        this.discountPercent = discountPercent;
    }
}