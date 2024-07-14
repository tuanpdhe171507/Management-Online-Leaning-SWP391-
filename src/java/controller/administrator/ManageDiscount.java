/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller.administrator;

import dao.AdministratorContext;
import dao.CourseContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.websocket.EncodeException;
import java.io.IOException;
import java.sql.SQLException;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Course;
import model.CourseDiscount;
import model.User;
import model.DiscountEvent;
import model.Notification;

/**
 *
 * @author HuyLQ;
 */
@WebServlet(name = "ManageDiscount", urlPatterns = {"/administrator/discount-event"})
public class ManageDiscount extends authentication.Authentication {

    @Override
    protected void doGet(User user, HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            //String flag = req.getParameter("flag");
            CourseContext db = new CourseContext();
            ArrayList<DiscountEvent> listEvent = db.getEvent();
            ArrayList<CourseDiscount> listCourseJoinEvented = db.getPricePackage();
            String eventDeleted = req.getParameter("eventDeleted");
            String eventName = req.getParameter("eventName");
            String fromDate = req.getParameter("fromdate");
            String toDate = req.getParameter("todate");
            String sort = req.getParameter("sort");
            String nameInstructor = req.getParameter("nameInstructor");

            db.deleteEvent(eventDeleted);
            boolean hasKey = eventName != null && !eventName.isEmpty();
            boolean hasKeyIns = nameInstructor != null && !nameInstructor.isEmpty();
            boolean hasDateRange = fromDate != null && !fromDate.isEmpty() && toDate != null && !toDate.isEmpty();
            if (hasKey || hasDateRange) {
                // Build and execute query based on provided filters
                listEvent = db.searchEvent(eventName, sort, fromDate, toDate);
            } else if (hasKeyIns) {
                listCourseJoinEvented = db.searchCourseDiscount(nameInstructor, sort);
            }
            req.setAttribute("listEvent", listEvent);
            req.setAttribute("listCourseJoinEvented", listCourseJoinEvented);
            req.getRequestDispatcher("../view/administrator/manage-discount.jsp").forward(req, resp);
        } catch (SQLException | ParseException ex) {
            Logger.getLogger(ManageDiscount.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    @Override
    protected void doPost(User user, HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            int action = Integer.parseInt(req.getParameter("action"));
            CourseContext db = new CourseContext();

            String title = req.getParameter("title");
            String discountStr = req.getParameter("discount");
            String startDate = req.getParameter("startDate");
            String endDate = req.getParameter("endDate");

            String titleCurrent = req.getParameter("titleCurrent");
            String eventNew = req.getParameter("titleNew");

            String startDateNew = req.getParameter("startDateNew");
            String endDateNew = req.getParameter("endDateNew");

            if (action == 1) {
                if (title == null || title.isEmpty()
                        || discountStr == null || discountStr.isEmpty()
                        || startDate == null || startDate.isEmpty()
                        || endDate == null || endDate.isEmpty()) {
                } else {
                    int discount = Integer.parseInt(discountStr);
                    db.createEvent(title, discount, startDate, endDate);
                }
            } else if (action == 2) {
                int discountNew = Integer.parseInt(req.getParameter("discountNew"));
                db.updateEvent(titleCurrent, eventNew, discountNew, startDateNew, endDateNew);
            } else if (action == 3) {
                int courseId = Integer.parseInt(req.getParameter("courseId"));

                db.deleteOrUpdateCourseDiscounted("delete", courseId, title);
            } else if (action == 4) {
                int courseId = Integer.parseInt(req.getParameter("courseId"));

                Course course = db.getCourse(courseId);
                AdministratorContext dbCT = new AdministratorContext();
                Notification noti = dbCT.insertNotification(course.getInstructor().getEmail(), 
                        "Khoa hoc cua m da bi ban, m cut", "http://localhost:8080/SWP391/notification");
                util.websocket.EchoEndPoint.send(course.getInstructor().getEmail(), noti);
                db.deleteOrUpdateCourseDiscounted("accept", courseId, title);
            }
            ArrayList<DiscountEvent> listEvent = db.getEvent();
            ArrayList<CourseDiscount> listCourseJoinEvented = db.getPricePackage();
            req.setAttribute("listEvent", listEvent);
            req.setAttribute("listCourseJoinEvented", listCourseJoinEvented);
            req.getRequestDispatcher("../view/administrator/manage-discount.jsp").forward(req, resp);
        } catch (SQLException | ParseException ex) {
            Logger.getLogger(ManageDiscount.class.getName()).log(Level.SEVERE, null, ex);
        } catch (EncodeException ex) {
            Logger.getLogger(ManageDiscount.class.getName()).log(Level.SEVERE, null, ex);
        }

    }

}
