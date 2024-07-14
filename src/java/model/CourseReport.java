/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;
import java.sql.Date;
/**
 *
 * @author TuanPD
 */
public class CourseReport {
    private int id;
    private Report report;
    private Course course;
    private Profile profile;
    private String sentTime;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }


    public Report getReport() {
        return report;
    }

    public void setReport(Report report) {
        this.report = report;
    }
    public Course getCourse() {
        return course;
    }

    public void setCourse(Course course) {
        this.course = course;
    }

    public Profile getProfile() {
        return profile;
    }

    public void setProfile(Profile profile) {
        this.profile = profile;
    }

   

    public String getSentTime() {
        return sentTime;
    }

    public void setSentTime(String sentTime) {
        this.sentTime = sentTime;
    }

    
    
}
