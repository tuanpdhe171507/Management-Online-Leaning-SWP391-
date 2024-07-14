/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package util.websocket;

import com.google.gson.Gson;
import jakarta.websocket.DecodeException;
import model.Notification;


/**
 *
 * @author HieuTC
 */
public class Decoder implements jakarta.websocket.Decoder.Text<Notification>{

    @Override
    public Notification decode(String json) throws DecodeException {
        Gson gson = new Gson();
        Notification noti = gson.fromJson(json, Notification.class);
        return noti;
    }

    @Override
    public boolean willDecode(String string) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }
    
}
