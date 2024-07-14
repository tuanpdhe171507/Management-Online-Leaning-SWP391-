/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.user;

import dao.CourseContext;
import dao.ReportContext;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.SQLException;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Course;
import model.Lesson;
import model.Report;
import model.ReportType;
import model.Section;
import model.User;

/**
 *
 * @author HaiNV
 */
@WebServlet("/my-courses")
public class MyCourses extends authentication.Authentication {

    CourseContext courseContext = new CourseContext();

    @Override
    protected void doGet(User user, HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String email = user.getEmail();
        try {
            ArrayList<Course> enrolledCourses = courseContext.getEnrolledCoursesByEmail(email);
            /* Save completion rate */
            HashMap<Integer, Integer> completionPercentages = new HashMap<>();
            for (Course course : enrolledCourses) {
                int totalLessons = course.getSumOfLesson();
                int completedLessons = countCompletedLessons(email, course.getId());
                /* Calculates the user's completion percentage */
                int completionPercentage = (totalLessons == 0) ? 0 : (completedLessons * 100 / totalLessons);
                completionPercentages.put(course.getId(), completionPercentage);
            }
            if (enrolledCourses.isEmpty()) {
                req.setAttribute("noEnrolledCourses", true);
            } else {
                req.setAttribute("enrolledCourses", enrolledCourses);
                req.setAttribute("completionPercentages", completionPercentages);
                String courseId = req.getParameter("courseId");
                if (courseId != null && !courseId.isEmpty()) {
                    courseContext.UnenrollCourse(Integer.parseInt(courseId));
                    resp.setStatus(HttpServletResponse.SC_OK);
                }

                ReportContext reportContent = new ReportContext();
                ArrayList<ReportType> listReports = reportContent.getListReport();
                req.setAttribute("listReports", listReports);

            }
            req.getRequestDispatcher("view/my-courses.jsp").forward(req, resp);
        } catch (SQLException | ParseException ex) {
            Logger.getLogger(MyCourses.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    public int countTotalLessons(int courseId) throws SQLException, ParseException {
        /* Get the list of sections for the course */
        ArrayList<Section> sections = courseContext.getSectionList(courseId);
        int totalLessons = 0;
        /* Iterate through each section and count the lessons */
        for (Section section : sections) {
            ArrayList<Lesson> lessons = courseContext.getLessonList(section.getId());
            totalLessons += lessons.size();
        }
        return totalLessons;
    }

    public int countCompletedLessons(String email, int courseId) throws SQLException {
        List<Integer> completedLessonIds = courseContext.getCompletedLessonId(email, courseId);
        return completedLessonIds.size();
    }

    @Override
    protected void doPost(User user, HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String email = user.getEmail();
        String reportTypeSelection = req.getParameter("reportTypeSelection");
        String selectedReport = req.getParameter("reportSelection");
        String courseString = req.getParameter("courseID");

        int reporTypetid = Integer.parseInt(reportTypeSelection);
        int courseid = Integer.parseInt(courseString);
        ReportContext reportContent = new ReportContext();

        if (selectedReport == null || selectedReport.isEmpty()) {
            reportContent.insertReportresult(null, reporTypetid, courseid, email);
        } else {
            reportContent.insertReportresult(selectedReport, reporTypetid, courseid, email);
        }

        resp.sendRedirect("http://localhost:8080/SWP391/my-courses?mess=Report+submitted+successfully!");
    }
}
