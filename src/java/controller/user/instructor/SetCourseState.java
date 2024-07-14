/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller.user.instructor;

import dao.InstructorContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
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
@WebServlet("/course/set-state")
public class SetCourseState extends authentication.Authentication {

    @Override
    protected void doGet(User user, HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            int courseId = Integer.parseInt(req.getParameter("course"));
            int state = Integer.parseInt(req.getParameter("state"));
            
            String email = user.getEmail();
            InstructorContext intructorContext = new InstructorContext();
            intructorContext.setCourseState(email, courseId, state);
        } catch (SQLException ex) {
            Logger.getLogger(SetCourseState.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    @Override
    protected void doPost(User user, HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }
    
}
