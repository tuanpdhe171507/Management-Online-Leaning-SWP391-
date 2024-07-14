/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;

/**
 *
 * @author Trongnd
 */
public class QuizSession {
    private int quizSession;
    private int quizId;
    private String email;
    private Timestamp takedTime, doneTime;
    private final SimpleDateFormat day =  new SimpleDateFormat("MMM dd, hh:mm");

    public QuizSession() {
    }

    public int getQuizSession() {
        return quizSession;
    }

    public void setQuizSession(int quizSession) {
        this.quizSession = quizSession;
    }

    public int getQuizId() {
        return quizId;
    }

    public void setQuizId(int quizId) {
        this.quizId = quizId;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public Timestamp getTakedTime() {
        return takedTime;
    }

    public void setTakedTime(Timestamp takedTime) {
        this.takedTime = takedTime;
    }

    public Timestamp getDoneTime() {
        return doneTime;
    }

    public void setDoneTime(Timestamp doneTime) {
        this.doneTime = doneTime;
    }
    
    public String getDoneTimeDate() {
        return day.format(this.getDoneTime());
    }
}
