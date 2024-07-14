/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.user.instructor;

import dao.QuizContext;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import model.Answer;
import model.Question;
import model.Quiz;
import java.sql.Time;

/**
 *
 * @author Trongnd
 */
@WebServlet(name = "ManageQuiz", urlPatterns = {"/quiz/manage"})
public class ManageQuiz extends authentication.authorization.Authorization {
    @Override
    protected void forwardGetRequest(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int quizId = Integer.parseInt(req.getParameter("id"));
        QuizContext qc = new QuizContext();
        Quiz quiz = qc.getQuiz(quizId);

        ArrayList<Question> listQuestion = qc.getQuestionByQuizID(quiz.getId());

        for (Question question : listQuestion) {
            ArrayList<Answer> answersQues = qc.getAswerByQuestionID(question.getId());
            question.setAnswers(answersQues);
        }
        quiz.setQuestions(listQuestion);
        req.setAttribute("quiz", quiz);
        String time[] = (qc.getQuiz(quizId).getDuration() + "").split("\\:");
        req.setAttribute("time", time);
        
        req.getRequestDispatcher("../view/instructor/manage-quiz.jsp").forward(req, resp);    }

    @Override
    protected void forwardPostRequest(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
String title = req.getParameter("title")==""?"Quiz":req.getParameter("title");
        String random = req.getParameter("random");
        String passedTarget_raw = req.getParameter("passedTarget")==""?"0":req.getParameter("passedTarget");
        String numOfQues_raw = req.getParameter("numberOfQuestion");

        String hours = req.getParameter("hours")==""?"0":req.getParameter("hours");
        String minutes = req.getParameter("minutes")==""?"0":req.getParameter("minutes");;
        String seconds = req.getParameter("seconds")==""?"0":req.getParameter("seconds");;
        String timeString = String.format(hours+":"+minutes+":"+seconds);
        Time time = Time.valueOf(timeString);
        Time zero = Time.valueOf("00:00:00");
        
        int quizId = Integer.parseInt(req.getParameter("id"));
        Quiz quiz = new Quiz();
        quiz.setTitle(title);
        quiz.setQuestionRandomly(Boolean.parseBoolean(random));
        quiz.setNumberQuestion(Integer.parseInt(numOfQues_raw));
        quiz.setPassedTarget(Float.parseFloat(passedTarget_raw));
        
        quiz.setId(quizId);
        
        if(time.after(zero)){
            quiz.setDuration(time);
        }        
        QuizContext qc = new QuizContext();
        qc.updateQuizById(quiz);
        // Update question
 
        resp.sendRedirect(req.getContextPath()+"/quiz/manage?id="+quizId);    }

}
