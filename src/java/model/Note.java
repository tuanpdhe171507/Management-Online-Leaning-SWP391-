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
public class Note {
    private int id;
    private int lessonId;
    private String lessonName;
    private String atTime;
    private String content;
    private Date notedTime;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getLessonId() {
        return lessonId;
    }

    public void setLessonId(int lessonId) {
        this.lessonId = lessonId;
    }

    public String getLessonName() {
        return lessonName;
    }

    public void setLessonName(String lessonName) {
        this.lessonName = lessonName;
    }

    public String getAtTime() {
        return atTime;
    }

    public void setAtTime(String atTime) {
        this.atTime = atTime;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public Date getNotedTime() {
        return notedTime;
    }

    public void setNotedTime(Date notedTime) {
        this.notedTime = notedTime;
    }
    
    
}
