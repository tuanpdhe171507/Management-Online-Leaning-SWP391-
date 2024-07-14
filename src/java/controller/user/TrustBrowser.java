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
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author HieuTC
 */

@WebServlet("/trust")
public class TrustBrowser extends HttpServlet{
    
    String email;
    String ip;
    String token;
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            email = req.getParameter("email");
            ip = req.getParameter("ip");
            token = req.getParameter("token");
            UserContext userContext = new UserContext();
            
            /*The verication link is valid*/
            if (userContext.authenticateDevice(email,
                    ip, token)) {
                
                /* Trust device*/
                if (userContext.trustDevice(email, ip)) {
                    req.setAttribute("done", true);
                } else {
                    req.setAttribute("error", true);
                }
            } else {
                /* Nofity error */
                req.setAttribute("error", true);
            }
            req.getRequestDispatcher("view/auth/trust.jsp").forward(req, resp);
        } catch (SQLException ex) {
            Logger.getLogger(TrustBrowser.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
    
}
