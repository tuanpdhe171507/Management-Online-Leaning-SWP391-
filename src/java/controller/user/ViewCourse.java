/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller.user;

import dao.CourseContext;
import dao.InstructorContext;
import dao.PlansContext;
import dao.QuizContext;
import dao.UserContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Course;
import model.Interaction;
import model.Item;
import model.Lesson;
import model.Quiz;
import model.QuizSession;
import model.Section;
import model.User;
import model.Video;

/**
 *
 * @author HieuTC
 */
@WebServlet("/course/page")
public class ViewCourse extends authentication.Authentication {

    @Override
    protected void doGet(User user, HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        PrintWriter writer = resp.getWriter();
        try {
            String email = user.getEmail();
            UserContext userContext = new UserContext();
            String paramCourse = req.getParameter("course");

            int courseId = Integer.parseInt(paramCourse);
            CourseContext courseContext = new CourseContext();
            Course course = courseContext.getCourse(courseId);
            
            boolean accountPro = false;
            Timestamp planExpiredTime = new PlansContext().getPlanExpiredTime(email);
            if (planExpiredTime != null) {
                Timestamp currentTime = new Timestamp(System.currentTimeMillis());
                if (planExpiredTime.after(currentTime)) {
                    accountPro = true;
                }

            }
            /* Instructors are allowed to preview their courses or
            *   students can access enrolled courses;
            */
            if (new InstructorContext().getCourse(email, courseId) != null
                    || (course.getVisibility() != 0 && 
                    userContext.authorizeAccessibleCourse(email, courseId))
                    || accountPro) {
                String paramSection = req.getParameter("section");
                String paramLesson = req.getParameter("lesson");
                String paramQuiz = req.getParameter("quiz");

                req.setAttribute("course", course);

                int studiedLessons = userContext.
                        getNumberOfStudiedLesson(email, courseId);
                int numberLessons = course.getSumOfLesson();
                if (numberLessons != 0) {
                    float progress = (float) studiedLessons / (float) numberLessons;
                    req.setAttribute("progress", progress);
                }

                ArrayList<Section> sectionList = course.getSectionList();

                //Lack of parameters;
                if (paramSection == null
                        || (paramLesson == null && paramQuiz == null)) {

                    int studiedLesson = userContext
                            .getLastestLesson(email, courseId);

                    // No lesson is studied;
                    if (studiedLesson == 0) {

                        Section firstSection = sectionList.get(0);
                        
                       
                        if (!firstSection.getItemList().isEmpty()) { 
                            Item firstItem = firstSection
                                .getItemList().get(0);
                            // Redirect to first lesson;
                            resp.sendRedirect("page?course=" + course.getId()
                                + "&section=" + firstSection.getId()
                                + "&" + (firstItem.getClass() == Lesson.class ? 
                                    "lesson" : "quiz") + "=" + firstItem.getId());
                            
                             // None lesson to redirect;
                        } else {
                            req.getRequestDispatcher("../view/course-page.jsp")
                            .forward(req, resp);
                        }
                        
                    } else {

                        //Get lastest studied lesson;
                        for (Section section : sectionList) {
                            for (Item item : section.getItemList()) {

                                if (item.getClass() == Lesson.class &&
                                        item.getId() == studiedLesson) {
                                    req.setAttribute("lesson", item);
                                    
                                    // Redirect to learning lesson;
                                    resp.sendRedirect("page?course=" + course.getId()
                                            + "&section=" + section.getId()
                                            + "&lesson=" + item.getId());
                                }
                            }
                        }
                    }
                } else {
                    int sectionId = Integer.parseInt(paramSection);
                    Section selectedSection = null;
                    for (Section section : sectionList) {
                        if (section.getId() == sectionId) {
                            selectedSection = section;
                        }
                    }

                    // Valid section id;
                    if (selectedSection != null) {
                        
                         ArrayList<Item> itemList = selectedSection.getItemList();
                        // Lesson is selected;
                        if (paramLesson != null) {
                            int lessonId = Integer.parseInt(paramLesson);
                           
                            for (Item item : itemList) {
                                if (item.getClass() == Lesson.class 
                                        && item.getId() == lessonId) {
                                    Lesson lesson = (Lesson) item;
                                    Video video = lesson.getVideo();
                                    if (video != null) {
                                        ArrayList<Interaction> interactionList = courseContext
                                            .getInteractionList(lessonId, video.getId());
                                        req.setAttribute("interactionList", interactionList);
                                    }
                                    
                                    req.setAttribute("lesson", lesson);
                                }
                            }

                            // Quiz is selected;
                        } else if (paramQuiz != null) {
                            int quizId = Integer.parseInt(paramQuiz);

                            for (Item item : itemList) {
                                if (item.getClass() == Quiz.class
                                        && item.getId() == quizId) {
                                    QuizContext quizContext = new QuizContext();
                                    QuizSession quizSession = quizContext.getQuizSession(email, quizId);
                                    req.setAttribute("quizSession", quizSession);
                                    req.setAttribute("quiz", item);
                                }
                            }

                        }
                    } else {
                        selectedSection = sectionList.get(0);
                        Item item = selectedSection.getItemList().get(0);
                        req.setAttribute((item.getClass() == Lesson.class ? 
                                    "lesson" : "quiz"), item);
                    }
                    req.getRequestDispatcher("../view/course-page.jsp")
                            .forward(req, resp);
                }

            } else {
                writer.print("Access denied");
            }

        } catch (SQLException ex) {
            Logger.getLogger(ViewCourse.class.getName())
                    .log(Level.SEVERE, null, ex);
        } catch (ParseException ex) {
            writer.print("Failed");
        }
    }

    @Override
    protected void doPost(User user, HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

    }

}
