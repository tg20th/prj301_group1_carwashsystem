
package dto;

import java.sql.Date;

public class Customer {
    private int cusID;
    private int accID;
    private int tierID;
    private Date joinedAt;
    private int totalPoint;

    public Customer() {
    }

    public Customer(int accID, int tierID, Date joinedAt, int totalPoint) {
        this.accID = accID;
        this.tierID = tierID;
        this.joinedAt = joinedAt;
        this.totalPoint = totalPoint;
    }

    public Customer(int cusID, int accID, int tierID, Date joinedAt, int totalPoint) {
        this.cusID = cusID;
        this.accID = accID;
        this.tierID = tierID;
        this.joinedAt = joinedAt;
        this.totalPoint = totalPoint;
    }
    
    

    public int getCusID() {
        return cusID;
    }

    public void setCusID(int cusID) {
        this.cusID = cusID;
    }

    public int getAccID() {
        return accID;
    }

    public void setAccID(int accID) {
        this.accID = accID;
    }

    public int getTierID() {
        return tierID;
    }

    public void setTierID(int tierID) {
        this.tierID = tierID;
    }

    public Date getJoinedAt() {
        return joinedAt;
    }

    public void setJoinedAt(Date joinedAt) {
        this.joinedAt = joinedAt;
    }

    public int getTotalPoint() {
        return totalPoint;
    }

    public void setTotalPoint(int totalPoint) {
        this.totalPoint = totalPoint;
    }
    
}
