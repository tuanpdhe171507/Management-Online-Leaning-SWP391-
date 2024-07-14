/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.user;

import dao.UserContext;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.File;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.sql.SQLException;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Device;
import model.Profile;
import model.User;

/**
 *
 * @author Huy
 */
@WebServlet("/account")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 1, // 1 MB
        maxFileSize = 1024 * 1024 * 10, // 10 MB
        maxRequestSize = 1024 * 1024 * 15 // 15 MB
)
public class AccountSetUp extends authentication.Authentication {

    @Override
    protected void doGet(User user, HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String email = user.getEmail();
            UserContext userContext = new UserContext();
            Profile profile = userContext.getProfile(email);
            request.setAttribute("profile", profile);

            /**
             *
             * HieuTC Get trusted device list;
             */
            ArrayList<Device> deviceList = userContext
                    .getTrustedDeviceList(email);
            
            Device thisDevice = null;
            for (Device device : deviceList) {
                if (device.getIp().equals(user.getIp())) {
                    thisDevice = device;
                }
            }
            
            deviceList.remove(thisDevice);
            request.setAttribute("thisDevice", thisDevice);
            request.setAttribute("deviceList", deviceList);
            // Forward the request to the JSP page with updated data
            request.getRequestDispatcher("view/account.jsp").forward(request, response);
        } catch (SQLException | ParseException ex) {
            Logger.getLogger(AccountSetUp.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    @Override
    protected void doPost(User user, HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Part part = request.getPart("profilePicture");
        String picturePath = "/images";

        /*add path to new folder image*/
        String fileName = UUID.randomUUID().toString() + "_" + Paths.get(part.getSubmittedFileName()).getFileName().toString();
        String filePath = request.getServletContext().getRealPath(picturePath) + File.separator + fileName;

          /*create folde if not exist*/
        File uploadDir = new File(request.getServletContext().getRealPath(picturePath));
        if (!uploadDir.exists()) {
            uploadDir.mkdir();
        }
        /* delete image affter update*/
        UserContext db = new UserContext();
        String email = user.getEmail();
        try {
            Profile currentProfile = db.getProfile(email);
            if (currentProfile != null && currentProfile.getPicture() != null) {
                String oldPicturePath = request.getServletContext().getRealPath(currentProfile.getPicture());
                File oldFile = new File(oldPicturePath);
                /*only one picture in folder images*/
                if (oldFile.exists()) {
                    oldFile.delete();
                }
            }
        } catch (SQLException | ParseException ex) {
            Logger.getLogger(AccountSetUp.class.getName()).log(Level.SEVERE, null, ex);
            request.setAttribute("pError", "Failed to retrieve current profile");
        }

        part.write(filePath);
        String headline = request.getParameter("headline");
        Boolean gender = Boolean.valueOf(request.getParameter("gender"));
        String name = request.getParameter("fullname");

        if (db.updateProfile(email, name, picturePath + "/" + fileName, headline, gender)) {
            try {
                Profile profile = db.getProfile(email);
                request.setAttribute("profile", profile);
                request.setAttribute("pDone", "Updated successful");
            } catch (SQLException | ParseException ex) {
                Logger.getLogger(AccountSetUp.class.getName()).log(Level.SEVERE, null, ex);
                request.setAttribute("pError", "Failed to retrieve updated profile");
            }
        } else {
            request.setAttribute("pError", "Update failed");
        }

        // Chuyển hướng đến trang account.jsp để hiển thị thông tin hồ sơ
        request.getRequestDispatcher("view/account.jsp").forward(request, response);
    }

}
