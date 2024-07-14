/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;
import dao.CourseContext;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;

/**
 *
 * @author HieuTC
 */
public class Course {
    private int id;
    private Instructor instructor;
    private Category category;
    private String name;
    private String description;
    private String thumbnail;
    private String tagLine;
    private String badge;
    private ArrayList<String> objectives;
    private ArrayList<String> prerequiresites;
    private ArrayList<String> intentedLearners;
    private float price;
    private Date createdTime;
    private Date lastUpdatedTime;
    private ArrayList<Section> sectionList;
    private int visibility;

    private final SimpleDateFormat day =  new SimpleDateFormat("MMM yyyy");

    public Course() {
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public Instructor getInstructor() {
        return instructor;
    }

    public void setInstructor(Instructor instructor) {
        this.instructor = instructor;
    }

    public Category getCategory() {
        return category;
    }

    public void setCategory(Category category) {
        this.category = category;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getThumbnail() {
        return thumbnail;
    }

    public void setThumbnail(String thumbnail) {
        this.thumbnail = thumbnail;
    }

    public String getTagLine() {
        return tagLine;
    }

    public void setTagLine(String tagLine) {
        this.tagLine = tagLine;
    }
    
    public String getBadge() {
        return badge;
    }

    public void setBadge(String badge) {
        this.badge = badge;
    }

    public ArrayList<String> getObjectives() {
        return objectives;
    }

    public void setObjectives(ArrayList<String> objectives) {
        this.objectives = objectives;
    }

    public ArrayList<String> getPrerequiresites() {
        return prerequiresites;
    }

    public void setPrerequiresites(ArrayList<String> prerequiresites) {
        this.prerequiresites = prerequiresites;
    }

    public ArrayList<String> getIntentedLearners() {
        return intentedLearners;
    }

    public void setIntentedLearners(ArrayList<String> intentedLearners) {
        this.intentedLearners = intentedLearners;
    }

    public float getPrice() {
        return price;
    }

    public void setPrice(float price) {
        this.price = price;
    }

    public Date getCreatedTime() {
        return createdTime;
    }

    public void setCreatedTime(Date createdTime) {
        this.createdTime = createdTime;
    }
    
    public String getCreatedDate() {
        return day.format(createdTime);
    }
       public Date getCreatedDate2() {
        return createdTime;
    }
    
    
    public Date getLastUpdatedTime() {
        return lastUpdatedTime;
    }
    
    public String getLastUpdatedDate() {
        return day.format(lastUpdatedTime);
    }
    
    public void setLastUpdatedTime(Date lastUpdatedTime) {
        this.lastUpdatedTime = lastUpdatedTime;
    }

    public ArrayList<Section> getSectionList() {
        return sectionList;
    }

    public void setSectionList(ArrayList<Section> sectionList) {
        this.sectionList = sectionList;
    }
    
    public int getSumOfSection() {
        return sectionList.size();
    }

    public int getVisibility() {
        return visibility;
    }

    public void setVisibility(int visibility) {
        this.visibility = visibility;
    }
    
   
    public int getSumOfLesson() {
        int sum = 0;
        for (Section section : this.sectionList) {
            if (section.isVisibility()) {
                for (Item item : section.getItemList()) {
                    if (item.getClass() == Lesson.class) {
                        sum ++;
                    }
                }
            }
        }
        return sum;
    }
    
    public float getCurrentPrice() throws SQLException {
        float currentPrice = new CourseContext()
                .getPriceOnDate(id, new Date());
        return currentPrice != 0 ? currentPrice : price;
    }
    
    public float getPriceAtDate(Date date) throws SQLException {
        float currentPrice = new CourseContext()
                .getPriceOnDate(id, date);
        return currentPrice != 0 ? currentPrice : price;
    }
    
    public int getTotalStudents() throws SQLException {
        return new CourseContext().getTotalStudent(id);
    }
    public int getTotalEnrolledStudentInMonth(int month) throws SQLException {
        return new CourseContext()
                .getEnrolledStudentInMonth(id, 
                        month);
    }
    
    public int getTotalEnrolledStudentsInCurrentMonth() throws SQLException {
        return new CourseContext()
                .getEnrolledStudentInMonth(id, 
                        new Date().getMonth() + 1);
    }
    
    public float getCourseRating() throws ParseException, SQLException {
        return new CourseContext().getCourseRating(id);
    }
    
    public int getRatings() throws ParseException, SQLException {
        return new CourseContext().getRatingList(id).size();
    }

}
