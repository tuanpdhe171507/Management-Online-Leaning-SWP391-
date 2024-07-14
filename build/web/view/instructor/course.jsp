<%-- 
    Document   : courses
    Created on : May 30, 2024, 2:54:05 PM
    Author     : HieuTC
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!doctype html>
<html lang="en">
    <head>
        <meta charset="utf-8"/>
        <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
        <title>EduPort</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
        <link href="../view/assets/css/base.css" rel="stylesheet"/>
        <link href="../view/assets/css/hieutc.css" rel="stylesheet"/>
        <style>
            .container {
                max-width: 70vw;
            }
            
            summary.section, summary.lesson {
                border: 1px solid black;
                padding: 0.5rem;
            }
            
            .form-control {
                border: unset;
                padding: 0;
            }
            
            .form-control:focus {
                border-bottom: 2px solid black;
            }
        </style>
    </head>
    <body>
        <div class="container-fluid border-bottom">
            <nav class="navbar">
                <div class="container pt-2 pb-2">
                    <a class="btn" href="">Go back</a>
                    <a class="btn" href="">Preview</a>
                </div>
            </nav>
        </div>    
        <div class="container pt-5 pb-5">
            <div class="row">
                <div class="col-3">
                    <h5>Create you content</h5>
                    <button class="btn" type="button" style="border-left: 3px solid black;">
                        Curriculum
                    </button>
                </div>
                <div class="col-9">
                    <h5>Curriculum</h5>
                    <div class="row gy-2">
                    <c:forEach items="${requestScope.course.sectionList}" var="section">
                        <div class="col-12">
                            <details>
                                <summary class="section">
                                    <div class="p-2">
                                        <div class="row">
                                            <div class="col-2">
                                                <h6>Section ${requestScope.course.sectionList.indexOf(section) + 1}:</h6>
                                            </div>
                                            <div class="col-10">
                                                <input class="form-control" type="text" name="section" id="section${section.id}" onfocus="openSectionEditor(${section.id})"
                                                       placeholder="Insert a title" value="${section.title}">
                                                <input type="hidden" value="${section.title}" id="initialSection${section.id}"/>
                                            </div>
                                            <div class="col-12 d-flex justify-content-end pt-2 d-none" id="sectionEditor${section.id}">
                                                <button class="btn" type="button" onclick="cancelSectionEditor(${section.id})">Cancel</button>
                                                <button class="btn btn-dark" type="button" onclick="updateSection(${section.id})">Save</button>   
                                            </div>
                                        </div>
                                    </div>
                                </summary>
                                <div class="border border-top-0">
                                    <div class="row">
                                        <div class="col-2">    
                                        </div>
                                        <div class="col-10 p-4">
                                            <div class="row gy-2" id="${section.id}">
                                            <c:forEach items="${section.lessonList}" var="lesson">  
                                                <div class="col-12">
                                                    <details open="true">
                                                        <summary class="section">
                                                            <div class="row p-2">
                                                                <div class="col-2">
                                                                    <h6>Lesson ${section.lessonList.indexOf(lesson) + 1}:</h6>
                                                                </div>
                                                                <div class="col-10">
                                                                    <input class="form-control" type="text" name="section" onfocus="openLessonEditor(${lesson.id})"
                                                                           placeholder="Insert a title" value="${lesson.name}" id="lesson${lesson.id}">
                                                                    <input type="hidden" value="${lesson.name}" id="initialLesson${lesson.id}">
                                                                </div>
                                                            </div>
                                                            <div class="col-12 d-flex justify-content-end pt-2 d-none" id="lessonEditor${lesson.id}">
                                                                    <button class="btn" type="button" onclick="cancelLessonEditor(${lesson.id})">Cancel</button>
                                                                    <button class="btn btn-dark" type="button" onclick="updateLesson(${lesson.id})">Save</button>   
                                                            </div>
                                                        </summary> 
                                                    </details>
                                                </div>
                                            </c:forEach>
                                                <div class="col-12 d-none" id="lessonCreatorFor${section.id}">
                                                    <div class="border">
                                                        <div class="row p-3">
                                                            <div class="col-2">
                                                                <h6>Lesson</h6>

                                                            </div>
                                                            <div class="col-10">
                                                                <input class="form-control"
                                                                       name="lesson" placeholder="Insert a title" id="lessonFor${section.id}"/>
                                                               
                                                            </div>
                                                            <div class="col-12 d-flex justify-content-end pt-2">
                                                                <button class="btn" type="button" onclick="cancelLessonCreator(${section.id})">Cancel</button>
                                                                <button class="btn btn-outline-secondary border" type="button" onclick="addLesson(${section.id})">Add lesson</button>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="col-12">
                                                    <button class="btn p-0" type="button" onclick="openLessonCreator(${section.id})"><ion-icon name="add-outline"></ion-icon> Add lesson</button>
                                                    <button class="btn p-0 ms-2" type="button"><ion-icon name="add-outline"></ion-icon> Add quiz</button>
                                                </div>                                             
                                            </div>
                                        </div>
                                    </div>
                                    
                                </div>
                            </details> 
                        </div>
                    </c:forEach>
                        <div class="col-12 d-none" id="sectionCreator">
                            <div class="border">
                                <div class="row p-3">
                                    <div class="col-2">
                                        <h6>Section</h6>

                                    </div>
                                    <div class="col-10">
                                        <input class="form-control"
                                               name="lesson" placeholder="Insert a title" id="section"/>

                                    </div>
                                    <div class="col-12 d-flex justify-content-end pt-2">
                                        <button class="btn" type="button" onclick="cancelSectionCreator()">Cancel</button>
                                        <button class="btn btn-outline-secondary border" type="button"
                                                onclick="addSection()">Add section</button>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-12">
                            <button class="btn p-0" type="button" onclick="openSectionCreator()"><ion-icon name="add-outline"></ion-icon> Add section</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script type="module" src="https://unpkg.com/ionicons@7.1.0/dist/ionicons/ionicons.esm.js"></script>
        <script nomodule src="https://unpkg.com/ionicons@7.1.0/dist/ionicons/ionicons.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
        <script>
            
            function openSectionEditor(e) {
                document.getElementById('sectionEditor' + e).classList.remove('d-none');
            }
            
            function cancelSectionEditor(e) {
                document.getElementById('sectionEditor' + e).classList.add('d-none');
                document.getElementById('section' + e).value = document.getElementById('initialSection' + e).value;
            }
            
            function openLessonEditor(e) {
                document.getElementById('lessonEditor' + e).classList.remove('d-none');
            }
            
            function cancelLessonEditor(e) {
                document.getElementById('lessonEditor' + e).classList.add('d-none');
                document.getElementById('lesson' + e).value = document.getElementById('initialLesson' + e).value;
            }
            
            function cancelSectionCreator() {
                document.getElementById('sectionCreator').classList.add('d-none');
                document.getElementById('section').value = '';
            }
            
            function openSectionCreator() {
                document.getElementById('sectionCreator').classList.remove('d-none');
                document.getElementById('section').focus();
            }
            
            function cancelLessonCreator(e) {
                document.getElementById('lessonCreatorFor' + e).classList.add('d-none');
                document.getElementById('lessonFor' + e).value = "";
            }
            
            function openLessonCreator(e) {
                document.getElementById('lessonCreatorFor' + e).classList.remove('d-none');
                document.getElementById('lessonFor' + e).focus();
            }
            
            function addSection() {
                const xhttp = new XMLHttpRequest();
                xhttp.onreadystatechange = function() {
                    if (this.readyState === 4 && this.status === 200) {
                        window.location.reload();
                    }
                };
                var title = document.getElementById('section').value;
                var data = JSON.stringify({
                    course: ${requestScope.course.id},
                    section: title
                });
                xhttp.open("post", "add-section", true); 
                xhttp.setRequestHeader("Content-Type", "application/json");
                xhttp.send(data);
            }
            
            function updateSection(e) {
                const xhttp = new XMLHttpRequest();
                xhttp.onreadystatechange = function() {
                    if (this.readyState === 4 && this.status === 200) {
                        window.location.reload();
                    }
                };
                var title = document.getElementById('section' + e).value;
                var data = JSON.stringify({
                    section: e,
                    title: title
                });
                xhttp.open("post", "update-section", true); 
                xhttp.setRequestHeader("Content-Type", "application/json");
                xhttp.send(data);
            }
            
            function addLesson(e) {
                const xhttp = new XMLHttpRequest();
                xhttp.onreadystatechange = function() {
                    if (this.readyState === 4 && this.status === 200) {
                        window.location.reload();
                    }
                };
                var name = document.getElementById('lessonFor' + e).value;
                var data = JSON.stringify({
                    section: e,
                    lesson: name
                });
                xhttp.open("post", "add-lesson", true); 
                xhttp.setRequestHeader("Content-Type", "application/json");
                xhttp.send(data);
            }
            
            function updateLesson(e) {
                const xhttp = new XMLHttpRequest();
                xhttp.onreadystatechange = function() {
                    if (this.readyState === 4 && this.status === 200) {
                        window.location.reload();
                    }
                };
                var name = document.getElementById('lesson' + e).value;
                var data = JSON.stringify({
                    lesson: e,
                    name: name
                });
                xhttp.open("post", "update-lesson", true); 
                xhttp.setRequestHeader("Content-Type", "application/json");
                xhttp.send(data);
            }
           
        </script>
    </body>
</html>
