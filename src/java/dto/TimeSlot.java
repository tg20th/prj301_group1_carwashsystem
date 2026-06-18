package dto;

import java.time.LocalDateTime;

public class TimeSlot {
    private String timeslotID;
    private LocalDateTime start;
    private LocalDateTime end;
    private String status;

    public TimeSlot(String timeslotID, LocalDateTime start, LocalDateTime end, String status) {
        this.timeslotID = timeslotID;
        this.start = start;
        this.end = end;
        this.status = status;
    }

    public String getTimeslotID() {
        return timeslotID;
    }

    public void setTimeslotID(String timeslotID) {
        this.timeslotID = timeslotID;
    }

    public LocalDateTime getStart() {
        return start;
    }

    public void setStart(LocalDateTime start) {
        this.start = start;
    }

    public LocalDateTime getEnd() {
        return end;
    }

    public void setEnd(LocalDateTime end) {
        this.end = end;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public boolean isAvailable() {
        return TimeSlotDTO.AVAILABLE.equals(status);
    }
}