package controller.administrator;

import dao.AdministratorContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Path;

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */

/**
 *
 * @author HieuTC
 */
@WebServlet("/administrator/settings")
public class Settings extends authentication.authorization.Authorization {

    @Override
    protected void forwardGetRequest(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            AdministratorContext dbContext = new AdministratorContext();

            String paramRow = req.getParameter("row");
            String query = req.getParameter("query");
            
            if (paramRow == null) {
                resp.sendRedirect("/SWP391/administrator/settings?row=5&query=all");
            } else {
                if (query == null) {
                    resp.sendRedirect("/SWP391/administrator/settings?row=" + paramRow
                            + "&query=all");
                } else {
                    ArrayList<Path> pathList = dbContext.getPathList();
                    
                    if (query.equalsIgnoreCase("disabled")) {
                        for (int i = 0; i < pathList.size(); i++) {
                            
                            Path path = pathList.get(i);
                            if (path.isAvailableState()) {
                                
                                pathList.remove(i);
                                i--;
                            }
                        }
                    }
                    req.setAttribute("pathList", pathList);
                    req.getRequestDispatcher("../view/administrator/settings.jsp")
                            .forward(req, resp);
                }

            }
        } catch (SQLException ex) {
            Logger.getLogger(Settings.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    @Override
    protected void forwardPostRequest(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }
    
}
