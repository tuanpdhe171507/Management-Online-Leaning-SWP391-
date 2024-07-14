/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller.user;

import dao.CourseContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.AccessibleCourse;
import model.Category;
import model.User;

/**
 *
 * @author TuanPD
 */
@WebServlet("/payment-history")
public class PaymentHistory extends authentication.Authentication {

    @Override
    protected void doGet(User user, HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        CourseContext courseContext = new CourseContext();
        try {
            ArrayList<Category> listCategorys = courseContext.getListCategory();
            ArrayList<AccessibleCourse> listAccessibleCourses;

            String key = req.getParameter("key");
            String categoryID = req.getParameter("serviceCategory");
            String fromDate = req.getParameter("fromdate");
            String toDate = req.getParameter("todate");
            String sort = req.getParameter("sort");
            String email= user.getEmail();

            // Initialize query parameters
            boolean hasKey = key != null && !key.isEmpty();
            boolean hasCategory = categoryID != null && !categoryID.equals("all");
            boolean hasDateRange = fromDate != null && !fromDate.isEmpty() && toDate != null && !toDate.isEmpty();

            if (hasKey || hasCategory || hasDateRange) {
                // Build and execute query based on provided filters
                listAccessibleCourses = courseContext.searchCourses(key, categoryID, fromDate, toDate);
            } else {
                listAccessibleCourses = courseContext.getListAccessibleCourses(email);
            }

            // Sort the list if required
            if (sort != null && !sort.isEmpty()) {
                if (sort.equalsIgnoreCase("newest")) {
                    listAccessibleCourses.sort((o1, o2) -> o2.getDate().compareTo(o1.getDate()));
                } else if (sort.equalsIgnoreCase("oldest")) {
                    listAccessibleCourses.sort((o1, o2) -> o1.getDate().compareTo(o2.getDate()));
                }
            }

            req.setAttribute("listCategorys", listCategorys);
            req.setAttribute("listAccessibleCourses", listAccessibleCourses);
        } catch (ParseException ex) {
            Logger.getLogger(PaymentHistory.class.getName()).log(Level.SEVERE, null, ex);
        }
        req.getRequestDispatcher("view/student/history-payment.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(User user, HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        String email = user.getEmail();

        if ("changeStatus".equals(action)) {
            String courseId = req.getParameter("courseId");
            int currentVisibility = Integer.parseInt(req.getParameter("currentStatus"));

            int newState = (currentVisibility == 0) ? 1 : 0;

            CourseContext db = new CourseContext();
            if (courseId != null && !courseId.isEmpty()) {
                int cid = Integer.parseInt(courseId);
                db.updateHiddenState(email, cid, newState);

            }
            resp.sendRedirect("http://localhost:8080/SWP391/payment-history");
        }
    }
}
