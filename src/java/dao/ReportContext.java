/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.sql.*;
import java.text.SimpleDateFormat;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Course;
import model.Report;
import model.CourseReport;
import model.ReportType;

/**
 *
 * @author TuanPD
 */
public class ReportContext extends ConnectionOpen {

    public ArrayList<ReportType> getListReport() {
        ArrayList<ReportType> list = new ArrayList<>();
        String sql = "select a.typeId,a.typeName from ReportType as a";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();

            while (rs.next()) {
                ReportType report = new ReportType();
                int typeId = rs.getInt("typeId");
                report.setTypeId(typeId);
                report.setTypeName(rs.getString("typeName"));

                // Lấy danh sách ReportType cho từng Report
                ArrayList<Report> reportTypes = getListReport(rs.getInt("typeId"));
                report.setReportList(reportTypes);

                list.add(report);
            }
        } catch (SQLException ex) {
            Logger.getLogger(ReportContext.class.getName()).log(Level.SEVERE, null, ex);
        }
        return list;
    }

  
    public ArrayList<Report> getListReport(int typeid) {
        ArrayList<Report> list = new ArrayList<>();
        String sql = "select a.reportId from Report as a\n"
                + "where a.typeId=?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, typeid);

            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                list.add(this.getReport(rs.getInt("reportId")));
            }
        } catch (SQLException ex) {
            Logger.getLogger(ReportContext.class.getName()).log(Level.SEVERE, null, ex);
        }
        return list;
    }
    
    
      
        public ReportType getListReportTypeById(int reportid) {
        String sql = "select a.typeId,a.typeName from ReportType as a\n"
                + "where a.typeId=?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, reportid);

            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                ReportType s = new ReportType();
                s.setTypeId(rs.getInt("typeId"));
                s.setTypeName(rs.getString("typeName"));

                return s;
            }
        } catch (SQLException ex) {
            Logger.getLogger(ReportContext.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }

    public Report getListReportById(int reportid) {
        String sql = "select a.reportId,a.reportName from Report as a\n"
                + "where a.reportId=?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, reportid);

            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                Report s = new Report();
                s.setReportId(rs.getInt("reportId"));
                s.setReportName(rs.getString("reportName"));
                return s;
            }
        } catch (SQLException ex) {
            Logger.getLogger(ReportContext.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }

    public void insertReportresult(String reportId, int typeId, int courseID, String email) {
        String sql = "INSERT INTO [dbo].[CourseReport]\n"
                + "           ([reportId]\n"
                + "           ,[courseID]\n"
                + "           ,[emailAddress]\n"
                + "           ,[sentTime])\n"
                + "     VALUES\n"
                + "           (?,?,?,GETDATE())";

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, reportId);
            st.setInt(2, courseID);
            st.setString(3, email);

            st.executeUpdate();
        } catch (SQLException ex) {
            Logger.getLogger(ReportContext.class.getName()).log(Level.SEVERE, "Error inserting report result: " + ex.getMessage(), ex);
        }
    }

    public ArrayList<CourseReport> getListReportResult() throws ParseException {
        ArrayList<CourseReport> list = new ArrayList<>();
        String sql = "SELECT a.id, a.reportId, a.courseID, a.emailAddress, a.sentTime\n"
                + "FROM CourseReport as a\n"
                + "WHERE a.id IN (\n"
                + "    SELECT MIN(id)\n"
                + "    FROM CourseReport\n"
                + "    GROUP BY courseID\n"
                + ");";
        try {
            PreparedStatement st = connection.prepareStatement(sql);

            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                CourseReport s = new CourseReport();
                s.setId(rs.getInt("id"));
                s.setReport(this.getListReportById(rs.getInt("reportId")));
                s.setCourse(new CourseContext().getCourse(rs.getInt("courseID")));
                s.setProfile(new UserContext().getProfile(rs.getString("emailAddress")));

                Timestamp sentTime = rs.getTimestamp("sentTime");
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                String formattedDate = sdf.format(sentTime);
                s.setSentTime(formattedDate);
                list.add(s);
            }
        } catch (SQLException ex) {
            Logger.getLogger(ReportContext.class.getName()).log(Level.SEVERE, null, ex);
        }
        return list;
    }

    public ArrayList<CourseReport> getListMess() throws ParseException {
        ArrayList<CourseReport> list = new ArrayList<>();
        String sql = "SELECT a.id, a.reportId,b.typeId, a.courseID, a.emailAddress, a.sentTime\n"
                + "FROM CourseReport as a\n"
                + "Join Report as b\n"
                + "On a.reportId=b.reportId\n"
                + "WHERE a.id IN (\n"
                + "    SELECT MIN(id)\n"
                + "    FROM CourseReport\n"
                + "    GROUP BY courseID,emailAddress\n"
                + ");";
        try {
            PreparedStatement st = connection.prepareStatement(sql);

            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                CourseReport s = new CourseReport();
                s.setId(rs.getInt("id"));
                s.setReport(this.getReport(rs.getInt("reportId")));

                s.setCourse(new CourseContext().getCourse(rs.getInt("courseID")));
                s.setProfile(new UserContext().getProfile(rs.getString("emailAddress")));

                Timestamp sentTime = rs.getTimestamp("sentTime");
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                String formattedDate = sdf.format(sentTime);
                s.setSentTime(formattedDate);
                list.add(s);
            }
        } catch (SQLException ex) {
            Logger.getLogger(ReportContext.class.getName()).log(Level.SEVERE, null, ex);
        }
        return list;
    }

    public ArrayList<CourseReport> Search(String key) throws ParseException {
        ArrayList<CourseReport> list = new ArrayList<>();
        String sql = "SELECT a.id, a.reportId, a.courseID, a.emailAddress, a.sentTime\n"
                + "FROM CourseReport AS a\n"
                + "JOIN Courses AS b ON a.courseID = b.courseID\n"
                + "JOIN Instructor AS c ON b.emailAddress = c.emailAddress\n"
                + "JOIN [Profile] AS d ON c.emailAddress = d.emailAddress\n"
                + "WHERE a.id IN (\n"
                + "    SELECT MIN(id)\n"
                + "    FROM CourseReport\n"
                + "    GROUP BY courseID\n"
                + ")\n"
                + "AND ( b.courseName LIKE ? OR d.fullName LIKE ?";

        if (isNumeric(key)) {
            sql += " OR DAY(a.sentTime) = ?";
        }

        sql += " )";

        try {
            PreparedStatement ppsm = connection.prepareStatement(sql);

            String searchPattern = "%" + key + "%";
            ppsm.setString(1, searchPattern);
            ppsm.setString(2, searchPattern);

            if (isNumeric(key)) {
                ppsm.setInt(3, Integer.parseInt(key));
            }

            ResultSet rs = ppsm.executeQuery();
            while (rs.next()) {
                CourseReport s = new CourseReport();
                s.setId(rs.getInt("id"));
                s.setReport(this.getListReportById(rs.getInt("reportId")));
                s.setCourse(new CourseContext().getCourse(rs.getInt("courseID")));
                s.setProfile(new UserContext().getProfile(rs.getString("emailAddress")));

                Timestamp sentTime = rs.getTimestamp("sentTime");
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                String formattedDate = sdf.format(sentTime);
                s.setSentTime(formattedDate);
                list.add(s);
            }
        } catch (SQLException ex) {
            Logger.getLogger(ReportContext.class.getName()).log(Level.SEVERE, null, ex);
        }
        return list;
    }

    private boolean isNumeric(String str) {
        if (str == null) {
            return false;
        }
        try {
            Integer.parseInt(str);
        } catch (NumberFormatException nfe) {
            return false;
        }
        return true;
    }

    public ReportType getReportType(int typeId) throws SQLException {
        String sql = "select typeId, typeName\n"
                + "from ReportType\n"
                + "where typeId = ?;";
        PreparedStatement ppsm = connection.prepareStatement(sql);
        ppsm.setInt(1, typeId);
        ReportType type = null;
        ResultSet rs = ppsm.executeQuery();
        while (rs.next()) {
            type = new ReportType();
            type.setTypeId(typeId);
            type.setTypeName(rs.getString("typeName"));
        }
        ppsm.close();
        return type;
    }

    public Report getReport(int reportId) throws SQLException {
        String sql = "select reportId, typeId, reportName\n"
                + "from Report\n"
                + "where reportId = ?;";
        PreparedStatement ppsm = connection.prepareStatement(sql);
        ppsm.setInt(1, reportId);
        Report report = null;
        ResultSet rs = ppsm.executeQuery();
        while (rs.next()) {
            report = new Report();
            report.setReportId(reportId);
            report.setReportName(rs.getString("reportName"));
            report.setReportType(this.getReportType(rs.getInt("typeId")));
        }
        return report;
    }

}
