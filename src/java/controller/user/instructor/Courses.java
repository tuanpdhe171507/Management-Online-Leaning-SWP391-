/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller.user.instructor;

import authentication.authorization.Authorization;
import dao.InstructorContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Course;

/**
 *
 * @author HieuTC
 */
@WebServlet("/instructor/courses")
public class Courses extends Authorization{

    @Override
    protected void forwardGetRequest(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            InstructorContext instructorContext = new InstructorContext();
            /* Get course list by instructor. */
            ArrayList<Course> courseList = instructorContext
                    .getCourseList(user.getEmail());
            
            
            String query = req.getParameter("query");
            String sort = req.getParameter("sort");
            
            /* Filter course list by search key */
            if (query != null) {
                /* Traversal course list*/
                for (int i = 0; i < courseList.size(); i++) {
                    
                    /* The course is not matched*/
                    if (!courseList.get(i).getName().toLowerCase()
                            .contains(query.toLowerCase())) {
                        courseList.remove(i);
                        i--;
                    }
                }
            }
           
            /* Sort list*/
            if (sort != null
                    && courseList.size() != 0) {
                Collections.sort(courseList, (Course o1, Course o2) -> {
                    switch (sort) {
                        case "newest" -> {
                            return o1.getCreatedTime()
                                    .before(o2.getCreatedTime()) ? 1 : -1;
                        }
                        case "oldest" -> {
                            return o1.getCreatedTime()
                                    .before(o2.getCreatedTime()) ? -1 : 1;
                        }
                        case "aToZ" -> {
                            return o1.getName().charAt(0) -
                                    o2.getName().charAt(0);
                        }
                        case "zToA" -> {
                            return o2.getName().charAt(0) -
                                    o1.getName().charAt(0);
                        }
                        
                        case "most" -> {
                            try {
                                return o2.getTotalStudents() -
                                        o1.getTotalStudents();
                            } catch (SQLException ex) {
                                return 0;
                            }
                        }
                        case "least" -> {
                            try {
                                return o1.getTotalStudents() -
                                        o2.getTotalStudents();
                            } catch (SQLException ex) {
                                return 0;
                            }
                        }
                        default -> {
                            return 0; 
                        }
                    }                
                });
            }
            /**/
            req.setAttribute("courseList", courseList);
            
            req.getRequestDispatcher("../view/instructor/courses.jsp")
                    .forward(req, resp);
        } catch (SQLException | ParseException ex) {
            Logger.getLogger(Courses.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    @Override
    protected void forwardPostRequest(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }
    
}
