/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package util;

import java.util.Properties;
import javax.mail.*;
import javax.mail.internet.*;

/**
 *
 * @author HieuTC
 */
public class Mail {
    
    /*
     * 
     */
    public static void sendMail(String recipient, String subject, String content) throws MessagingException {
        
        // Set session properties;
        Properties properties = new Properties();
        properties.put("mail.smtp.auth", "true");
        properties.put("mail.smtp.host", "smtp.gmail.com");
        properties.put("mail.smtp.port", "587");
        properties.put("mail.smtp.ssl.trust", "smtp.gmail.com");
        properties.put("mail.smtp.ssl.protocols", "TLSv1.2");
        properties.put("mail.smtp.starttls.enable", "true");
        properties.put("mail.smtp.debug", "true");
        
        Session session = Session.getDefaultInstance(properties, 
                new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(
                        "noreply.eduport.swp391@gmail.com",
                        "uvwm qvgk fnpk ggnb");
            }
        });

        /* Set message target */
        Message message = new MimeMessage(session);
        message.setFrom(new InternetAddress("noreply.eduport.swp391@gmail.com"));
        message.addRecipient(Message.RecipientType.TO,
               new InternetAddress(recipient));
        
        /* Set message content */
        message.setSubject(subject);
        message.setContent(content, "text/html");
        
        Transport.send(message);
    }
}
