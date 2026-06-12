/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dto;

import java.time.LocalDateTime;

/**
 *
 * @author PC
 */
public class TimeSlot {
    private String timeslotID;
    private LocalDateTime start;
    private LocalDateTime end;
    private boolean status;

    public TimeSlot(String timeslotID, LocalDateTime start, LocalDateTime end, boolean status) {
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

    public boolean isStatus() {
        return status;
    }

    public void setStatus(boolean status) {
        this.status = status;
    }
    
    
}
