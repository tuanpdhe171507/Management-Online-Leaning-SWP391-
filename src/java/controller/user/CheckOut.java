/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller.user;

import dao.CourseContext;
import dao.PlansContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.mail.MessagingException;
import model.Course;
import model.User;
import model.Wishlist;
import util.Mail;

/**
 *
 * @author HuyLQ;
 */
@WebServlet("/CheckOut")
public class CheckOut extends authentication.Authentication {

    @Override
    protected void doGet(User user, HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            String vnp_TxnRef = req.getParameter("vnp_TxnRef");

            String vnp_OrderInfo = req.getParameter("vnp_OrderInfo");
            String vnp_BankCode = req.getParameter("vnp_BankCode");
            String vnp_PayDate = req.getParameter("vnp_PayDate");
            String vnp_TransactionStatus = req.getParameter("vnp_TransactionStatus");
            float Amount = Float.parseFloat(req.getParameter("vnp_Amount"));
            float vnp_Amount = Amount / 100;
            String formattedAmount = String.format("%.0f", vnp_Amount);

            String emailAddress = user.getEmail();
            CourseContext db = new CourseContext();
            Wishlist wishList = db.getWishListByEmail(emailAddress);
            ArrayList<Course> courseList = wishList.getCourseId();
            
            if (vnp_TransactionStatus.equalsIgnoreCase("00")) {
                for (Course course : courseList) {
                    db.addCourseToAccessible(emailAddress, course.getId());
                  senMail(emailAddress);
                }
            }
            
            // checck out plan
            String[] vnp_checkOutPlan = vnp_OrderInfo.trim().split("\\/");
            if(vnp_checkOutPlan.length == 2 && vnp_TransactionStatus.equalsIgnoreCase("00")){
                PlansContext pc = new PlansContext();
                if(vnp_checkOutPlan[1].equals("month")){
                    pc.insertUserPlan(user.getEmail(), vnp_checkOutPlan[1], 1);
                }
                if(vnp_checkOutPlan[1].equals("quarter")){
                    pc.insertUserPlan(user.getEmail(), vnp_checkOutPlan[1], 4);
                }
            }
                    
            req.setAttribute("vnp_TxnRef", vnp_TxnRef);
            req.setAttribute("vnp_Amount", formattedAmount);
            req.setAttribute("vnp_OrderInfo", vnp_OrderInfo);
            req.setAttribute("vnp_BankCode", vnp_BankCode);
            req.setAttribute("vnp_PayDate", vnp_PayDate);
            req.setAttribute("vnp_TransactionStatus", vnp_TransactionStatus);

            req.getRequestDispatcher("view/vnpay/vnpay_return.jsp").forward(req, resp);

        } catch (SQLException | ParseException ex) {
            Logger.getLogger(CheckOut.class.getName()).log(Level.SEVERE, null, ex);
        } catch (MessagingException ex) {
            Logger.getLogger(CheckOut.class.getName()).log(Level.SEVERE, null, ex);
        } 
    }

    public void senMail(String email) throws MessagingException {
        String content = 
                " <div dir=\"ltr\" style=\"width: 600px; margin: 0 auto; background-color: #ffffff; padding: 20px;\">\n" +
"        <div style=\"text-align: center; padding-bottom: 20px;\">\n" +
"            <h1>EduPort</h1>\n" +
"        </div>\n" +
"        <div style=\"text-align: center; padding-bottom: 20px;\">\n" +
"            <img src=\"https://fhgfjrf.stripocdn.email/content/guids/CABINET_c0e87147643dfd412738cb6184109942/images/151618429860259.png\"\n" +
"                alt=\"\" style=\"display: block; margin: 0 auto;\" width=\"100\">\n" +
"            <h1 style=\"font-size: 46px; line-height: 100%;\">Thanks for choosing us!</h1>\n" +
"        </div>\n" +
"        <div style=\"text-align: center; padding-bottom: 20px;\">\n" +
"            <p>Your order has now been completed!</p>\n" +
"            <a style=\"background-color: black; color: white; padding: 0.5rem; display: inline-block; margin-top: 1rem; text-decoration: none; font-weight: bold;\"\n" +
"                href=\"http://localhost:8080/SWP391/account\"\n" +
"                target=\"_blank\">My Account</a>\n" +
"        </div>\n" +
"        <div style=\"border-bottom: 2px solid #efefef; padding: 20px 0;\"></div>\n" +
"        <div style=\"text-align: center; padding-top: 20px;\">\n" +
"            <p>Got a question? Email us at: EduPortEducation@gmail.com or phone number: 0976888888.</p>\n" +
"        </div>\n" +
"    </div>";
        Mail.sendMail(email, "Course payment successful in EduPort", content);
    }

    @Override
    protected void doPost(User user, HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

}
