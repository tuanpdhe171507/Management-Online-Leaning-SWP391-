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
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.User;

/**
 *
 * @author HieuTC
 */
@WebServlet("/notification")
public class Notification extends authentication.Authentication{



    @Override
    protected void doGet(User user, HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            String paramRows = req.getParameter("rows");
            String query = req.getParameter("query");
            String email = user.getEmail();
            if (paramRows != null) {
                UserContext userContext = new UserContext();

                if (query == null) {
                    resp.sendRedirect("notification?rows=" + paramRows
                            + "&query=all");
                } else {
                   ArrayList<model.Notification> notifications = userContext.getNotifications(email);

                    //Filter unread notification
                    if (query.equalsIgnoreCase("unread")) {
                        for (int i = 0; i < notifications.size(); i++) {
                            model.Notification noti = notifications.get(i);
                            if (noti.isRead()) {
                                notifications.remove(i);
                                i--;
                            }
                        }
                    }

                    // Limit size of notification list;
                    if (!paramRows.equalsIgnoreCase("all")) {
                        int rows = Integer.parseInt(paramRows);

                        notifications = new ArrayList<>(notifications
                                .subList(0, Math.min(rows,
                                        notifications.size())));
                    }
                    req.setAttribute("notifications", notifications);
                    req.getRequestDispatcher("view/notification.jsp")
                            .forward(req, resp);

                }

                
            } else {
                resp.sendRedirect("notification?rows=5&query=all");
            }
        } catch (SQLException | ParseException ex) {
            Logger.getLogger(Notification.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    @Override
    protected void doPost(User user, HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }
    
}
