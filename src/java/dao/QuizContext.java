/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Answer;
import model.Question;
import model.Quiz;
import model.QuizSession;

/**
 *
 * @author Trongnd
 */
public class QuizContext extends ConnectionOpen {

    public Quiz getQuiz(int id) {
        try {
            String sql = "select quizId, quizTitle,passedTarget,numberQuestion, questionRandomly, duration\n"
                    + "from Quiz\n"
                    + "where quizId = ?;";
            PreparedStatement stm = connection.prepareStatement(sql);
            stm.setInt(1, id);
            ResultSet rs = stm.executeQuery();
            while (rs.next()) {
                Quiz qu = new Quiz();
                qu.setId(rs.getInt("quizId"));
                qu.setTitle(rs.getString("quizTitle"));
                qu.setPassedTarget(rs.getInt("passedTarget"));
                qu.setNumberQuestion(rs.getInt("numberQuestion"));
                qu.setQuestionRandomly(rs.getBoolean("questionRandomly"));
                qu.setDuration(rs.getTime("duration"));
                return qu;
            }
        } catch (SQLException ex) {
            Logger.getLogger(QuizContext.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }

    public ArrayList<Question> getQuestionByQuizID(int id) {
        ArrayList<Question> list = new ArrayList<>();
        try {
            String sql = "select qu.quizId,q.questionID,q.questionContent \n"
                    + "                     from Questions q  \n"
                    + "                     inner join Quiz qu on q.quizId = qu.quizId\n"
                    + "                     where qu.quizId=?";
            PreparedStatement stm = connection.prepareStatement(sql);
            stm.setInt(1, id);
            ResultSet rs = stm.executeQuery();
            while (rs.next()) {
                Question q = new Question();
                q.setId(rs.getInt("questionID"));
                q.setContent(rs.getString("questionContent"));
                list.add(q);
            }
        } catch (SQLException ex) {
            Logger.getLogger(QuizContext.class.getName()).log(Level.SEVERE, null, ex);
        }
        return list;
    }

    public ArrayList<Answer> getAswerByQuestionID(int id) {
        ArrayList<Answer> list = new ArrayList<>();
        try {
            String sql = "select a.answerID, a.answerContent,a.correctless\n"
                    + "from Questions q inner join Answers a on q.questionID = a.questionID\n"
                    + "where q.questionID=?";
            PreparedStatement stm = connection.prepareStatement(sql);
            stm.setInt(1, id);
            ResultSet rs = stm.executeQuery();
            while (rs.next()) {
                Answer a = new Answer();
                a.setId(rs.getInt("answerID"));
                a.setContent(rs.getString("answerContent"));
                a.setCorrectless(rs.getBoolean("correctless"));
                list.add(a);
            }
        } catch (SQLException ex) {
            Logger.getLogger(QuizContext.class.getName()).log(Level.SEVERE, null, ex);
        }
        return list;
    }

    //TuanPD
    public int insertOrUpdateQuizSession(String quizId, String email, String taketime) {
        int quizSessionId = -1;
        ResultSet rs = null;
        try {
            String checkQuizSql = "SELECT quizSession FROM QuizSession WHERE emailAddress = ? AND quizId = ?";
            PreparedStatement checkQuizStm = connection.prepareStatement(checkQuizSql);
            checkQuizStm.setString(1, email);
            checkQuizStm.setString(2, quizId);
            ResultSet quizResult = checkQuizStm.executeQuery();

            if (quizResult.next()) {
                quizSessionId = quizResult.getInt("quizSession");
                String updateSql = "UPDATE QuizSession SET takedTime = ?, doneTime = GETDATE() WHERE quizSession = ?";
                PreparedStatement updateStm = connection.prepareStatement(updateSql);
                updateStm.setString(1, taketime);
                updateStm.setInt(2, quizSessionId);
                updateStm.executeUpdate();
            } else {
                String insertSql = "INSERT INTO QuizSession (quizId, emailAddress, takedTime, doneTime) VALUES (?, ?, ?, GETDATE())";
                PreparedStatement insertStm = connection.prepareStatement(insertSql, PreparedStatement.RETURN_GENERATED_KEYS);
                insertStm.setString(1, quizId);
                insertStm.setString(2, email);
                insertStm.setString(3, taketime);
                insertStm.executeUpdate();

                rs = insertStm.getGeneratedKeys();
                if (rs.next()) {
                    quizSessionId = rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            Logger.getLogger(QuizContext.class.getName()).log(Level.SEVERE, null, e);
        } finally {
            try {
                if (rs != null) {
                    rs.close();
                }
            } catch (SQLException ex) {
                Logger.getLogger(QuizContext.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        return quizSessionId;
    }

    public void resetAndInsertQuizResult(int quizSessionId, List<String> questionIds, List<String> answerIds) {
        try {
            String deleteSql = "DELETE FROM QuizRecord WHERE quizSession = ?";
            PreparedStatement deleteStm = connection.prepareStatement(deleteSql);
            deleteStm.setInt(1, quizSessionId);
            deleteStm.executeUpdate();

            String insertSql = "INSERT INTO QuizRecord (quizSession, questionId, selectedAnswer) VALUES (?, ?, ?)";
            PreparedStatement insertStm = connection.prepareStatement(insertSql);

            for (int i = 0; i < questionIds.size(); i++) {
                String questionId = questionIds.get(i);
                String answerId = (i < answerIds.size()) ? answerIds.get(i) : null;

                insertStm.setInt(1, quizSessionId);
                insertStm.setString(2, questionId);
                insertStm.setString(3, answerId);
                insertStm.addBatch();
            }

            insertStm.executeBatch();
        } catch (SQLException e) {
            Logger.getLogger(QuizContext.class.getName()).log(Level.SEVERE, null, e);
        }
    }

    // Result quiz
    public QuizSession getQuizSession(String email, int quizId) {
        try {
            String sql = "select qs.quizSession, qs.takedTime, qs.doneTime\n"
                    + "from QuizSession qs\n"
                    + "where qs.emailAddress like ? and qs.quizId = ?\n"
                    + "and qs.takedTime = (select MAX(takedTime) from QuizSession);";
            PreparedStatement stm = connection.prepareStatement(sql);
            stm.setString(1, email);
            stm.setInt(2, quizId);
            ResultSet rs = stm.executeQuery();
            while (rs.next()) {
                QuizSession qs = new QuizSession();
                qs.setQuizSession(rs.getInt("quizSession"));
                qs.setTakedTime(rs.getTimestamp("takedTime"));
                qs.setDoneTime(rs.getTimestamp("doneTime"));
                return qs;
            }
        } catch (SQLException ex) {
            Logger.getLogger(QuizContext.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }

    public ArrayList<Question> getQuizRecord(int quizSession) {
        ArrayList<Question> list = new ArrayList<>();
        try {
            String sql = "select q.questionID,q.questionContent\n"
                    + "from QuizRecord qr inner join Questions q on qr.questionId = q.questionID\n"
                    + "where qr.quizSession = ?";
            PreparedStatement stm = connection.prepareStatement(sql);
            stm.setInt(1, quizSession);
            ResultSet rs = stm.executeQuery();
            while (rs.next()) {
                Question q = new Question();
                q.setId(rs.getInt("questionID"));
                q.setContent(rs.getString("questionContent"));
                q.setAnswers(new QuizContext().getAswerByQuestionID(q.getId()));

                list.add(q);
            }
        } catch (SQLException ex) {
            Logger.getLogger(QuizContext.class.getName()).log(Level.SEVERE, null, ex);
        }
        return list;
    }

    public int getSelectedAnswer(int quizSession, int questionId) {
        try {
            String sql = "select questionId, selectedAnswer\n"
                    + "from QuizRecord\n"
                    + "Where quizSession = ? and questionId = ? ";
            PreparedStatement stm = connection.prepareStatement(sql);
            stm.setInt(1, quizSession);
            stm.setInt(2, questionId);
            ResultSet rs = stm.executeQuery();
            if (rs.next()) {
                return (rs.getInt("selectedAnswer"));
            }
        } catch (SQLException ex) {
            Logger.getLogger(QuizContext.class.getName()).log(Level.SEVERE, null, ex);
        }
        return 0;
    }
// update quiz

    public void updateQuizById(Quiz quiz) {
        try {
            String sql = "UPDATE [dbo].[Quiz]\n"
                    + "   SET [quizTitle] = ?\n"
                    + "      ,[passedTarget] = ?\n"
                    + "      ,[numberQuestion] = ?\n"
                    + "      ,[questionRandomly] = ?\n"
                    + "      ,[duration] = ?\n"
                    + " WHERE [quizId] = ?;";
            PreparedStatement stm = connection.prepareStatement(sql);
            stm.setString(1, quiz.getTitle());
            stm.setFloat(2, quiz.getPassedTarget());
            stm.setInt(3, quiz.getNumberQuestion());
            if (quiz.isQuestionRandomly()) {
                stm.setInt(4, 1);
            } else {
                stm.setInt(4, 0);
            }
            stm.setTime(5, quiz.getDuration());
            stm.setInt(6, quiz.getId());
            stm.executeUpdate();
        } catch (SQLException ex) {
            Logger.getLogger(QuizContext.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    public void insertQuestionByQuizId(int id) {
        try {
            String sql = "INSERT INTO [dbo].[Questions]\n"
                    + "           ([quizId])\n"
                    + "     VALUES\n"
                    + "           (?);";
            PreparedStatement stm = connection.prepareStatement(sql);
            stm.setInt(1, id);
            stm.execute();

        } catch (SQLException ex) {
            Logger.getLogger(QuizContext.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    public void deleteQuesionById(int id) {
        try {
            String sql = "delete Questions where questionID =?";
            PreparedStatement stm = connection.prepareStatement(sql);
            stm.setInt(1, id);
            stm.execute();
        } catch (SQLException ex) {
            Logger.getLogger(QuizContext.class.getName()).log(Level.SEVERE, null, ex);
        }

    }

    public void deleteAnswerByQuestionId(int id) {
        try {
            String sql = "delete Answers where questionID =?;";
            PreparedStatement stm = connection.prepareStatement(sql);
            stm.setInt(1, id);
            stm.execute();
        } catch (SQLException ex) {
            Logger.getLogger(QuizContext.class.getName()).log(Level.SEVERE, null, ex);
        }

    }

    public void deleteQuizRecordByQuestionId(int id) {
        try {
            String sql = "delete QuizRecord where questionID =?;";
            PreparedStatement stm = connection.prepareStatement(sql);
            stm.setInt(1, id);
            stm.execute();
        } catch (SQLException ex) {
            Logger.getLogger(QuizContext.class.getName()).log(Level.SEVERE, null, ex);
        }

    }

    public void updateQuestionById(int id, String content) {
        try {
            String sql = "UPDATE [dbo].[Questions]\n"
                    + "   SET [questionContent] = ?\n"
                    + " WHERE questionID =?";
            PreparedStatement stm = connection.prepareStatement(sql);

            stm.setString(1, content);
            stm.setInt(2, id);
            stm.executeUpdate();
        } catch (SQLException ex) {
            Logger.getLogger(QuizContext.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    public void updateAnswerById(int id, String content, int i) {
        try {
            String sql = "UPDATE [dbo].[Answers]\n"
                    + "   SET [answerContent] = ?\n"
                    + "      ,[correctless] = ?\n"
                    + " WHERE [answerId] = ?";
            PreparedStatement stm = connection.prepareStatement(sql);
            stm.setInt(3, id);
            stm.setString(1, content);
            stm.setInt(2, i);
            stm.executeUpdate();
        } catch (SQLException ex) {
            Logger.getLogger(QuizContext.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    public int getQuestionIdNewInsert(int id) {
        try {
            String sql = "SELECT TOP(1) questionID \n"
                    + "FROM Questions\n"
                    + "WHERE quizId = ?\n"
                    + "ORDER BY questionID DESC;";
            PreparedStatement stm = connection.prepareStatement(sql);
            stm.setInt(1, id);
            ResultSet rs = stm.executeQuery();
            if (rs.next()) {
                return rs.getInt("questionID");
            }
        } catch (SQLException ex) {
            Logger.getLogger(QuizContext.class.getName()).log(Level.SEVERE, null, ex);
        }
        return -1;
    }

    public void insertAnswerByQuestionId(int id) {
        try {
            String sql = "INSERT INTO [dbo].[Answers]\n"
                    + "           ([questionID])\n"
                    + "     VALUES\n"
                    + "           (?);";
            PreparedStatement stm = connection.prepareStatement(sql);
            stm.setInt(1, id);
            stm.execute();
        } catch (SQLException ex) {
            Logger.getLogger(QuizContext.class.getName()).log(Level.SEVERE, null, ex);
        }

    }

    public int getAnswerIdNewInsertedByQId(int id) {
        try {
            String sql = "SELECT TOP(1) [answerID]\n"
                    + "  FROM [dbo].[Answers]\n"
                    + "  WHERE questionID = ?\n"
                    + "  ORDER BY answerID desc;";
            PreparedStatement stm = connection.prepareStatement(sql);
            stm.setInt(1, id);
            ResultSet rs = stm.executeQuery();
            if (rs.next()) {
                return rs.getInt("answerID");
            }
        } catch (SQLException ex) {
            Logger.getLogger(QuizContext.class.getName()).log(Level.SEVERE, null, ex);
        }
        return -1;
    }

    public void deleteAnswerById(int id) {
        try {
            String sql = "DELETE FROM [dbo].[Answers]\n"
                    + "      WHERE answerID=?";
            PreparedStatement stm = connection.prepareStatement(sql);
            stm.setInt(1, id);
            stm.execute();
        } catch (SQLException ex) {
            Logger.getLogger(QuizContext.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    public void deleteAnswerSelected(int id) {
        try {
            String sql = "DELETE FROM [dbo].[QuizRecord]\n"
                    + "      WHERE selectedAnswer = ?";
            PreparedStatement stm = connection.prepareStatement(sql);
            stm.setInt(1, id);
            stm.execute();
        } catch (SQLException ex) {
            Logger.getLogger(QuizContext.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    public void deleteQuestionSelected(int id) {
        try {
            String sql = "DELETE FROM [dbo].[QuizRecord]\n" +
"      WHERE questionId = ?";
            PreparedStatement stm = connection.prepareStatement(sql);
            stm.setInt(1, id);
            stm.execute();
        } catch (SQLException ex) {
            Logger.getLogger(QuizContext.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    public Question getQuesionById(int id) {
        try {
            String sql = "SELECT [quizId]\n"
                    + "      ,[questionContent]\n"
                    + "  FROM [dbo].[Questions]\n"
                    + "  WHERE questionID =?;";
            PreparedStatement stm = connection.prepareStatement(sql);
            stm.setInt(1, id);
            ResultSet rs = stm.executeQuery();
            if (rs.next()) {
                Question q = new Question();
                q.setContent(rs.getString("questionContent"));
                q.setId(id);
                return q;
            }
        } catch (SQLException ex) {
            Logger.getLogger(QuizContext.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }


    /*
    *HuyLQ
    *Add question to quiz
     */
    public void addQuestion(int quizID, String questionContent) {
        String sql = "INSERT INTO [dbo].[Questions]\n"
                + "           ([quizId]\n"
                + "           ,[questionContent])\n"
                + "     VALUES\n"
                + "           (?,?)\n";

        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, quizID);
            stm.setString(2, questionContent);
            stm.executeUpdate();
        } catch (SQLException ex) {
            Logger.getLogger(QuizContext.class.getName()).log(Level.SEVERE, null, ex);
        }
    }


    /*
    *HuyLQ
    *Add answer to question
     */
    public boolean addAnswer(int questionID, String answerContent, boolean correctless) throws SQLException {
        String sql = "INSERT INTO [dbo].[Answers]\n"
                + "           ([questionID]\n"
                + "           ,[answerContent]\n"
                + "           ,[correctless])\n"
                + "     VALUES\n"
                + "           (?,?,?)\n";

        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, questionID);
            stm.setString(2, answerContent);
            stm.setBoolean(3, correctless);
            stm.executeUpdate();
        }
        return true;
    }

    /*
    *HuyLQ
    *Add answer to question
     */
    public int getQuestionId(String questionContent) throws SQLException {
        int questionID = 0;
        String sql = "select questionID from Questions\n"
                + "where  questionContent like  ?";
        PreparedStatement stm = connection.prepareStatement(sql);
        stm.setString(1, questionContent);
        ResultSet rs = stm.executeQuery();
        while (rs.next()) {
            Question q = new Question();
            q.setId(rs.getInt("questionID"));
            questionID = q.getId();
        }
        return questionID;
    }

}
