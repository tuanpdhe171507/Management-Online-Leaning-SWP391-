/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller.user;

import dao.UserContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.text.ParseException;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.mail.MessagingException;
import model.Profile;
import model.User;
import util.Mail;

/**
 *
 * @author HieuTC
 */
@WebServlet("/change-password")
public class ChangePassword extends authentication.Authentication {

    @Override
    protected void doGet(User user, HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    protected void doPost(User user, HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            String email = user.getEmail();
            UserContext userContext = new UserContext();
            String currentPassword = req.getParameter("currentPassword");
            String newPassword = req.getParameter("newPassword");
            
            //Correct password
            if (userContext.verifyUserLogInInfo(email, currentPassword)) {
                if (userContext
                        .updatePassword(email, newPassword)) {
                    String content = "<div style=\"width: 50%; margin: 0 auto; padding: 1.0rem;\">\n"
                    + "    <p style=\"font-size: large; font-weight: bold;\">EduPort</p>\n"
                    + "    <span>The password for your account has been changed.</span><br>\n"
                    + "    <span>If it is not you, please contact <a style=\"font-weight: bold;\" "
                    + "href=\"\" target=\"_blank\">support</a><br>\n"
                    + "        Have a great day!</span>\n"
                    + "</div>\n";
                    try {
                        Mail.sendMail(email, "Your password has been changed", email);
                    } catch (MessagingException ex) {
                        Logger.getLogger(AccountSetUp.class.getName()).log(Level.SEVERE, null, ex);
                    }
                    req.setAttribute("pwDone", "The password has been changed");
                }
            } else {
                req.setAttribute("pwError", "Inserted current password is incorrect");
                
            }
            Profile profile = userContext.getProfile(email);
            req.setAttribute("profile", profile);
            req.getRequestDispatcher("view/account.jsp").forward(req, resp);
        } catch (SQLException | ParseException ex) {
            Logger.getLogger(ChangePassword.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

}
