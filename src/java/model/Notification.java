/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.text.SimpleDateFormat;
import java.util.Date;

/**
 *
 * @author HieuTC
 */
public class Notification {
    private int id;
    private String message;
    private String hyperLink;
    private boolean read;
    private boolean hiddenState;
    private Date receivedTime;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public String getHyperLink() {
        return hyperLink;
    }

    public void setHyperLink(String hyperLink) {
        this.hyperLink = hyperLink;
    } 

    public boolean isRead() {
        return read;
    }

    public void setRead(boolean read) {
        this.read = read;
    }

    public boolean isHiddenState() {
        return hiddenState;
    }

    public void setHiddenState(boolean hiddenState) {
        this.hiddenState = hiddenState;
    }

    public Date getReceivedTime() {
        return receivedTime;
    }

    public void setReceivedTime(Date receivedTime) {
        this.receivedTime = receivedTime;
    }
    
    public String getFormattedDatetime() {
        return new SimpleDateFormat("MMM dd, HH:mm")
                    .format(this.receivedTime);
    }
}
