/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller.user;

import dao.CourseContext;
import dao.PlansContext;
import dao.UserContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Course;
import model.Profile;
import model.User;

/**
 *
 * @author TuanPD
 */
@WebServlet("/course/course-enroll")
public class CourseEnroll extends authentication.Authentication {

    @Override
    protected void doGet(User user, HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String id = req.getParameter("courseId");
        String categoryId = req.getParameter("categoryId");
        String emailInstructor = req.getParameter("email");

        CourseContext courseContext = new CourseContext();
        UserContext userContext = new UserContext();
        Course course = null;
        Profile profile = null;
        String email = user.getEmail();
        ArrayList<Course> courseList = new ArrayList<>();
         ArrayList<Course> courseListAllByStar = new ArrayList<>();
        try {
            profile = userContext.getProfile(email);
            course = courseContext.getCourse(Integer.parseInt(id));
            courseListAllByStar=courseContext.getStaRateByCourses();
            if(id!=null){
                  courseListAllByStar.removeIf(c -> Integer.valueOf(c.getId()).equals(Integer.valueOf(id)));
            }

            courseList = courseContext.getCourseListByCategoryAndInstructor(emailInstructor, categoryId);
            if (id != null) {
                courseList.removeIf(c -> Integer.valueOf(c.getId()).equals(Integer.valueOf(id)));
            }
                            // user is registed plan
                Timestamp planExpiredTime = new PlansContext().getPlanExpiredTime(email);
                if(planExpiredTime !=null){
                    Timestamp currentTime = new Timestamp(System.currentTimeMillis());
                    if(planExpiredTime.after(currentTime)){
                        boolean accountPro = true;
                        req.setAttribute("accountPro", accountPro);
                    }                    
                }else{
                    courseContext.addAccessibleCourse(email, id);
                }            
        } catch (SQLException | ParseException ex) {
            Logger.getLogger(CourseEnroll.class.getName()).log(Level.SEVERE, null, ex);
        }

        req.setAttribute("courseList", courseList);
        req.setAttribute("courseListAllByStar", courseListAllByStar);
        req.setAttribute("course", course);
        req.setAttribute("profile", profile);
        req.getRequestDispatcher("../view/course-enroll.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(User user, HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

}
