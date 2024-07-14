/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.util.ArrayList;

/**
 *
 * @author HuyLQ
 */
public class Wishlist {

    private ArrayList<Course> courseId;
    private User email;

    public ArrayList<Course> getCourseId() {
        return courseId;
    }

    public void setCourseId(ArrayList<Course> courseId) {
        this.courseId = courseId;
    }

    public User getEmail() {
        return email;
    }

    public void setEmail(User email) {
        this.email = email;
    }

}
