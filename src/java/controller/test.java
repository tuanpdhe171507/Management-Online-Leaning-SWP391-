/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller;

import dao.AdministratorContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.websocket.EncodeException;
import java.io.IOException;
import java.sql.SQLException;
import java.text.ParseException;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Notification;

/**
 *
 * @author HieuTC
 */

@WebServlet("/test")
public class test extends HttpServlet{

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            AdministratorContext ct = new AdministratorContext();
            
            String receiver = "itranconghieu@gmail.com";
            Notification n = ct.insertNotification(receiver,
                    "Hello", "wishlist");
            util.websocket.EchoEndPoint.send(receiver, n);
            
        } catch (SQLException | ParseException | EncodeException ex) {
            Logger.getLogger(test.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
    
}
