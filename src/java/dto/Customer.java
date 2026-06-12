
package dto;

import java.sql.Date;

public class Customer {
    private int cusID;
    private int accID;
    private int tierID;
    private Date joinedAt;

    public Customer() {
    }

    public Customer(int accID, int tierID, Date joinedAt) {
        this.accID = accID;
        this.tierID = tierID;
        this.joinedAt = joinedAt;
    }

    public Customer(int cusID, int accID, int tierID, Date joinedAt) {
        this.cusID = cusID;
        this.accID = accID;
        this.tierID = tierID;
        this.joinedAt = joinedAt;
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
}
