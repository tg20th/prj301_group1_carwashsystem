package dto;

public class WashBaySlotDTO {

    private int washBayID;
    private String bayName;
    private String description;
    private String baseStatus;
    private String slotStatus;

    public WashBaySlotDTO() {
    }

    public WashBaySlotDTO(int washBayID, String bayName, String description,
            String baseStatus, String slotStatus) {
        this.washBayID = washBayID;
        this.bayName = bayName;
        this.description = description;
        this.baseStatus = baseStatus;
        this.slotStatus = slotStatus;
    }

    public int getWashBayID() {
        return washBayID;
    }

    public void setWashBayID(int washBayID) {
        this.washBayID = washBayID;
    }

    public String getBayName() {
        return bayName;
    }

    public void setBayName(String bayName) {
        this.bayName = bayName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getBaseStatus() {
        return baseStatus;
    }

    public void setBaseStatus(String baseStatus) {
        this.baseStatus = baseStatus;
    }

    public String getSlotStatus() {
        return slotStatus;
    }

    public void setSlotStatus(String slotStatus) {
        this.slotStatus = slotStatus;
    }

    public boolean isSelectable() {
        return WashBay.AVAILABLE.equalsIgnoreCase(slotStatus);
    }
}