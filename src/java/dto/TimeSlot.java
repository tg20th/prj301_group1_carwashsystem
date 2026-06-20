package dto;

import java.time.LocalDateTime;

public class TimeSlot {
    private String timeslotID;
    private LocalDateTime start;
    private LocalDateTime end;
    private boolean isFull;

    public TimeSlot(String timeslotID, LocalDateTime start, LocalDateTime end, boolean isFull) {
        this.timeslotID = timeslotID;
        this.start = start;
        this.end = end;
        this.isFull = isFull;
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

    public boolean isFull() {
        return isFull;
    }

    public void setFull(boolean full) {
        isFull = full;
    }

    public boolean isAvailable() {
        return !isFull;
    }
}