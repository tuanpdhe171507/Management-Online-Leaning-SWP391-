/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller.user;

import jakarta.servlet.annotation.WebServlet;
import dao.InstructorContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.User;

/**
 *
 * @author HieuTC
 */
@WebServlet("/instructor/register")
public class RegisterInstructor extends authentication.Authentication{

    @Override
    protected void doGet(User user, HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        
        req.getRequestDispatcher("../view/instructor/register.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(User user, HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            
            
            /* Personalize for instructor*/
            
            /* Get role for instructor */
            InstructorContext instructorContext = new InstructorContext();
            instructorContext.register(user.getEmail());

            /* Redirect to dashboard for instructor*/
            resp.sendRedirect("instructor/courses");
        } catch (SQLException ex) {
            Logger.getLogger( RegisterInstructor.class.getName()).log(Level.SEVERE, null, ex);
        }
        
    }
    
    
}
