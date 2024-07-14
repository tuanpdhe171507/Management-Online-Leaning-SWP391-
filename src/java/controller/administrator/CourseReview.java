/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.administrator;

import com.google.gson.Gson;
import dao.CourseContext;
import dao.InstructorContext;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Category;
import model.Course;
import model.CourseSubmission;

/**
 *
 * @author Trongnd
 */
@WebServlet(name = "CourseReview", urlPatterns = {"/administrator/course-review"})
public class CourseReview extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        CourseContext c = new CourseContext();
        ArrayList<CourseSubmission> listCourse = c.getCourseReview("", "");
        
        ArrayList<Category> ca = c.getCategory();
        request.setAttribute("category", ca);
        request.setAttribute("listCourse", listCourse);
        request.getRequestDispatcher("../view/administrator/course-review.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action =  request.getParameter("action");
        CourseContext c = new CourseContext();
        if(action != "" && action != null){
            int courseId = Integer.parseInt(request.getParameter("courseId"));
            if(action.equals("reject")){
                c.resposeCourseSubmited(courseId, -1);
            }
            if(action.equals("accept")){
                c.resposeCourseSubmited(courseId, 1);
                String emailInstructor = request.getParameter("email");
                try {
                    new InstructorContext().setCourseState(emailInstructor, courseId, 1);
                } catch (SQLException ex) {
                    Logger.getLogger(CourseReview.class.getName()).log(Level.SEVERE, null, ex);
                }
            }
        }
        String key = request.getParameter("key") == null ? "" : request.getParameter("key");
        String category = request.getParameter("category") == null ? "" : request.getParameter("category");        
        
        ArrayList<CourseSubmission> listCourse = c.getCourseReview(key, category);
        
        ArrayList<Category> ca = c.getCategory();
        request.setAttribute("category", ca);
        request.setAttribute("categorySelected", category);
        request.setAttribute("listCourse", listCourse);
        request.setAttribute("key", key);
        request.getRequestDispatcher("../view/administrator/course-review.jsp").forward(request, response);

    }

}
