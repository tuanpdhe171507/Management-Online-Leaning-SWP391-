/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package controller.user;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import dao.CourseContext;
import util.Vnpay;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collections;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.TimeZone;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.SQLException;
import java.util.Date;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Course;
import model.User;
import model.Wishlist;
import org.json.simple.parser.ParseException;

/**
 *
 * @author HuyLQ
 */
@WebServlet("/VNPay/*")
public class VNPay extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            String all = req.getParameter("all");
            // Get course id list;
            String[] ids = req.getParameterValues("course");
            CourseContext courseContext = new CourseContext();
            float totalPriceUSD = 0;
            // Get course price;
            Date now = new Date();
            if (all == null) {
                for (String id : ids) {
                    try {
                        totalPriceUSD += courseContext
                                .getPriceOnDate(Integer.parseInt(id), now);
                    } catch (SQLException ex) {
                        Logger.getLogger(VNPay.class.getName()).log(Level.SEVERE, null, ex);
                    }
                }
            } else {
                User user = (User) req.getSession().getAttribute("user");
                CourseContext db = new CourseContext();
                Wishlist wishList = db.getWishListByEmail(user.getEmail());
                ArrayList<Course> courseList = wishList.getCourseId();
                
                for (Course course : courseList) {
                    totalPriceUSD += course.getCurrentPrice();
                }
            }
            
            float totalPriceVND = totalPriceUSD * util.Utils.getConverter("USD-VND");
            String totalPrice = String.format("%.0f", totalPriceVND);
            req.setAttribute("totalPrice", totalPrice);
            req.getRequestDispatcher("view/vnpay/vnpay_pay.jsp").forward(req, resp);
        } catch (InterruptedException ex) {
            Logger.getLogger(VNPay.class.getName()).log(Level.SEVERE, null, ex);
        } catch (ParseException ex) {
            Logger.getLogger(VNPay.class.getName()).log(Level.SEVERE, null, ex);
        } catch (SQLException ex) {
            Logger.getLogger(VNPay.class.getName()).log(Level.SEVERE, null, ex);
        } catch (java.text.ParseException ex) {
            Logger.getLogger(VNPay.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        String vnp_Version = "2.1.0";
        String vnp_Command = "pay";
        String orderType = "other";             
        long amount = Integer.parseInt(req.getParameter("amount")) * 100;
        String bankCode = req.getParameter("bankCode");
        String vnp_TxnRef = Vnpay.getRandomNumber(8);
        String plan = req.getParameter("plan");
        if (plan != null && !plan.isEmpty()) {
            vnp_TxnRef += "/"+plan;
        } 

        String vnp_IpAddr = Vnpay.getIpAddress(req);

        String vnp_TmnCode = Vnpay.vnp_TmnCode;

        Map<String, String> vnp_Params = new HashMap<>();
        vnp_Params.put("vnp_Version", vnp_Version);
        vnp_Params.put("vnp_Command", vnp_Command);
        vnp_Params.put("vnp_TmnCode", vnp_TmnCode);
        vnp_Params.put("vnp_Amount", String.valueOf(amount));
        vnp_Params.put("vnp_CurrCode", "VND");

        if (bankCode != null && !bankCode.isEmpty()) {
            vnp_Params.put("vnp_BankCode", bankCode);
        }
        vnp_Params.put("vnp_TxnRef", vnp_TxnRef);
        vnp_Params.put("vnp_OrderInfo", "Thanh toan don hang:" + vnp_TxnRef);
        vnp_Params.put("vnp_OrderType", orderType);

        String locate = req.getParameter("language");
        if (locate != null && !locate.isEmpty()) {
            vnp_Params.put("vnp_Locale", locate);
        } else {
            vnp_Params.put("vnp_Locale", "vn");
        }
        vnp_Params.put("vnp_ReturnUrl", Vnpay.vnp_ReturnUrl);
        vnp_Params.put("vnp_IpAddr", vnp_IpAddr);

        Calendar cld = Calendar.getInstance(TimeZone.getTimeZone("Etc/GMT+7"));
        SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
        String vnp_CreateDate = formatter.format(cld.getTime());
        vnp_Params.put("vnp_CreateDate", vnp_CreateDate);

        cld.add(Calendar.MINUTE, 15);
        String vnp_ExpireDate = formatter.format(cld.getTime());
        vnp_Params.put("vnp_ExpireDate", vnp_ExpireDate);

        List fieldNames = new ArrayList(vnp_Params.keySet());
        Collections.sort(fieldNames);
        StringBuilder hashData = new StringBuilder();
        StringBuilder query = new StringBuilder();
        Iterator itr = fieldNames.iterator();
        while (itr.hasNext()) {
            String fieldName = (String) itr.next();
            String fieldValue = (String) vnp_Params.get(fieldName);
            if ((fieldValue != null) && (fieldValue.length() > 0)) {
                //Build hash data
                hashData.append(fieldName);
                hashData.append('=');
                hashData.append(URLEncoder.encode(fieldValue, StandardCharsets.US_ASCII.toString()));
                //Build query
                query.append(URLEncoder.encode(fieldName, StandardCharsets.US_ASCII.toString()));
                query.append('=');
                query.append(URLEncoder.encode(fieldValue, StandardCharsets.US_ASCII.toString()));
                if (itr.hasNext()) {
                    query.append('&');
                    hashData.append('&');
                }
            }
        }
        String queryUrl = query.toString();
        String vnp_SecureHash = Vnpay.hmacSHA512(Vnpay.secretKey, hashData.toString());
        queryUrl += "&vnp_SecureHash=" + vnp_SecureHash;
        String paymentUrl = Vnpay.vnp_PayUrl + "?" + queryUrl;
        com.google.gson.JsonObject job = new JsonObject();
        job.addProperty("code", "00");
        job.addProperty("message", "success");
        job.addProperty("data", paymentUrl);
        Gson gson = new Gson();
        resp.getWriter().write(gson.toJson(job));
    }

}
