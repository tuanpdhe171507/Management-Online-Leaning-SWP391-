/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller;

import dao.CourseContext;
import dao.InstructorContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Category;
import model.Course;
import model.Instructor;

/**
 *
 * @author HieuTC
 */
@WebServlet("/courses")
public class CategoryCourses extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            String categoryId = req.getParameter("category");
            String sort = req.getParameter("sort");

            if (sort == null) {
                resp.sendRedirect("?category=" + categoryId
                        + "&sort=highest");
            } else {
                CourseContext courseContext = new CourseContext();
                Category category = courseContext.getCategory(categoryId);
                req.setAttribute("category", category);

                ArrayList<Course> courseList = courseContext
                        .getCourseListByCategory(categoryId);

                Collections.sort(courseList, (Course o1, Course o2) -> {
                    switch (sort) {
                        
                        case "most" -> {
                            try {
                                return o2.getTotalStudents() - o1.getTotalStudents();
                            } catch (SQLException ex) {
                                Logger.getLogger(CategoryCourses.class.getName()).log(Level.SEVERE, null, ex);
                            }
                        }
                        
                        case "newest" -> {
                            return o2.getCreatedTime()
                                    .before(o1.getCreatedTime()) ? -1 : 0;
                        }
                        
                        default -> {
                            try {
                                return (int) (o2.getCourseRating()
                                        - o1.getCourseRating());
                                
                            } catch (ParseException | SQLException ex) {
                                Logger.getLogger(CategoryCourses.class.getName())
                                        .log(Level.SEVERE, null, ex);
                            }

                        }
                    }
                    return 0;
                });

                req.setAttribute("courseList", courseList);

                InstructorContext instructorContext = new InstructorContext();
                ArrayList<Instructor> instructorList = courseContext
                        .getInstructorListByCategory(categoryId);
                Collections.sort(instructorList, (Instructor o1, Instructor o2) -> {
                    try {
                        return (int) (o2.getInstructorRating()
                                - o1.getInstructorRating());
                    } catch (SQLException | ParseException ex) {
                        Logger.getLogger(CategoryCourses.class.getName()).log(Level.SEVERE, null, ex);
                    }
                    return 0;
                });
                req.setAttribute("instructorList", instructorList.subList(0,
                        Math.min(instructorList.size(), 4)));
                req.getRequestDispatcher("view/courses.jsp")
                        .forward(req, resp);
            }

        } catch (ParseException | SQLException ex) {
            Logger.getLogger(CategoryCourses.class.getName())
                    .log(Level.SEVERE, null, ex);
        }
    }
    
}
