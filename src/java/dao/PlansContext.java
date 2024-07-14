/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import model.Plan;
import java.sql.*;
import java.util.ArrayList;
import java.util.Collections;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author Trongnd
 */
public class PlansContext extends ConnectionOpen {

    public ArrayList<Plan> getPlans() {
        ArrayList<Plan> plans = new ArrayList<>();
        try {
            String sql = "SELECT [plan]\n"
                    + "      ,[planName]\n"
                    + "      ,[planDescription]\n"
                    + "      ,[price]\n"
                    + "  FROM [dbo].[Plans]";
            PreparedStatement stm = connection.prepareStatement(sql);
            ResultSet rs = stm.executeQuery();
            while (rs.next()) {
                Plan p = new Plan();
                p.setPlan(rs.getString("plan"));
                p.setName(rs.getString("planName"));

                ArrayList<String> des = new ArrayList<>();
                if (rs.getString("planDescription") != null) {
                    Collections.addAll(des,
                            rs.getString("planDescription").split("/"));
                }
                p.setDescription(des);
                p.setPrice(rs.getFloat("price"));
                plans.add(p);
            }
        } catch (SQLException ex) {
            Logger.getLogger(PlansContext.class.getName()).log(Level.SEVERE, null, ex);
        }
        return plans;
    }

    public void insertUserPlan(String email, String plan, int duration) {
        try {
            String sql = "INSERT INTO [dbo].[UserPlan]\n"
                    + "           ([emailAddress]\n"
                    + "           ,[plan]\n"
                    + "           ,[registerTime]\n"
                    + "           ,[expiredTime])\n"
                    + "     VALUES\n"
                    + "           (?\n"
                    + "           ,?\n"
                    + "           ,GETDATE()\n"
                    + "           ,DATEADD(MONTH, ?, GETDATE()));";
            PreparedStatement stm = connection.prepareStatement(sql);
            stm.setString(1, email);
            stm.setString(2, plan);
            stm.setInt(3, duration);
            stm.execute();
        } catch (SQLException ex) {
            Logger.getLogger(PlansContext.class.getName()).log(Level.SEVERE, null, ex);
        }

    }

    public Timestamp getPlanExpiredTime(String email) {
        try {
            String sql = "SELECT MAX(expiredTime) AS latestExpiredTime\n"
                    + "FROM UserPlan\n"
                    + "WHERE emailAddress = ?;";
            PreparedStatement stm = connection.prepareStatement(sql);
            stm.setString(1, email);
            ResultSet rs = stm.executeQuery();
            if (rs.next()) {
                return rs.getTimestamp("latestExpiredTime");
            }
        } catch (SQLException ex) {
            Logger.getLogger(PlansContext.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }

    public String getPlanCurrentRegisted(String email) {
        try {
            String sql = "select [plan] from UserPlan \n"
                    + "where emailAddress = ?\n"
                    + "ORDER BY expiredTime DESC";
            PreparedStatement stm = connection.prepareStatement(sql);
            stm.setString(1, email);
            ResultSet rs = stm.executeQuery();
            if(rs.next()){
                return rs.getString("plan");
            }
        } catch (SQLException ex) {
            Logger.getLogger(PlansContext.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }
}
