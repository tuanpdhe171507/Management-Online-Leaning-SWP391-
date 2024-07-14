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
@WebServlet("/update-note")
public class UpdateNote extends authentication.Authentication {

    @Override
    protected void doGet(User user, HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            String noteId = req.getParameter("note");
            
            UserContext userContext = new UserContext();
            
            String email = user.getEmail();
            userContext.removeNote(email, Integer.parseInt(noteId));
        } catch (SQLException ex) {
            Logger.getLogger(UpdateNote.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    @Override
    protected void doPost(User user, HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            
            String email = user.getEmail();
            // Get json data from request;
            BufferedReader reader = req.getReader();
            String jsonData = reader.readLine();
            
            // Covert data to json object;
            JSONParser jsonParser = new JSONParser();
            JSONObject jsonObject = (JSONObject) jsonParser.parse(jsonData);
            
            // Format data type;
            int noteId = Integer.parseInt(jsonObject
                    .get("note").toString());
            String content = jsonObject.get("content").toString();
            
            UserContext userContext = new UserContext();
            userContext.updateNote(email, noteId, content);
        } catch (ParseException | SQLException ex) {
            Logger.getLogger(UpdateNote.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
    
    
    
}
