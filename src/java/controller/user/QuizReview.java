/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.user;

import dao.QuizContext;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import model.Answer;
import model.Question;
import model.Quiz;
import model.QuizSession;
import model.User;

/**
 *
 * @author Trongnd
 */
@WebServlet(name = "QuizReview", urlPatterns = {"/quiz/review"})
public class QuizReview extends authentication.Authentication { 
    @Override
    protected void doGet(User user, HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int quizId = Integer.parseInt(req.getParameter("id"));
        
        QuizContext qc = new QuizContext();
        Quiz quiz = qc.getQuiz(quizId);

        QuizSession qs = qc.getQuizSession(user.getEmail(), quiz.getId());
        ArrayList<Question> listQuestion = qc.getQuizRecord(qs.getQuizSession());
        quiz.setQuestions(listQuestion);

        req.setAttribute("quiz", quiz);
        req.setAttribute("quizSession", qs);
        LinkedHashMap<Question, Integer> result = new LinkedHashMap<>();
        int count = 0;
        for (Question q : listQuestion) {
            int selectedAnswer = qc.getSelectedAnswer(qs.getQuizSession(), q.getId());
            result.put(q, selectedAnswer);
            if (checkAnswerQuestion(selectedAnswer, q.getAnswers())) {
                count++;
            }
        }

        double mark = (1.0 * count / quiz.getNumberQuestion()) * 100;
        req.setAttribute("mark", mark);
        req.setAttribute("result", result);
        req.getRequestDispatcher("../view/student/review-quiz.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(User user, HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    public boolean checkAnswerQuestion(int selectedAnswer, ArrayList<Answer> answerList) {
        for (Answer answer : answerList) {
            // get status of selected answer by user
            if (selectedAnswer == answer.getId()) {
                return answer.isCorrectless();
            }
        }
        return false;
    }
}
