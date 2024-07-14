/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import model.Course;
import java.sql.*;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.AccessibleCourse;
import model.Category;
import model.CourseDiscount;
import model.CourseSubmission;
import model.DiscountEvent;
import model.Instructor;
import model.Interaction;
import model.Item;
import model.Lesson;
import model.LessonType;
import model.Profile;
import model.Question;
import model.Quiz;
import model.Rating;
import model.RatingStatistics;
import model.Resource;
import model.Section;
import model.User;
import model.Video;
import model.Wishlist;

/**
 *
 * @author HieuTC
 */
public class CourseContext extends ConnectionOpen {

    public ArrayList<Course> getCourseList() throws SQLException, ParseException {
        String sql = "select courseId\n"
                + "from Courses\n"
                + "where visibility = 1;";
        PreparedStatement ppsm = connection.prepareStatement(sql);
        ArrayList<Course> courseList = new ArrayList<>();
        ResultSet rs = ppsm.executeQuery();

        while (rs.next()) {
            courseList.add(this.getReleasedCourse(rs.getInt("courseId")));
        }
        return courseList;
    }

    /**
     * HieuTC Get course that is released or reviewed by administrator;
     */
    public Course getReleasedCourse(int courseId) throws SQLException, ParseException {
        String sql = "select courseId\n"
                + "from Courses\n"
                + "where courseId = ? and visibility != 0";
        PreparedStatement ppsm = connection.prepareStatement(sql);
        ppsm.setInt(1, courseId);
        ResultSet rs = ppsm.executeQuery();
        Course course = new Course();

        while (rs.next()) {
            course = this.getCourse(courseId);
        }
        return course;
    }

    public Course getCourse(int courseId) throws SQLException, ParseException {
        String sql = "select courseId, emailAddress, categoryId, courseName, courseDescription,"
                + " thumbnail, tagLine, badge, objective, prerequiresite,"
                + " intendedLearner, price, createdTime, lastUpdatedTime, visibility\n"
                + "from Courses\n"
                + "where courseId = ?";
        PreparedStatement ppsm = connection.prepareStatement(sql);
        ppsm.setInt(1, courseId);
        ResultSet rs = ppsm.executeQuery();

        Course course = new Course();
        while (rs.next()) {

            course.setId(courseId);

            course.setInstructor(new InstructorContext()
                    .getInstructor(rs.getString("emailAddress")));
            course.setCategory(this.getCategory(rs.getString("categoryId")));
            course.setName(rs.getString("courseName"));
            course.setDescription(rs.getString("courseDescription"));
            course.setThumbnail(rs.getString("thumbnail"));
            course.setTagLine(rs.getString("tagLine"));
            course.setBadge(rs.getString("badge"));

            ArrayList<String> objectives = new ArrayList<>();
            ArrayList<String> prerequiresites = new ArrayList<>();
            ArrayList<String> intendedLearners = new ArrayList<>();

            if (rs.getString("objective") != null) {
                Collections.addAll(objectives,
                        rs.getString("objective").split("/"));
            }

            if (rs.getString("prerequiresite") != null) {
                Collections.addAll(prerequiresites,
                        rs.getString("prerequiresite").split("/"));
            }
            if (rs.getString("intendedLearner") != null) {
                Collections.addAll(intendedLearners,
                        rs.getString("intendedLearner").split("/"));
            }

            course.setObjectives(objectives);
            course.setPrerequiresites(prerequiresites);
            course.setIntentedLearners(intendedLearners);

            course.setPrice(rs.getFloat("price"));
            course.setCreatedTime(
                    dateTime.parse(rs.getString("createdTime")));
            course.setLastUpdatedTime(
                    dateTime.parse(rs.getString("lastUpdatedTime")));
            course.setSectionList(this.getSectionList(course.getId()));
            course.setVisibility(rs.getInt("visibility"));
        }
        return course;
    }

    public ArrayList<Category> getCategoryList() throws SQLException {
        String sql = "select categoryId\n"
                + "from Categories\n";
        PreparedStatement ppsm = connection.prepareStatement(sql);
        ResultSet rs = ppsm.executeQuery();
        ArrayList<Category> categoryList = new ArrayList();

        while (rs.next()) {
            categoryList.add(this.getCategory(
                    rs.getString("categoryId")));
        }
        return categoryList;
    }

    public Category getCategory(String categoryId) throws SQLException {
        String sql = "select a.categoryID,a.categoryName,a.categoryDescription from Categories as a\n"
                + "where a.categoryID=?";
        PreparedStatement st = connection.prepareStatement(sql);
        st.setString(1, categoryId);
        ResultSet rs = st.executeQuery();
        Category category = new Category();
        if (rs.next()) {

            category.setId(rs.getString("categoryID"));
            category.setName(rs.getString("categoryName"));
            category.setDescription(rs.getString("categoryDescription"));
        }
        return category;
    }

    public ArrayList<Section> getSectionList(int courseId) throws SQLException, ParseException {
        String sql = "select sectionId\n"
                + "from Sections\n"
                + "where courseId = ?\n";
        PreparedStatement ppsm = connection.prepareStatement(sql);
        ppsm.setInt(1, courseId);
        ArrayList<Section> sectionList = new ArrayList<>();
        ResultSet rs = ppsm.executeQuery();

        while (rs.next()) {
            Section section = this.getSection(
                    rs.getInt("sectionId"));
            sectionList.add(section);
        }

        return sectionList;
    }

    public ArrayList<Section> getPublishSectionList(int courseId) throws SQLException, ParseException {
        String sql = "select sectionId\n"
                + "from Sections\n"
                + "where courseId = ? and Sections.visibility = 1\n";
        PreparedStatement ppsm = connection.prepareStatement(sql);
        ppsm.setInt(1, courseId);
        ArrayList<Section> sectionList = new ArrayList<>();
        ResultSet rs = ppsm.executeQuery();

        while (rs.next()) {
            Section section = this.getSection(
                    rs.getInt("sectionId"));
            sectionList.add(section);
        }

        return sectionList;
    }

    public Section getSection(int sectionId) throws SQLException, ParseException {
        String sql = "select sectionTitle, visibility\n"
                + "from Sections\n"
                + "where sectionId = ?";
        PreparedStatement ppsm = connection.prepareStatement(sql);
        ppsm.setInt(1, sectionId);
        ResultSet rs = ppsm.executeQuery();

        Section section = new Section();
        while (rs.next()) {
            section.setId(sectionId);
            section.setTitle(rs.getString("sectionTitle"));
            ArrayList<Item> itemList = new ArrayList();
            ArrayList<Lesson> lessonList = this.getLessonList(sectionId);
            itemList.addAll(lessonList);
            
            ArrayList<Quiz> quizList = this.getQuizList(sectionId);
            itemList.addAll(quizList);
            
            Collections.sort(itemList, (Item o1, Item o2) -> o1.getAddedTime()
                    .after(o2.getAddedTime()) ? 0 : -1);
            section.setItemList(itemList);
            
            section.setVisibility(rs.getBoolean("visibility"));
        }
        return section;
    }

    public ArrayList<Lesson> getLessonList(int sectionId) throws SQLException, ParseException {
        String sql = "select lessonId\n"
                + "from Lesson\n"
                + "where sectionId = ?";
        PreparedStatement ppsm = connection.prepareStatement(sql);
        ppsm.setInt(1, sectionId);
        ArrayList<Lesson> lessonList = new ArrayList<>();
        ResultSet rs = ppsm.executeQuery();

        while (rs.next()) {
            lessonList.add(this.getLesson(rs.getInt("lessonId")));
        }
        return lessonList;
    }

    public Lesson getLesson(int lessonId) throws SQLException, ParseException {
        String sql = "select lessonID, type, videoId, lessonName, readingContent, addedTime\n"
                + "from Lesson\n"
                + "where lessonId = ?";
        PreparedStatement ppsm = connection.prepareStatement(sql);
        ppsm.setInt(1, lessonId);
        ResultSet rs = ppsm.executeQuery();

        Lesson lesson = new Lesson();
        while (rs.next()) {
            lesson.setId(rs.getInt("lessonID"));
            lesson.setType(this.getLessonType(
                    rs.getString("type")));
            lesson.setName(rs.getString("lessonName"));
            lesson.setVideo(this
                    .getVideo(rs.getInt("videoId")));
            lesson.setReadingContent(rs
                    .getString("readingContent"));
            lesson.setAddedTime(dateTime
                    .parse(rs.getString("addedTime")));
        }
        return lesson;
    }

    public LessonType getLessonType(String type) throws SQLException {
        String sql = "select typeName, typeDescription\n"
                + "from LessonType\n"
                + "where type = ?";
        PreparedStatement ppsm = connection.prepareStatement(sql);
        ppsm.setString(1, type);
        ResultSet rs = ppsm.executeQuery();

        LessonType lessonType = new LessonType();
        while (rs.next()) {
            lessonType.setType(type);
            lessonType.setName(rs.getString("typeName"));
            lessonType.setDescription(rs.getString("typeDescription"));
        }
        return lessonType;
    }

    public ArrayList<Rating> getRatingList(int coursesid) throws ParseException, SQLException {
        ArrayList<Rating> list = new ArrayList<>();
        String sql = "select a.courseID,a.emailAddress,a.starRate,a.comment,a.ratedTime from CourseRating as a\n"
                + "where a.courseID=?";
        PreparedStatement st = connection.prepareStatement(sql);
        st.setInt(1, coursesid);
        ResultSet rs = st.executeQuery();
        while (rs.next()) {
            Rating c = new Rating();
            c.setProfile(new UserContext().getProfile(rs.getString("emailAddress")));
            c.setStar(rs.getInt("starRate"));
            c.setComment(rs.getString("comment"));
            c.setRateTime(dateTime.parse(rs.getString("ratedTime")));
            list.add(c);
        }
        return list;
    }

    public Integer createCourse(String email, String name, int category) throws SQLException {
        String sql = "insert into Courses( emailAddress, courseName, categoryId, lastUpdatedTime)\n"
                + "values(?, ?, ?, current_timestamp);";
        PreparedStatement ppsm = connection.prepareStatement(sql);
        ppsm.setString(1, email);
        ppsm.setString(2, name);
        ppsm.setInt(3, category);
        int rowUpdated = ppsm.executeUpdate();
        // Course has been insert;
        if (rowUpdated > 0) {
            sql = "select courseId\n"
                    + "from Courses\n"
                    + "where emailAddress = ?\n"
                    + "order by courseId DESC;";
            ppsm = connection.prepareStatement(sql);
            ppsm.setString(1, email);
            ResultSet rs = ppsm.executeQuery();

            while (rs.next()) {
                return rs.getInt("courseId");
            }
        }
        return null;
        /* Failed to create course */
    }

    public void updateCourseById(Course course, int courseID, String emailAddress) {
        try {
            int count = 0;
            String sql = "UPDATE [dbo].[Courses]\n"
                    + "   SET";

            ArrayList<Object> param = new ArrayList<>();
            if (course.getCategory().getId() != null && !course.getCategory().getId().isBlank()) {
                sql += "[categoryID] = ?,";
                count++;
                param.add(course.getCategory().getId());
            }
            if (course.getName() != null && !course.getName().isBlank()) {
                sql += "[courseName] = ?,";
                count++;
                param.add(course.getName());
            }
            if (course.getDescription() != null) {
                sql += "[courseDescription] = ?,";
                count++;
                param.add(course.getDescription());

            }
            if (course.getThumbnail() != null) {
                sql += "[thumbnail] = ?,";
                count++;
                param.add(course.getThumbnail());
            }
            if (course.getTagLine() != null) {
                sql += "[tagLine] = ?,";
                count++;
                param.add(course.getTagLine());
            }
            if (course.getBadge() != null) {
                sql += "[badge]";
                count++;
                param.add(course.getBadge());
            }
            if (course.getObjectives() != null) {
                sql += "[objective] = ?,";
                count++;
                param.add(concatString(course.getObjectives()));
            }
            if (course.getPrerequiresites() != null) {
                sql += "[prerequiresite] = ?,";
                count++;
                param.add(concatString(course.getPrerequiresites()));
            }
            if (course.getIntentedLearners() != null) {
                sql += "[intendedLearner] = ?,";
                count++;
                param.add(concatString(course.getIntentedLearners()));
            }
            if (course.getPrice() >= 0) {
                sql += "[price] = ?,";
                count++;
                param.add(course.getPrice());
            }
            sql += "[lastUpdatedTime] = GETDATE()";
            sql += " WHERE courseId = ? AND emailAddress like ?";
            PreparedStatement stm = connection.prepareStatement(sql);
            for (int i = 0; i < count; i++) {
                // check param.get(i) is a String or not
                if (param.get(i) instanceof String) {
                    stm.setString(i + 1, (String) param.get(i));
                    continue;
                }
                if (param.get(i) instanceof Float) {
                    stm.setFloat(i + 1, (Float) param.get(i));
                }
            }
            stm.setInt(count + 1, courseID);
            stm.setString(count + 2, emailAddress);
            stm.executeUpdate();
        } catch (SQLException ex) {
            Logger.getLogger(CourseContext.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    public String concatString(ArrayList<String> list) {
        if (list.isEmpty()) {
            return null;
        }
        String concatString = "";
        for (int i = 0; i < list.size() - 1; i++) {
            concatString += list.get(i).trim() + "/ ";
        }
        return concatString + list.get(list.size() - 1);
    }

    public ArrayList<Category> getCategory() {
        ArrayList<Category> categories = new ArrayList<>();
        try {
            String sql = "SELECT [categoryID]\n"
                    + "      ,[categoryName]\n"
                    + "      ,[categoryDescription]\n"
                    + "  FROM [dbo].[Categories]";
            PreparedStatement stm = connection.prepareStatement(sql);
            ResultSet rs = stm.executeQuery();
            while (rs.next()) {
                Category c = new Category();
                c.setId(rs.getString("categoryID"));
                c.setName(rs.getString("categoryName"));
                c.setDescription(rs.getString("categoryDescription"));
                categories.add(c);
            }
        } catch (SQLException ex) {
            Logger.getLogger(CourseContext.class.getName()).log(Level.SEVERE, null, ex);
        }
        return categories;
    }

    public Course getCourseByID(String emailAddress, int courseID) {
        try {
            String sql = "select* from [Courses]\n"
                    + "where [courseID] = ? and emailAddress like ?";
            PreparedStatement stm = connection.prepareStatement(sql);
            stm.setInt(1, courseID);
            stm.setString(2, emailAddress);
            ResultSet rs = stm.executeQuery();
            if (rs.next()) {
                Course c = new Course();
                c.setId(rs.getInt("courseId"));
                c.setName(rs.getString("courseName"));

                Category category = new Category();
                category.setId(rs.getString("categoryId"));

                c.setCategory(category);

                c.setDescription(rs.getString("courseDescription"));
                c.setThumbnail(rs.getString("thumbnail"));
                c.setTagLine(rs.getString("tagLine"));

                ArrayList<String> objectives = new ArrayList<>();
                ArrayList<String> prerequiresites = new ArrayList<>();
                ArrayList<String> intendedLearners = new ArrayList<>();

                if (rs.getString("objective") != null && !rs.getString("objective").isBlank()) {
                    Collections.addAll(objectives,
                            rs.getString("objective").trim().split("/"));
                }
                if (rs.getString("prerequiresite") != null && !rs.getString("prerequiresite").isBlank()) {
                    Collections.addAll(prerequiresites,
                            rs.getString("prerequiresite").trim().split("/"));
                }

                if (rs.getString("intendedLearner") != null && !rs.getString("intendedLearner").isBlank()) {
                    Collections.addAll(intendedLearners,
                            rs.getString("intendedLearner").trim().split("/"));
                }

                c.setObjectives(objectives);
                c.setPrerequiresites(prerequiresites);
                c.setIntentedLearners(intendedLearners);
                c.setPrice(rs.getFloat("price"));
                return c;
            }

        } catch (SQLException ex) {
            Logger.getLogger(CourseContext.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }

    /**
     * HieuTC Get course total student
     */
    public int getTotalStudent(int courseId) throws SQLException {
        String sql = "select count(distinct emailAddress) as totalStudent\n"
                + "from AccessibleCourse\n"
                + "where courseId = ?;";
        PreparedStatement ppsm = connection.prepareStatement(sql);
        ppsm.setInt(1, courseId);
        ResultSet rs = ppsm.executeQuery();

        int totalStudent = 0;
        while (rs.next()) {
            totalStudent = rs.getInt("totalStudent");
        }
        return totalStudent;
    }

    /**
     * HieuTC Get total student who enrolled follow specific month;
     */
    public int getEnrolledStudentInMonth(int courseId, int month) throws SQLException {
        String sql = "select count(distinct emailAddress) as totalStudent\n"
                + "from AccessibleCourse\n"
                + "where courseId = ? and month(enrolledTime) = ?;";
        PreparedStatement ppsm = connection.prepareStatement(sql);
        ppsm.setInt(1, courseId);
        ppsm.setInt(2, month);
        ResultSet rs = ppsm.executeQuery();

        int totalStudent = 0;
        while (rs.next()) {
            totalStudent = rs.getInt("totalStudent");
        }
        return totalStudent;
    }

    /**
     * HieuTC Get average rating for course.
     */
    public float getCourseRating(int courseId) throws ParseException, SQLException {
        /* Get rating list*/
        ArrayList<Rating> ratingList = this
                .getRatingList(courseId);

        // Rating for course is not empty;
        if (ratingList.size() != 0) {
            int sum = 0;

            /* Traversal rating list*/
            for (Rating rating : ratingList) {
                sum += rating.getStar();
            }
            return (float) (sum / ratingList.size());
        } else {
            return 0;
        }
    }

    ////TuanPD
    public ArrayList<Course> searchCourse(String name) throws ParseException, SQLException {
        String sql = "SELECT a.courseID, a.courseName, a.categoryID "
                + "FROM Courses AS a "
                + "LEFT JOIN Instructor AS b ON a.emailAddress = b.emailAddress "
                + "LEFT JOIN Categories AS c ON a.categoryID = c.categoryID "
                + "LEFT JOIN Profile AS d ON b.emailAddress = d.emailAddress "
                + "WHERE (a.courseName LIKE ? "
                + "OR d.fullName LIKE ? "
                + "OR c.categoryName LIKE ? "
                + "OR c.categoryDescription LIKE ?) "
                + "AND a.visibility != 0";

        PreparedStatement ppsm = connection.prepareStatement(sql);
        ArrayList<Course> courseList = new ArrayList<>();

        String searchPattern = "%" + name + "%";
        ppsm.setString(1, searchPattern);
        ppsm.setString(2, searchPattern);
        ppsm.setString(3, searchPattern);
        ppsm.setString(4, searchPattern);

        ResultSet rs = ppsm.executeQuery();

        while (rs.next()) {
            courseList.add(this.getReleasedCourse(rs.getInt("courseID")));
        }
        return courseList;
    }

    public ArrayList<Course> filterCourses(String name, Boolean filterStatus, Float minRating) throws SQLException, ParseException {
        String sql = "SELECT a.courseID, a.courseName, a.categoryID "
                + "FROM Courses AS a "
                + "LEFT JOIN Instructor AS b ON a.emailAddress = b.emailAddress "
                + "LEFT JOIN Categories AS c ON a.categoryID = c.categoryID "
                + "LEFT JOIN Profile AS d ON b.emailAddress = d.emailAddress "
                + "WHERE (a.courseName LIKE ? "
                + "OR d.fullName LIKE ? "
                + "OR c.categoryName LIKE ? "
                + "OR c.categoryDescription LIKE ?) "
                + "AND a.visibility != 0 ";

        if (filterStatus != null) {
            if (filterStatus) {
                sql += "AND a.price = 0.0 ";
            } else {
                sql += "AND a.price > 0.0 ";
            }
        }

        PreparedStatement ppsm = connection.prepareStatement(sql);
        String searchPattern = "%" + name + "%";
        ppsm.setString(1, searchPattern);
        ppsm.setString(2, searchPattern);
        ppsm.setString(3, searchPattern);
        ppsm.setString(4, searchPattern);

        ArrayList<Course> courseList = new ArrayList<>();
        ResultSet rs = ppsm.executeQuery();
        while (rs.next()) {
            int courseId = rs.getInt("courseID");

            if (minRating != null) {
                float courseRating = getCourseRating(courseId);
                if (courseRating >= minRating) {
                    courseList.add(this.getReleasedCourse(courseId));
                }
            } else {
                courseList.add(this.getReleasedCourse(courseId));
            }
        }

        return courseList;
    }
    public void UnenrollCourse(int courseid) {
        try {
            String sql = " delete from AccessibleCourse\n"
                    + " where courseID=?";
            PreparedStatement stm = connection.prepareStatement(sql);
            stm.setInt(1, courseid);
            stm.executeUpdate();
        } catch (SQLException ex) {
            Logger.getLogger(CourseContext.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    /**
     * HieuTC Get realtime price.
     */
    public float getPriceOnDate(int courseId, java.util.Date date) throws SQLException {
        String sql = "select top(1)\n"
                + "case\n"
                + "	when DiscountEvent.event is not null\n"
                + "	then price - (price * cast (DiscountEvent.discount as float) / 100)\n"
                + "	else price\n"
                + "end as price\n"
                + "from Courses\n"
                + "left join PricePackage\n"
                + "on Courses.courseID = PricePackage.courseID\n"
                + "left join DiscountEvent\n"
                + "on PricePackage.event = DiscountEvent.event\n"
                + "where Courses.courseID = 4 and PricePackage.approved = 1 \n"
                + "and (? between startDate and endDate) and Courses.courseId = ?\n"
                + "order by DiscountEvent.discount desc;";
        PreparedStatement ppsm = connection.prepareStatement(sql);
        ppsm.setInt(2, courseId);
        ppsm.setString(1, new SimpleDateFormat("yyyy-MM-dd").format(date));
        ResultSet rs = ppsm.executeQuery();

        float price = 0;
        while (rs.next()) {
            price = rs.getFloat("price");
        }

        return price;
    }

    public Wishlist getWishListByEmail(String email) throws SQLException, ParseException {
        Wishlist wishList = new Wishlist();
        ArrayList<Course> listCourse = new ArrayList<>();
        User user = new User();

        String sql = "select * from [WishList]\n"
                + "where [emailAddress] = ?";
        PreparedStatement stm = connection.prepareStatement(sql);
        stm.setString(1, email);
        ResultSet rs = stm.executeQuery();

        while (rs.next()) {
            int courseId = rs.getInt("courseID");
            Course course = this.getCourse(courseId);
            listCourse.add(course);
        }

        user.setEmail(email);
        wishList.setCourseId(listCourse);
        wishList.setEmail(user);

        return wishList;
    }

    public void removeCourseInWishList(String email, int courseId) throws SQLException {
        String sql = "DELETE FROM [dbo].[WishList] W"
                + "HERE emailAddress = ? AND courseID = ?";

        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setString(1, email);
            stm.setInt(2, courseId);
            stm.executeUpdate();
        }
    }

    public void addCourseInWishList(String email, int courseId) throws SQLException {
        String sql = "INSERT INTO [dbo].[WishList]\n"
                + "           ([emailAddress]\n"
                + "           ,[courseID])\n"
                + "     VALUES\n"
                + "           (?,?)";

        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setString(1, email);
            stm.setInt(2, courseId);
            stm.executeUpdate();
        }
    }

    /**
     * HieuTC Get quiz.
     */
    public Quiz getQuiz(int quizId) throws SQLException, ParseException {
        String sql = "select quizTitle, quizDescription, passedTarget,"
                + "numberQuestion, questionRandomly, duration, addedTime\n"
                + "from Quiz\n"
                + "where quizId = ?;";
        PreparedStatement ppsm = connection.prepareStatement(sql);
        ppsm.setInt(1, quizId);
        ResultSet rs = ppsm.executeQuery();
        Quiz quiz = new Quiz();
        while (rs.next()) {
            quiz.setId(quizId);
            quiz.setTitle(rs.getString("quizTitle"));
            quiz.setDescription(rs.getString("quizDescription"));
            quiz.setPassedTarget(rs.getFloat("passedTarget"));
            quiz.setNumberQuestion(
                    rs.getInt("numberQuestion"));
            quiz.setQuestionRandomly(
                    rs.getBoolean("questionRandomly"));
            quiz.setQuestionRandomly(rs.getBoolean("questionRandomly"));
            quiz.setDuration(rs.getTime("duration"));
            quiz.setAddedTime(dateTime
                    .parse(rs.getString("addedTime")));
        }
        return quiz;
    }

    public ArrayList<Quiz> getQuizList(int sectionId) throws SQLException, ParseException {
        String sql = "select quizId\n"
                + "from Quiz\n"
                + "where sectionId = ?";
        PreparedStatement ppsm = connection.prepareStatement(sql);
        ppsm.setInt(1, sectionId);
        ResultSet rs = ppsm.executeQuery();
        ArrayList<Quiz> quizList = new ArrayList<>();
        while (rs.next()) {
            quizList.add(this.getQuiz(rs.getInt("quizId")));
        }
        return quizList;
    }

    /**
     * HieuTC.
     */
    public Resource getResource(int resourceId) throws SQLException, ParseException {
        String sql = "select resourceName, resourceType,"
                + " resourcePath, uploadedDate\n"
                + "from Resources\n"
                + "where resourceId = ?;";
        PreparedStatement ppsm = connection.prepareStatement(sql);
        ppsm.setInt(1, resourceId);
        Resource resource = new Resource();
        ResultSet rs = ppsm.executeQuery();

        while (rs.next()) {
            resource.setId(resourceId);
            resource.setName(rs.getString("resourceName"));
            resource.setType(rs.getString("resourceType"));
            resource.setPath(rs.getString("resourcePath"));
            resource.setUploadedDate(dateTime
                    .parse(rs.getString("uploadedDate")));
        }

        return resource;
    }

    public ArrayList<Resource> getResourceList(String email) throws SQLException, ParseException {
        String sql = "select resourceId\n"
                + "from Resources\n"
                + "join Lesson\n"
                + "on Resources.lessonId = Lesson.lessonID\n"
                + "join Sections\n"
                + "on Lesson.sectionID = Sections.sectionID\n"
                + "join Courses\n"
                + "on Sections.courseID = Courses.courseID\n"
                + "where emailAddress = ?;";
        PreparedStatement ppsm = connection.prepareStatement(sql);
        ppsm.setString(1, email);
        ResultSet rs = ppsm.executeQuery();
        ArrayList<Resource> resourceList = new ArrayList<>();
        while (rs.next()) {
            resourceList.add(this.getResource(
                    rs.getInt("resourceId")));
        }
        return resourceList;
    }

    public Resource getResourceByLesson(int lessonId) throws SQLException, ParseException {
        String sql = "select top(1) resourceId\n"
                + "from Resources\n"
                + "where lessonId = ?\n"
                + "order by resourceId desc";
        PreparedStatement ppsm = connection.prepareStatement(sql);
        ppsm.setInt(1, lessonId);
        ResultSet rs = ppsm.executeQuery();
        Resource resource = new Resource();

        while (rs.next()) {
            resource = this.getResource(
                    rs.getInt("resourceId"));
        }
        return resource;

    }

    public Video getVideo(int videoId) throws SQLException, ParseException {
        String sql = "select videoName, videoType,"
                + "videoTime, videoPath, uploadedDate\n"
                + "from Videos\n"
                + "where videoId = ?";
        PreparedStatement ppsm = connection.prepareStatement(sql);
        ppsm.setInt(1, videoId);
        Video video = null;
        ResultSet rs = ppsm.executeQuery();

        while (rs.next()) {
            video = new Video();
            video.setId(videoId);
            video.setName(rs.getString("videoName"));
            video.setType(rs.getString("videoType"));
            video.setTime(rs.getFloat("videoTime"));
            video.setPath(rs.getString("videoPath"));
            video.setUploadedUpdate(dateTime
                    .parse(rs.getString("uploadedDate")));

        }

        return video;

    }

    public Question getQuestion(int questionId) throws SQLException {
        String sql = "select questionId, questionContent\n"
                + "from Questions\n"
                + "where questionId = ?";
        PreparedStatement ppsm = connection.prepareStatement(sql);
        ppsm.setInt(1, questionId);
        ResultSet rs = ppsm.executeQuery();
        Question question = null;
        QuizContext quizContext = new QuizContext();
        while (rs.next()) {
            question = new Question();
            question.setId(questionId);
            question.setAnswers(quizContext
                    .getAswerByQuestionID(questionId));
            question.setContent(rs.getString("questionContent"));
        }
        return question;
    }

    public Interaction getInteraction(int interactionId) throws SQLException, ParseException {
        String sql = "select interactionId, questionId, atTime, position, size, addedTime\n"
                + "from Interactions\n"
                + "where interactionId = ?;";
        PreparedStatement ppsm = connection.prepareStatement(sql);
        ppsm.setInt(1, interactionId);
        Interaction interaction = null;
        ResultSet rs = ppsm.executeQuery();
        while (rs.next()) {
            interaction = new Interaction();
            interaction.setId(interactionId);
            interaction.setQuestion(this.getQuestion(
                    rs.getInt("questionId")));
            interaction.setAtTime(rs.getFloat("atTime"));
            interaction.setPosition(rs.getString("position"));
            interaction.setSize(rs.getString("size"));
            interaction.setAddedTime(dateTime
                    .parse(rs.getString("addedTime")));
        }

        return interaction;
    }

    public ArrayList<Interaction> getInteractionList(int lessonId, int videoId) throws SQLException, ParseException {
        String sql = "select interactionId\n"
                + "from Interactions\n"
                + "where lessonId = ? and videoId = ?;";
        PreparedStatement ppsm = connection.prepareStatement(sql);
        ppsm.setInt(1, lessonId);
        ppsm.setInt(2, videoId);
        ResultSet rs = ppsm.executeQuery();
        ArrayList<Interaction> interactionList = new ArrayList<>();
        while (rs.next()) {
            interactionList.add(this
                    .getInteraction(rs.getInt("interactionId")));
        }
        return interactionList;
    }

    /* HaiNV */
    public ArrayList<Course> getEnrolledCoursesByEmail(String email) throws SQLException, ParseException {
        String sql = "SELECT [emailAddress]\n"
                + "      ,[courseId]\n"
                + "  FROM [AccessibleCourse]\n"
                + "  WHERE [emailAddress] = ?";
        PreparedStatement ppsm = connection.prepareStatement(sql);
        ppsm.setString(1, email);
        ResultSet rs = ppsm.executeQuery();
        ArrayList<Course> enrolledCourses = new ArrayList<>();
        while (rs.next()) {
            enrolledCourses.add(this.getCourse(rs.getInt("courseId")));
        }
        return enrolledCourses;
    }

    /* HaiNV */
    public List<Integer> getCompletedLessonId(String email, int courseId) throws SQLException {
        String sql = "SELECT sl.lessonID "
                + "FROM StudiedLesson sl "
                + "JOIN Lesson l ON sl.lessonID = l.lessonID "
                + "WHERE l.sectionId IN (SELECT sectionId FROM Sections WHERE courseId = ?) "
                + "AND sl.emailAddress = ?";
        PreparedStatement ppsm = connection.prepareStatement(sql);
        ppsm.setInt(1, courseId);
        ppsm.setString(2, email);
        ResultSet rs = ppsm.executeQuery();

        List<Integer> completedLessonIds = new ArrayList<>();
        while (rs.next()) {
            completedLessonIds.add(rs.getInt("lessonID"));
        }
        return completedLessonIds;
    }

    /* HaiNV */
    public void insertCourseRating(int courseId, String emailAddress, int starRate, String comment, Timestamp ratedTime) {
        String sql = "INSERT INTO CourseRating (courseID, emailAddress, starRate, comment, ratedTime) VALUES (?, ?, ?, ?, ?)";

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, courseId);
            ps.setString(2, emailAddress);
            ps.setInt(3, starRate);
            ps.setString(4, comment);
            ps.setTimestamp(5, ratedTime);

            ps.executeUpdate();

            System.out.println("Insert into CourseRating successful.");
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    /* HaiNV */
    public RatingStatistics calculateRatingStatistics(int courseId) throws SQLException {
        PreparedStatement ps = null;
        ResultSet rs = null;
        RatingStatistics ratingStatistics = null;

        try {
            /* Calculate the average total starRate */
            String sql = "SELECT \n"
                    + "    CASE \n"
                    + "        WHEN COUNT(starRate) > 0 THEN CAST(SUM(starRate) AS FLOAT) / COUNT(starRate)\n"
                    + "        ELSE 0\n"
                    + "    END AS averageRating\n"
                    + "FROM CourseRating\n"
                    + "WHERE courseID = ?";
            ps = connection.prepareStatement(sql);
            ps.setInt(1, courseId);
            rs = ps.executeQuery();
            double averageRating = 0.0;
            if (rs.next()) {
                averageRating = rs.getDouble("averageRating");
            }

            /* Calculate the total number of rate */
            String countSql = "SELECT COUNT(*) AS totalRatings FROM CourseRating WHERE courseId = ?";
            ps = connection.prepareStatement(countSql);
            ps.setInt(1, courseId);
            rs = ps.executeQuery();
            int totalRatings = 0;
            if (rs.next()) {
                totalRatings = rs.getInt("totalRatings");
            }
            int[] starCounts = new int[5];
            double[] starPercentages = new double[5];

            /* Calculate the number and percentage of each rating from 1 to 5 stars */
            for (int i = 1; i <= 5; i++) {
                String starCountSql = "SELECT COUNT(*) AS starCount FROM CourseRating WHERE courseId = ? AND starRate = ?";
                ps = connection.prepareStatement(starCountSql);
                ps.setInt(1, courseId);
                ps.setInt(2, i);
                rs = ps.executeQuery();
                int starCount = 0;
                if (rs.next()) {
                    starCount = rs.getInt("starCount");
                }
                starCounts[i - 1] = starCount;
                starPercentages[i - 1] = (totalRatings > 0) ? (double) starCount / totalRatings * 100 : 0;
            }

            ratingStatistics = new RatingStatistics(averageRating, starCounts, starPercentages);

        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            /* close ResultSet and PreparedStatement */
            if (rs != null) {
                try {
                    rs.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
            if (ps != null) {
                try {
                    ps.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
        return ratingStatistics;
    }

    /* HaiNV */
    public boolean checkUserEnrollment(String emailAddress, int courseId) {
        boolean isEnrolled = false;
        String sql = "SELECT COUNT(*) FROM AccessibleCourse WHERE emailAddress = ? AND courseID = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, emailAddress);
            ps.setInt(2, courseId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    int count = rs.getInt(1);
                    if (count > 0) {
                        isEnrolled = true;
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return isEnrolled;
    }

    /*
    *HuyLQ
    *Add course to accessibleCourse
     */
    public void addCourseToAccessible(String email, int courseId) throws SQLException {
        String insertSql = "INSERT INTO [dbo].[AccessibleCourse] ([emailAddress], [courseID],[enrolledTime],[hiddenState]) VALUES (?, ?,GETDATE(),0)";
        String deleteSql = "DELETE FROM [dbo].[WishList] WHERE [emailAddress] = ? AND [courseID] = ?";

        try (PreparedStatement insertStmt = connection.prepareStatement(insertSql); PreparedStatement deleteStmt = connection.prepareStatement(deleteSql)) {

            insertStmt.setString(1, email);
            insertStmt.setInt(2, courseId);
            insertStmt.executeUpdate();

            deleteStmt.setString(1, email);
            deleteStmt.setInt(2, courseId);
            deleteStmt.executeUpdate();

        } catch (SQLException e) {
        }

    }
    public void addAccessibleCourse(String email, String courseId) throws SQLException {
        String sql = "INSERT INTO [dbo].[AccessibleCourse] ([emailAddress], [courseID],[enrolledTime],[hiddenState]) VALUES (?, ?,GETDATE(),0)";

        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setString(1, email);
            stm.setString(2, courseId);
            stm.executeUpdate();
        }
    }

    public ArrayList<Course> getCourseListByCategoryAndInstructor(String email, String categoryId)
            throws SQLException, ParseException {
        String sql = "select a.courseID from Courses as a where a.visibility = 1 and a.emailAddress=? and a.categoryID=?";
        PreparedStatement ppsm = connection.prepareStatement(sql);

        ppsm.setString(1, email);
        ppsm.setString(2, categoryId);
        ResultSet rs = ppsm.executeQuery();
        ArrayList<Course> courseList = new ArrayList<>();
        while (rs.next()) {
            courseList.add(this.getReleasedCourse(rs.getInt("courseID")));
        }
        rs.close();
        ppsm.close();
        return courseList;
    }

    public ArrayList<Course> getStaRateByCourses() throws ParseException, SQLException {
        String sql = "SELECT a.courseID\n"
                + "FROM Courses AS a\n"
                + "LEFT JOIN (\n"
                + "   SELECT courseID, MAX(starRate) AS starRate\n"
                + "   FROM CourseRating\n"
                + "   GROUP BY courseID\n"
                + ") AS b ON a.courseID = b.courseID\n";

        PreparedStatement ppsm = connection.prepareStatement(sql);
        ResultSet rs = ppsm.executeQuery();

        ArrayList<Course> courseList = new ArrayList<>();
        while (rs.next()) {
            int courseId = rs.getInt("courseID");

            float courseRating = getCourseRating(courseId);

            if (courseRating >= 4) {
                courseList.add(this.getReleasedCourse(courseId));
            }
        }

        return courseList;
    }

    public AccessibleCourse getAccourseByID(String email, int courseID) throws ParseException {
        try {
            String sql = "select a.courseID from AccessibleCourse as a \n"
                    + "where a.emailAddress=? and a.courseID=?";
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, email);
            st.setInt(2, courseID);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                AccessibleCourse t = new AccessibleCourse();
                t.setEmail(email);
                t.setCourse(this.getReleasedCourse(rs.getInt("courseID")));
                return t;
            }
        } catch (SQLException ex) {
            Logger.getLogger(CourseContext.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }

    public ArrayList<Course> getCourseListByInstructor(String email)
            throws SQLException, ParseException {
        String sql = "select a.courseID from Courses as a where a.visibility = 1 and a.emailAddress=?";
        PreparedStatement ppsm = connection.prepareStatement(sql);

        ppsm.setString(1, email);
        ResultSet rs = ppsm.executeQuery();
        ArrayList<Course> courseList = new ArrayList<>();
        while (rs.next()) {
            courseList.add(this.getReleasedCourse(rs.getInt("courseID")));
        }
        rs.close();
        ppsm.close();
        return courseList;
    }

    public ArrayList<Course> sumRatingByEmail(String email)
            throws SQLException, ParseException {
        String sql = "select a.courseID from Courses as a\n"
                + "join CourseRating as b\n"
                + "On a.courseID=b.courseID\n"
                + "where a.emailAddress=?";
        PreparedStatement ppsm = connection.prepareStatement(sql);

        ppsm.setString(1, email);
        ResultSet rs = ppsm.executeQuery();
        ArrayList<Course> courseList = new ArrayList<>();
        while (rs.next()) {
            courseList.add(this.getReleasedCourse(rs.getInt("courseID")));
        }
        rs.close();
        ppsm.close();
        return courseList;
    }

    //TuanPD
    public ArrayList<Course> totalStudentOfInstructor(String email)
            throws SQLException, ParseException {
        String sql = "select a.courseID from Courses as a\n"
                + "join AccessibleCourse as b\n"
                + "On a.courseID=b.courseID\n"
                + "where a.emailAddress=?";
        PreparedStatement ppsm = connection.prepareStatement(sql);

        ppsm.setString(1, email);
        ResultSet rs = ppsm.executeQuery();
        ArrayList<Course> courseList = new ArrayList<>();
        while (rs.next()) {
            courseList.add(this.getReleasedCourse(rs.getInt("courseID")));
        }
        rs.close();
        ppsm.close();
        return courseList;
    }

    public void deteleNote(int noteId) throws SQLException {
        String sql = "delete Notes\n"
                + "where noteId = ?;";
        PreparedStatement ppsm = connection.prepareStatement(sql);
        ppsm.setInt(1, noteId);

        ppsm.executeUpdate();
        ppsm.close();
    }

    public void deleteInteraction(int interactionId) throws SQLException {
        String sql = "delete Interactions\n"
                + "where interactionId = ?;";
        PreparedStatement ppsm = connection.prepareStatement(sql);
        ppsm.setInt(1, interactionId);

        ppsm.executeUpdate();
        ppsm.close();
    }

    public void deleteAnswer(int answerId) throws SQLException {
        String sql = "delete Answers\n"
                + "where answerId = ?;";
        PreparedStatement ppsm = connection.prepareStatement(sql);
        ppsm.setInt(1, answerId);

        ppsm.executeUpdate();
        ppsm.close();
    }

    public void deleteQuestion(int questionId) throws SQLException {
        String sql = "select answerId\n"
                + "from Answers\n"
                + "where questionId = ?";
        PreparedStatement ppsm = connection.prepareStatement(sql);
        ppsm.setInt(1, questionId);
        ResultSet rs = ppsm.executeQuery();

        while (rs.next()) {
            this.deleteAnswer(rs.getInt("answerId"));
        }
        sql = "delete Questions\n"
                + "where questionId = ?;";
        ppsm = connection.prepareStatement(sql);
        ppsm.setInt(1, questionId);

        ppsm.executeUpdate();
        ppsm.close();
    }
    
    /*
    * HieuTC
    */
    
    public ArrayList<Course> getCourseListByCategory(String category) throws SQLException, ParseException {
        String sql = "select courseId\n"
                + "from Courses\n"
                + "where categoryId = ?;";
        PreparedStatement ppsm = connection.prepareStatement(sql);
        ppsm.setString(1, category);
        ResultSet rs = ppsm.executeQuery();
        
        ArrayList<Course> courseList = new ArrayList<>();
        while (rs.next()) {
            Course course = this.getReleasedCourse(
                    rs.getInt("courseId"));
            courseList.add(course);
        }
        
        return courseList;
    }
    
    public ArrayList<Instructor> getInstructorListByCategory(String category) throws SQLException, ParseException {
        String sql = "select Instructor.emailAddress\n"
                + "from Instructor\n"
                + "join Courses\n"
                + "on Instructor.emailAddress = Courses.emailAddress\n"
                + "where categoryID = ?\n"
                + "group by Instructor.emailAddress;";
        PreparedStatement ppsm = connection.prepareStatement(sql);
        ppsm.setString(1, category);
        ResultSet rs = ppsm.executeQuery();
        
        InstructorContext instructorContext = new InstructorContext();
        ArrayList<Instructor> instructorList = new ArrayList<>();
        while (rs.next()) {
            Instructor instructor = instructorContext
                    .getInstructor(rs.getString("emailAddress"));
            instructorList.add(instructor);
        }
        
        return instructorList;
    }
    
    // Submit Course
    public CourseSubmission getCourseSubmissionSatus(int id) {
        try {
            String sql = "SELECT courseId, submitedTime, [status], responseTime\n"
                    + "FROM ReviewRequest\n"
                    + "WHERE courseId =?";
            PreparedStatement stm = connection.prepareStatement(sql);
            stm.setInt(1, id);
            ResultSet rs = stm.executeQuery();
            if (rs.next()) {
                CourseSubmission course = new CourseSubmission();
                course.setSubmitedTime(rs.getDate("submitedTime"));
                course.setResponseTime(rs.getDate("responseTime"));
                course.setStatus(rs.getInt("status"));
                return course;
            }
        } catch (SQLException ex) {
            Logger.getLogger(CourseContext.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }

    public void deleteCourseSubmission(int id) {
        try {
            String sql = "DELETE FROM [dbo].[ReviewRequest]\n"
                    + "      WHERE courseId = ?";
            PreparedStatement stm = connection.prepareStatement(sql);
            stm.setInt(1, id);
            stm.execute();
        } catch (SQLException ex) {
            Logger.getLogger(CourseContext.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    public void submitCourse(int id) {
        try {
            String sql = "INSERT INTO [dbo].[ReviewRequest] \n"
                    + "   ([courseId] \n"
                    + "   ,[submitedTime],[status]) \n"
                    + "   VALUES(?,GETDATE(),0)";
            PreparedStatement stm = connection.prepareStatement(sql);
            stm.setInt(1, id);
            stm.execute();
        } catch (SQLException ex) {
            Logger.getLogger(CourseContext.class.getName()).log(Level.SEVERE, null, ex);
        }

    }

    public void resposeCourseSubmited(int id, int response) {

        try {
            String sql = "UPDATE [dbo].[ReviewRequest]\n"
                    + "   SET [status] = ?\n"
                    + "      ,[responseTime] = GETDATE()\n"
                    + " WHERE courseId = ?";
            PreparedStatement stm = connection.prepareStatement(sql);
            stm.setInt(1, response);
            stm.setInt(2, id);
            stm.executeUpdate();
        } catch (SQLException ex) {
            Logger.getLogger(CourseContext.class.getName()).log(Level.SEVERE, null, ex);
        }

    }
    

    // Course Review
    public ArrayList<CourseSubmission> getCourseReview(String key, String category) {
        ArrayList<CourseSubmission> list = new ArrayList<>();
        try {
            String sql = "select c.courseName, c.courseID, c.thumbnail,c.price, c.createdTime,\n"
                    + "                     ca.categoryName , p.fullName, p.emailAddress,\n"
                    + "					 rq.submitedTime,rq.[status],rq.responseTime\n"
                    + "                     from Courses c inner join Categories ca on ca.categoryID = c.categoryID\n"
                    + "                     inner join Instructor i on i.emailAddress= c.emailAddress\n"
                    + "                     inner join [Profile] p  on p.emailAddress = c.emailAddress\n"
                    + "			inner join ReviewRequest rq on rq.courseId = c.courseID"
                    + "                 where (rq.[status] = 0 or rq.[status] is NULL) ";
            if (key != null && key!= "") {
                sql += "and (c.courseName like ? or p.fullName like ? or p.emailAddress like ?) ";
            }
            if (category != null && category != "") {
                sql += "and ca.categoryName = ?";
            }

            PreparedStatement stm = connection.prepareStatement(sql);
            int count = 1;
            if (key != null && !key.isBlank()) {
                stm.setString(count++, "%" + key + "%");
                stm.setString(count++, "%" + key + "%");
                stm.setString(count++, "%" + key + "%");
            }
            if (category != null && !category.isBlank()) {
                stm.setString(count, category);
            }
            ResultSet rs = stm.executeQuery();
            while (rs.next()) {
                Course c = new Course();
                c.setId(rs.getInt("courseID"));
                c.setName(rs.getString("courseName"));
                c.setThumbnail(rs.getString("thumbnail"));
                c.setPrice(rs.getFloat("price"));
                c.setCreatedTime(rs.getDate("createdTime"));

                Category ca = new Category();
                ca.setName(rs.getString("categoryName"));
                c.setCategory(ca);

                Instructor i = new Instructor();
                i.setEmail(rs.getString("emailAddress"));
                Profile p = new Profile();
                p.setName(rs.getString("fullName"));
                i.setProfile(p);
                c.setInstructor(i);

                CourseSubmission cs = new CourseSubmission();
                cs.setSubmitedTime(rs.getDate("submitedTime"));
                cs.setCourse(c);
                list.add(cs);
            }
        } catch (SQLException ex) {
            Logger.getLogger(CourseContext.class.getName()).log(Level.SEVERE, null, ex);
        }
        return list;
    }
    
    
      /*get discount event 
    HuyLQ */
    public ArrayList<DiscountEvent> getEvent() throws SQLException, ParseException {
        ArrayList<DiscountEvent> eventList = new ArrayList<>();
        String sql = "SELECT [event]\n"
                + "      ,[discount]\n"
                + "      ,[startDate]\n"
                + "      ,[endDate]\n"
                + "  FROM [DiscountEvent]";
        PreparedStatement stm = connection.prepareStatement(sql);
        ResultSet rs = stm.executeQuery();
        while (rs.next()) {
            DiscountEvent event = new DiscountEvent();
            event.setDiscount(rs.getInt("discount"));
            event.setEvent(rs.getString("event"));
            event.setStartDate(rs.getDate("startDate"));
            event.setEndDate(rs.getDate("endDate"));

            eventList.add(event);
        }
        rs.close();
        stm.close();
        return eventList;
    }

    /*get create  event 
    HuyLQ */
    public void createEvent(String title, int discount, String startDate, String endDate) throws SQLException {
        String sql = "INSERT INTO [dbo].[DiscountEvent]\n"
                + "           ([event]\n"
                + "           ,[discount]\n"
                + "           ,[startDate]\n"
                + "           ,[endDate])\n"
                + "     VALUES\n"
                + "           (?,?,?,?)";
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setString(1, title);
            stm.setInt(2, discount);
            stm.setString(3, startDate);
            stm.setString(4, endDate);
            stm.executeUpdate();
        }
    }

    /*update information event 
    HuyLQ */
    public Boolean updateEvent(String eventCurrent, String eventNew, int discountNew, String startDateNew, String endDateNew) {
        boolean rowUpdated = false;
        String sql = "UPDATE [dbo].[DiscountEvent]\n"
                + "SET \n"
                + "    [event] = COALESCE(NULLIF(?, ''), [event]),\n"
                + "    [discount] = COALESCE(NULLIF(?, ''), [discount]),\n"
                + "    [startDate] = COALESCE(NULLIF(?, ''), [startDate]),\n"
                + "    [endDate] = COALESCE(NULLIF(?, ''), [endDate])\n"
                + "WHERE [event] =?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, eventNew);
            st.setInt(2, discountNew);
            st.setString(3, startDateNew);
            st.setString(4, endDateNew);
            st.setString(5, eventCurrent);
            int rowsAffected = st.executeUpdate();
            rowUpdated = rowsAffected > 0;
        } catch (SQLException ex) {
            Logger.getLogger(UserContext.class.getName()).log(Level.SEVERE, null, ex);
        }
        return rowUpdated;
    }

    public void deleteEvent(String event) {
        String sql = "DELETE FROM [dbo].[DiscountEvent]\n"
                + "      WHERE [event] =? \n";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, event);
            st.executeUpdate();
        } catch (SQLException ex) {
            Logger.getLogger(UserContext.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    public ArrayList<DiscountEvent> searchEvent(String eventName, String sortByDiscount, String fromDate, String toDate) throws ParseException {
        ArrayList<DiscountEvent> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT event, discount, startDate, endDate FROM [dbo].[DiscountEvent] WHERE 1=1");
        List<Object> params = new ArrayList<>();
        // Add filters to the query
        if (eventName != null && !eventName.isEmpty()) {
            String searchPattern = "%" + eventName + "%";
            sql.append(" AND event LIKE ?");
            params.add(searchPattern);
        }
        if (fromDate != null && !fromDate.isEmpty() && toDate != null && !toDate.isEmpty()) {
            sql.append(" AND startDate BETWEEN ? AND ?");
            params.add(java.sql.Date.valueOf(fromDate));
            params.add(java.sql.Date.valueOf(toDate));
        }
        if (sortByDiscount != null && !sortByDiscount.isEmpty()) {
            if (sortByDiscount.equalsIgnoreCase("asc")) {
                sql.append(" ORDER BY discount ASC");
            } else if (sortByDiscount.equalsIgnoreCase("desc")) {
                sql.append(" ORDER BY discount DESC");
            }
        }
        // Debug: In ra câu truy vấn SQL và các tham số
        System.out.println("SQL Query: " + sql.toString());
        System.out.println("Parameters: " + params);
        try {
            PreparedStatement ppsm = connection.prepareStatement(sql.toString());
            for (int i = 0; i < params.size(); i++) {
                ppsm.setObject(i + 1, params.get(i));
            }
            ResultSet rs = ppsm.executeQuery();
            while (rs.next()) {
                DiscountEvent event = new DiscountEvent();
                event.setEvent(rs.getString("event"));
                event.setDiscount(rs.getInt("discount"));
                event.setStartDate(rs.getDate("startDate"));
                event.setEndDate(rs.getDate("endDate"));
                list.add(event);
            }
        } catch (SQLException ex) {
            Logger.getLogger(CourseContext.class.getName()).log(Level.SEVERE, null, ex);
        }

        return list;
    }

    public ArrayList<CourseDiscount> getPricePackage() throws SQLException, ParseException {
        ArrayList<CourseDiscount> list = new ArrayList<>();
        String sql = "SELECT c.courseID, d.[event], c.courseName, c.thumbnail, c.price, d.discount, po.fullName, p.approved "
                + "FROM PricePackage p "
                + "INNER JOIN Courses c ON c.courseID = p.courseID "
                + "INNER JOIN [Profile] po ON c.emailAddress = po.emailAddress "
                + "INNER JOIN DiscountEvent d ON d.[event] = p.[event]";
        PreparedStatement ppsm = connection.prepareStatement(sql);
        ResultSet rs = ppsm.executeQuery();
        while (rs.next()) {
            boolean approved = rs.getBoolean("approved");

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
            courseDiscount.setApproved(approved);
            list.add(courseDiscount);
        }

        return list;
    }

    public ArrayList<CourseDiscount> searchCourseDiscount(String instructorName, String sortByDiscount) throws SQLException, ParseException {
        ArrayList<CourseDiscount> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT d.[event], c.courseName, c.thumbnail, c.price, d.discount, po.fullName, p.approved "
                + "FROM PricePackage p "
                + "INNER JOIN Courses c ON c.courseID = p.courseID "
                + "INNER JOIN [Profile] po ON c.emailAddress = po.emailAddress "
                + "INNER JOIN DiscountEvent d ON d.[event] = p.[event] "
                + "WHERE 1=1");
        List<Object> params = new ArrayList<>();

        // Add filters to the query
        if (instructorName != null && !instructorName.isEmpty()) {
            String searchPattern = "%" + instructorName + "%";
            sql.append(" AND po.fullName LIKE ?");
            params.add(searchPattern);
        }
        if (sortByDiscount != null && !sortByDiscount.isEmpty()) {
            if (sortByDiscount.equalsIgnoreCase("asc")) {
                sql.append(" ORDER BY d.discount ASC");
            } else if (sortByDiscount.equalsIgnoreCase("desc")) {
                sql.append(" ORDER BY d.discount DESC");
            }
        }

        // Debug: In ra câu truy vấn SQL và các tham số
        System.out.println("SQL Query: " + sql.toString());
        System.out.println("Parameters: " + params);

        try {
            PreparedStatement ppsm = connection.prepareStatement(sql.toString());
            for (int i = 0; i < params.size(); i++) {
                ppsm.setObject(i + 1, params.get(i));
            }
            ResultSet rs = ppsm.executeQuery();
            while (rs.next()) {
                boolean approved = rs.getBoolean("approved");

                Profile profile = new Profile();
                profile.setName(rs.getString("fullName"));

                Instructor instructor = new Instructor();
                instructor.setProfile(profile);

                Course course = new Course();
                course.setName(rs.getString("courseName"));
                course.setThumbnail(rs.getString("thumbnail"));
                course.setPrice(rs.getFloat("price"));
                course.setInstructor(instructor);

                DiscountEvent discountEvent = new DiscountEvent();
                discountEvent.setEvent(rs.getString("event"));
                discountEvent.setDiscount(rs.getInt("discount"));

                CourseDiscount courseDiscount = new CourseDiscount();
                courseDiscount.setCourse(course);
                courseDiscount.setDiscountEvent(discountEvent);
                courseDiscount.setApproved(approved);
                list.add(courseDiscount);
            }
        } catch (SQLException ex) {
            Logger.getLogger(CourseContext.class.getName()).log(Level.SEVERE, null, ex);
        }

        return list;
    }

    public void deleteOrUpdateCourseDiscounted(String action, int courseID, String nameEvent) {
        String sql = null;
        if (action.equalsIgnoreCase("delete")) {
            sql = "DELETE FROM [dbo].[PricePackage] WHERE courseID = ? AND event LIKE ?";
        } else if (action.equalsIgnoreCase("accept")) {
            sql = "UPDATE [dbo].[PricePackage] SET approved = 1 WHERE courseID = ? AND event LIKE ?";
        } 
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, courseID);
            st.setString(2, nameEvent);
            st.executeUpdate();
        } catch (SQLException ex) {
            Logger.getLogger(UserContext.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

///TuanPD
    public void updateVisibility(int courseId, int newVisibility) {
        try {
            String sql = "UPDATE [Courses] SET [visibility] = ? WHERE [courseID] = ?";
            PreparedStatement stm = connection.prepareStatement(sql);
            stm.setInt(1, newVisibility);
            stm.setInt(2, courseId);
            stm.executeUpdate();
        } catch (SQLException ex) {
            Logger.getLogger(CourseContext.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
    public ArrayList<Category> getListCategory() {
        ArrayList<Category> list = new ArrayList<>();
        String sql = "select a.categoryID,a.categoryName from Categories as a";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();

            while (rs.next()) {
                Category c = new Category();
                c.setId(rs.getString("categoryID"));
                c.setName(rs.getString("categoryName"));
                list.add(c);
            }
        } catch (SQLException ex) {
            Logger.getLogger(CourseContext.class.getName()).log(Level.SEVERE, null, ex);
        }
        return list;
    }
    public ArrayList<AccessibleCourse> searchCourses(String key, String categoryID, String fromDate, String toDate) throws ParseException {
        ArrayList<AccessibleCourse> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT a.emailAddress, a.courseID, a.enrolledTime, a.hiddenState "
                + "FROM AccessibleCourse AS a "
                + "JOIN Courses AS b ON a.courseID = b.courseID "
                + "JOIN Instructor AS c ON b.emailAddress = c.emailAddress "
                + "JOIN [Profile] AS d ON c.emailAddress = d.emailAddress "
                + "JOIN [Categories] AS e ON b.categoryID = e.categoryID "
                + "WHERE (b.price > 0 AND a.hiddenState != 1)");

        List<Object> params = new ArrayList<>();

        // Add filters to the query
        if (categoryID != null && !categoryID.equals("all")) {
            sql.append(" AND e.categoryID = ?");
            params.add(categoryID);
        }

        if (fromDate != null && !fromDate.isEmpty() && toDate != null && !toDate.isEmpty()) {
            sql.append(" AND a.enrolledTime BETWEEN ? AND ?");
            // Adding time part to the dates to cover the full day
            params.add(java.sql.Timestamp.valueOf(fromDate + " 00:00:00"));
            params.add(java.sql.Timestamp.valueOf(toDate + " 23:59:59"));
        }

        if (key != null && !key.isEmpty()) {
            String searchPattern = "%" + key + "%";
            sql.append(" AND (d.fullName LIKE ? OR b.courseName LIKE ?)");
            params.add(searchPattern);
            params.add(searchPattern);
        }

        // Debug: In ra câu truy vấn SQL và các tham số
        System.out.println("SQL Query: " + sql.toString());
        System.out.println("Parameters: " + params);

        try {
            PreparedStatement ppsm = connection.prepareStatement(sql.toString());
            for (int i = 0; i < params.size(); i++) {
                ppsm.setObject(i + 1, params.get(i));
            }

            ResultSet rs = ppsm.executeQuery();
            while (rs.next()) {
                AccessibleCourse s = new AccessibleCourse();
                s.setEmail(rs.getString("emailAddress"));
                s.setCourse(this.getCourse(rs.getInt("courseID")));
                s.setDate(rs.getTimestamp("enrolledTime")); // Changed to getTimestamp
                s.setHiddenState(rs.getInt("hiddenState"));
                list.add(s);
            }
        } catch (SQLException ex) {
            Logger.getLogger(CourseContext.class.getName()).log(Level.SEVERE, null, ex);
        }

        return list;
    }
    public ArrayList<AccessibleCourse> getListAccessibleCourses(String email) throws ParseException {
        ArrayList<AccessibleCourse> list = new ArrayList<>();
        String sql = "select a.emailAddress,a.courseID,a.enrolledTime,a.hiddenState from AccessibleCourse as a\n"
                + "                join Courses as b\n"
                + "                On a.courseID=b.courseID\n"
                + "                where b.price>0 and a.hiddenState !=1 and a.emailAddress=?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, email);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                AccessibleCourse s = new AccessibleCourse();
                s.setEmail(rs.getString("emailAddress"));
                s.setCourse(this.getReleasedCourse(rs.getInt("courseID")));
                s.setDate(rs.getTimestamp("enrolledTime"));
                s.setHiddenState(rs.getInt("hiddenState"));
                list.add(s);
            }
        } catch (SQLException ex) {
            Logger.getLogger(CourseContext.class.getName()).log(Level.SEVERE, null, ex);
        }
        return list;
    }
    public void updateHiddenState(String email, int cid, int newState) {
        try {
            String sql = "UPDATE [AccessibleCourse] SET [hiddenState] = ? WHERE [emailAddress] = ? and [courseID] = ?";
            PreparedStatement stm = connection.prepareStatement(sql);
            stm.setInt(1, newState);
            stm.setString(2, email);
            stm.setInt(3, cid);
            stm.executeUpdate();
        } catch (SQLException ex) {
            Logger.getLogger(CourseContext.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
}
