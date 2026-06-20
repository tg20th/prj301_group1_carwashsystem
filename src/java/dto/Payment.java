
package dto;

public class Payment {
    private String method;
    private long totalAmount;

    public Payment() {
    }

    public Payment(String method, long totalAmount) {
        this.method = method;
        this.totalAmount = totalAmount;
    }

    public String getMethod() {
        return method;
    }

    public void setMethod(String method) {
        this.method = method;
    }

    public long getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(long totalAmount) {
        this.totalAmount = totalAmount;
    }
    
}
