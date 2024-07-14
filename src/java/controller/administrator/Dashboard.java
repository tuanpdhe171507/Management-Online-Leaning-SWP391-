/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller.administrator;

import dao.AdministratorContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.time.Month;
import java.util.ArrayList;
import java.util.Date;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author HieuTC
 */
@WebServlet("/administrator/dashboard")
public class Dashboard extends authentication.authorization.Authorization {

    @Override
    protected void forwardGetRequest(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            AdministratorContext dbContext = new AdministratorContext();
            int totalCourse = dbContext.getTotalCourse();
            int totalStudent = dbContext.getTotalStudent();
            int totalRatings = dbContext.getTotaRatings();
            int totalPositiveRatings = dbContext.getTotalPositiveRatings();
            req.setAttribute("totalCourse", totalCourse);
            req.setAttribute("totalStudent", totalStudent);
            req.setAttribute("totalRatings", totalRatings);
            req.setAttribute("totalPositiveRatings", totalPositiveRatings);
            
            Date now = new Date();
            int month = now.getMonth() + 1;
            int lastMonth = month - 1;
            
            // Last month report;
            int numberStudentLastMonth = dbContext
                    .getNumberStudentInMonth(lastMonth);
            int numberCourseLastMonth = dbContext
                    .getNumberCourseInMonth(lastMonth);
            
            int numberRatingLastMonth = dbContext
                    .getRatingsInMonth(lastMonth);
            int numberPositiveRatingLastMonth = dbContext
                    .getPositiveRatingsInMonth(lastMonth);
            req.setAttribute("numberStudentLastMonth", numberStudentLastMonth);
            req.setAttribute("numberCourseLastMonth", numberCourseLastMonth);
            req.setAttribute("numberRatingLastMonth", numberRatingLastMonth);
            req.setAttribute("numberPositiveRatingLastMonth", numberPositiveRatingLastMonth);
            
            // Current month report;
             int numberStudentCurrentMonth = dbContext
                    .getNumberStudentInMonth(month);
            int numberCourseCurrentMonth = dbContext
                    .getNumberCourseInMonth(month);
            int numberRatingCurrentMonth = dbContext
                    .getRatingsInMonth(month);
            int numberPositiveRatingCurrentMonth = dbContext
                    .getPositiveRatingsInMonth(month);
            req.setAttribute("numberStudentCurrentMonth", numberStudentCurrentMonth);
            req.setAttribute("numberCourseCurrentMonth", numberCourseCurrentMonth);
            req.setAttribute("numberRatingCurrentMonth", numberRatingCurrentMonth);
            req.setAttribute("numberPositiveRatingCurrentMonth", numberPositiveRatingCurrentMonth);
            
            ArrayList<Spot> spots = new ArrayList<>();
            for (int i = (now.getMonth() < 3 ?
                    0 : now.getMonth() - 3); i <= ((now.getMonth() < 3) ?
                    now.getMonth() + (3 - now.getMonth()) : now.getMonth()); i++) {
                Spot spot = new Spot();
                spot.setMonth(Month.of(i + 1).name());
                spot.setEnrollments(dbContext
                        .getEnrollmentsInMonth(i + 1));
                spot.setRatings(dbContext.getRatingsInMonth(i + 1));
                spots.add(spot);
            }
            req.setAttribute("spots", spots);
            
            req.getRequestDispatcher("../view/administrator/dashboard.jsp")
                    .forward(req, resp);
        } catch (SQLException ex) {
            Logger.getLogger(Dashboard.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    @Override
    protected void forwardPostRequest(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }
    
    public class Spot {
        private String month;
        private int enrollments;
        private int ratings;

        public String getMonth() {
            return month;
        }

        public void setMonth(String month) {
            this.month = month;
        }

        public int getEnrollments() {
            return enrollments;
        }

        public void setEnrollments(int enrollments) {
            this.enrollments = enrollments;
        }

        public int getRatings() {
            return ratings;
        }

        public void setRatings(int ratings) {
            this.ratings = ratings;
        }  
        
    }
}
