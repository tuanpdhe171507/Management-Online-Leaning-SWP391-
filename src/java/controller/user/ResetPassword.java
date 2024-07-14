/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.user;

import dao.UserContext;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.User;

/**
 *
 * @author HuyLQ;
 */
@WebServlet("/reset-password")

public class ResetPassword extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String token = request.getParameter("token");
            String email = request.getParameter("emailAddress");
            
            UserContext userContext = new UserContext();
            // The link is invalid;
            if (!userContext.validateResetPasswordRequest(email, token)) {
                request.setAttribute("wrong", true);
            }
            request.getRequestDispatcher("view/auth/reset-password.jsp").forward(request, response);
        } catch (SQLException ex) {
            Logger.getLogger(ResetPassword.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String token = request.getParameter("token");
            String newPassword = request.getParameter("newPassword");
            String email = request.getParameter("emailAddress");
            UserContext db = new UserContext();

            if (db.updatePasswordByReset(email, newPassword, token)) {
                User user = new User();
                user.setEmail(email);
                request.getSession().setAttribute("user", user);
                request.setAttribute("done", "Password has been reset");
            } else {
                // Outdate time;
                request.setAttribute("error", "Failed to change the password");
            }
            request.getRequestDispatcher("view/auth/reset-password.jsp").forward(request, response);
        } catch (SQLException ex) {
            Logger.getLogger(ResetPassword.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

}
