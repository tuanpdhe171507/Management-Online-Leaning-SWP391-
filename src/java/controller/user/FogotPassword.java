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
import javax.mail.MessagingException;

import util.Mail;
import util.Authentication;

/**
 *
 * @author HuyLQ;
 */
@WebServlet("/forgot-password")
public class FogotPassword extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/view/auth/fogot-password.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String email = request.getParameter("email");
            Authentication authentication = new Authentication();
            String token = authentication.generateCredentialToken();
            UserContext userContext = new UserContext();
            userContext.fogotPassword(email, token);
            String content = "<div style=\"width: 50%; margin: 0 auto; padding: 1.0rem;\">\n"
                    + "    <p style=\"font-size: large; font-weight: bold;\">EduPort</p>\n"
                    + "  You recently requested to reset the password for your account.<br>\n"
                    + "   Click the link below to proceed.</span><br>"
                    + "    <span style=\"font-weight: bold;\"></span></br>\n"
                    + "    <a style=\"background-color: black; color: white; padding: 0.5rem;"
                    + " display: block; width: fit-content; margin-top: 1.0rem; text-decoration: unset; font-weight: bold;\" href=\"http://localhost:8080/SWP391/reset-password?emailAddress="
                    + email + "&token="
                    + token + "\" target=\"_blank\">Reset password</a><br>\n"
                    + "    <span>If you did not request a password reset, please ignore this email or reply\n"
                    + "        to let us know. this password reset link only valid for the next 30 mintunes <a style=\"font-weight: bold;\" "
                    + "href=\"\" target=\"_blank\">support</a><br>\n"
                    + "        Have a great day!</span>\n"
                    + "</div>";
            Mail.sendMail(email, "You have sent a request for reset password", content);
            request.setAttribute("done", true);
            request.getRequestDispatcher("view/auth/fogot-password.jsp")
                    .forward(request, response);
        } catch (MessagingException ex) {
            Logger.getLogger(FogotPassword.class.getName()).log(Level.SEVERE, null, ex);
        } catch (SQLException ex) {
            Logger.getLogger(FogotPassword.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
}
