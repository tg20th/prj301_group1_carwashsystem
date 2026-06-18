package dto;

import java.time.LocalDate;
import java.time.LocalDateTime;

public class TimeSlotDTO {

    private int slotId;
    private LocalDate slotDate;
    private LocalDateTime startTime;
    private LocalDateTime endTime;
    private boolean isFull;
    private int bookedCount;
    private int availableBayCount;
    private int totalBayCount;

    public TimeSlotDTO() {
    }

    public TimeSlotDTO(int slotId, LocalDate slotDate, LocalDateTime startTime,
            LocalDateTime endTime, boolean isFull) {
        this.slotId = slotId;
        this.slotDate = slotDate;
        this.startTime = startTime;
        this.endTime = endTime;
        this.isFull = isFull;
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

    public boolean isFull() {
        return isFull;
    }

    public void setFull(boolean full) {
        isFull = full;
    }

    public int getBookedCount() {
        return bookedCount;
    }

    public void setBookedCount(int bookedCount) {
        this.bookedCount = bookedCount;
    }

    public int getAvailableBayCount() {
        return availableBayCount;
    }

    public void setAvailableBayCount(int availableBayCount) {
        this.availableBayCount = availableBayCount;
    }

    public int getTotalBayCount() {
        return totalBayCount;
    }

    public void setTotalBayCount(int totalBayCount) {
        this.totalBayCount = totalBayCount;
    }

    public boolean hasAvailability() {
        return !isFull && availableBayCount > 0;
    }
}