/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.user;

import dao.CourseContext;
import dao.InstructorContext;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.SQLException;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Course;
import model.Instructor;

/**
 *
 * @author TuanPD
 */
@WebServlet("/instructor")
public class InstructorProfile extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        CourseContext courseContext = new CourseContext();

        try {
            String email = request.getParameter("emailAdress");
            Instructor instructor = new InstructorContext().getInstructor(email);

            ArrayList<Course> courseList = courseContext.getCourseListByInstructor(email);
            ArrayList<Course> sumRatingOfCourses = courseContext.sumRatingByEmail(email);
             ArrayList<Course> totalStudentInstructor = courseContext.totalStudentOfInstructor(email);
            request.setAttribute("sumRatingOfCourses", sumRatingOfCourses);
             request.setAttribute("totalStudentInstructor", totalStudentInstructor);
            request.setAttribute("listC", courseList);
            request.setAttribute("instructor", instructor);
            request.getRequestDispatcher("view/profile.jsp").forward(request, response);
        } catch (ParseException | SQLException ex) {
            Logger.getLogger(InstructorProfile.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
