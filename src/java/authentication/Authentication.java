/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package authentication;

import dao.UserContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.crypto.BadPaddingException;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;
import model.User;

/**
 *
 * @author HieuTC
 */
public abstract class Authentication extends HttpServlet{
    public User user;
    
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            this.processRequest(true, req, resp);
        } catch (NoSuchAlgorithmException | NoSuchPaddingException | InvalidKeyException | IllegalBlockSizeException | BadPaddingException | SQLException ex) {
            Logger.getLogger(Authentication.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            this.processRequest(false, req, resp);
        } catch (NoSuchAlgorithmException | NoSuchPaddingException | InvalidKeyException | IllegalBlockSizeException | BadPaddingException | SQLException ex) {
            Logger.getLogger(Authentication.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
    
    protected void processRequest(boolean doGet, HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException, NoSuchAlgorithmException, NoSuchPaddingException, InvalidKeyException, IllegalBlockSizeException, BadPaddingException, SQLException {
        user = (User) req.getSession().getAttribute("user");
        UserContext userContext = new UserContext();
        req.getSession().setAttribute("user", user);
        /*  */
        if (user == null || userContext
                .verifyTrustedDevice(user.getEmail(), user.getIp()) != 1) {
            /* Remove session on illegal device*/
            req.getSession().removeAttribute("user");
            
            resp.sendRedirect("http://localhost:8080/SWP391/log-in");
        } else {
            if (doGet) {
                this.doGet(user, req, resp);
            } else {
                this.doPost(user, req, resp);
            }
        }
       
    }
    
    protected abstract void doGet(User user, HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException;
    protected abstract void doPost(User user, HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException;
}
