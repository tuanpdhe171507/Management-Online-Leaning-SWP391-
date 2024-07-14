/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller.user;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import com.google.api.client.googleapis.auth.oauth2.GoogleIdToken;
import com.google.api.client.googleapis.auth.oauth2.GoogleIdTokenVerifier;
import com.google.api.client.http.javanet.NetHttpTransport;
import com.google.api.client.json.jackson2.JacksonFactory;
import dao.UserContext;
import java.security.GeneralSecurityException;
import java.util.Collections;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.User;
/**
 *
 * @author TuanPD
 */
@WebServlet("/google-log-in")
public class GoogleLogIn extends HttpServlet{
    private final String CLIENT_ID = "444175066040-vfraie2ohc68jei5v58b1il2kppqm0o4.apps.googleusercontent.com";
    private final NetHttpTransport transport = new NetHttpTransport();
    private final JacksonFactory jsonFactory = new JacksonFactory();
    
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            GoogleIdTokenVerifier verifier = new GoogleIdTokenVerifier.Builder(transport, jsonFactory)
                    .setAudience(Collections.singletonList(CLIENT_ID)).build();
            
            String idTokenString = req.getParameter("credential");
            GoogleIdToken idToken = verifier.verify(idTokenString);
            GoogleIdToken.Payload payload = idToken.getPayload();
            String email = payload.getEmail();
            String name = (String) payload.get("name");
            UserContext userContext = new UserContext();
            
            /* Verify that this email match with a profile*/
            if (userContext.isExistedEmail(email)) {
                User user = new User();
                user.setEmail(email);
                req.getSession().setAttribute("user", user);
                req.getRequestDispatcher("view/auth/log-in.jsp").forward(req, resp);
                // req.getRequestDispatcher("view/home.jsp").forward(req, resp);

                
            } else {
                req.setAttribute("email", email);
                req.setAttribute("fullname", name);
                req.getRequestDispatcher("view/auth/sign-up.jsp").forward(req, resp);
            }
        } catch (GeneralSecurityException ex) {
            Logger.getLogger(GoogleLogIn.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
    
}
