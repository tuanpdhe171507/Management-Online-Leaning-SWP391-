/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller.user.instructor;

import dao.CourseContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
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
@WebServlet("/course/loading-page")
public class LoadingPage extends authentication.Authentication {

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
            req.getRequestDispatcher("../view/instructor/loading-page.jsp").forward(req, resp);
        } catch (NumberFormatException e) {
        }
    }

    @Override
    protected void doPost(User user, HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int courseID = Integer.parseInt(req.getParameter("id"));
        CourseContext manageCourse = new CourseContext();
        Course course = manageCourse.getCourseByID(user.getEmail(), courseID);
        // course-title
        String courseName = req.getParameter("course-title");
        course.setName(courseName);
        //course category
        String categoryID = req.getParameter("category");
        Category category = new Category();
        category.setId(categoryID);
        course.setCategory(category);
        //course-description
        String courseDpt = req.getParameter("course-description");
        course.setDescription(courseDpt);
        manageCourse.updateCourseById(course, courseID, user.getEmail());
        resp.sendRedirect("loading-page?id=" + courseID);
    }
    
}
