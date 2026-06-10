
package dto;

import java.sql.Date;

public class Promotion {
    private int id;
    private String name;
    private int discountPercent;
    private Date startDate;
    private Date endDate;
    private String description;
    private boolean status;

    public Promotion() {
    }

    public Promotion(int id, String name, int discountPercent, Date startDate, Date endDate, String description, boolean status) {
        this.id = id;
        this.name = name;
        this.discountPercent = discountPercent;
        this.startDate = startDate;
        this.endDate = endDate;
        this.description = description;
        this.status = status;
    }

    public Promotion(String name, Date endDate, String description) {
        this.name = name;
        this.endDate = endDate;
        this.description = description;
    }

    
    public Promotion(int id, String name, Date endDate, String description, boolean status) {
        this.id = id;
        this.name = name;
        this.endDate = endDate;
        this.description = description;
        this.status = status;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public int getDiscountPercent() {
        return discountPercent;
    }

    public void setDiscountPercent(int discountPercent) {
        this.discountPercent = discountPercent;
    }

    public Date getStartDate() {
        return startDate;
    }

    public void setStartDate(Date startDate) {
        this.startDate = startDate;
    }

    public Date getEndDate() {
        return endDate;
    }

    public void setEndDate(Date endDate) {
        this.endDate = endDate;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public boolean isStatus() {
        return status;
    }

    public void setStatus(boolean status) {
        this.status = status;
    }
    
    
}
