/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller.user.instructor;

import dao.InstructorContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.BufferedReader;
import java.io.IOException;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;

/**
 *
 * @author HieuTC
 */
@WebServlet("/course/add-section")
public class AddSection extends HttpServlet{

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        super.doGet(req, resp); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/OverriddenMethodBody
    }
    
    
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            //Read data from request;
            resp.setContentType("application/json");
            BufferedReader reader = req.getReader();
            String jsonData = reader.readLine();
            
            // Parse data to object;
            JSONParser jsonParser = new JSONParser();
            JSONObject jsonObject = (JSONObject) jsonParser.parse(jsonData);
            
            
            int courseId = Integer
                    .parseInt(jsonObject.get("course").toString());
            String sectionTitle = jsonObject.get("section").toString();
            
            InstructorContext instructorContext = new InstructorContext();
            
            //Add section
            instructorContext.addSection(courseId, sectionTitle);

        } catch (SQLException ex) {
            Logger.getLogger(AddSection.class.getName()).log(Level.SEVERE, null, ex);
        } catch (ParseException ex) {
            Logger.getLogger(AddSection.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
    
    
    
}
