/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;
import java.sql.*;
/**
 *
 * @author TuanPD
 */
public class AccessibleCourse {
    private String email;
    private Course course;
    private Timestamp date;
    private int hiddenState;

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public Course getCourse() {
        return course;
    }

    public void setCourse(Course course) {
        this.course = course;
    }
   

    public Timestamp getDate() {
        return date;
    }

    public void setDate(Timestamp date) {
        this.date = date;
    }

    public int getHiddenState() {
        return hiddenState;
    }

    public void setHiddenState(int hiddenState) {
        this.hiddenState = hiddenState;
    }
    
}
