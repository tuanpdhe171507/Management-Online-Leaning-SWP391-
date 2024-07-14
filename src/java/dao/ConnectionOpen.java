/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author 
 */
public abstract class ConnectionOpen {
    Connection connection;
            
    public ConnectionOpen() {
        try {
             String url = "jdbc:sqlserver://localhost\\SQLEXPRESS:1433;"
                     + "databaseName=SWP391;encrypt=true;"
                     + "trustServerCertificate=true;";
            String driver = "com.microsoft.sqlserver.jdbc.SQLServerDriver";
         
            Class.forName(driver);
            connection = (Connection) DriverManager
                    .getConnection(url, "admin", "123456");
        } catch (ClassNotFoundException | SQLException ex) {

            Logger.getLogger(ConnectionOpen.class.getName())
                    .log(Level.SEVERE, null, ex);
        }
    }

    public final SimpleDateFormat dateTime = new SimpleDateFormat("yyyy-mm-dd hh:mm:ss.sss");
}
