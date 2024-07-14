/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller.user.instructor;

import com.google.api.client.http.InputStreamContent;
import com.google.api.services.drive.Drive;
import com.google.api.services.drive.model.File;
import com.google.api.services.drive.model.Permission;
import dao.InstructorContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.security.GeneralSecurityException;
import java.sql.SQLException;
import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.zip.ZipEntry;
import java.util.zip.ZipInputStream;
import model.User;
import model.Video;
import util.GoogleDrive;

/**
 *
 * @author HieuTC
 */
@WebServlet("/course/upload-video")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 1,
        maxFileSize = 1024 * 1024 * 20,
        maxRequestSize = 1024 * 1024 * 40
)
public class UploadVideo extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String url = req.getParameter("url");
        try {
            int lessonId = Integer.parseInt(req.getParameter("lesson"));
            int videoId = Integer.parseInt(req.getParameter("video"));

            InstructorContext instructorContext = new InstructorContext();
            instructorContext.setVideoForLesson(lessonId, videoId);
            resp.sendRedirect(url);
        } catch (SQLException ex) {
            Logger.getLogger(UploadVideo.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String url = req.getParameter("url");
        GoogleDrive google = new GoogleDrive();
        try {
            int lessonId = Integer.parseInt(req.getParameter("lesson"));
            float videoTime = Float
                    .parseFloat(req.getParameter("duration"));
            HttpSession session = req.getSession();
            User user = (User) session.getAttribute("user");
            if (user != null) {

                String email = user.getEmail();
                // Drive service call;
                Drive service = google.getDrive();

                // Get file;
                for (Part part : req.getParts()) {

                    // File there
                    if (part.getSubmittedFileName() != null) {
                        InputStream in = part.getInputStream();
                        String contentType = part.getContentType();
                        Video video = new Video();
                        // Uploaded file is video type;
                        if (contentType.startsWith("video/")) {
                            File metadata = new File();
                            metadata.setName(part.getSubmittedFileName());
                            InputStreamContent fileContent
                                    = new InputStreamContent(contentType, in);
                            File file = service.files()
                                    .create(metadata, fileContent)
                                    .setFields("id, mimeType, webViewLink")
                                    .execute();
                            // Set scale share for file;
                            Permission permission = new Permission();
                            permission.setType("anyone")
                                    .setRole("reader");
                            service.permissions()
                                    .create(file.getId(), permission)
                                    .execute();

                            video = new Video();
                            video.setName(metadata.getName());
                            video.setType(contentType);
                            video.setTime(videoTime);
                            video.setPath(file.getId());

                            
                        } else {
                            String dir = this.getServletContext().getRealPath("uploads");
                            java.io.File zip = new java.io.File(dir,
                                    UUID.randomUUID().toString());
                            String zipPackage = extractZip(zip.getAbsolutePath(), in);

                            // Wrong format
                            if (zipPackage == null) {
                                zip.delete();
                            }
                            video = new Video();
                            video.setName(part.getSubmittedFileName());
                            video.setType(zipPackage);
                            video.setTime(videoTime);
                            video.setPath(zip.getName());
                        }
                        
                        InstructorContext instructorContext = new InstructorContext();

                        //Save video informations
                        int videoId = instructorContext.saveVideo(email, video);
                        instructorContext.setVideoForLesson(lessonId, videoId);
                        break;

                    }

                }
            }
        } catch (GeneralSecurityException | SQLException ex) {
            Logger.getLogger(UploadVideo.class.getName()).log(Level.SEVERE, null, ex);
        }
        resp.sendRedirect(url);
    }

    public String extractZip(String dir, InputStream in) throws IOException {
        String zipPackage = null;
        try (ZipInputStream zip = new ZipInputStream(new BufferedInputStream(in))) {
            byte[] buffer = new byte[1024];
            ZipEntry entry;

            while ((entry = zip.getNextEntry()) != null) {
                String fileName = entry.getName();
                java.io.File file = new java.io.File(dir, fileName);
                
                if (zipPackage == null) {
                    
                    // The H5P package will include h5p.json file;
                    java.io.File stdH5P = new java.io.File(dir, "h5p.json");
                    
                    // The SCORM package will include SCORM_API_wrapper.js file;
                    java.io.File stdSCORM = new java.io.File(dir, "SCORM_API_wrapper.js");
                    if (stdH5P.exists()) {
                        zipPackage = "H5P";
                    } else if (stdSCORM.exists()) {
                        zipPackage = "SCORM";
                    }
                }

                if (entry.isDirectory()) {
                    // Create directory if it doesn't exist
                    file.mkdirs();
                } else {
                    // Ensure parent directory exists
                    java.io.File parent = file.getParentFile();
                    if (!parent.exists()) {
                        parent.mkdirs();
                    }

                    // Write file content
                    try (OutputStream out = new BufferedOutputStream(new FileOutputStream(file))) {
                        int len;
                        while ((len = zip.read(buffer)) > 0) {
                            out.write(buffer, 0, len);
                        }
                    }
                }

                zip.closeEntry();
            }
        }
        return zipPackage;
    }
}
