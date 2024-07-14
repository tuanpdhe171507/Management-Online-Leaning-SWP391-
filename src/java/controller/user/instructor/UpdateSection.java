/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller.user.instructor;

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
@WebServlet("/course/update-section")
public class UpdateSection extends authentication.Authentication{

    @Override
    protected void doGet(User user, HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            int sectionId = Integer.parseInt(req.getParameter("id"));
            
            InstructorContext instructorContext = new InstructorContext();
            
            //Remove section by id;
            instructorContext.removeSection(sectionId);
        } catch (SQLException ex) {
            Logger.getLogger(UpdateSection.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    @Override
    protected void doPost(User user, HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            //Read data from request;
            resp.setContentType("application/json");
            BufferedReader reader = req.getReader();
            String jsonData = reader.readLine();
            
            // Parse data to object;
            JSONParser jsonParser = new JSONParser();
            JSONObject jsonObject = (JSONObject) jsonParser.parse(jsonData);
            
            int sectionId = Integer
                    .parseInt(jsonObject.get("section").toString());
            String sectionTitle = jsonObject.get("title").toString();
            InstructorContext instructorContext = new InstructorContext();
            
            //Add section
            instructorContext.updateSection(sectionId, sectionTitle);
        } catch (SQLException ex) {
            Logger.getLogger(AddSection.class.getName()).log(Level.SEVERE, null, ex);
        } catch (ParseException ex) {
            Logger.getLogger(UpdateSection.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
    
}
