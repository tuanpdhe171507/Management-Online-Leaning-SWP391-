/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.sql.*;
import java.text.ParseException;
import java.util.ArrayList;
import model.Notification;
import model.Path;

/**
 *
 * @author HieuTC
 */
public class AdministratorContext extends ConnectionOpen{
    
    /**
     * HieuTC
     */
    public ArrayList<Path> getAdministratorPathList() throws SQLException {
        String sql = "select Paths.path, roleDescription, pathDescription, availableState\n"
               + "from Paths\n"
               + "join AccessiblePath\n"
               + "on Paths.path = AccessiblePath.path\n"
                + "join Roles\n"
                + "on AccessiblePath.role = Roles.role\n"
                + "where AccessiblePath.role = 'administrator';";
        PreparedStatement ppsm = connection.prepareStatement(sql);
        ResultSet rs = ppsm.executeQuery();
        ArrayList<Path> pathList = new ArrayList<>();
        
        while (rs.next()) {
            Path path = new Path();
            path.setPath(rs.getString("path"));
            path.setDescription(rs.getString("pathDescription"));
            path.setRole(rs.getString("roleDescription"));
            path.setAvailableState(rs.getBoolean("availableState"));
            pathList.add(path);
        }
        return pathList;
    }
    
    public ArrayList<Path> getPathList() throws SQLException {
        String sql = "select Paths.path, roleDescription, pathDescription, availableState\n"
               + "from Paths\n"
               + "join AccessiblePath\n"
               + "on Paths.path = AccessiblePath.path\n"
                + "join Roles\n"
                + "on AccessiblePath.role = Roles.role\n"
                + "where AccessiblePath.role != 'administrator';";
        PreparedStatement ppsm = connection.prepareStatement(sql);
        ResultSet rs = ppsm.executeQuery();
        ArrayList<Path> pathList = new ArrayList<>();
        
        while (rs.next()) {
            Path path = new Path();
            path.setPath(rs.getString("path"));
            path.setDescription(rs.getString("pathDescription"));
            path.setRole(rs.getString("roleDescription"));
            path.setAvailableState(rs.getBoolean("availableState"));
            pathList.add(path);
        }
        return pathList;
    }
    
    public void setPathState(String path, boolean state) throws SQLException {
        String sql = "update Paths\n"
                + "set availableState = ?\n"
                + "where path = ?;";
        PreparedStatement ppsm = connection.prepareStatement(sql);
        ppsm.setBoolean(1, state);
        ppsm.setString(2, path);
        ppsm.executeUpdate();
    }

    public String getValue(String parameter) throws SQLException {
        String sql = "select value\n"
                + "from Settings\n"
                + "where parameter = ?;";
        PreparedStatement ppsm = connection.prepareStatement(sql);
        ppsm.setString(1, parameter);   
        ResultSet rs = ppsm.executeQuery();
        
        String value = null;
        while (rs.next()) {
            value =  rs.getString("value");
        }
        return value;
    }
    
    public void setValue(String parameter, String value) throws SQLException {
        String sql = "update Settings\n"
                + "set value = ?\n"
                + "where parameter = ?;";
        PreparedStatement ppsm = connection.prepareStatement(sql);
        ppsm.setString(2, parameter);  
        ppsm.setString(1, value);
        ppsm.executeUpdate();
        ppsm.close();
    }
    
    public int getTotalCourse() throws SQLException {
        String sql = "select COUNT(distinct courseId) as count\n"
                + "from Courses;";
        PreparedStatement ppsm = connection.prepareStatement(sql);
        int count = 0;
        ResultSet rs = ppsm.executeQuery();
        while (rs.next()) {
            count = rs.getInt("count");
        }
        return count;
    }
    
    public int getNumberCourseInMonth(int month) throws SQLException {
        String sql = "select COUNT(distinct courseId) as count\n"
                + "from Courses\n"
                + "where month(createdTime) = ?; ";
        PreparedStatement ppsm = connection.prepareStatement(sql);
        ppsm.setInt(1, month);
        int count = 0;
        ResultSet rs = ppsm.executeQuery();
        while (rs.next()) {
            count = rs.getInt("count");
        }
        return count;
    }
    
    public int getTotalStudent() throws SQLException {
        String sql = "select COUNT(distinct emailAddress) as count\n"
                + "from Profile;";
        PreparedStatement ppsm = connection.prepareStatement(sql);
        int count = 0;
        ResultSet rs = ppsm.executeQuery();
        while (rs.next()) {
            count = rs.getInt("count");
        }
        return count;
    }
    
    public int getNumberStudentInMonth(int month) throws SQLException {
        String sql = "select COUNT(distinct emailAddress) as count\n"
                + "from Profile\n"
                + "where month(registeredTime) = ?; ";
        PreparedStatement ppsm = connection.prepareStatement(sql);
        ppsm.setInt(1, month);
        int count = 0;
        ResultSet rs = ppsm.executeQuery();
        while (rs.next()) {
            count = rs.getInt("count");
        }
        return count;
    }
    
    public int getEnrollmentsInMonth(int month) throws SQLException {
        String sql = "select COUNT(*) as count\n"
                + "from AccessibleCourse\n"
                + "where month(enrolledTime) = ?;";
        PreparedStatement ppsm = connection.prepareStatement(sql);
        ppsm.setInt(1, month);
        int count = 0;
        ResultSet rs = ppsm.executeQuery();
        while (rs.next()) {
            count = rs.getInt("count");
        }
        return count;
    }
    
    public int getRatingsInMonth(int month) throws SQLException {
        String sql = "select COUNT(*) as count\n"
                + "from CourseRating\n"
                + "where month(ratedTime) = ?;";
        PreparedStatement ppsm = connection.prepareStatement(sql);
        ppsm.setInt(1, month);
        int count = 0;
        ResultSet rs = ppsm.executeQuery();
        while (rs.next()) {
            count = rs.getInt("count");
        }
        return count;
    }
    
    public int getPositiveRatingsInMonth(int month) throws SQLException {
        String sql = "select COUNT(*) as count\n"
                + "from CourseRating\n"
                + "where month(ratedTime) = ? and starRate >= 3;";
        PreparedStatement ppsm = connection.prepareStatement(sql);
        ppsm.setInt(1, month);
        int count = 0;
        ResultSet rs = ppsm.executeQuery();
        while (rs.next()) {
            count = rs.getInt("count");
        }
        return count;
    }
    
    public int getTotaRatings() throws SQLException {
        String sql = "select COUNT(*) as count\n"
                + "from CourseRating;";
        PreparedStatement ppsm = connection.prepareStatement(sql);
        int count = 0;
        ResultSet rs = ppsm.executeQuery();
        while (rs.next()) {
            count = rs.getInt("count");
        }
        return count;
    }
    
    public int getTotalPositiveRatings() throws SQLException {
        String sql = "select COUNT(*) as count\n"
                + "from CourseRating\n"
                + "where starRate >= 3;";
        PreparedStatement ppsm = connection.prepareStatement(sql);
        int count = 0;
        ResultSet rs = ppsm.executeQuery();
        while (rs.next()) {
            count = rs.getInt("count");
        }
        return count;
    }
    
    public Notification insertNotification(String email, String message, String hyperLink) throws SQLException, ParseException {
        String sql = "insert into Notifications(emailAddress, message, hyperLink)\n"
                + "values(?, ?, ?);";
        PreparedStatement ppsm = connection.prepareStatement(sql);
        ppsm.setString(1, email);
        ppsm.setString(2, message);
        ppsm.setString(3, hyperLink);
        ResultSet rs = ppsm.executeQuery();
        Notification noti = null;
        UserContext userContext = new UserContext();
        while (rs.next()) {
            noti = userContext.getNotification(rs.getInt("id"));
        }
        
        return noti;
    }
}
