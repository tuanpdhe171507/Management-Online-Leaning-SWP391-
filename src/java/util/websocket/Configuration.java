/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package util.websocket;

import jakarta.servlet.http.HttpSession;
import jakarta.websocket.HandshakeResponse;
import jakarta.websocket.server.HandshakeRequest;
import jakarta.websocket.server.ServerEndpointConfig;
import model.User;

/**
 *
 * @author HieuTC
 */
public class Configuration extends ServerEndpointConfig.Configurator {

    @Override
    public void modifyHandshake(ServerEndpointConfig config, HandshakeRequest req, HandshakeResponse resp) {
        HttpSession httpSession = (HttpSession) req.getHttpSession();
        User user = (User) httpSession.getAttribute("user");
        if (user != null) {
            String email = user.getEmail();
            config.getUserProperties()
                .put("email", email);
        }
        
    }
}
