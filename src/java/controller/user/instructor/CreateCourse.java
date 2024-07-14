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
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Category;

/**
 *
 * @author HieuTC
 */
@WebServlet("/course/create")
public class CreateCourse extends authentication.authorization.Authorization{

    @Override
    protected void forwardGetRequest(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            CourseContext courseContext = new CourseContext();
            ArrayList<Category> categoryList = courseContext.getCategoryList();
            req.setAttribute("categoryList", categoryList);
            req.getRequestDispatcher("../view/instructor/create-course.jsp").forward(req, resp);
        } catch (SQLException ex) {
            Logger.getLogger(CreateCourse.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    @Override
    protected void forwardPostRequest(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            String name = req.getParameter("name").trim();
            int category = Integer.parseInt(req.getParameter("category"));
            
            CourseContext courseContext = new CourseContext();
            Integer courseId = courseContext.createCourse(user.getEmail(), name, category);
            /* Redirect to couse management page*/
            if (courseId != null) {
                resp.sendRedirect("manage?id=" + courseId);
            } else {
                resp.sendRedirect("../instructor/home");
            }
        } catch (SQLException ex) {
            Logger.getLogger(CreateCourse.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

}
