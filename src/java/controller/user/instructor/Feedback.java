/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller.user.instructor;

import com.google.gson.Gson;
import dao.InstructorContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
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
import model.Rating;


/**
 *
 * @author HieuTC
 */

@WebServlet("/instructor/feedback")
public class Feedback extends authentication.authorization.Authorization {
    
    @Override
    protected void forwardGetRequest(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            String[] paramStars = req.getParameterValues("star");
            String sort = req.getParameter("sort");
            InstructorContext instructorContext = new InstructorContext();
            String email = user.getEmail();
            
            ArrayList<Rating> ratingList = instructorContext
                    .getRatingWithin48Hours(email);
            
            if (paramStars != null) {
                ArrayList<String> stars = new ArrayList<>();
                Collections.addAll(stars, paramStars); 
                
                for (int i = 0; i < ratingList.size(); i++) {
                    Rating rating = ratingList.get(i);
                    
                    if (!stars.contains(
                            String.valueOf(rating.getStar()))) {
                        ratingList.remove(i);
                        i--;
                    }
                }
            }
            
            Collections.sort(ratingList, new Comparator<Rating>() {
                @Override
                public int compare(Rating o1, Rating o2) {
                    
                    if (sort != null
                            && sort.equalsIgnoreCase("oldest")) {
                        return o1.getRatedTime()
                                .before(o2.getRatedTime()) ? -1 : 0;
                    } else {
                        return o1.getRatedTime()
                                .after(o2.getRatedTime()) ? -1 : 0;
                    }
                }
                
            });
                    
            // Set context for response;
            resp.setContentType("application/json");
            resp.setCharacterEncoding("UTF-8");
            
            Gson gson = new Gson();
            
            String jsonResponse = gson.toJson(ratingList);
            PrintWriter writer = resp.getWriter();
            writer.print(jsonResponse);
        } catch (SQLException | ParseException ex) {
            Logger.getLogger(Feedback.class.getName()).log(Level.SEVERE, null, ex);
        }
        
    }
    
    @Override
    protected void forwardPostRequest(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    }

}
