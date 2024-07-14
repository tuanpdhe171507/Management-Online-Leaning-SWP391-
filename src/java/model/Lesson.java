/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.util.List;

/**
 *
 * @author TuanPD
 */
public class Lesson extends Item {
    private LessonType type;
    private String name;
    private Video video;
    private String readingContent;
    private List<Resource> resource;
    
    public Lesson() {
    }

    public LessonType getType() {
        return type;
    }

    public void setType(LessonType type) {
        this.type = type;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Video getVideo() {
        return video;
    }

    public void setVideo(Video video) {
        this.video = video;
    }

    public String getReadingContent() {
        return readingContent;
    }

    public void setReadingContent(String readingContent) {
        this.readingContent = readingContent;
    }

    public List<Resource> getResource() {
        return resource;
    }

    public void setResource(List<Resource> resource) {
        this.resource = resource;
    }


    
}
