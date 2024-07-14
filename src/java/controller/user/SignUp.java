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
import java.security.NoSuchAlgorithmException;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.crypto.NoSuchPaddingException;
import javax.mail.MessagingException;
import model.User;

/**
 *
 * @author TrongND
 */

@WebServlet("/sign-up")
public class SignUp extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("view/auth/sign-up.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        UserContext userContext = new UserContext();
        String os = req.getParameter("os");
        String browser = req.getParameter("browser");
        String ip = req.getParameter("ip");
        String email = req.getParameter("email");
        String passwd = req.getParameter("password");
        String fullname = req.getParameter("fullname").trim();

         if (userContext.isExistedEmail(email)) {
            req.setAttribute("error", "Email had been used by other user");
            req.getRequestDispatcher("view/auth/sign-up.jsp").forward(req, resp);
        } else {
            try {
                userContext.signUp(fullname, email, passwd);
                LogIn logIn = new LogIn();
                logIn.getIn(email, os, browser, ip, true);
                User user = new User();
                user.setEmail(email);
                user.setIp(ip);
                req.getSession().setAttribute("user", user);
                /* Log in succesfully and redirect to home page */
                resp.sendRedirect("http://localhost:8080/SWP391/");
            } catch (NoSuchAlgorithmException | NoSuchPaddingException | SQLException | MessagingException ex) {
                Logger.getLogger(SignUp.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        
    }

}
