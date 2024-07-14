/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package util.websocket;

import com.google.gson.Gson;
import jakarta.websocket.EncodeException;
import model.Notification;

/**
 *
 * @author HieuTC
 */
public class Encoder implements jakarta.websocket.Encoder.Text<Notification>{

    @Override
    public String encode(Notification noti) throws EncodeException {
        Gson gson = new Gson();
        String json = gson.toJson(noti);
        return json;
    }
    
}
