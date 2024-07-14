/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller;

import dao.CourseContext;
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
import java.util.Date;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Course;

/**
 *
 * @author TuanPD
 */
@WebServlet("/search")
public class SearchCourse extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String key = req.getParameter("key");
        String paid = req.getParameter("paid");
        String free = req.getParameter("free");

        CourseContext courseContext = new CourseContext();
        ArrayList<Course> searchedCourses = new ArrayList<>();

        try {
            // Step 1: Search Courses by Key
            searchedCourses = courseContext.searchCourse(key);

            // Step 2: Determine Filter Criteria
            Boolean filterStatus = null;
            if ("true".equals(free) && !"true".equals(paid)) {
                filterStatus = true; // Only free courses
            } else if ("true".equals(paid) && !"true".equals(free)) {
                filterStatus = false; // Only paid courses
            }

            Float stars = null;
            String star = req.getParameter("rating2");
            if (star != null && !star.isEmpty()) {
                stars = Float.parseFloat(star);
            }

            // Step 3: Filter Courses if at least one filter is applied
            if (filterStatus != null || stars != null) {
                searchedCourses = courseContext.filterCourses(key, filterStatus, stars);
            }

            // Step 4: Sort the Courses
            String sortCourse = req.getParameter("sort");
            if (sortCourse != null && !sortCourse.isEmpty()) {
                if (sortCourse.equalsIgnoreCase("rating")) {
                    searchedCourses.sort((o1, o2) -> {
                        try {
                            return Float.compare(o2.getCourseRating(), o1.getCourseRating());
                        } catch (ParseException | SQLException ex) {
                            return 0;
                        }
                    });
                } else if (sortCourse.equalsIgnoreCase("newest")) {
                    searchedCourses.sort((Course course1, Course course2) -> {
                        Date createdDate1 = course1.getCreatedDate2();
                        Date createdDate2 = course2.getCreatedDate2();
                        return createdDate2.compareTo(createdDate1);
                    });
                } else if (sortCourse.equalsIgnoreCase("lowest")) {
                    searchedCourses.sort((o1, o2) -> Double.compare(o1.getPrice(), o2.getPrice()));
                } else if (sortCourse.equalsIgnoreCase("highest")) {
                    searchedCourses.sort((o1, o2) -> Double.compare(o2.getPrice(), o1.getPrice()));
                }
            }
        } catch (SQLException | ParseException ex) {
            Logger.getLogger(SearchCourse.class.getName()).log(Level.SEVERE, null, ex);
        }

        req.setAttribute("searchedCourses", searchedCourses);
        req.getRequestDispatcher("view/search-course.jsp").forward(req, resp);
    }

}
