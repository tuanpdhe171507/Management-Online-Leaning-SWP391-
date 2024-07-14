/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package authentication.authorization;

import authentication.Authentication;
import dao.UserContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.crypto.BadPaddingException;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;
import model.User;

/**
 *
 * @author HieuTC
 */

public abstract class Authorization extends Authentication {

    @Override
    protected void doGet(User user, HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            this.proccessRequest(true, user, req, resp);
        } catch (SQLException ex) {
            Logger.getLogger(Authorization.class.getName()).log(Level.SEVERE, null, ex);
        } catch (NoSuchAlgorithmException ex) {
            Logger.getLogger(Authorization.class.getName()).log(Level.SEVERE, null, ex);
        } catch (NoSuchPaddingException ex) {
            Logger.getLogger(Authorization.class.getName()).log(Level.SEVERE, null, ex);
        } catch (InvalidKeyException ex) {
            Logger.getLogger(Authorization.class.getName()).log(Level.SEVERE, null, ex);
        } catch (IllegalBlockSizeException ex) {
            Logger.getLogger(Authorization.class.getName()).log(Level.SEVERE, null, ex);
        } catch (BadPaddingException ex) {
            Logger.getLogger(Authorization.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    @Override
    protected void doPost(User user, HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            this.proccessRequest(false, user, req, resp);
        } catch (SQLException ex) {
            Logger.getLogger(Authorization.class.getName()).log(Level.SEVERE, null, ex);
        } catch (NoSuchAlgorithmException ex) {
            Logger.getLogger(Authorization.class.getName()).log(Level.SEVERE, null, ex);
        } catch (NoSuchPaddingException ex) {
            Logger.getLogger(Authorization.class.getName()).log(Level.SEVERE, null, ex);
        } catch (InvalidKeyException ex) {
            Logger.getLogger(Authorization.class.getName()).log(Level.SEVERE, null, ex);
        } catch (IllegalBlockSizeException ex) {
            Logger.getLogger(Authorization.class.getName()).log(Level.SEVERE, null, ex);
        } catch (BadPaddingException ex) {
            Logger.getLogger(Authorization.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
    
    protected void proccessRequest(boolean doGet, User user, HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException, SQLException, NoSuchAlgorithmException, NoSuchPaddingException, InvalidKeyException, IllegalBlockSizeException, BadPaddingException {
        UserContext userContext = new UserContext();
        String path = req.getServletPath();

        if (userContext.verifyAccessiblePath(user.getEmail(), path)) {
            if (doGet) {
                this.forwardGetRequest(req, resp);
            } else {
                this.forwardPostRequest(req, resp);
            }
        } else {
            resp.getWriter().print("Access denied");
        }
        
    }
    
    protected abstract void forwardGetRequest(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException;
    protected abstract void forwardPostRequest(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException;
}
