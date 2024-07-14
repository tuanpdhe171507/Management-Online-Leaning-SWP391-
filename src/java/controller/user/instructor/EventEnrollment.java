/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller.user.instructor;

import controller.administrator.ManageDiscount;
import dao.CourseContext;
import dao.InstructorContext;
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
import model.CourseDiscount;
import model.DiscountEvent;
import model.User;

/**
 *
 * @author HuyLQ;
 */
@WebServlet(name = "EventEnrollment", urlPatterns = {"/instructor/event-enrollment"})
public class EventEnrollment extends authentication.Authentication {

    @Override
    protected void doGet(User user, HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            InstructorContext instructorContext = new InstructorContext();
            ArrayList<Course> courseList = instructorContext.getCourseList(user.getEmail());
            CourseContext db = new CourseContext();
            ArrayList<CourseDiscount> listCourseJoinEventedOfIns = new ArrayList<>();
            ArrayList<DiscountEvent> listEvent = db.getEvent();
            ArrayList<CourseDiscount> listCourseJoinEvented = instructorContext.getCourseJoinedEvent(user.getEmail(), LEGACY_DO_HEAD);
            req.setAttribute("listCourseJoinEventedOfIns", listCourseJoinEventedOfIns);
            req.setAttribute("courseList", courseList);
            req.setAttribute("listEvent", listEvent);
            req.getRequestDispatcher("../view/instructor/event-enrollment.jsp").forward(req, resp);
        } catch (SQLException | ParseException ex) {
            Logger.getLogger(ManageDiscount.class.getName()).log(Level.SEVERE, null, ex);
        }

    }

    @Override
    protected void doPost(User user, HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

}
