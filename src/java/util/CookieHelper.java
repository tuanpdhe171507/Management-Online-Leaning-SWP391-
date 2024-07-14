/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package util;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.Cookie;
/**
 *
 * @author HieuTC
 */
public class CookieHelper {

    
    /**
     */
    public static String getCookieContent(HttpServletRequest req, String cookieName) {
        Cookie[] cookies = req.getCookies();
        
        /* Travel cookie list*/
        for (Cookie cooky : cookies) {
            
            /* Cookie name matched*/
            if (cooky.getName().equalsIgnoreCase(cookieName)) {
                return cooky.getValue(); /* Return it's value*/
            }
        }
        return null; /* Cookie name do not matched*/
    }
}
