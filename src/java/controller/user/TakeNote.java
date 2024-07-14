/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller.user;

import com.google.gson.Gson;
import dao.UserContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Note;
import model.User;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;

/**
 *
 * @author HieuTC
 */
@WebServlet("/take-note")
public class TakeNote extends authentication.Authentication {

    @Override
    protected void doGet(User user, HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
         try {
            String email = "itranconghieu@gmail.com";
            
            UserContext userContext = new UserContext();
            ArrayList<Note> notes = userContext.getNotes(email);
            
            String query = req.getParameter("query");
            String sort = req.getParameter("sort");
            
            if (!query.equalsIgnoreCase("all") && query != null) {
                int lesson = Integer.parseInt(query);
                
                //Traversal note list;
                for (int i = 0; i < notes.size(); i++) {
                    
                    Note note = notes.get(i);
                    
                    // Not yet;
                    if (note.getLessonId() != lesson) {
                        notes.remove(i);
                        i--;
                    }
                }
            }
            
            if (sort != null) {
                switch (sort) {
                    case "oldest" ->  {
                        Collections.sort(notes, new Comparator<Note>() {
                            @Override
                            public int compare(Note o1, Note o2) {
                                return o1.getNotedTime()
                                        .before(o2.getNotedTime()) ? -1 : 1;
                            }
                        });
                    }
                    default -> {
                        Collections.sort(notes, new Comparator<Note>() {
                            @Override
                            public int compare(Note o1, Note o2) {
                                return o1.getNotedTime()
                                        .before(o2.getNotedTime()) ? 1 : -1;
                            }
                        });
                    }
                }
            }
            
            // Set context for response;
            resp.setContentType("application/json");
            resp.setCharacterEncoding("UTF-8");
            
            Gson gson = new Gson();
            
            String jsonResponse = gson.toJson(notes);
            PrintWriter writer = resp.getWriter();
            writer.print(jsonResponse);
        } catch (SQLException | ParseException ex) {
            Logger.getLogger(Note.class.getName()).log(Level.SEVERE, null, ex);
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
            int lessonId = Integer
                    .parseInt(jsonObject.get("lesson").toString());
            String atTime = jsonObject.get("time").toString();
            String noteContent = jsonObject.get("content").toString();
            
            UserContext userContext = new UserContext();
            userContext
                    .addNote(email, lessonId, atTime, noteContent);
        } catch (org.json.simple.parser.ParseException | SQLException ex) {
            Logger.getLogger(Note.class.getName())
                    .log(Level.SEVERE, null, ex);
        }

    }
    
    
    
}
