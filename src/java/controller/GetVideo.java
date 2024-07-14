/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.ServletOutputStream;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;

/**
 *
 * @author HieuTC
 */
@WebServlet("/course/video")
public class GetVideo extends HttpServlet{

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String fileId = req.getParameter("id");
        String encodedFileId = URLEncoder.encode(fileId, "UTF-8");
        String urlString = "https://www.googleapis.com/drive/v3/files/"
                + encodedFileId + "?alt=media&key=" + apiKey;
        
        URL url =  new URL(urlString);
        
        // Open connection to Google API;
        HttpURLConnection connection = (HttpURLConnection) url.openConnection();
        resp.sendRedirect(urlString);
        
        // Set request method;
        connection.setRequestMethod("GET");
        
        // Connection is worked;
        int responseCode = connection.getResponseCode();
        if (responseCode == HttpURLConnection.HTTP_OK) {
            
            ServletOutputStream outputStream = resp.getOutputStream();
            InputStream inputStream = connection.getInputStream();
            // Write out response content;
            outputStream.write(inputStream.readAllBytes());
        }
    }
    
    private final String apiKey = "AIzaSyCNYu0x3GaF1LgVljhvfkJPCQTcfX91K6Q";
    
}
