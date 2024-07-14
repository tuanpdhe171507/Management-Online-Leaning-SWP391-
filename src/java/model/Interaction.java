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
public class Interaction {
    private int id;
    private Question question;
    private float atTime;
    private String position;
    private String size;
    private Date addedTime;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public Question getQuestion() {
        return question;
    }

    public void setQuestion(Question question) {
        this.question = question;
    }

    public float getAtTime() {
        return atTime;
    }

    public void setAtTime(float atTime) {
        this.atTime = atTime;
    }

    public String getPosition() {
        return position;
    }

    public void setPosition(String position) {
        this.position = position;
    }

    public String getSize() {
        return size;
    }

    public void setSize(String size) {
        this.size = size;
    }

    public Date getAddedTime() {
        return addedTime;
    }

    public void setAddedTime(Date addedTime) {
        this.addedTime = addedTime;
    }

    public String getFormatedTime() {
        int second = (int)(Math.floor(this.atTime % 60));
        return String.valueOf((int)(Math.floor(this.atTime / 60)))
                + ":" + ((second < 10) ? "0" + String.valueOf(second) 
                : String.valueOf(second));
    }
}
