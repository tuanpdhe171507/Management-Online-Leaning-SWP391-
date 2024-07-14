/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author HuyLQ;
 */
public class CourseDiscount {

    private Course course;
    private DiscountEvent discountEvent;
    private Boolean approved;

    public CourseDiscount() {
    }

    public Course getCourse() {
        return course;
    }

    public void setCourse(Course course) {
        this.course = course;
    }

    public DiscountEvent getDiscountEvent() {
        return discountEvent;
    }

    public void setDiscountEvent(DiscountEvent discountEvent) {
        this.discountEvent = discountEvent;
    }

    public Boolean getApproved() {
        return approved;
    }

    public void setApproved(Boolean approved) {
        this.approved = approved;
    }
    
    
}
