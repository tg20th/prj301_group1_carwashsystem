package dto;

import java.time.LocalDateTime;

public class InvoiceHistorySummary {

    private int invoiceId;
    private LocalDateTime invoiceDate;
    private long subTotal;
    private long discountAmount;
    private long finalAmount;
    private String paymentStatus;
    private String paymentMethod;
    private String promotionName;
    private String serviceSummary;
    private int bookingCount;
    private String bookingStatus;
    private LocalDateTime scheduleStart;
    private LocalDateTime scheduleEnd;
    private String customerName;

    public int getInvoiceId() {
        return invoiceId;
    }

    public void setInvoiceId(int invoiceId) {
        this.invoiceId = invoiceId;
    }

    public LocalDateTime getInvoiceDate() {
        return invoiceDate;
    }

    public void setInvoiceDate(LocalDateTime invoiceDate) {
        this.invoiceDate = invoiceDate;
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

    public String getPaymentStatus() {
        return paymentStatus;
    }

    public void setPaymentStatus(String paymentStatus) {
        this.paymentStatus = paymentStatus;
    }

    public String getPaymentMethod() {
        return paymentMethod;
    }

    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }

    public String getPromotionName() {
        return promotionName;
    }

    public void setPromotionName(String promotionName) {
        this.promotionName = promotionName;
    }

    public String getServiceSummary() {
        return serviceSummary;
    }

    public void setServiceSummary(String serviceSummary) {
        this.serviceSummary = serviceSummary;
    }

    public int getBookingCount() {
        return bookingCount;
    }

    public void setBookingCount(int bookingCount) {
        this.bookingCount = bookingCount;
    }

    public String getBookingStatus() {
        return bookingStatus;
    }

    public void setBookingStatus(String bookingStatus) {
        this.bookingStatus = bookingStatus;
    }

    public LocalDateTime getScheduleStart() {
        return scheduleStart;
    }

    public void setScheduleStart(LocalDateTime scheduleStart) {
        this.scheduleStart = scheduleStart;
    }

    public LocalDateTime getScheduleEnd() {
        return scheduleEnd;
    }

    public void setScheduleEnd(LocalDateTime scheduleEnd) {
        this.scheduleEnd = scheduleEnd;
    }

    public String getCustomerName() {
        return customerName;
    }

    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }
}