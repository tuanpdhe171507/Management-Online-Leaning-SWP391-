/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller.user.instructor;

import dao.CourseContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import model.Category;
import model.Course;
import model.User;

/**
 *
 * @author HieuTC
 */
@WebServlet("/course/intended-learner")
public class IntendedLearner extends authentication.Authentication{

    @Override
    protected void doGet(User user, HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String courseID_raw = (req.getParameter("id") == null) 
                        ? "" : req.getParameter("id");
        try {
            int courseID = Integer.parseInt(courseID_raw);
            CourseContext manage = new CourseContext();
            Course course = manage.getCourseByID(user.getEmail(), courseID);
            ArrayList<Category> listCategory = manage.getCategory();

            req.setAttribute("categories", listCategory);
            req.setAttribute("course", course);
            req.getRequestDispatcher("../view/instructor/intended-learner.jsp").forward(req, resp);
        } catch (NumberFormatException e) {
        }
    }

    @Override
    protected void doPost(User user, HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        CourseContext manageCourse = new CourseContext();
        int courseID = Integer.parseInt(req.getParameter("id"));
        Course course = manageCourse.getCourseByID(user.getEmail(), courseID);
        String[] objectives = req.getParameterValues("objective");        
        if(objectives != null){
            course.setObjectives(convertArrayList(objectives));
        }

        String[] prerequisites = req.getParameterValues("prerequisite");
        if(prerequisites !=null){
            course.setPrerequiresites(convertArrayList(prerequisites));
        }

        String[] intendedLearneres = req.getParameterValues("intended-learner");
        if(intendedLearneres != null){
            course.setIntentedLearners(convertArrayList(intendedLearneres));
        }
        manageCourse.updateCourseById(course, courseID, user.getEmail());
        resp.sendRedirect("intended-learner?id=" + courseID);
    }
    
    public ArrayList<String> convertArrayList(String[] arrayString) {
        ArrayList<String> list = new ArrayList<>();
        for (String str : arrayString) {
            if (str == null || str.isBlank()) {
                continue;
            }
            list.add(str.trim());
        }
        return list;
    }
}
