/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.util.Date;

/**
 *
 * @author HieuTC
 */
public class Video {
    private int id;
    private String name;
    private String type;
    private float time;
    private String path;
    private Date uploadedUpdate;

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

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public float getTime() {
        return time;
    }

    public void setTime(float time) {
        this.time = time;
    }

    public String getPath() {
        return path;
    }

    public void setPath(String path) {
        this.path = path;
    }

    public Date getUploadedUpdate() {
        return uploadedUpdate;
    }

    public void setUploadedUpdate(Date uploadedUpdate) {
        this.uploadedUpdate = uploadedUpdate;
    }
    
    public int getMinutes(){
        return (this.time < 60 ? 1 : (int)(Math.floor(this.time / 60)));
    }
    
}
