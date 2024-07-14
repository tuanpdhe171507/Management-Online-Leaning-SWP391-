/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller.user.instructor;

import com.google.gson.Gson;
import dao.InstructorContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.PrintWriter;
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
@WebServlet("/course/add-item")
public class AddItem extends HttpServlet{
        
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
            
            InstructorContext instructorContext = new InstructorContext();
            int sectionId = Integer
                    .parseInt(jsonObject.get("section").toString());
            String itemType = jsonObject.get("item").toString();
            String itemTitle = jsonObject.get("title").toString();
            
            Item item = new Item();
            int itemId = 0;
            item.setType(itemType);
            // Item that need to add is an lesson;
            if (itemType.equals("lesson")) {

                //Add section
                itemId = instructorContext.addLesson(sectionId, itemTitle);
            } else {
                itemId = instructorContext
                        .addQuiz(sectionId, itemTitle);
            }
            
            item.setId(itemId);
             // Set context for response;
            resp.setContentType("application/json");
            resp.setCharacterEncoding("UTF-8");
            
            Gson gson = new Gson();
            String jsonResponse = gson.toJson(item);
            PrintWriter writer = resp.getWriter();
            writer.print(jsonResponse);
        } catch (SQLException ex) {
            Logger.getLogger(AddSection.class.getName()).log(Level.SEVERE, null, ex);
        } catch (ParseException ex) {
            Logger.getLogger(AddItem.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
    
    public class Item {
        private int id;
        private String type;

        public int getId() {
            return id;
        }

        public void setId(int id) {
            this.id = id;
        }

        public String getType() {
            return type;
        }

        public void setType(String type) {
            this.type = type;
        }
        
    }
}
