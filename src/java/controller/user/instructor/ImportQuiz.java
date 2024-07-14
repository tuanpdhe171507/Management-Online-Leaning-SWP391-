package controller.user.instructor;

import dao.QuizContext;
import java.io.IOException;
import java.util.ArrayList;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.InputStream;
import java.sql.SQLException;
import model.Answer;
import model.Question;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.usermodel.WorkbookFactory;

@WebServlet("/course/import-quiz")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 1, // 1 MB
        maxFileSize = 1024 * 1024 * 10, // 10 MB
        maxRequestSize = 1024 * 1024 * 15 // 15 MB
)
public class ImportQuiz extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String quizId = req.getParameter("quizId");
        req.setAttribute("quizId", quizId);
        req.getRequestDispatcher("../view/instructor/import-quiz.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int flag = 2;
        String add = req.getParameter("add");
        String quizId = req.getParameter("quizId");
        ArrayList<Question> questions = new ArrayList<>();
        for (Part part : req.getParts()) {
            if (part.getName().equals("file")) {
                InputStream in = part.getInputStream();
                questions = this.readExcelFile(in);
            }
        }
        req.setAttribute("questions", questions);
        QuizContext db = new QuizContext();
        String[] questionContents = req.getParameterValues("questionContent");
        if (questionContents == null) {
            req.setAttribute("quizId", quizId);
            req.getRequestDispatcher("../view/instructor/import-quiz.jsp").forward(req, resp);
            return;
        }
        String[][] answerContents = new String[questionContents.length][];
        String[][] correctLessValues = new String[questionContents.length][];

        for (int i = 0; i < questionContents.length; i++) {
            answerContents[i] = req.getParameterValues("answerContent" + i);
            correctLessValues[i] = req.getParameterValues("correctLess" + i);
        }

        if (add != null) {
            int theNumberQuizId = Integer.parseInt(quizId);
            try {
                for (int i = 0; i < questionContents.length; i++) {
                    String questionContent = questionContents[i];

                    db.addQuestion(theNumberQuizId, questionContent);
                    int questionID = db.getQuestionId(questionContent);

                    String[] answersForCurrentQuestion = answerContents[i];
                    String[] correctLessValuesForCurrentAnswer = correctLessValues[i];

                    if (answersForCurrentQuestion != null) {
                        for (int j = 0; j < answersForCurrentQuestion.length; j++) {
                            String answerContent = answersForCurrentQuestion[j];
                            boolean correctLess = Boolean.parseBoolean(correctLessValuesForCurrentAnswer[j]);
                            if (db.addAnswer(questionID, answerContent, correctLess)) {
                                flag = 1;
                            }
                        }
                    }

                }
            } catch (SQLException e) {
                throw new ServletException(e);
            }

        }
        req.setAttribute("alert", flag);
        req.setAttribute("quizId", quizId);
        req.getRequestDispatcher("../view/instructor/import-quiz.jsp").forward(req, resp);
    }

    private ArrayList<Question> readExcelFile(InputStream in) {
        ArrayList<Question> questions = new ArrayList<>();
        try (Workbook workbook = WorkbookFactory.create(in)) {
            Sheet sheet = workbook.getSheetAt(0);
            for (Row row : sheet) {
                if (row.getRowNum() == 0) {
                    continue; // Skip the header row
                }
                Question question = new Question();
                question.setContent(row.getCell(0).getStringCellValue());
                ArrayList<Answer> answers = new ArrayList<>();
                for (int i = 2; i < row.getLastCellNum(); i++) {
                    Cell answerCell = row.getCell(i);
                    // when answer is null, the loop will stop
                    if (answerCell == null || answerCell.toString().trim().isEmpty()) {
                        break;
                    }
                    Answer answer = new Answer();
                    answer.setContent(answerCell.getStringCellValue());
                    answer.setCorrectless(answer.getContent().equalsIgnoreCase(row.getCell(1).getStringCellValue()));
                    answers.add(answer);
                }
                question.setAnswers(answers);
                questions.add(question);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return questions;
    }

}
