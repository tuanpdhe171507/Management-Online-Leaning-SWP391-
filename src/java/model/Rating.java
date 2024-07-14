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
public class Rating {
    private Profile profile;
    private String courseName;
    private int star;
    private String comment;
    private Date ratedTime;

    public Profile getProfile() {
        return profile;
    }

    public void setProfile(Profile profile) {
        this.profile = profile;
    }

    public String getCourseName() {
        return courseName;
    }

    public void setCourseName(String courseName) {
        this.courseName = courseName;
    }

    
    public int getStar() {
        return star;
    }

    public void setStar(int star) {
        this.star = star;
    }

    public String getComment() {
        return comment;
    }

    public void setComment(String comment) {
        this.comment = comment;
    }

    public Date getRatedTime() {
        return ratedTime;
    }

    public void setRateTime(Date ratedTime) {
        this.ratedTime = ratedTime;
    }
    
    public String getRatedCourseName() {
        return null;
    }
    
}
