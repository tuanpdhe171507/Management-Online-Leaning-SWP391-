/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author Trongnd
 */
public class Answer {
    private int id;
    private String content;
    private boolean correctless;

    public Answer() {
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public boolean isCorrectless() {
        return correctless;
    }

    public void setCorrectless(boolean correctless) {
        this.correctless = correctless;
    }
    
}
