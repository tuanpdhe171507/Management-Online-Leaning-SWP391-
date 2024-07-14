/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller.user.instructor;

import dao.CourseContext;
import dao.InstructorContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.text.ParseException;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Course;
import model.User;

/**
 *
 * @author HieuTC
 */
@WebServlet("/course/settings")
public class Settings extends authentication.Authentication {
    
    @Override
    protected void doGet(User user, HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            InstructorContext instructorContext = new InstructorContext();
            String email = user.getEmail();
            int courseId = Integer
                    .parseInt(req.getParameter("id"));
            Course course = instructorContext.getCourse(email, courseId);
            
            // Athenticate instructor for course successfully;
            if (course != null) {
                req.setAttribute("course", course);
                req.getRequestDispatcher("../view/instructor/settings.jsp")
                    .forward(req, resp);
            } else {
                resp.getWriter().print("Access denied");
            }
        } catch (SQLException | ParseException ex) {
            Logger.getLogger(PricePackage.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    @Override
    protected void doPost(User user, HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            int courseId = Integer
                    .parseInt(req.getParameter("course"));
            
            float price = Float
                    .parseFloat(req.getParameter("price"));
            
            InstructorContext instructorContext = new InstructorContext();
            instructorContext.setPrice(user.getEmail(), courseId, price);
            resp.sendRedirect("pricing?id=" + courseId);
        } catch (SQLException ex) {
            Logger.getLogger(PricePackage.class.getName()).log(Level.SEVERE, null, ex);
        }
        
        
    }
    
}
