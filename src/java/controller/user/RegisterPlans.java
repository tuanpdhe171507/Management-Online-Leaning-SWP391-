/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.user;

import dao.PlansContext;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.Timestamp;
import java.util.ArrayList;
import model.Plan;
import model.User;

/**
 *
 * @author Trongnd
 */
@WebServlet(name = "RegisterPlans", urlPatterns = {"/plans"})
public class RegisterPlans extends authentication.Authentication {

    @Override
    protected void doGet(User user, HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        PlansContext pc = new PlansContext();
        String check = req.getParameter("action") == null ? "" : req.getParameter("action");
        if (check.equals("check")) {
            boolean accountPro = false;
            Timestamp planExpiredTime = new PlansContext().getPlanExpiredTime(user.getEmail());
            if (planExpiredTime != null) {
                Timestamp currentTime = new Timestamp(System.currentTimeMillis());
                if (planExpiredTime.after(currentTime)) {
                    accountPro = true;
                }
            }
            String jsonResponse = "{\"accountPro\":" + accountPro + "}";
            resp.setContentType("application/json");
            resp.setCharacterEncoding("UTF-8");
            resp.getWriter().write(jsonResponse);
        } else {
            ArrayList<Plan> plans = pc.getPlans();
            req.setAttribute("plans", plans);
            req.setAttribute("planRegisted", pc.getPlanCurrentRegisted(user.getEmail()));
            req.getRequestDispatcher("/view/plans.jsp").forward(req, resp);
        }

    }

    @Override
    protected void doPost(User user, HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String plan = req.getParameter("plan");
        PlansContext pc = new PlansContext();
        ArrayList<Plan> plans = pc.getPlans();
        if (plan == "month") {
            pc.insertUserPlan(user.getEmail(), plan, 1);
        }
        if (plan == "quater") {
            pc.insertUserPlan(user.getEmail(), plan, 3);
        }

        resp.sendRedirect(req.getContextPath() + "/plans");
    }

}
