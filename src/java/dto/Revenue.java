package dto;

public class Revenue {

    private int month;
    private long totalRevenue;
    private int totalBooking;
    private double growthRate;

    public Revenue() {
    }

    public Revenue(int month, long totalRevenue, int totalBooking) {
        this.month = month;
        this.totalRevenue = totalRevenue;
        this.totalBooking = totalBooking;
    }

    public int getMonth() {
        return month;
    }

    public void setMonth(int month) {
        this.month = month;
    }

    public long getTotalRevenue() {
        return totalRevenue;
    }

    public void setTotalRevenue(long totalRevenue) {
        this.totalRevenue = totalRevenue;
    }

    public int getTotalBooking() {
        return totalBooking;
    }

    public void setTotalBooking(int totalBooking) {
        this.totalBooking = totalBooking;
    }

    public double getGrowthRate() {
        return growthRate;
    }

    public void setGrowthRate(double growthRate) {
        this.growthRate = growthRate;
    }

}
