/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller.user.instructor;

import authentication.Authentication;
import dao.InstructorContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.BufferedReader;
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
@WebServlet("/course/update-item")
public class UpdateItem extends Authentication{

    @Override
    protected void doGet(User user, HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        InstructorContext instructorContext = new InstructorContext();
        try {
            String itemType = req.getParameter("type");
            int id = Integer.parseInt(req.getParameter("id"));

            if (itemType.equals("lesson")) {

                //Remove a lesson;
                instructorContext.removeLesson(id);
            } else {
                //Remove a quiz
                instructorContext.removeQuiz(id);
            }
        } catch (SQLException ex) {
            Logger.getLogger(UpdateItem.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    @Override
    protected void doPost(User user, HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            InstructorContext instructorContext = new InstructorContext();
            //Read data from request;
            resp.setContentType("application/json");
            BufferedReader reader = req.getReader();
            String jsonData = reader.readLine();
            
            // Parse data to object;
            JSONParser jsonParser = new JSONParser();
            JSONObject jsonObject = (JSONObject) jsonParser.parse(jsonData);
            int item = Integer
                    .parseInt(jsonObject.get("item").toString());
            String itemType = jsonObject.get("type").toString();
            String itemTitle = jsonObject.get("title").toString();
            String itemContent = jsonObject.get("content").toString();
            // Item that need to add is an lesson;
            if (itemType.equals("lesson")) {
                
                instructorContext
                    .updateLesson(item, itemTitle, itemContent);
                
            } else {
                
                instructorContext
                    .updateQuiz(item, itemTitle, itemContent);
                
            }
        } catch (SQLException | ParseException ex) {
            Logger.getLogger(UpdateItem.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
    
}
