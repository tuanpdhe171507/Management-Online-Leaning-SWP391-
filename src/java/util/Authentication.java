/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package util;

/**
 *
 * @author HieuTC
 */
public class Authentication {
    public String generateCredentialToken() {
        
        /* Characters allowed to appear in credential token */
        String letters = "abcdefghijklmnopqrstuvwxyz";
        String numbers = "0123456789";
        String specialChar = "!@$*-_.";
        String credentialToken = new String();
        
        /* Credential token's length must be 32 */
        while (credentialToken.length() < 32) {
            
            // i is random number less than 3;
            int i = (int)(Math.floor(Math.random() * 3));
            
            /* j is random character */
            char j = 0;
            switch (i) {
            case 0 -> /* j will be letter*/
                j = letters.charAt((int)(Math.floor(
                        Math.random() * letters.length())));
            case 1 -> /* j will be number*/
                j = numbers.charAt((int)(Math.floor(
                        Math.random() * numbers.length())));
            case 2 -> /* j will be special character*/
                j = specialChar.charAt((int)(Math.floor(
                        Math.random() * specialChar.length())));
            }
            
            // Append j to credential token;
            credentialToken += (Character.toString(j));
        }
        
        return credentialToken;
    }
    
}
