
package dto;

public class Tier {
    private int tierID;
    private String tierName;
    private int minSpend;
    private double pointRate;
    private String desciption;
    private boolean status;
    private int totalCus;

    public Tier(int tierID, String tierName, int totalCus) {
        this.tierID = tierID;
        this.tierName = tierName;
        this.totalCus = totalCus;
    }

    public Tier(int tierID, String tierName, int minSpend, double pointRate, String desciption, boolean status, int totalCus) {
        this.tierID = tierID;
        this.tierName = tierName;
        this.minSpend = minSpend;
        this.pointRate = pointRate;
        this.desciption = desciption;
        this.status = status;
        this.totalCus = totalCus;
    }

    public Tier(String tierName, int minSpend, double pointRate, String desciption, boolean status) {
        this.tierName = tierName;
        this.minSpend = minSpend;
        this.pointRate = pointRate;
        this.desciption = desciption;
        this.status = status;
    }

    
    
    public Tier(int tierID, String tierName, int minSpend, double pointRate, boolean status, int totalCus) {
        this.tierID = tierID;
        this.tierName = tierName;
        this.minSpend = minSpend;
        this.pointRate = pointRate;
        this.status = status;
        this.totalCus = totalCus;
    }

    public String getDesciption() {
        return desciption;
    }

    public void setDesciption(String desciption) {
        this.desciption = desciption;
    }
    
    

    public boolean isStatus() {
        return status;
    }

    public void setStatus(boolean status) {
        this.status = status;
    }

    public int getTotalCus() {
        return totalCus;
    }

    public void setTotalCus(int totalCus) {
        this.totalCus = totalCus;
    }
    

    public Tier() {
    }


    public int getTierID() {
        return tierID;
    }

    public void setTierID(int tierID) {
        this.tierID = tierID;
    }

    public String getTierName() {
        return tierName;
    }

    public void setTierName(String tierName) {
        this.tierName = tierName;
    }


    public int getMinSpend() {
        return minSpend;
    }

    public void setMinSpend(int minSpend) {
        this.minSpend = minSpend;
    }

    public double getPointRate() {
        return pointRate;
    }

    public void setPointRate(double pointRate) {
        this.pointRate = pointRate;
    }

    
}