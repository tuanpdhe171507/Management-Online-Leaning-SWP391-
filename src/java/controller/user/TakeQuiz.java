/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller.user;

import dao.QuizContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.Date;
import java.util.List;
import model.Answer;
import model.Question;
import model.Quiz;
import model.User;

/**
 *
 * @author :TuanPD
 */
@WebServlet("/takequiz")
public class TakeQuiz extends authentication.Authentication {

    @Override
    protected void doGet(User user, HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int quizId = Integer.parseInt(request.getParameter("id"));
        long startTimeMillis = System.currentTimeMillis();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        String startTimeString = sdf.format(new Date(startTimeMillis));

        HttpSession session = request.getSession();
        session.setAttribute("startTime", startTimeString);

        QuizContext qc = new QuizContext();
        Quiz quiz = qc.getQuiz(quizId);
        ArrayList<Question> listQuestion = qc.getQuestionByQuizID(quiz.getId());

        if (quiz.isQuestionRandomly()) {
            Collections.shuffle(listQuestion);
        }

        int numberOfQuestionsRequested = quiz.getNumberQuestion();
        if (numberOfQuestionsRequested > listQuestion.size()) {
            numberOfQuestionsRequested = listQuestion.size();
        }

        listQuestion = new ArrayList<>(listQuestion.subList(0, numberOfQuestionsRequested));
        quiz.setQuestions(listQuestion);

        for (Question question : listQuestion) {
            ArrayList<Answer> answersQues = qc.getAswerByQuestionID(question.getId());
            if (quiz.isQuestionRandomly()) {
                Collections.shuffle(answersQues);
            }
            question.setAnswers(answersQues);
        }

        request.setAttribute("quiz", quiz);
        request.getRequestDispatcher("view/student/take-quiz.jsp").forward(request, response);

    }

    @Override
    protected void doPost(User user, HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        QuizContext e = new QuizContext();

        HttpSession session = req.getSession();
        String startTime = (String) session.getAttribute("startTime");

        String quizId = req.getParameter("quizId");
        if (quizId != null && !quizId.isEmpty()) {
            String email = user.getEmail();
            int quizSectionID = e.insertOrUpdateQuizSession(quizId, email, startTime);

            List<String> questionIds = Arrays.asList(req.getParameterValues("questionId"));
            List<String> answerIds = new ArrayList<>();
            for (int i = 0; i < questionIds.size(); i++) {
                String answerIdParam = req.getParameter("answer" + i);
                answerIds.add(answerIdParam);
            }

            e.resetAndInsertQuizResult(quizSectionID, questionIds, answerIds);
        }
        String course = req.getParameter("course");
        String section = req.getParameter("section");

        resp.sendRedirect(req.getContextPath() + "/quiz/review?course=" + course+"&section="+section+"&id="+quizId);
    }
}
