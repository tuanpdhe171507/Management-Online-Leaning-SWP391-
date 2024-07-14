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
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Video;

/**
 *
 * @author HieuTC
 */

@WebServlet("/course/load-library")
public class LoadVideoLibrary extends HttpServlet{

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            String query = req.getParameter("query");
            String sort = req.getParameter("sort");
            
            InstructorContext instructorContext = new InstructorContext();
            ArrayList<Video> videoList = instructorContext
                    .getVideoLibrary("itranconghieu@gmail.com");
            
           
            if (query != null && !"all".equalsIgnoreCase(query)) {
                
                query = query.trim();
                for (int i = 0; i < videoList.size(); i++) {
                    Video video = videoList.get(i);
                    
                    if (video.getName() == null ||
                            !video.getName().contains(query)) {

                        videoList.remove(i);
                        i --;
                    }
                }
            }
            
            // Sort list
            switch (sort) {
                case "oldest" ->  {
                        Collections
                                .sort(videoList, new Comparator<Video>() {
                            @Override
                            public int compare(Video o1, Video o2) {
                                
                                // Swap position;
                                return o1.getUploadedUpdate()
                                        .before(o2.getUploadedUpdate()) ?
                                        -1 : 0;
                            }
                            
                        });
                    }
                default -> {
                    Collections
                                .sort(videoList, new Comparator<Video>() {
                            @Override
                            public int compare(Video o1, Video o2) {
                                
                                // Swap position;
                                return o1.getUploadedUpdate()
                                        .after(o2.getUploadedUpdate()) ?
                                        -1 : 0;
                            }
                            
                        });
                }
            }
            
            // Convert response to json object;
            Gson gson = new Gson();
            String jsonResponse = gson.toJson(videoList);
            
            // Set context for response;
            resp.setContentType("application/json");
            resp.setCharacterEncoding("UTF-8");
            
            PrintWriter writer = resp.getWriter();
            writer.print(jsonResponse);
        } catch (SQLException | ParseException ex) {
            Logger.getLogger(LoadVideoLibrary.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
}
