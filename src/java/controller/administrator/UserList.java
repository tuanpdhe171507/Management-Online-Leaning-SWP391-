/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.administrator;

import dao.UserContext;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.SQLException;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Instructor;
import model.User;

/**
 *
 * @author Trongnd
 */
@WebServlet(name = "UserList", urlPatterns = {"/administrator/user-list"})
public class UserList extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HashMap<User, Instructor> hashMap = new UserContext().getUserList("", "", "", "");
        request.setAttribute("users", hashMap);
        request.getRequestDispatcher("../view/administrator/user-list.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String emailBan = request.getParameter("emailBan");
        String action = request.getParameter("action") == null ? "" : request.getParameter("action");
        UserContext userContext = new UserContext();
        if (emailBan != null) {
            String jsonResponse = null;
            if (action.equals("ban")) {
                userContext.banOrUnbanUser(emailBan, true);
                jsonResponse = "{\"ban\":" + true + "}";
            }
            if (action.equals("unban")) {
                userContext.banOrUnbanUser(emailBan, false);
                jsonResponse = "{\"ban\":" + false + "}";
            }
            response.setContentType("application/json");
            response.getWriter().write(jsonResponse);
        } else {
            String gender = "";
            String status = "";
            String role = "";
            if (action.equals("filter")) {
                gender = request.getParameter("gender") == null ? "" : request.getParameter("gender");
                status = request.getParameter("status") == null ? "" : request.getParameter("status");
                role = request.getParameter("role") == null ? "" : request.getParameter("role");

            }
            String searchContent = request.getParameter("key") == null ? "" : request.getParameter("key");
            HashMap<User, Instructor> hashMap = new UserContext().getUserList(searchContent, status, role, gender);
            String rating_raw = request.getParameter("rating");
            if (rating_raw != null && !rating_raw.isBlank()) {
                float rating = Float.parseFloat(rating_raw);
                
                request.setAttribute("users",filterByRating(hashMap, rating));
            }else{
                request.setAttribute("users", hashMap);
            }
            
            request.setAttribute("key", searchContent);
            request.setAttribute("ratingSelected", rating_raw);
            request.setAttribute("statusSelected", status);
            request.setAttribute("roleSelected", role);
            request.setAttribute("genderSelected", gender);
            request.getRequestDispatcher("../view/administrator/user-list.jsp").forward(request, response);

        }

    }

    public HashMap<User, Instructor> filterByRating(HashMap<User, Instructor> hashMap, float rating) {
        HashMap<User, Instructor> result = new HashMap<>();
        for (Map.Entry<User, Instructor> entry : hashMap.entrySet()) {
            User key = entry.getKey();
            Instructor val = entry.getValue();

            try {
                if (val.getRate() >= rating) {
                    result.put(key, val);
                }
            } catch (SQLException ex) {
                Logger.getLogger(UserList.class.getName()).log(Level.SEVERE, null, ex);
            } catch (ParseException ex) {
                Logger.getLogger(UserList.class.getName()).log(Level.SEVERE, null, ex);
            }

        }
        return result;
    }

}
