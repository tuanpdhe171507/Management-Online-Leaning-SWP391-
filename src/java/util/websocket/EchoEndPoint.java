/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package util.websocket;

import jakarta.websocket.*;
import jakarta.websocket.server.ServerEndpoint;
import java.io.IOException;
import java.util.LinkedList;
import java.util.List;
import model.Notification;

/**
 *
 * @author HieuTC
 */
@ServerEndpoint(
        value = "/notify",
        configurator = Configuration.class,
        encoders = Encoder.class,
        decoders = Decoder.class
)
public class EchoEndPoint{
    
    private static final List<Session> stack = new LinkedList<>();
        
    @OnOpen
    public void open(Session session) throws IOException, EncodeException {
        stack.add(session);
    }
    
    @OnMessage
    public void message(Session session, Notification noti) {
    }
    
    @OnError
    public void error(Session session, Throwable throwable) {     
        this.close(session);
    }
    
    @OnClose
    public void close(Session session) {
        stack.remove(session);
    }
    
    
    public static void send(String email, Notification noti) throws EncodeException, IOException {
        for (Session session : stack) {
            String userPorperty = (String) session.getUserProperties()
                    .get("email");
            if (email.equalsIgnoreCase(userPorperty)) {
                session.getBasicRemote().sendObject(noti);
            }
        }
    }
    
    public static List<Session> getStack() {
        return stack;
    }
    
}

