/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.CourseContext;
import dao.PlansContext;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.AccessibleCourse;
import model.Course;
import model.Lesson;
import model.Rating;
import model.RatingStatistics;
import model.User;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

/**
 *
 * @author TuanPD
 */
@WebServlet("/course/details")
public class CourseDetails extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        CourseContext courseContext = new CourseContext();
        String courseId = request.getParameter("id");
        String sectionId = request.getParameter("sectionId");
        if (sectionId != null && !sectionId.isEmpty()) {
            try {
                JSONArray lessonsArray = new JSONArray();
                int seid = Integer.parseInt(sectionId);
                ArrayList<Lesson> lessons = courseContext.getLessonList(seid);
                for (Lesson lesson : lessons) {
                    JSONObject lessonObj = new JSONObject();
                    lessonObj.put("name", lesson.getName());
                    lessonsArray.add(lessonObj);
                }

                // Tạo một StringBuilder để xây dựng chuỗi JSON với mỗi tên bài học trên một dòng
                StringBuilder jsonBuilder = new StringBuilder();

                for (int i = 0; i < lessonsArray.size(); i++) {
                    JSONObject lessonObj = (JSONObject) lessonsArray.get(i);
                    jsonBuilder.append(lessonObj.get("name"));
                    if (i != lessonsArray.size() - 1) {
                        jsonBuilder.append("<br>");
                    }
                }

                // Gửi chuỗi JSON đã xây dựng về phía client
                response.setContentType("application/json");
                PrintWriter out = response.getWriter();
                out.print(jsonBuilder.toString());
                out.flush();
            } catch (SQLException ex) {
                Logger.getLogger(CourseDetails.class.getName()).log(Level.SEVERE, null, ex);
            } catch (ParseException ex) {
                Logger.getLogger(CourseDetails.class.getName()).log(Level.SEVERE, null, ex);
            }
        } else {
            try {
                // Nếu không có sectionId được cung cấp, chỉ chuyển hướng đến trang "course.jsp"
                Course course = new Course();
                course = courseContext.getCourse(
                        Integer.parseInt(courseId));

                ArrayList<Rating> ratingList
                        = courseContext.getRatingList(
                                Integer.parseInt(courseId));

                RatingStatistics ratingStatistics
                        = courseContext.calculateRatingStatistics(
                                Integer.parseInt(courseId));

                User user = (User) request.getSession().getAttribute("user");
                String userEmail = "";
                if (user != null) {
                    userEmail = user.getEmail() != null ? user.getEmail() : "";
                }
                boolean isEnrolled = courseContext.checkUserEnrollment(userEmail, course.getId());

                request.setAttribute("course", course);
                request.setAttribute("ratingList", ratingList);
                request.setAttribute("ratingStatistics", ratingStatistics);
                request.getSession().setAttribute("isEnrolled", isEnrolled);

            } catch (SQLException | ParseException ex) {
                Logger.getLogger(CourseDetails.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        AccessibleCourse accessibleCourse = new AccessibleCourse();
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user != null) {
            try {
                String email = user.getEmail();
                accessibleCourse = courseContext.getAccourseByID(email, Integer.parseInt(courseId));
                if (accessibleCourse != null) {
                    request.setAttribute("accessibleCourse", accessibleCourse);
                }
                // user is registed plan
                Timestamp planExpiredTime = new PlansContext().getPlanExpiredTime(email);
                if(planExpiredTime !=null){
                    Timestamp currentTime = new Timestamp(System.currentTimeMillis());
                    if(planExpiredTime.after(currentTime)){
                        boolean accountPro = true;
                        request.setAttribute("accountPro", accountPro);
                    }
                }
                 request.setAttribute("email2", email);
            } catch (ParseException ex) {
                Logger.getLogger(CourseDetails.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        request.getRequestDispatcher("../view/course.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");
        String courseIdStr = request.getParameter("courseId");
        String startRateStr = request.getParameter("starRating");
        int startRate = Integer.parseInt(startRateStr);
        String comment = request.getParameter("comment");
        int courseId = Integer.parseInt(courseIdStr);
        String email = user.getEmail();
        Timestamp ratedTime = new Timestamp(System.currentTimeMillis());
        CourseContext context = new CourseContext();
        context.insertCourseRating(courseId, email, startRate, comment, ratedTime);
        response.sendRedirect("../course/details?id=" + courseId);
    }
}
