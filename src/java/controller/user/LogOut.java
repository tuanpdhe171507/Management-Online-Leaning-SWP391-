/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller.user;

import authentication.Authentication;
import dao.UserContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.User;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
        
/**
 *
 * @author HieuTC
 */
@WebServlet("/log-out")
public class LogOut extends Authentication{

    @Override
    protected void doGet(User user, HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            /* Remove user's session for browser*/
            req.getSession().removeAttribute("user");
            
            /* Update logging in state for logged out device*/
            
            UserContext userContext = new UserContext();
            userContext.updateLoggingIn(user.getEmail(), user.getIp(), false);
            
            /* Redirect to home page*/
            resp.sendRedirect("home");
        } catch (SQLException ex) {
            Logger.getLogger(LogOut.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    @Override
    protected void doPost(User user, HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            resp.setContentType("text/plain");
        
            // Get the JSON data from request
            String jsonData = req.getReader().readLine();
            
            JSONObject jsonObject = (JSONObject)(
                    new JSONParser().parse(jsonData));
            
            /* Get ip*/
            String[] ipArray = jsonObject.get("ip").toString().split("/");
            
            UserContext userContext = new UserContext();
            
            //Logout
            for (String ip : ipArray) {
                userContext.updateLoggingIn(user.getEmail(), ip, false);
            }
            
        } catch (SQLException ex) {
            Logger.getLogger(LogOut.class.getName()).log(Level.SEVERE, null, ex);
        } catch (ParseException ex) {
            Logger.getLogger(LogOut.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
    
}
