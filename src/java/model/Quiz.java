/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;
import java.util.ArrayList;
import java.sql.Time;

/**
 *
 * @author Trongnd
 */
public class Quiz extends Item {
    private String title;
    private String description;
    private Time duration;
    private float passedTarget;    
    private ArrayList<Question> questions;
    private int numberQuestion;
    private boolean questionRandomly;

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Time getDuration() {
        return duration;
    }

    public void setDuration(Time duration) {
        this.duration = duration;
    }

    public float getPassedTarget() {
        return passedTarget;
    }

    public void setPassedTarget(float passedTarget) {
        this.passedTarget = passedTarget;
    }

    public ArrayList<Question> getQuestions() {
        return questions;
    }

    public void setQuestions(ArrayList<Question> questions) {
        this.questions = questions;
    }

    public int getNumberQuestion() {
        return numberQuestion;
    }

    public void setNumberQuestion(int numberQuestion) {
        this.numberQuestion = numberQuestion;
    }

    public boolean isQuestionRandomly() {
        return questionRandomly;
    }

    public void setQuestionRandomly(boolean questionRandomly) {
        this.questionRandomly = questionRandomly;
    }

    
      
}
