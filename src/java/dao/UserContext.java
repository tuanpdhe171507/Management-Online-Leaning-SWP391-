/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.sql.*;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Device;
import model.Instructor;
import model.Note;
import model.Notification;
import model.Profile;
import model.User;

/**
 *
 * @author HieuTC
 */
public class UserContext extends ConnectionOpen {

    public boolean verifyAccessiblePath(String email, String path) throws SQLException {
        String sql = "select * from [UserRole]\n"
                + "join [AccessiblePath]\n"
                + "on [UserRole].role = [AccessiblePath].role"
                + " where emailAddress = ? and path = ?;";

        PreparedStatement preState = connection.prepareStatement(sql);
        preState.setString(1, email);
        preState.setString(2, path);

        ResultSet reSet = preState.executeQuery();
        while (reSet.next()) {
            return true;
            /* User can access this path*/
        }
        return false;
        /* User do not have permisson to acess this path*/
    }

    public boolean verifyUserLogInInfo(String email, String passwd) throws SQLException {
        String sql = "select * from [User]"
                + " where emailAddress = ? and password is not null and password = ?;";
        PreparedStatement preState = connection.prepareStatement(sql);
        preState.setString(1, email);
        preState.setString(2, passwd);

        return preState.executeQuery().next();
    }

    /**
     *
     * @return
     */
    public int verifyTrustedDevice(String emailAddress, String ip) throws SQLException {
        String sql = "select loggingIn from TrustedDevice"
                + " where emailAddress = ? and ip = ?;";

        PreparedStatement preState = connection.prepareStatement(sql);
        preState.setString(1, emailAddress);
        preState.setString(2, ip);
        ResultSet reSet = preState.executeQuery();

        while (reSet.next()) {
            /* Logging in*/
            return reSet.getBoolean("loggingIn") ? 1 : 0;
        }
        return -1;
    }

    public void updateLoggingIn(String emailAddress, String ip, boolean state) throws SQLException {
        String sql = "update TrustedDevice "
                + "set loggingIn = ?, lastedActivity = current_timestamp"
                + " where emailAddress = ? and ip = ?;";

        PreparedStatement preState = connection.prepareStatement(sql);
        preState.setBoolean(1, state);
        preState.setString(2, emailAddress);
        preState.setString(3, ip);
        preState.executeUpdate();
    }

    public ArrayList<Device> getTrustedDeviceList(String email) throws SQLException, ParseException {
        String sql = "select os, browser, TrustedDevice.ip , detectedTime, lastedActivity\n"
                + "from TrustedDevice\n"
                + "left join DetectedDevice\n"
                + "on TrustedDevice.ip = DetectedDevice.ip and TrustedDevice.emailAddress = DetectedDevice.emailAddress\n"
                + "where TrustedDevice.emailAddress = ? and loggingIn = 1;";
        PreparedStatement preState = connection.prepareStatement(sql);
        preState.setString(1, email);
        ResultSet rs = preState.executeQuery();
        ArrayList<Device> deviceList = new ArrayList<>();
        while (rs.next()) {
            Device device = new Device();
            device.setOs(rs.getString("os"));
            device.setBrowser(rs.getString("browser"));
            device.setIp(rs.getString("ip"));
            device.setDetectedTime(dateTime.parse(
                    rs.getString("detectedTime")));
            device.setLastedActivity(dateTime.parse(
                    rs.getString("lastedActivity")));
            deviceList.add(device);
        }
        return deviceList;
    }

    public boolean trustDevice(String email, String ip) {
        try {
            String sql = "insert into TrustedDevice(emailAddress, ip, lastedActivity)"
                    + " values(?, ?, current_timestamp)";

            PreparedStatement preState = connection.prepareStatement(sql);
            preState.setString(1, email);
            preState.setString(2, ip);

            preState.executeUpdate();
        } catch (SQLException e) {
            return false;
        }
        return true;

    }

    public String detectDevice(String email, String os, String browser,
            String ip) throws SQLException {
        String sql = "select credentialToken from DetectedDevice"
                + " where emailAddress = ? and ip = ?;";
        PreparedStatement preState = connection.prepareStatement(sql);
        preState.setString(1, email);
        preState.setString(2, ip);
        ResultSet reSet = preState.executeQuery();

        while (reSet.next()) {
            /* Update update detected time for re-verifing device*/
            sql = "update DetectedDevice set detectedTime = current_timestamp "
                    + "where emailAddress = ? and ip = ?;";
            preState = connection.prepareStatement(sql);
            preState.setString(1, email);
            preState.setString(2, ip);
            preState.executeUpdate();

            /* Return credential token have been create before */
            return reSet.getString("credentialToken");
        }

        /* Generate new credential token for new dectection */
        String credentialToken = new util.Authentication()
                .generateCredentialToken();

        sql = "insert into DetectedDevice(emailAddress, os, browser, ip, credentialToken)"
                + " values(?, ?, ?, ?, ?)";
        preState = connection.prepareStatement(sql);
        preState.setString(1, email);
        preState.setString(2, os);
        preState.setString(3, browser);
        preState.setString(4, ip);
        preState.setString(5, credentialToken);
        preState.executeUpdate();

        return credentialToken;
    }

    public boolean authenticateDevice(String email,
            String ip, String credentialToken) throws SQLException {
        String sql = "select detectedTime from DetectedDevice"
                + " where emailAddress = ? and ip = ? and credentialToken = ?";

        PreparedStatement preState = connection.prepareStatement(sql);
        preState.setString(1, email);
        preState.setString(2, ip);
        preState.setString(3, credentialToken);
        java.util.Date now = new java.util.Date();
        ResultSet reSet = preState.executeQuery();
        while (reSet.next()) {
            Timestamp detectedTime = reSet
                    .getTimestamp("detectedTime");

            /* 30 minutes - 1800000 miniseconds after detected browser,
             *   the token can not be used
             */
            return detectedTime.getTime() + 1800000 >= now.getTime();
        }
        return false;
    }

    public void signUp(String fullname, String email, String passwd) throws SQLException {
        String sql = "insert into [dbo].[Profile](emailAddress, fullName)\n"
                + "values (?, ?);"
                + "insert into [dbo].[User]([emailAddress] ,[password])\n"
                + "values (?, ?)";
        PreparedStatement stm = connection.prepareStatement(sql);
        stm.setString(1, email);
        stm.setString(2, fullname);
        stm.setString(3, email);
        stm.setString(4, passwd);

        stm.executeUpdate();

    }

    public boolean isExistedEmail(String email) {
        try {
            String sql = "select [emailAddress]\n"
                    + "  from [dbo].[User]\n"
                    + "where emailAddress = ?";
            PreparedStatement stm = connection.prepareStatement(sql);
            stm.setString(1, email);
            ResultSet rs = stm.executeQuery();
            // already existed
            return rs.next();
        } catch (SQLException ex) {
            Logger.getLogger(UserContext.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }

    public Profile getProfile(String email) throws SQLException, ParseException {
        String sql = "select profilePicture, fullName, headline, gender, registeredTime\n"
                + "from profile\n"
                + "where emailAddress = ?";
        PreparedStatement stm = connection.prepareStatement(sql);
        stm.setString(1, email);
        ResultSet rs = stm.executeQuery();

        Profile profile = new Profile();
        while (rs.next()) {
            profile.setPicture(rs.getString("profilePicture"));
            profile.setName(rs.getString("fullName"));
            profile.setHeadline(rs.getString("headline"));
            profile.setGender(rs.getBoolean("gender"));
            profile.setRegisterdTime(dateTime.parse(rs.getString("registeredTime")));
        }
        return profile;
    }

    public User getUserByEmail(String email) throws ParseException {

        try {
            String sql = "select a.emailAddress,a.password from [User] as a\n"
                    + "where a.emailAddress=?";
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, email);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                User c = new User();
                c.setEmail(rs.getString("emailAddress"));
                c.setIp(rs.getString("password"));
                return c;
            }

        } catch (SQLException ex) {
            Logger.getLogger(UserContext.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }

    public Boolean updateProfile(String emailAddress, String fullName, String profilePicture, String headline, Boolean gender) {
        boolean rowUpdated = false;
        String sql = "UPDATE [dbo].[Profile]\n"
                + "SET \n"
                + "    [fullName] = COALESCE(NULLIF(?, ''), [fullName]),\n"
                + "    [profilePicture] = COALESCE(NULLIF(?, ''), [profilePicture]),\n"
                + "    [headline] = COALESCE(NULLIF(?, ''), [headline]),\n"
                + "    [gender] = COALESCE(NULLIF(?, ''), [gender])\n"
                + "WHERE emailAddress = ?\n";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, fullName);
            st.setString(2, profilePicture);
            st.setString(3, headline);
            st.setBoolean(4, gender);
            st.setString(5, emailAddress);

            int rowsAffected = st.executeUpdate();
            rowUpdated = rowsAffected > 0;
        } catch (SQLException ex) {
            Logger.getLogger(UserContext.class.getName()).log(Level.SEVERE, null, ex);
        }
        return rowUpdated;
    }

    public Boolean updatePassword(String username, String password) {
        boolean rowUpdated = false;
        String sql = "UPDATE [User]\n"
                + "SET [password] = ?\n"
                + "WHERE emailAddress = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, password);
            st.setString(2, username);
            int rowsAffected = st.executeUpdate();
            rowUpdated = rowsAffected > 0;
        } catch (SQLException ex) {
            Logger.getLogger(UserContext.class.getName()).log(Level.SEVERE, null, ex);
        }
        return rowUpdated;
    }

    public boolean validateResetPasswordRequest(String email, String token) throws SQLException {
        String sql = "select *\n"
                + "from PasswordHelper\n"
                + "where emailAddress = ? and credentialToken = ?\n"
                + "and CURRENT_TIMESTAMP between requestedTime and DATEADD(MINUTE, 30, requestedTime);";
        PreparedStatement ppsm = connection.prepareStatement(sql);
        ppsm.setString(1, email);
        ppsm.setString(2, token);
        ResultSet rs = ppsm.executeQuery();
        while (rs.next()) {
            return true;
        }
        return false;

    }

    public Boolean updatePasswordByReset(String email, String password, String token) throws SQLException {
        boolean rowUpdated = false;
        String sql = "UPDATE u\n"
                + "SET u.[password] = ?\n"
                + "FROM [dbo].[User] u\n"
                + "INNER JOIN [Profile] p ON u.emailAddress = p.emailAddress\n"
                + "INNER JOIN [PasswordHelper] ph ON u.emailAddress = ph.emailAddress\n"
                + "WHERE u.emailAddress = ? AND ph.credentialToken = ?\n"
                + "and CURRENT_TIMESTAMP between ph.requestedTime and DATEADD(MINUTE, 30, ph.requestedTime)\n"
                + "and availableState = 1;\n";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, password);
            st.setString(2, email);
            st.setString(3, token);
            int rowsAffected = st.executeUpdate();
            rowUpdated = rowsAffected > 0;
            if (rowUpdated) {
                sql = "update PasswordHelper\n"
                        + "set availableState = 0\n"
                        + "where emailAddress = ? and credentialToken = ?;";
                PreparedStatement stm = connection.prepareStatement(sql);
                stm.setString(1, email);
                stm.setString(2, token);
                stm.executeUpdate();
            }
        } catch (SQLException ex) {
            Logger.getLogger(UserContext.class.getName()).log(Level.SEVERE, null, ex);
        }
        return rowUpdated;
    }

    public boolean fogotPassword(String email, String token) throws SQLException {
        // Email must be matched with user in database;
        if (!this.isExistedEmail(email)) {
            return false;
        }
        String sql = "INSERT INTO [PasswordHelper]\n"
                + "  ([emailAddress], [credentialToken]) \n"
                + " VALUES (?, ?)";
        PreparedStatement preState = connection.prepareStatement(sql);
        preState.setString(1, email);
        preState.setString(2, token);
        preState.executeUpdate();
        return true;
    }

    /**
     * HieuTC Get notes;
     */
    public ArrayList<Note> getNotes(String email) throws SQLException, ParseException {
        String sql = "select noteId, Notes.lessonId, lessonName, atTime, noteContent, notedTime\n"
                + "from Notes\n"
                + "join Lesson\n"
                + "on Notes.lessonId = Lesson.lessonId\n"
                + "where emailAddress = ?;";
        PreparedStatement ppsm = connection.prepareStatement(sql);
        ppsm.setString(1, email);
        ResultSet rs = ppsm.executeQuery();

        ArrayList<Note> notes = new ArrayList<>();
        CourseContext courseContext = new CourseContext();
        while (rs.next()) {
            Note note = new Note();
            note.setId(rs.getInt("noteId"));
            note.setLessonId(rs.getInt("lessonId"));
            note.setLessonName(rs.getString("lessonName"));
            note.setContent(rs.getString("noteContent"));
            note.setAtTime(rs.getString("atTime"));
            note.setNotedTime(dateTime
                    .parse(rs.getString("notedTime")));
            notes.add(note);
        }
        return notes;
    }

    public void addNote(String email, int lessonId, String atTime, String noteContent) throws SQLException {
        String sql = "insert into Notes(lessonId, emailAddress, atTime, noteContent)\n"
                + "values(?, ?, ?, ?)";
        PreparedStatement ppsm = connection.prepareStatement(sql);
        ppsm.setInt(1, lessonId);
        ppsm.setString(2, email);
        ppsm.setString(3, atTime);
        ppsm.setString(4, noteContent);

        ppsm.executeUpdate();
        ppsm.close();
    }

    public void removeNote(String email, int noteId) throws SQLException {
        String sql = "delete Notes\n"
                + "where noteId = ? and emailAddress = ?;";
        PreparedStatement ppsm = connection.prepareStatement(sql);
        ppsm.setInt(1, noteId);
        ppsm.setString(2, email);

        ppsm.executeUpdate();
        ppsm.close();
    }

    public void updateNote(String email, int noteId, String noteContent) throws SQLException {
        String sql = "update Notes\n"
                + "set noteContent = ?\n"
                + "where noteId = ? and emailAddress = ?;";
        PreparedStatement ppsm = connection.prepareStatement(sql);
        ppsm.setString(1, noteContent);
        ppsm.setInt(2, noteId);
        ppsm.setString(3, email);

        ppsm.executeUpdate();
    }

    /**
     * HieuTC
     */
    public boolean isStudied(String email, int lessonId) throws SQLException {
        String sql = "select lessonId\n"
                + "from StudiedLesson\n"
                + "where emailAddress = ? and lessonId = ?;";
        PreparedStatement ppsm = connection.prepareStatement(sql);
        ppsm.setString(1, email);
        ppsm.setInt(2, lessonId);

        ppsm.executeQuery();
        ResultSet rs = ppsm.executeQuery();

        boolean studied = false;
        while (rs.next()) {
            studied = true;
        }

        return studied;
    }

    public float getGrade(String email, int quizId) throws SQLException {
        String sql = "select count(distinct selectedAnswer) as count\n"
                + "from QuizRecord\n"
                + "join QuizSession\n"
                + "on QuizRecord.quizSession = QuizSession.quizSession\n"
                + "join Quiz\n"
                + "on Quiz.quizId = QuizSession.quizId\n"
                + "join Questions\n"
                + "on QuizRecord.questionId = Questions.questionID\n"
                + "join Answers\n"
                + "on Questions.questionID = Answers.questionID and correctless = 1\n"
                + "where QuizRecord.selectedAnswer = Answers.answerID and\n"
                + "QuizSession.quizId = ? and emailAddress = ?;";
        PreparedStatement ppsm = connection.prepareStatement(sql);
        ppsm.setInt(1, quizId);
        ppsm.setString(2, email);
        ResultSet rs = ppsm.executeQuery();
        float grade = 0;
        while (rs.next()) {
            int count = rs.getInt("count");
            sql = "select Quiz.numberQuestion\n"
                    + "from Quiz\n"
                    + "where quizId = ?;";
            ppsm = connection.prepareStatement(sql);
            ppsm.setInt(1, quizId);
            rs = ppsm.executeQuery();
            while (rs.next()) {
                grade = (float) (count * 100
                        / (rs.getInt("numberQuestion")));
            }
        }
        return grade;
    }

    public boolean isPassed(String email, int quizId) throws SQLException {
        String sql = "select quizSession\n"
                + "from QuizSession\n"
                + "where emailAddress = ? and quizId = ?;";
        PreparedStatement ppsm = connection.prepareStatement(sql);
        ppsm.setString(1, email);
        ppsm.setInt(2, quizId);
        ResultSet rs = ppsm.executeQuery();
        boolean passed = false;
        while (rs.next()) {
            float grade = this.getGrade(email, quizId);
            sql = "select passedTarget\n"
                    + "from Quiz\n"
                    + "where quizId = ?;";
            ppsm = connection.prepareStatement(sql);
            ppsm.setInt(1, quizId);
            rs = ppsm.executeQuery();
            while (rs.next()) {
                float passedCondition = rs.getFloat("passedTarget");
                passed = grade >= passedCondition ? true : false;
            }
        }
        return passed;
    }

    /**
     * HieuTC
     */
    public int getLastestLesson(String email, int courseId) throws SQLException {
        String sql = "select StudiedLesson.lessonId\n"
                + "from StudiedLesson\n"
                + "join Lesson\n"
                + "on StudiedLesson.lessonId = Lesson.lessonID\n"
                + "join Sections\n"
                + "on Lesson.sectionID = Sections.sectionID\n"
                + "join Courses\n"
                + "on Sections.courseID = Courses.courseID\n"
                + "where Courses.courseID = ? and StudiedLesson.emailAddress = ?;";

        PreparedStatement ppsm = connection.prepareStatement(sql);
        ppsm.setInt(1, courseId);
        ppsm.setString(2, email);
        int lessonId = 0;

        ResultSet rs = ppsm.executeQuery();
        while (rs.next()) {
            lessonId = rs.getInt("lessonId");
        }
        return lessonId;

    }

    /**
     * HieuTC
     */
    public boolean authorizeAccessibleCourse(String email, int courseId) throws SQLException {
        String sql = "select courseId\n"
                + "from AccessibleCourse\n"
                + "where emailAddress = ? and courseId = ?;";
        PreparedStatement ppsm = connection.prepareStatement(sql);
        ppsm.setString(1, email);
        ppsm.setInt(2, courseId);
        ResultSet rs = ppsm.executeQuery();

        boolean accessible = false;
        while (rs.next()) {
            accessible = true;
        }

        return accessible;
    }

    /**
     * HieuTC
     */
    public void markLessonAsCompleted(String email, int lessonId) throws SQLException {
        String sql = "insert into StudiedLesson(lessonId, emailAddress)\n"
                + "values(?, ?)";

        PreparedStatement ppsm = connection.prepareStatement(sql);
        ppsm.setInt(1, lessonId);
        ppsm.setString(2, email);

        ppsm.executeUpdate();
    }

    public int getNumberOfStudiedLesson(String email, int courseId) throws SQLException {
        String sql = "select count(distinct StudiedLesson.lessonId) as count\n"
                + "from StudiedLesson\n"
                + "join Lesson\n"
                + "on StudiedLesson.lessonId = Lesson.lessonID\n"
                + "join Sections\n"
                + "on Lesson.sectionID = Sections.sectionID\n"
                + "join Courses\n"
                + "on Sections.courseID = Courses.courseID\n"
                + "where StudiedLesson.emailAddress = ? and Courses.courseId = ?;";
        PreparedStatement ppsm = connection.prepareStatement(sql);
        ppsm.setString(1, email);
        ppsm.setInt(2, courseId);
        ResultSet rs = ppsm.executeQuery();

        int count = 0;
        while (rs.next()) {
            count = rs.getInt("count");
        }

        return count;
    }

    /**
     * HieuTC
    */
    public Notification getNotification(int id) throws SQLException, ParseException {
        String sql = "select id, message, hyperLink, [read], hiddenState, receivedTime\n"
                + "from Notifications\n"
                + "where id = ?;";
        PreparedStatement ppsm = connection.prepareStatement(sql);
        ppsm.setInt(1, id);
        ResultSet rs = ppsm.executeQuery();
        Notification notification = null;
        while (rs.next()) {
            notification = new Notification();
            notification.setId(id);
            notification.setMessage(rs.getString("message"));
            notification.setHyperLink(rs.getString("hyperLink"));
            notification.setRead(rs.getBoolean("read"));
            notification.setHiddenState(rs.getBoolean("hiddenState"));
            notification.setReceivedTime(dateTime
                    .parse(rs.getString("receivedTime")));
        }
        return notification;
    }
    
    public ArrayList<Notification> getNotifications(String email, int size) throws SQLException, ParseException {
        String sql = "select top(?) id\n"
                + "from Notifications\n"
                + "where emailAddress = ? and hiddenState = 0\n"
                + "order by receivedTime DESC;";
        PreparedStatement ppsm = connection.prepareStatement(sql);
        ppsm.setInt(1, size);
        ppsm.setString(2, email);
        ResultSet rs = ppsm.executeQuery();
        ArrayList<Notification> notifications = new ArrayList<>();
        while (rs.next()) {
            Notification noti = this.getNotification(rs.getInt("id"));
            notifications.add(noti);
        }
        
        return notifications;
    }
    
    public ArrayList<Notification> getNotifications(String email) throws SQLException, ParseException {
        String sql = "select id\n"
                + "from Notifications\n"
                + "where emailAddress = ? and hiddenState = 0\n"
                + "order by receivedTime DESC;";
        PreparedStatement ppsm = connection.prepareStatement(sql);
        ppsm.setString(1, email);
        ResultSet rs = ppsm.executeQuery();
        ArrayList<Notification> notifications = new ArrayList<>();
        while (rs.next()) {
            Notification noti = this.getNotification(rs.getInt("id"));
            notifications.add(noti);
        }
        
        return notifications;
    }
    
    public void setNotificationState(int id, String attribute, boolean value) throws SQLException {
        String sql = "update Notifications\n"
                + "set [" + attribute + "] = ?\n"
                + "where id = ?;";
        PreparedStatement ppsm = connection.prepareStatement(sql);
        
        ppsm.setBoolean(1, value);
        ppsm.setInt(2, id);
        
        ppsm.executeUpdate();
        ppsm.close();
    }
    
    // User management
    public HashMap<User, Instructor> getUserList(String key,String status, String role, String gender) {
        HashMap<User, Instructor> hashmap = new HashMap<>();
        try {
            String sql = "select p.fullName,p.gender, p.emailAddress as [UserEmail],p.registeredTime,p.profilePicture,\n"
                    + "	   nc.NumberCourse, u.banned, i.emailAddress as[InstructorEmail]\n"
                    + "from [Profile] p \n"
                    + "inner join [User] u on p.emailAddress = u.emailAddress\n"
                    + "left join Instructor i on i.emailAddress = p.emailAddress\n"
                    + "left join (SELECT emailAddress, COUNT(courseID) AS NumberCourse \n"
                    + "			FROM Courses \n"
                    + "			GROUP BY emailAddress)as nc on nc.emailAddress = p.emailAddress";

                sql += " WHERE (p.fullName LIKE ? OR p.emailAddress LIKE ?) ";
                if(!gender.isBlank()){                    
                    if(gender.equals("0")){
                        sql +="AND (p.gender = 0 OR p.gender is NULL) ";
                    }else{
                        sql +="AND p.gender = 1 ";
                    }
                }                
                if(!role.isBlank()){
                    sql += "AND (i.emailAddress is NOT NULL) ";
                }
                if(!status.isBlank()){
                    sql+="AND u.banned = ?";
                }
                PreparedStatement stm = connection.prepareStatement(sql);
                stm.setString(1, "%" + key + "%");
                stm.setString(2, "%" + key + "%");
                if(!status.isBlank()){
                    stm.setString(3,status.trim());
                }
            ResultSet rs = stm.executeQuery();
            while (rs.next()) {
                Instructor i = new Instructor();
                i.setNumberCourses(rs.getInt("NumberCourse"));
                i.setEmail(rs.getString("InstructorEmail"));

                Profile p = new Profile();
                p.setGender(rs.getBoolean("gender"));
                p.setName(rs.getString("fullName"));
                p.setRegisterdTime(rs.getDate("registeredTime"));
                p.setStatus(rs.getBoolean("banned"));
                p.setPicture(rs.getString("profilePicture"));

                i.setProfile(p);
                User u = new User();
                u.setEmail(rs.getString("UserEmail"));
                hashmap.put(u, i);
            }
        } catch (SQLException ex) {
            Logger.getLogger(UserContext.class.getName()).log(Level.SEVERE, null, ex);
        }
        return hashmap;
        
    }

    public void banOrUnbanUser(String email, boolean b) {
        try {
            String sql = "UPDATE [dbo].[User]\n"
                    + "   SET [banned] = ?\n"
                    + " WHERE emailAddress = ?";
            PreparedStatement stm = connection.prepareStatement(sql);
            stm.setBoolean(1, b);
            stm.setString(2, email);
            stm.executeUpdate();
        } catch (SQLException ex) {
            Logger.getLogger(UserContext.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    public boolean isBaned(String email) {
        try {
            String sql = "SELECT [banned]\n"
                    + "  FROM [dbo].[User]\n"
                    + "  WHERE emailAddress =?";
            PreparedStatement stm = connection.prepareStatement(sql);
            stm.setString(1, email);
            ResultSet rs = stm.executeQuery();
            if (rs.next()) {
                return rs.getBoolean("banned");
            }
        } catch (SQLException ex) {
            Logger.getLogger(UserContext.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }
}
