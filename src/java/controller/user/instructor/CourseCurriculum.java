/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller.user.instructor;

import dao.CourseContext;
import dao.InstructorContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Course;
import model.Interaction;
import model.Item;
import model.Lesson;
import model.Quiz;
import model.Section;
import model.Video;

/**
 *
 * @author HieuTC
 */
@WebServlet("/course/curriculum")
public class CourseCurriculum extends authentication.authorization.Authorization {
    
    @Override
    protected void forwardGetRequest(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            InstructorContext instructorContext = new InstructorContext();
            CourseContext courseContext = new CourseContext();
            String email = user.getEmail();
            int courseId = Integer
                    .parseInt(req.getParameter("id"));
            Course course = instructorContext.getCourse(email, courseId);
            
            String paramSection = req.getParameter("section");
            String paramQuiz = req.getParameter("quiz");
            String paramLesson = req.getParameter("lesson");
            
            
            // Athenticate instructor for course successfully;
            if (course != null) {
                

                if (paramSection != null) {
                    int sectionId = Integer
                            .parseInt(paramSection);
                    
                    for (Section section : course.getSectionList()) {
                        if (section.getId() == sectionId) {

                            if (paramQuiz != null) {
                                
                                int quizId = Integer.parseInt(paramQuiz);
                                
                                for (Item item : section.getItemList()) {
                                    
                                    if (item.getClass() == Quiz.class
                                            && item.getId() == quizId) {
                                        req.setAttribute("quiz", item);
                                    }
                                }
                                
                            } else if (paramLesson != null) {
                                
                                int lessonId = Integer.parseInt(paramLesson);
                                for (Item item : section.getItemList()) {
                                    if (item.getClass() == Lesson.class
                                            && item.getId() == lessonId) {
                                        Lesson lesson = (Lesson) item;
                                        req.setAttribute("lesson", lesson);
                                        
                                        Video video = lesson.getVideo();
                                        if (video != null) {
                                             ArrayList<Interaction> interactionList = 
                                                 courseContext.
                                                         getInteractionList(lessonId, lesson.getVideo().getId());
                                            req.setAttribute("interactionList", interactionList);
                                        }
                                    }
                                }
                                
                            } else {
                                req.setAttribute("section", section);
                            }
                        }
                    }
                } else {
                    ArrayList<Item> itemList = new ArrayList<>();
                    req.setAttribute("course", course);
                }
                
                req.getRequestDispatcher("../view/instructor/content.jsp")
                    .forward(req, resp);
            } else {
                PrintWriter writer = resp.getWriter();
                writer.print("Access denied");
            }
        } catch (SQLException | ParseException ex) {
            Logger.getLogger(CourseCurriculum.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    @Override
    protected void forwardPostRequest(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            String paramCourse = req.getParameter("course");
            int courseId = Integer.parseInt(paramCourse);
            
            String email = user.getEmail();
            InstructorContext instructorContext = new InstructorContext();
            instructorContext.deleteCourse(courseId);
            resp.sendRedirect("../instructor/courses");
        } catch (SQLException ex) {
            Logger.getLogger(CourseCurriculum.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
  
}
