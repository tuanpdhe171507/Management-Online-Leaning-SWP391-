/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller;

import dao.CourseContext;
import dao.SliderContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Course;
import model.Slider;

/**
 *
 * @author HaiNV
 */
@WebServlet("/home")
public class Home extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            SliderContext sliderContext = new SliderContext();
            CourseContext courseContext = new CourseContext();

            /* Get slider list*/
            ArrayList<Slider> sliderList = sliderContext.getSliderList();
            req.setAttribute("sliderList", sliderList);
            
            /* Get course list */
            ArrayList<Course> courseList = courseContext.getCourseList();
            req.setAttribute("courseList", courseList);
             

            req.getRequestDispatcher("view/home.jsp").forward(req, resp);
        } catch (SQLException | ParseException ex) {
            Logger.getLogger(Home.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

}
