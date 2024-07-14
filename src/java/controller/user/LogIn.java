/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller.user;

import dao.UserContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.security.NoSuchAlgorithmException;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.crypto.NoSuchPaddingException;
import javax.mail.MessagingException;
import model.User;

import util.Mail;

/**
 *
 * @author HieuTC
 */
@WebServlet("/log-in")
public class LogIn extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("view/auth/log-in.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("user");
        boolean withoutPassword = user != null;
        String os = req.getParameter("os");
        String browser = req.getParameter("browser");
        String ip = req.getParameter("ip");
        String email = withoutPassword ? user.getEmail()
                : req.getParameter("email");
        String passwd = req.getParameter("password");
        UserContext userContext = new UserContext();
        
        
        try {   
            /* Both email and password is correct */
            if (withoutPassword || userContext.verifyUserLogInInfo(email, passwd)) {
                int i = this.getIn(email, os, browser, ip,
                        withoutPassword);
                if (i == 1) {
                    user = new User();
                    user.setEmail(email); 
                    user.setIp(ip);
                    req.getSession().setAttribute("user", user);
                    /* Log in succesfully and redirect to home page */
                    resp.sendRedirect("home");
                } else {
                    req.getRequestDispatcher("/view/auth/trouble.jsp").forward(req, resp);
                }
            } else {
                /*  */
                req.setAttribute("error", "There is problem with your email or password");
                req.getRequestDispatcher("view/auth/log-in.jsp").forward(req, resp);
            }
            
        } catch (SQLException ex) {
            Logger.getLogger(LogIn.class.getName())
                    .log(Level.SEVERE, null, ex);
        } catch (NoSuchAlgorithmException ex) {
            Logger.getLogger(LogIn.class.getName()).log(Level.SEVERE, null, ex);
        } catch (NoSuchPaddingException ex) {
            Logger.getLogger(LogIn.class.getName()).log(Level.SEVERE, null, ex);
        } catch (MessagingException ex) {
            Logger.getLogger(LogIn.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    /*  */
    public int getIn(String email, String os, String browser, String ip,
            boolean withoutTrustingStep) throws NoSuchAlgorithmException, NoSuchPaddingException, NoSuchPaddingException, NoSuchPaddingException, SQLException, MessagingException {

        UserContext userContext = new UserContext();
        int i = userContext.verifyTrustedDevice(email, ip);
        String credentialToken = userContext.detectDevice(email, os, browser, ip);
        /**/
        if (withoutTrustingStep || i == 1) {
            if (withoutTrustingStep) {
                userContext.trustDevice(email, ip);
                userContext.updateLoggingIn(email, ip, true);
            }
            return 1;
        } else if (i == -1) {
                        String content = "<div style=\"width: 50%; margin: 0 auto; padding: 1.0rem;\">\n"
                    + "    <p style=\"font-size: large; font-weight: bold;\">EduPort</p>\n"
                    + "        You are logging in to a new browser, please click on the button below to verify it's you.<br>\n"
                    + "        Also, note this link is available in 30 minutes only. After this time, it will be expired.</span><br>"
                    + "    <span style=\"font-weight: bold;\">" + os + ", " + browser  +"</span></br>\n"
                    + "    <a style=\"background-color: black; color: white; padding: 0.5rem;"
                    + " display: block; width: fit-content; margin-top: 1.0rem; text-decoration: unset; font-weight: bold;\" href=\"http://localhost:8080/SWP391/trust?email="
                    + email + "&ip="
                    + ip + "&token="
                    + credentialToken + "\" target=\"_blank\">Trust browser</a><br>\n"
                    + "    <span>If it is not you, please contact <a style=\"font-weight: bold;\" "
                    + "href=\"\" target=\"_blank\">support</a><br>\n"
                    + "        Have a great day!</span>\n"
                    + "</div>\n";

            // Send verifing message to user mail address;
                Mail.sendMail(email,
                    "You just log in in new device", content);
            return 0;
            
        } else {
            
            /* Update log in state for trusted device*/
            userContext.updateLoggingIn(email, ip, true);
            return 1;
        }
        
    }
    
}
