package controller.administrator;

import dao.AdministratorContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */

/**
 *
 * @author HieuTC
 */
@WebServlet("/administrator/set-attribute")
public class SetAttribute extends authentication.authorization.Authorization {

    @Override
    protected void forwardGetRequest(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            AdministratorContext dbContext = new AdministratorContext();
            String variable = req.getParameter("var");
            String value = req.getParameter("val");
            dbContext.setValue(variable, value);
        } catch (SQLException ex) {
            Logger.getLogger(SetAttribute.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    @Override
    protected void forwardPostRequest(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }
}
