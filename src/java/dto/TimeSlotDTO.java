package dto;

import java.time.LocalDate;
import java.time.LocalDateTime;

public class TimeSlotDTO {

    public static final String AVAILABLE = "AVAILABLE";
    public static final String UNAVAILABLE = "UNAVAILABLE";
    public static final String MAINTENANCE = "MAINTENANCE";

    private int slotId;
    private LocalDate slotDate;
    private LocalDateTime startTime;
    private LocalDateTime endTime;
    private String status;
    private String maintenanceNote;

    public TimeSlotDTO() {
    }

    public TimeSlotDTO(int slotId, LocalDate slotDate, LocalDateTime startTime,
            LocalDateTime endTime, String status, String maintenanceNote) {
        this.slotId = slotId;
        this.slotDate = slotDate;
        this.startTime = startTime;
        this.endTime = endTime;
        this.status = status;
        this.maintenanceNote = maintenanceNote;
    }

    public int getSlotId() {
        return slotId;
    }

    public void setSlotId(int slotId) {
        this.slotId = slotId;
    }

    public LocalDate getSlotDate() {
        return slotDate;
    }

    public void setSlotDate(LocalDate slotDate) {
        this.slotDate = slotDate;
    }

    public LocalDateTime getStartTime() {
        return startTime;
    }

    public void setStartTime(LocalDateTime startTime) {
        this.startTime = startTime;
    }

    public LocalDateTime getEndTime() {
        return endTime;
    }

    public void setEndTime(LocalDateTime endTime) {
        this.endTime = endTime;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getMaintenanceNote() {
        return maintenanceNote;
    }

    public void setMaintenanceNote(String maintenanceNote) {
        this.maintenanceNote = maintenanceNote;
    }
}