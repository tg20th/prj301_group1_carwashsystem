package service;

public class PayOSPaymentResult {

    private final String qrCode;
    private final String paymentLinkId;
    private final String checkoutUrl;
    private final long orderCode;

    public PayOSPaymentResult(String qrCode, String paymentLinkId, String checkoutUrl, long orderCode) {
        this.qrCode = qrCode;
        this.paymentLinkId = paymentLinkId;
        this.checkoutUrl = checkoutUrl;
        this.orderCode = orderCode;
    }

    public String getQrCode() {
        return qrCode;
    }

    public String getPaymentLinkId() {
        return paymentLinkId;
    }

    public String getCheckoutUrl() {
        return checkoutUrl;
    }

    public long getOrderCode() {
        return orderCode;
    }
}