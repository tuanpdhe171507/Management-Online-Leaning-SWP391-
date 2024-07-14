/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.sql.*;
import java.text.ParseException;
import java.util.ArrayList;
import model.Answer;
import model.Course;
import model.CourseDiscount;
import model.DiscountEvent;
import model.Instructor;
import model.Profile;
import model.Rating;
import model.Resource;
import model.Video;

/**
 *
 * @author HieuTC
 */
public class InstructorContext extends ConnectionOpen {
    
    public void register(String email) throws SQLException {
        String sql = "insert into Instructor(emailAddress)\n"
                + "values(?)";
        PreparedStatement ppsm = connection.prepareStatement(sql);
        ppsm.setString(1, email);
        ppsm.executeUpdate();
    }
    
    public Instructor getInstructor(String email) throws SQLException, ParseException {
        String sql = "select biography, facebookLink, youtubeLink\n"
                + "from Instructor\n"
                + "where emailAddress = ?";
        PreparedStatement ppsm = connection.prepareStatement(sql);
        ppsm.setString(1, email);
        ResultSet rs = ppsm.executeQuery();
        
        Instructor instructor = new Instructor();
        while (rs.next()) {
            instructor.setEmail(email);
            instructor.setProfile(new UserContext().getProfile(email));
            instructor.setBiography(rs.getString("biography"));
            instructor.setFacebookLink(rs.getString("facebookLink"));
            instructor.setYoutubeLink(rs.getString("youtubeLink"));
        }
        
        return instructor;
       
    }
    
    
    /**
     * HieuTC
     */
    public Course getCourse(String email, int courseId) throws SQLException, ParseException {
        String sql = "select courseId\n"
                + "from Courses\n"
                + "where courseId = ? and emailAddress = ?";
        PreparedStatement ppsm = connection.prepareStatement(sql);
        ppsm.setInt(1, courseId);
        ppsm.setString(2, email);
        ResultSet rs = ppsm.executeQuery();
        Course course = null;
        CourseContext courseContext = new CourseContext();
        while (rs.next()) {
            course = courseContext.getCourse(courseId);
        }
        return course;
    }
    
    
    /**
     * HieuTC
     * Get course list that provided by instructors by their email.
     */
    public ArrayList<Course> getCourseList(String email) throws SQLException, ParseException {
        CourseContext courseContext = new CourseContext();
        String sql = "select courseId\n"
                + "from Courses\n"
                + "where emailAddress = ?";
        PreparedStatement ppsm = connection.prepareStatement(sql);
        ppsm.setString(1, email);
        ArrayList<Course> courseList = new ArrayList<>();
        ResultSet rs = ppsm.executeQuery();
        while (rs.next()) {
            courseList.add(courseContext.getCourse(
                    rs.getInt("courseId")));
        }
        return courseList;
    }
    
    /**
     * HieuTC
     * Get comment list within last 48 hours by instructor's courses.
     */
    public ArrayList<Rating> getRatingWithin48Hours(String email) throws SQLException, ParseException {
        String sql = "select  CourseRating.emailAddress, courseName, starRate, comment, ratedTime\n"
                + "from CourseRating\n"
                + "join Courses\n"
                + "on CourseRating.courseId = Courses.courseId\n"
                + "where Courses.emailAddress = ?\n"
                + "and ratedTime BETWEEN DATEADD(HOUR, -48, GETDATE()) AND GETDATE();";
        PreparedStatement ppsm = connection.prepareStatement(sql);
        ppsm.setString(1, email);
        ArrayList<Rating> ratingList = new ArrayList<>();
        UserContext userContext = new UserContext();
        ResultSet rs = ppsm.executeQuery();
        
        while (rs.next()) {
            Rating rating = new Rating();
            rating.setProfile(userContext
                    .getProfile(rs.getString("emailAddress")));
            rating.setCourseName(rs.getString("courseName"));
            rating.setStar(rs.getInt("starRate"));
            rating.setComment(rs.getString("comment"));
            rating.setRateTime(dateTime
                    .parse(rs.getString("ratedTime")));
            ratingList.add(rating);
        }
        return ratingList;
    }
    
    
    /**
     * HieuTC
     * Get profit for specific course in month.
     */
    public float getCourseProfitInMonth(int courseId, int month) throws SQLException, ParseException {
        String sql = "select enrolledTime\n"
                + "from AccessibleCourse\n"
                + "where courseId = ? \n"
                + "and month(enrolledTime) = ?;";
        PreparedStatement ppsm = connection.prepareStatement(sql);
        ppsm.setInt(1, courseId);
        ppsm.setInt(2, month);
        ResultSet rs = ppsm.executeQuery();
        CourseContext courseContext = new CourseContext();
        int totalProfit = 0;
        
        while (rs.next()) {
            // Get price at enrolled time;
            totalProfit += courseContext.getPriceOnDate(courseId,
                    dateTime.parse(
                            rs.getString("enrolledTime")));
        }
        
        return totalProfit;
    }
    
    /**
     * HieuTC
     * Add new section.
     */
    public void addSection(int courseId, String sectionTitle) throws SQLException {
        String sql = "insert into Sections(courseId, sectionTitle)\n"
                + "values(?, ?);";
        PreparedStatement ppsm = connection.prepareStatement(sql);
        ppsm.setInt(1, courseId);
        ppsm.setString(2, sectionTitle);
        ppsm.executeUpdate();
        
    }
    
    /**
     * HieuTC
     * Update section.
     */
    public void updateSection(int sectionId, String sectionTitle) throws SQLException {
        String sql = "update Sections\n"
                + "set sectionTitle = ?\n"
                + "where sectionId = ?;";
        PreparedStatement ppsm = connection.prepareStatement(sql);
        ppsm.setInt(2, sectionId);
        ppsm.setString(1, sectionTitle);
        ppsm.executeUpdate();
    }
    
    /**
     * HieuTC
     * Remove section.
     */
    public void removeSection(int sectionId) throws SQLException {

        String sql = "select quizId\n"
                + "from Quiz\n"
                + "where sectionId = ?;";
        PreparedStatement ppsm = connection.prepareStatement(sql);
        ppsm = connection.prepareStatement(sql);
        ppsm.setInt(1, sectionId);
        ResultSet rs = ppsm.executeQuery();
        while (rs.next()) {
            this.removeQuiz(rs.getInt("quizId"));
        }
        
        sql = "select lessonId \n"
                + "from Lesson\n"
                + "where sectionId = ?";
        ppsm = connection.prepareStatement(sql);
        ppsm = connection.prepareStatement(sql);
        ppsm.setInt(1, sectionId);
        rs = ppsm.executeQuery();
        
        while (rs.next()) {
            this.removeLesson(rs.getInt("lessonId"));
        }
        
        sql = "delete Sections\n"
                + "where sectionId = ?;";
        ppsm = connection.prepareStatement(sql);
        ppsm.setInt(1, sectionId);
        ppsm.executeUpdate();
    }
    
    /**
     * HieuTC
     * Add new lesson.
     */
    public int addLesson(int sectionId, String lessonName) throws SQLException {
        String sql = "insert into Lesson(sectionId, lessonName, type)\n"
                + "values(?, ?, 'reading');";
        PreparedStatement ppsm = connection.prepareStatement(sql);
        ppsm.setInt(1,sectionId);
        ppsm.setString(2,lessonName);
        ResultSet rs = ppsm.executeQuery();
        int lessonId = 0;
        while (rs.next()) {
            lessonId = rs.getInt("lessonId");
        }
        
        return lessonId;
    }
    
    /**
     * HieuTC
     * Update lesson.
     */
    public void updateLesson(int lessonId, String lessonName, String readingContent) throws SQLException {
        String sql = "update Lesson\n"
                + "set lessonName = ?, readingContent = ?\n"
                + "where lessonID = ?;";
        PreparedStatement ppsm = connection.prepareStatement(sql);
        ppsm.setString(1, lessonName);
        ppsm.setString(2, readingContent);
        ppsm.setInt(3, lessonId);
        ppsm.executeUpdate();
    }

    /**
     * HieuTC
     * Remove a lesson.
     */
    public void removeLesson(int lessonId) throws SQLException {
        CourseContext courseContext = new CourseContext();
        String sql = "select noteId\n"
                + "from Notes\n"
                + "where lessonId = ?";
        PreparedStatement ppsm = connection.prepareStatement(sql);
        ppsm.setInt(1, lessonId);
        ResultSet rs = ppsm.executeQuery();
        while (rs.next()) {
            courseContext.deteleNote(rs.getInt("noteId"));
        }
        
        sql = "select interactionId\n"
                + "from Interactions\n"
                + "where lessonId = ?";
        ppsm = connection.prepareStatement(sql);
        ppsm.setInt(1, lessonId);
        rs = ppsm.executeQuery();
        while (rs.next()) {
            courseContext.deteleNote(rs.getInt("interactionId"));
        }
        
        sql = "delete StudiedLesson\n"
                + "where lessonId = ?;"
                + "delete Lesson\n"
                + "where lessonID = ?;";
        ppsm = connection.prepareStatement(sql);
        ppsm.setInt(1, lessonId);
        ppsm.setInt(2, lessonId);
        ppsm.executeUpdate();
    }
    
    public int addQuiz(int sectionId, String quizTitle) throws SQLException {
        String sql = "insert into Quiz(sectionId, quizTitle)\n"
                + "values(?, ?);";
        PreparedStatement ppsm = connection.prepareStatement(sql);
        ppsm.setInt(1,sectionId);
        ppsm.setString(2, quizTitle);
        ResultSet rs = ppsm.executeQuery();
        int quizId = 0;
        while (rs.next()) {
            quizId = rs.getInt("quizId");
        }
        
        return quizId;
    }
    
    public void updateQuiz(int quizId, String quizTitle, String quizDescription) throws SQLException {
        String sql = "update Quiz\n"
                + "set quizTitle = ?, quizDescription = ?\n"
                + "where quizId = ?";
        PreparedStatement ppsm = connection.prepareStatement(sql);
        ppsm.setString(1, quizTitle);
        ppsm.setString(2, quizDescription);
        ppsm.setInt(3, quizId);
        ppsm.executeUpdate();
    }
    
    public void removeQuiz(int quizId) throws SQLException {
        String sql = "select questionId\n"
                + "from Questions\n"
                + "where quizId = ?";
        PreparedStatement ppsm = connection.prepareStatement(sql);
        ppsm.setInt(1, quizId);
        ResultSet rs = ppsm.executeQuery();
        CourseContext courseContext = new CourseContext();
        while (rs.next()) {
            courseContext
                    .deleteQuestion(rs.getInt("questionId"));
        }
         
        sql = "delete Quiz\n"
                + "where quizId = ?;";
        ppsm = connection.prepareStatement(sql);
        ppsm.setInt(1, quizId);
        ppsm.executeUpdate();
    }
    
    /**
     * HieuTC
     * Upload video to lesson
     */
    
    public int saveVideo(String email, Video video) throws SQLException {
        String sql = "insert into Videos(emailAddress, videoName, videoType, videoTime, videoPath)\n"
                + "values(?, ?, ?, ?, ?);";
        PreparedStatement ppsm = connection.prepareStatement(sql);
        ppsm.setString(1, email);
        ppsm.setString(2, video.getName());
        ppsm.setString(3, video.getType());
        ppsm.setFloat(4, video.getTime());
        ppsm.setString(5, video.getPath());
        
        ppsm.executeUpdate();
        
        sql = "select videoId\n"
                + "from Videos\n"
                + "where videoPath = ?";
        ppsm = connection.prepareStatement(sql);
        ppsm.setString(1, video.getPath());
        ResultSet rs = ppsm.executeQuery();
        int videoId = 0;
        while (rs.next()) {
            videoId = rs.getInt("videoId");
        }
        return videoId;
    }
    
    public void setVideoForLesson(int lessonId, int videoId) throws SQLException {
        String sql = "update Lesson\n"
                + "set videoId = ?, type = 'watching'\n"
                + "where lessonId = ?;";
        PreparedStatement ppsm = connection.prepareStatement(sql);
        ppsm.setInt(1, videoId);
        ppsm.setInt(2, lessonId);
        
        ppsm.executeUpdate();
    }
    
    public void saveResource(int lessonId, Resource resource) throws SQLException {
        String sql = "insert into Resources(lessonId, resourceName, resourceType, resourcePath)\n"
                + "values(?, ?, ?, ?);";
        PreparedStatement ppsm = connection.prepareStatement(sql);
        ppsm.setInt(1, lessonId);
        ppsm.setString(2, resource.getName());
        ppsm.setString(3, resource.getType());
        ppsm.setString(4, resource.getPath());
        
        ppsm.executeUpdate();
    }
    
    public void setLessonType(String lessonType, int lessonId) throws SQLException {
        String sql = "update Lesson\n"
                + "set type = ?\n"
                + "where lessonId = ?;";
        PreparedStatement ppsm = connection.prepareStatement(sql);
        ppsm.setString(1,lessonType);
        ppsm.setInt(2, lessonId);
        
        ppsm.executeUpdate();
    }
    
    public ArrayList<Video> getVideoLibrary(String email) throws SQLException, ParseException {
        String sql = "select videoId\n"
                + "from Videos\n"
                + "where emailAddress = ?";
        PreparedStatement ppsm = connection.prepareStatement(sql);
        ppsm.setString(1,email);
        ResultSet rs = ppsm.executeQuery();
        CourseContext courseContext = new CourseContext();
        ArrayList<Video> videoList = new ArrayList();
        while (rs.next()) {
            videoList.add(courseContext
                    .getVideo(rs.getInt("videoId")));
        }
        return videoList;
    }
    
    public void deleteCourse(int courseId) throws SQLException {
        String sql = "select sectionId\n"
                + "from Sections\n"
                + "where courseId = ?";
        PreparedStatement ppsm = connection.prepareStatement(sql);
        ppsm.setInt(1, courseId);
        ResultSet rs = ppsm.executeQuery();
        while (rs.next()) {
            this.removeSection(rs.getInt("sectionId"));
        }
        
        sql = "delete Courses\n" +
            "where courseId = ?";
        ppsm = connection.prepareStatement(sql);
        ppsm.setInt(1, courseId);
        ppsm.executeUpdate();
    }
    
    /*
    * HieuTC
    */
    public int addQuestion(String questionContent, ArrayList<Answer> answers) throws SQLException {
        String sql = "insert into Questions(questionContent)\n"
                + "values(?)";
        PreparedStatement ppsm = connection.prepareStatement(sql);
        ppsm.setString(1, questionContent);
        ResultSet rs = ppsm.executeQuery();
        int questionId = 0;
        while (rs.next()) {
            questionId = rs.getInt("questionId");
            // Add answer list to question;
            for (Answer answer : answers) {
                this.addAnswer(questionId, 
                        answer.getContent(), 
                        answer.isCorrectless());
                
            }
        }
        return questionId;
        
    }
    
    public void addAnswer(int questionId, String answerContent, boolean correctless) throws SQLException {
        String sql = "insert into Answers(questionId, answerContent, correctless)\n"
                + "values(?, ?, ?)";
        PreparedStatement ppsm = connection.prepareStatement(sql);
        ppsm.setInt(1, questionId);
        ppsm.setString(2, answerContent);
        ppsm.setBoolean(3, correctless);
        ppsm.executeUpdate();
    }
    
    public void addInteraction(int lesssonId, int videoId, int questionId, float adTime, String position, String size) throws SQLException {
        String sql = "insert into Interactions(lessonId, videoId, questionId, atTime, position, size)\n"
                + "values(?, ?, ?, ?, ?, ?);";
        PreparedStatement ppsm = connection.prepareStatement(sql);
        ppsm.setInt(1, lesssonId);
        ppsm.setInt(2, videoId);
        ppsm.setInt(3, questionId);
        ppsm.setFloat(4, adTime);
        ppsm.setString(5, position);
        ppsm.setString(6, size);
        
        ppsm.executeUpdate();
    }
    
    public void removeInteraction(String email, int interactionId) throws SQLException {
        String sql = "delete Interactions\n"
                + "where interactionId = ?";
        PreparedStatement ppsm = connection.prepareStatement(sql);
        ppsm.setInt(1, interactionId);
        ppsm.executeUpdate();
    }
    
    public void setCourseState(String email, int courseId, int state) throws SQLException {
        
        // 1 - Publish, 2 - Private;
        String sql = "update Courses\n"
                + "set visibility = ?\n"
                + "where emailAddress = ? and courseId = ?;";
        PreparedStatement ppsm = connection.prepareStatement(sql);
        ppsm.setInt(1, state);
        ppsm.setString(2, email);
        ppsm.setInt(3, courseId);
        ppsm.executeUpdate();
    }
    
    public void setSectionState(String email, int sectionId, int state) throws SQLException {
        
        // 1 - Published, 0 - Unpublished;
        String sql = "update Sections\n"
                + "set visibility = ?\n"
                + "where sectionId in (select Sections.sectionID\n"
                + "from Sections\n"
                + "join Courses\n"
                + "on sectionID = ? and Courses.emailAddress = ?);";
        PreparedStatement ppsm = connection.prepareStatement(sql);
        ppsm.setInt(1, state);
        ppsm.setInt(2, sectionId);
        ppsm.setString(3, email);
        ppsm.executeUpdate();
    }

    public void setPrice(String email, int courseId, float price) throws SQLException {
        String sql = "update Courses\n"
                + "set price = ?\n"
                + "where courseId = ? and emailAddress = ?;";
        PreparedStatement ppsm = connection.prepareStatement(sql);   
        ppsm.setFloat(1, price);
        ppsm.setInt(2, courseId);
        ppsm.setString(3, email);
        ppsm.executeUpdate();
    }
    
    public float getInstructorRating(String email) throws SQLException, ParseException {
        String sql = "select courseId\n"
                + "from Courses\n"
                + "where emailAddress = ?;";
        PreparedStatement ppsm = connection.prepareStatement(sql);   
        ppsm.setString(1, email);
        ResultSet rs = ppsm.executeQuery();
        int count = 0;
        float sum = 0;
        
        CourseContext courseContext = new CourseContext();
        while (rs.next()) {
            sum += courseContext.getCourseRating(rs.getInt("courseId"));
            count ++;
        }
        
        return sum / count;
    }
    
    public int getTotalStudent(String email) throws SQLException, ParseException {
        String sql = "select courseId\n"
                + "from Courses\n"
                + "where emailAddress = ?;";
        PreparedStatement ppsm = connection.prepareStatement(sql);   
        ppsm.setString(1, email);
        ResultSet rs = ppsm.executeQuery();
        int student = 0;
        
        CourseContext courseContext = new CourseContext();
        while (rs.next()) {
            student += courseContext
                    .getTotalStudent(rs.getInt("courseId"));
        }
        
        return student;
    }
    
    /*get list course joined event by instructor 
    HuyLQ */
    public ArrayList<CourseDiscount> getCourseJoinedEvent(String email, String nameEvent) throws SQLException, ParseException {
        ArrayList<CourseDiscount> courseList = new ArrayList<>();
        String sql = "SELECT po.emailAddress , c.courseID, d.[event], c.courseName, c.thumbnail, c.price, d.discount, po.fullName, p.approved \n"
                + "                FROM PricePackage p \n"
                + "                INNER JOIN Courses c ON c.courseID = p.courseID \n"
                + "                INNER JOIN [Profile] po ON c.emailAddress = po.emailAddress \n"
                + "                INNER JOIN DiscountEvent d ON d.[event] = p.[event]\n"
                + "				where po.emailAddress  like ? and approved = 1  and d.[event] like ?";
        PreparedStatement stm = connection.prepareStatement(sql);
         stm.setString(1, email);
         stm.setString(2, nameEvent);
        ResultSet rs = stm.executeQuery();
        while (rs.next()) {
            Profile profile = new Profile();
            profile.setName(rs.getString("fullName"));

            Instructor instructor = new Instructor();
            instructor.setProfile(profile);

            Course course = new Course();
            course.setName(rs.getString("courseName"));
            course.setThumbnail(rs.getString("thumbnail"));
            course.setPrice(rs.getFloat("price"));
            course.setId(rs.getInt("courseID"));
            course.setInstructor(instructor);
            // Create DiscountEvent object and set values
            DiscountEvent discountEvent = new DiscountEvent();
            discountEvent.setEvent(rs.getString("event"));
            discountEvent.setDiscount(rs.getInt("discount"));

            CourseDiscount courseDiscount = new CourseDiscount();
            courseDiscount.setCourse(course);
            courseDiscount.setDiscountEvent(discountEvent);
          
            courseList.add(courseDiscount);
        }
        rs.close();
        stm.close();
        return courseList;
    }
}
