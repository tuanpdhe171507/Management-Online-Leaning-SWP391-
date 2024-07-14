/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller.administrator;

import dao.CourseContext;
import dao.ReportContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.mail.MessagingException;
import model.Course;
import model.CourseReport;
import model.User;
import util.Mail;

/**
 *
 * @author TuanPD
 */
@WebServlet("/administrator/manager-course")
public class ManagerCourse extends authentication.Authentication {

    @Override
    protected void doGet(User user, HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        ReportContext db = new ReportContext();
        try {
            ArrayList<CourseReport> listMess = db.getListMess();

            Collections.sort(listMess, new Comparator<CourseReport>() {
                @Override
                public int compare(CourseReport r1, CourseReport r2) {
                    return r2.getSentTime().compareTo(r1.getSentTime());
                }
            });

            // Get last visit time from cookie
            String lastVisitTime = getLastVisitTimeFromCookies(req.getCookies());
            int newReportsCount = countNewReports(listMess, lastVisitTime);
            req.getSession().setAttribute("newReports", newReportsCount);

            // Update last visit time in cookie
            String currentVisitTime = getCurrentTimeAsString();
            String encodedVisitTime = URLEncoder.encode(currentVisitTime, StandardCharsets.UTF_8.toString());
            Cookie lastVisitTimeCookie = new Cookie("lastVisitTime", encodedVisitTime);
            lastVisitTimeCookie.setMaxAge(60 * 60 * 24 * 365); // 1 year
            resp.addCookie(lastVisitTimeCookie);

            ArrayList<CourseReport> listCourseReport;

            String key = req.getParameter("key");
            if (key != null && !key.isEmpty()) {
                // Call the search function
                listCourseReport = db.Search(key);
            } else {
                // Show the entire list
                listCourseReport = db.getListReportResult();
            }

            String sort = req.getParameter("sort");
            if (sort != null && !sort.isEmpty()) {
                if (sort.equalsIgnoreCase("newest")) {
                    listCourseReport.sort((o1, o2) -> o2.getSentTime().compareTo(o1.getSentTime()));
                } else if (sort.equalsIgnoreCase("oldest")) {
                    listCourseReport.sort((o1, o2) -> o1.getSentTime().compareTo(o2.getSentTime()));
                }
            }

            req.setAttribute("listCourseReport", listCourseReport);
            req.setAttribute("listMess", listMess);
            req.setAttribute("key", key);
            req.getRequestDispatcher("../view/administrator/manager-course.jsp").forward(req, resp);

        } catch (ParseException ex) {
            Logger.getLogger(ManagerCourse.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    private String getCurrentTimeAsString() {
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        Date now = new Date();
        return dateFormat.format(now);
    }

    private int countNewReports(ArrayList<CourseReport> listCourseReport, String lastVisitTime) {
        int newReportsCount = 0;
        if (lastVisitTime == null) {
            return listCourseReport.size();
        }
        for (CourseReport report : listCourseReport) {
            if (report.getSentTime().compareTo(lastVisitTime) > 0) {
                newReportsCount++;
            }
        }
        return newReportsCount;
    }

    private String getLastVisitTimeFromCookies(Cookie[] cookies) {
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if ("lastVisitTime".equals(cookie.getName())) {
                    try {
                        return URLDecoder.decode(cookie.getValue(), StandardCharsets.UTF_8.toString());
                    } catch (UnsupportedEncodingException e) {
                        e.printStackTrace();
                    }
                }
            }
        }
        return null;
    }

    @Override
    protected void doPost(User user, HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");

        if ("changeVisibility".equals(action)) {
            String courseId = req.getParameter("courseId");
            String emailInstructor = req.getParameter("emailinstructor");
            int currentVisibility = Integer.parseInt(req.getParameter("currentVisibility"));

            int newVisibility = (currentVisibility == 0) ? 1 : 0;

            CourseContext db = new CourseContext();
            if (courseId != null && !courseId.isEmpty()) {
                int cid = Integer.parseInt(courseId);
                db.updateVisibility(cid, newVisibility);

                if (newVisibility == 0) {
                    try {
                        sendMail(emailInstructor);
                    } catch (MessagingException e) {
                        e.printStackTrace();
                    }
                }
            }
            resp.sendRedirect("http://localhost:8080/SWP391/administrator/manager-course");
        }
    }

    public void sendMail(String email) throws MessagingException {
        String content
                = "<div dir=\"ltr\" style=\"width: 600px; margin: 0 auto; background-color: #ffffff; padding: 20px;\">\n"
                + "    <div style=\"text-align: center; padding-bottom: 20px;\">\n"
                + "        <h1>EduPort</h1>\n"
                + "    </div>\n"
                + "    <div style=\"text-align: center; padding-bottom: 20px;\">\n"
                + "        <img src=\"https://fhgfjrf.stripocdn.email/content/guids/CABINET_c0e87147643dfd412738cb6184109942/images/151618429860259.png\"\n"
                + "            alt=\"\" style=\"display: block; margin: 0 auto;\" width=\"100\">\n"
                + "        <h1 style=\"font-size: 46px; line-height: 100%;\">Course Violation Report</h1>\n"
                + "    </div>\n"
                + "    <div style=\"text-align: center; padding-bottom: 20px;\">\n"
                + "        <p>Your course has been reported and found to be in violation of our policies.</p>\n"
                + "        <p>We kindly ask you to review and correct the issues with your course.</p>\n"
                + "        <a style=\"background-color: black; color: white; padding: 0.5rem; display: inline-block; margin-top: 1rem; text-decoration: none; font-weight: bold;\"\n"
                + "            href=\"http://localhost:8080/SWP391/account\"\n"
                + "            target=\"_blank\">My Account</a>\n"
                + "    </div>\n"
                + "    <div style=\"border-bottom: 2px solid #efefef; padding: 20px 0;\"></div>\n"
                + "    <div style=\"text-align: center; padding-top: 20px;\">\n"
                + "        <p>If you have any questions, please contact us at: EduPortEducation@gmail.com or phone number: 0976888888.</p>\n"
                + "    </div>\n"
                + "</div>";

        Mail.sendMail(email, "Course Violation Report in EduPort", content);
    }

}
