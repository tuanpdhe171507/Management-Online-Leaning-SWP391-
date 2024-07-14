/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import dao.InstructorContext;
import dao.CourseContext;
import java.sql.SQLException;
import java.text.ParseException;
import java.util.ArrayList;

/**
 *
 * @author HieuTC
 */
public class Instructor {
    private String email;
    private Profile profile;
    private String biography;
    private String facebookLink;
    private String youtubeLink;
    
    private int numberCourses;

    public int getNumberCourses() {
        return numberCourses;
    }

    public void setNumberCourses(int numberCourses) {
        this.numberCourses = numberCourses;
    }

    public float getRate() throws SQLException, ParseException {
        CourseContext cc = new CourseContext();
        ArrayList<Course> list = cc.getCourseListByInstructor(email);
        float sumRate = 0; 
        if(list.size()>0){
            for (Course course : list) {
                sumRate += cc.getCourseRating(course.getId());
            }
            return (float) (1.0*sumRate/list.size());
        }
        return 0;
    }
    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public Profile getProfile() {
        return profile;
    }

    public void setProfile(Profile profile) {
        this.profile = profile;
    }

    public String getBiography() {
        return biography;
    }

    public void setBiography(String biography) {
        this.biography = biography;
    }

    public String getFacebookLink() {
        return facebookLink;
    }

    public void setFacebookLink(String facebookLink) {
        this.facebookLink = facebookLink;
    }

    public String getYoutubeLink() {
        return youtubeLink;
    }

    public void setYoutubeLink(String youtubeLink) {
        this.youtubeLink = youtubeLink;
    }
    
    public int getTotalStudents() throws SQLException, ParseException {
        return new InstructorContext().getTotalStudent(email);
    }
    
    public float getInstructorRating() throws SQLException, ParseException {
        return new InstructorContext().getInstructorRating(email);
    }
    
}
