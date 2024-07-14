/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package util;

import com.google.api.client.auth.oauth2.Credential;
import com.google.api.client.googleapis.auth.oauth2.GoogleCredential;
import com.google.api.client.googleapis.javanet.GoogleNetHttpTransport;
import com.google.api.client.http.InputStreamContent;
import com.google.api.client.http.javanet.NetHttpTransport;
import com.google.api.client.json.JsonFactory;
import com.google.api.client.json.jackson2.JacksonFactory;
import com.google.api.services.drive.Drive;
import com.google.api.services.drive.DriveScopes;
import com.google.api.services.drive.model.File;
import com.google.api.services.drive.model.Permission;
import jakarta.servlet.http.Part;
import java.io.IOException;
import java.io.InputStream;
import java.security.GeneralSecurityException;
import java.util.Collections;
import java.util.List;

/**
 *
 * @author HieuTC
 */

public class GoogleDrive {
    
    private final String clientId = "444175066040-vfraie2ohc68jei5v58b1il2kppqm0o4.apps.googleusercontent.com";
    private final String credentialsFilePath = "/credentials.json";

    private final JsonFactory jsonFactory = JacksonFactory.getDefaultInstance();

    private static final List<String> scopes
            = Collections.singletonList(DriveScopes.DRIVE_FILE);

    private Credential getCredentials(final NetHttpTransport transport) throws GeneralSecurityException, IOException {
        GoogleCredential credential = GoogleCredential.fromStream(
                this.getClass().getResourceAsStream(credentialsFilePath))
                .createScoped(scopes);
        return credential;
    }

    public Drive getDrive() throws GeneralSecurityException, IOException {
        final NetHttpTransport transport
                = GoogleNetHttpTransport.newTrustedTransport();

        Drive service = new Drive.Builder(transport, jsonFactory,
                this.getCredentials(transport))
                .setApplicationName(clientId)
                .build();
        return service;
    }

    public String uploadImage(Part part) throws IOException, GeneralSecurityException {
        Drive service = this.getDrive();
        InputStream in = part.getInputStream();
        String contentType = part.getContentType();
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
        
        return file.getId();
    }
}
