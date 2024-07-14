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
import java.util.ArrayList;
import java.util.Collections;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Answer;
import model.Interaction;
import model.Lesson;
import model.Video;

/**
 *
 * @author HieuTC
 */
@WebServlet("/course/add-interaction")
public class AddInteractions extends authentication.authorization.Authorization {

    @Override
    protected void forwardGetRequest(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            int lessonId = Integer
                    .parseInt(req.getParameter("lesson"));
            String sort = req.getParameter("sort");

            CourseContext courseContext = new CourseContext();
            Lesson lesson = courseContext.getLesson(lessonId);

            if (lesson.getVideo().getType().startsWith("video/")) {
                req.setAttribute("lesson", lesson);
                Video video = lesson.getVideo();
                if (video != null) {
                    ArrayList<Interaction> interactionList = courseContext.
                            getInteractionList(lessonId, video.getId());

                    if (sort != null) {
                        Collections.sort(interactionList, (Interaction o1, Interaction o2) -> {
                            switch (sort) {
                                case "oldest" -> {
                                    return o2.getAddedTime()
                                            .before(o1.getAddedTime()) ? -1 : 0;

                                }
                                case "up" -> {
                                    return o1.getAtTime() - o2.getAtTime() < 0 ? -1 : 0;
                                }
                                case "down" -> {
                                    return o2.getAtTime() - o1.getAtTime() < 0 ? -1 : 0;
                                }
                                default -> {
                                    return o1.getAddedTime()
                                            .before(o2.getAddedTime()) ? -1 : 0;
                                }
                            }
                        });
                    }

                    req.setAttribute("interactionList", interactionList);
                }

                req.getRequestDispatcher("../view/instructor/interaction.jsp")
                        .forward(req, resp);
            } else {
                PrintWriter writer = resp.getWriter();
                writer.print("We can not support base interaction for this video");
            }

        } catch (SQLException | java.text.ParseException ex) {
            Logger.getLogger(AddInteractions.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    @Override
    protected void forwardPostRequest(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int lessonId = Integer
                .parseInt(req.getParameter("lesson"));
        int videoId = Integer
                .parseInt(req.getParameter("video"));
        String question = req.getParameter("question");
        String[] paramAnswers = req.getParameterValues("answer");
        String paramCorrect = req.getParameter("correct");
        float atTime = Float.parseFloat(req.getParameter("time"));
        String position = req.getParameter("position");
        String size = req.getParameter("size");

        InstructorContext instructorContext = new InstructorContext();

        if (paramCorrect != null) {
            try {
                int correct = Integer.parseInt(paramCorrect);
                ArrayList<Answer> answerList = new ArrayList<>();
                for (int i = 0; i < paramAnswers.length; i++) {
                    Answer answer = new Answer();
                    answer.setContent(paramAnswers[i]);
                    if (i == correct) {
                        answer.setCorrectless(true);
                    }
                    answerList.add(answer);
                }

                int questionId = instructorContext
                        .addQuestion(question, answerList);
                instructorContext.addInteraction(lessonId, videoId, questionId,
                        atTime, position, size);

            } catch (SQLException ex) {
                Logger.getLogger(AddInteractions.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        resp.sendRedirect("add-interaction?lesson=" + lessonId);
    }

}
