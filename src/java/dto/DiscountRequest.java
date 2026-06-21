package dto;

public class DiscountRequest {

    private int customerId;
    private int tierId;
    private long subTotal;
    private Integer promotionId;

    public DiscountRequest() {
    }

    public DiscountRequest(int customerId, int tierId, long subTotal, Integer promotionId) {
        this.customerId = customerId;
        this.tierId = tierId;
        this.subTotal = subTotal;
        this.promotionId = promotionId;
    }

    public int getCustomerId() {
        return customerId;
    }

    public void setCustomerId(int customerId) {
        this.customerId = customerId;
    }

    public int getTierId() {
        return tierId;
    }

    public void setTierId(int tierId) {
        this.tierId = tierId;
    }

    public long getSubTotal() {
        return subTotal;
    }

    public void setSubTotal(long subTotal) {
        this.subTotal = subTotal;
    }

    public Integer getPromotionId() {
        return promotionId;
    }

    public void setPromotionId(Integer promotionId) {
        this.promotionId = promotionId;
    }
}