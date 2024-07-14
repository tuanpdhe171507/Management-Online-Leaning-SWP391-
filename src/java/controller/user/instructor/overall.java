/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller.user.instructor;

import dao.InstructorContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.text.ParseException;
import java.time.Month;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Course;

/**
 *
 * @author HieuTC
 */
@WebServlet("/instructor/overall")
public class Overall extends authentication.authorization.Authorization {

    @Override
    protected void forwardGetRequest(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            InstructorContext instructorContext = new InstructorContext();
            String email = user.getEmail();
            Date now = new Date();
            
            
            ArrayList<Report> reports = new ArrayList<>();
            
            ArrayList<Course> courseList = instructorContext
                    .getCourseList(email);
            
            int enrollmentsInFreeCourse = 0;
            int enrollmentsInPaidCourse = 0;
            
            ArrayList<Spot> spots = new ArrayList<>();
            
            for (Course course : courseList) {
                Spot spot = new Spot();
                spot.setName(course.getName());
                spot.setEnrollments(0);
                spots.add(spot);
            }
            
            // Get most recent 4 months;
            for (int i = (now.getMonth() < 3 ?
                    0 : now.getMonth() - 3); i <= ((now.getMonth() < 3) ?
                    now.getMonth() + (3 - now.getMonth()) : now.getMonth()); i++) {
                Report report = new Report();
                String month = Month.of(i + 1).name();
                report.setMonth(month.substring(0, 1) 
                        + month.substring(1).toLowerCase());
                int sumEnrollments = 0;
                
                for (int j = 0; j < courseList.size(); j++) {
                    Course course = courseList.get(j);
                    // Course must be publish or private state;
                    if (course.getVisibility() != 0) {
                        int enrollment = course
                                .getTotalEnrolledStudentInMonth(i + 1);
                        if (course.getPrice() == 0) {
                            enrollmentsInFreeCourse += enrollment;
                        } else {
                            enrollmentsInPaidCourse += enrollment;
                        }
                        sumEnrollments += enrollment;
                        
                        Spot spot = spots.get(j);
                        spot.setEnrollments(
                                spot.getEnrollments() + enrollment);
                    }
                }
                report.setStudent(sumEnrollments);
                reports.add(report);
                
               
            }
            if (!spots.isEmpty()) {
                Collections.sort(spots, (Spot o1, Spot o2) -> o2.getEnrollments() - o1.getEnrollments());
            }
            
            
            /*Traversal spot list for caculate total enrollments not
            *  in most common 3 courses;
            */
            
            int others = 0;
            if (!spots.isEmpty()) {
                for (Spot spot : spots.subList(0,
                        spots.size() > 3 ? 3 : spots.size())) {
                    others += spot.getEnrollments();
                }
            }
            
            others = (enrollmentsInFreeCourse + enrollmentsInPaidCourse) - others;
            req.setAttribute("spots", spots.subList(0,
                    spots.size() > 3 ? 3 : spots.size()));
            req.setAttribute("others", others);
            req.setAttribute("reports", reports);
            req.setAttribute("freeCourse", enrollmentsInFreeCourse);
            req.setAttribute("paidCourse", enrollmentsInPaidCourse);

            req.getRequestDispatcher("../view/instructor/overall.jsp")
                    .forward(req, resp);
        } catch (SQLException | ParseException ex) {
            Logger.getLogger(Overall.class.getName()).log(Level.SEVERE, null, ex);
        }
    }


    @Override
    protected void forwardPostRequest(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }
    
    public class Report {
        private String month;
        private int student;

        public String getMonth() {
            return month;
        }

        public void setMonth(String month) {
            this.month = month;
        }

        public int getStudent() {
            return student;
        }

        public void setStudent(int student) {
            this.student = student;
        }
        
    }
    
    public class Spot {
        private String name;
        private int enrollments;

        public String getName() {
            return name;
        }

        public void setName(String name) {
            this.name = name;
        }

        public int getEnrollments() {
            return enrollments;
        }

        public void setEnrollments(int enrollments) {
            this.enrollments = enrollments;
        }
        
        
    }
}
