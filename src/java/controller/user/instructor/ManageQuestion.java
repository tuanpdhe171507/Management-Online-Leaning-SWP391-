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
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.HashMap;
import com.google.gson.Gson;
import java.util.ArrayList;
import java.util.Map;
import model.Answer;
import model.Question;

/**
 *
 * @author Trongnd
 */
@WebServlet(name = "ManageQuestion", urlPatterns = {"/quiz/question"})
public class ManageQuestion extends authentication.authorization.Authorization {


    @Override
    protected void forwardGetRequest(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        QuizContext qc = new QuizContext();
        // add new question
        String add = req.getParameter("action");
        if (add.equals("add")) {
            int qu = Integer.parseInt(req.getParameter("quizId"));
            qc.insertQuestionByQuizId(qu);
            int newQuestionId = qc.getQuestionIdNewInsert(qu);
            for (int i = 0; i < 2; i++) {
                qc.insertAnswerByQuestionId(newQuestionId);
            }
            ArrayList<Answer> answers = qc.getAswerByQuestionID(newQuestionId);

            Gson gson = new Gson();
            String jsonAnswers = gson.toJson(answers);
            String jsonResponse = "{\"newQuestionId\":" + newQuestionId + ", \"answers\":" + jsonAnswers + "}";

            resp.setContentType("application/json");
            resp.getWriter().write(jsonResponse);
        }
        // delete question
        String delete = req.getParameter("action") == null ? "" : req.getParameter("action");
        int questionId = -1;
        try {
            questionId = Integer.parseInt(req.getParameter("id"));
        } catch (NumberFormatException e) {
        }
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");

        if (delete.equals("delete")) {
            boolean isDeleted = false;
            try {
                qc.deleteQuizRecordByQuestionId(questionId);
                qc.deleteAnswerByQuestionId(questionId);
                qc.deleteQuestionSelected(questionId);
                qc.deleteQuesionById(questionId);
                isDeleted = true;
            } catch (Exception e) {
                // Handle exception if needed
            }

            // Prepare JSON resp
            Map<String, Object> respMap = new HashMap<>();
            respMap.put("success", isDeleted);

            String jsonResponse = new Gson().toJson(respMap);
            resp.getWriter().write(jsonResponse);
        }
        // delete answer
        String deleteAnswer = req.getParameter("action") == null ? "" : req.getParameter("action");
        if (deleteAnswer.equals("delete-answer")) {
            boolean isDeleted = false;
            try {
                qc.deleteAnswerById(Integer.parseInt(req.getParameter("answerId")));
                qc.deleteAnswerSelected(Integer.parseInt(req.getParameter("answerId")));
                isDeleted = true;
            } catch (NumberFormatException e) {

            }
            Map<String, Object> respMap = new HashMap<>();
            respMap.put("success", isDeleted);

            String jsonResponse = new Gson().toJson(respMap);
            resp.getWriter().write(jsonResponse);
            resp.setContentType("application/json");
        }

        // edit/ update question
        String edit = req.getParameter("action") == null ? "" : req.getParameter("action");
        if (edit.equals("edit")) {
            try {
                Question q = qc.getQuesionById(questionId);
                ArrayList<Answer> answers = qc.getAswerByQuestionID(questionId);
                Gson gson = new Gson();
                String jsonQuestion = gson.toJson(q);
                String jsonAnswers = gson.toJson(answers);
                String jsonResponse = "{\"question\":" + jsonQuestion + ", \"answers\":" + jsonAnswers + "}";
                resp.setContentType("application/json");
                resp.getWriter().write(jsonResponse);
            } catch (IOException e) {
            }
        }
        // New answer
        String newAnswer = req.getParameter("action") == null ? "" : req.getParameter("action");
        if (newAnswer.equals("new-answer")) {
            try {
                qc.insertAnswerByQuestionId(questionId);
                int newAnserInserted = qc.getAnswerIdNewInsertedByQId(questionId);
                Gson gson = new Gson();
                String jsonResponse = "{\"answerId\":" + newAnserInserted + "}";
                resp.setContentType("application/json");
                resp.getWriter().write(jsonResponse);
            } catch (Exception e) {

            }
        }
    }

    @Override
    protected void forwardPostRequest(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int questionId = Integer.parseInt(req.getParameter("questionId"));
        String questionContent = req.getParameter("question");

        String[] answers = req.getParameterValues("answer-question");
        String radioAnswer = req.getParameter("radio-question");

        QuizContext qc = new QuizContext();
        qc.updateQuestionById(questionId, questionContent);

        ArrayList<Answer> listAnswer = qc.getAswerByQuestionID(questionId);

        for (int i = 0; i < listAnswer.size(); i++) {
            if (String.valueOf(i).equals(radioAnswer)) {
                qc.updateAnswerById(listAnswer.get(i).getId(), answers[i], 1);
            } else {
                qc.updateAnswerById(listAnswer.get(i).getId(), answers[i], 0);

            }
        }
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        try {
            Question questionUpdated = qc.getQuesionById(questionId);
            ArrayList<Answer> listAnswerUpdate = qc.getAswerByQuestionID(questionId);
            Gson gson = new Gson();
            String jsonQuestion = gson.toJson(questionUpdated);
            String jsonAnswers = gson.toJson(listAnswerUpdate);
            String jsonResponse = "{\"question\":" + jsonQuestion + ", \"answers\":" + jsonAnswers + "}";
            resp.setContentType("application/json");
            resp.getWriter().write(jsonResponse);
        } catch (IOException e) {
        }
    }

}
