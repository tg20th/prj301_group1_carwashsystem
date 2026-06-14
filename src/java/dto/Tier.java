
package dto;

public class Tier {
    private int tierID;
    private String tierName;
    private int minWash;
    private double minSpend;
    private double pointRate;

    public Tier() {
    }

    public Tier(String tierName, int minWash, double minSpend, double pointRate) {
        this.tierName = tierName;
        this.minWash = minWash;
        this.minSpend = minSpend;
        this.pointRate = pointRate;
    }

    public Tier(int tierID, String tierName, int minWash, double minSpend, double pointRate) {
        this.tierID = tierID;
        this.tierName = tierName;
        this.minWash = minWash;
        this.minSpend = minSpend;
        this.pointRate = pointRate;
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

    public int getMinWash() {
        return minWash;
    }

    public void setMinWash(int minWash) {
        this.minWash = minWash;
    }

    public double getMinSpend() {
        return minSpend;
    }

    public void setMinSpend(double minSpend) {
        this.minSpend = minSpend;
    }

    public double getPointRate() {
        return pointRate;
    }

    public void setPointRate(double pointRate) {
        this.pointRate = pointRate;
    }

    
}