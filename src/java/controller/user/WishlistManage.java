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
import java.sql.SQLException;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Course;
import model.User;
import model.Wishlist;

/**
 *
 * @author HuyLQ;
 */
@WebServlet("/wishlist")
public class WishlistManage extends authentication.Authentication {

    @Override
    protected void doGet(User user, HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            String courseId = req.getParameter("id");
            String emailAddress = user.getEmail();
            int totalPrice = 0;
            CourseContext db = new CourseContext();
           
            if (courseId != null && !courseId.isEmpty()) {
                int courseID = Integer.parseInt(courseId);
                db.removeCourseInWishList(emailAddress, courseID);
            }
            
            Wishlist wishList = db.getWishListByEmail(emailAddress);
            ArrayList<Course> courseList = wishList.getCourseId();
            for (Course course : courseList) {
                totalPrice += course.getCurrentPrice();
            }

            req.setAttribute("totalPrice", totalPrice);
            req.setAttribute("courseList", courseList);

            req.getRequestDispatcher("view/wish-list.jsp").forward(req, resp);
        } catch (SQLException | ParseException ex) {
            Logger.getLogger(WishlistManage.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    @Override
    protected void doPost(User user, HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            int courseId = Integer.parseInt(req.getParameter("courseId"));
            String emailAddress = user.getEmail();

            CourseContext db = new CourseContext();
            db.addCourseInWishList(emailAddress, courseId);

        } catch (SQLException ex) {
            Logger.getLogger(WishlistManage.class.getName()).log(Level.SEVERE, null, ex);
        } 
    }

}
