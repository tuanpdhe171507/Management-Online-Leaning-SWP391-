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
public class Device {
    private String os;
    private String browser;
    private String ip;
    private Date detectedTime;
    private Date lastedActivity;
    private final SimpleDateFormat day =  new SimpleDateFormat("MMM dd, yyyy");
    
    public String getOs() {
        return os;
    }

    public void setOs(String os) {
        this.os = os;
    }

    public String getBrowser() {
        return browser;
    }

    public void setBrowser(String browser) {
        this.browser = browser;
    }

    public String getIp() {
        return ip;
    }

    public void setIp(String ip) {
        this.ip = ip;
    }

    public String getDetectedTime() {
        return day.format(detectedTime);
    }

    public void setDetectedTime(Date detectedTime) {
        this.detectedTime = detectedTime;
    }
    
    public String getLastedActivity() {
        return day.format(lastedActivity);
    }

    public void setLastedActivity(Date lastedActivity) {
        this.lastedActivity = lastedActivity;
    }
    
}
