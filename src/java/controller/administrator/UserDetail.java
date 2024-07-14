/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller.administrator;


import dao.InstructorContext;
import dao.UserContext;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.SQLException;
import java.text.ParseException;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Instructor;
import model.Profile;

/**
 *
 * @author Trongnd
 */
@WebServlet(name="UserDetail", urlPatterns={"/administrator/user-detail"})
public class UserDetail extends HttpServlet {


  
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        try {
            String emailSelected = request.getParameter("email")== null?"":request.getParameter("email");
            UserContext userContext = new UserContext();
            Profile p = userContext.getProfile(emailSelected); 
            p.setStatus(userContext.isBaned(emailSelected));
            InstructorContext instuctorContext = new InstructorContext();
            request.setAttribute("instrutorInfor", instuctorContext.getInstructor(emailSelected));
            request.setAttribute("courses", instuctorContext.getCourseList(emailSelected));
            request.setAttribute("email", emailSelected);
            request.setAttribute("infor", p);
            request.getRequestDispatcher("../view/administrator/user-detail.jsp").forward(request, response);
        } catch (SQLException ex) {
            Logger.getLogger(UserDetail.class.getName()).log(Level.SEVERE, null, ex);
        } catch (ParseException ex) {
            Logger.getLogger(UserDetail.class.getName()).log(Level.SEVERE, null, ex);
        }
        
    } 

    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        String emailSelected = request.getParameter("email") == null?"":request.getParameter("email");
        String ban_raw = request.getParameter("ban")== null?"":request.getParameter("ban");
        boolean ban = false;
        try {
            ban = Boolean.parseBoolean(ban_raw);
        } catch (Exception e) {
        }        
        new UserContext().banOrUnbanUser(emailSelected, ban); 
        response.setContentType("application/json");        
        
    }

}
