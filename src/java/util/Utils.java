/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package util;

import dao.AdministratorContext;
import jakarta.websocket.EncodeException;
import java.io.IOException;
import java.sql.SQLException;
import java.text.ParseException;
import model.Notification;
import util.websocket.EchoEndPoint;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;

/**
 *
 * @author HieuTC
 */
public class Utils {    
    public static void notify(String email, String message, String hyperLink) throws SQLException, ParseException, IOException, EncodeException {
        AdministratorContext dbContext = new AdministratorContext();
        Notification noti = dbContext.insertNotification(email, message, hyperLink); 
        EchoEndPoint.send(email, noti);
    }
    
    // query = USD-VND;
    public static float getConverter(String query) throws IOException, InterruptedException, org.json.simple.parser.ParseException {
        HttpClient client = HttpClient.newHttpClient();
        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create("https://www.searchapi.io/api/v1/search?"
                        + "api_key=DKmbr2aV929mA7Wy6fECqB2v&engine=google_finance&q=" + query))
                .build();
        HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());

        // Parser converter API response;
        JSONParser jsonParser = new JSONParser();
        JSONObject jsonObject = (JSONObject) jsonParser.parse(response.body());
        
        JSONObject summaryObject = (JSONObject) jsonObject.get("summary"); 
        return Float.parseFloat(summaryObject.get("price").toString());
    }

    
}
