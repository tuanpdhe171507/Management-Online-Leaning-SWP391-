<%-- 
    Document   : content
    Created on : Jun 22, 2024, 9:41:26 PM
    Author     : HieuTC
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%@page import="model.Item"%>
<%@page import="model.Lesson"%>
<%@page import="model.Quiz"%>
<!doctype html>
<html lang="en">

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>EduPort</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"
        integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    <Link href="../view/assets/css/hieutc.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/quill@2.0.2/dist/quill.snow.css" rel="stylesheet">
    <style>
        .item:hover {
            border-left: 3px solid black;
            cursor: pointer;
        }

        .ql-toolbar {
            border: unset !important;
            border-bottom: 1px solid whitesmoke !important;
        }

        .ql-container {
            border: unset !important;
            font-size: medium;
        }

        h6.input-group-text {
            background-color: unset;
            border: unset;
        }

        input.form-control {
            border-color: white !important;
            border-bottom: 2px solid whitesmoke !important;
            border-radius: unset !important;
            font-family: 'Epilogue';
        }

        input.form-control:focus {
            border-color: white !important;
            border-bottom: 2px solid black !important;
            border-radius: unset !important;
        }

        .btn:focus {
            border-color: white !important;
        }
        
        .subtab {
            display: none;
        }
        
        .tab:hover .subtab {
            display: block;
        }
        
        details.btn:hover {
            cursor: default !important;
        }
        
        .lesson, .quiz:hover {
            cursor: pointer !important;
        }
        
        button.here {
            border-left: 3px solid black;
            border-radius: 0 0.5rem 0.5rem 0;
        }
        
        .btn-base {
            padding: 0;
        }
        
        .btn-base:hover {
            text-decoration: underline;
        }
    </style>
</head>

<body>
    <div class="container-fluid border-bottom">
        <nav class="navbar">
            <div class="container container pt-2 pb-2">
                <div class="text-truncate w-50">
                    <h6 class="fw-bold">
                        <c:choose>
                            <c:when test="${requestScope.course != null}">
                                <button class="btn" type="button" onclick="openHyperLink('../instructor/courses')">
                                <ion-icon class="fs-5" name="arrow-back-sharp"></ion-icon></button>
                                ${requestScope.course.name}
                            </c:when>
                            <c:otherwise>
                                    <button class="btn" type="button" onclick="openHyperLink('curriculum?id=${param.id}')">
                                        <ion-icon class="fs-5" name="arrow-back-sharp"></ion-icon></button>
                                        <c:if test="${requestScope.quiz != null}">
                                            ${requestScope.quiz.title}
                                        </c:if>
                                       <c:if test="${requestScope.lesson != null}">
                                           ${requestScope.lesson.name}
                                       </c:if>
                                        <c:if test="${requestScope.section != null}">
                                            ${requestScope.section.title}
                                        </c:if>
                            </c:otherwise>
                       </c:choose></h6>
                </div>
                <div>
                <c:if test="${requestScope.course != null}">
                    <a class="btn" type="button" href="settings?id=${requestScope.course.id}"><ion-icon class="fs-5" name="settings-outline"></ion-icon></a>
                </c:if>
                <button class="btn btn-warning fw-bold" type="button"
                        <c:choose>
                            <c:when test="${requestScope.course != null}">
                                onclick="window.open('../course/page?course=${requestScope.course.id}')"
                            </c:when>
                            <c:otherwise>
                                <c:if test="${requestScope.quiz != null}">
                                    onclick="window.open('../course/page?course=${param.id}&section=${param.section}&quiz=${requestScope.quiz.id}')"
                                </c:if>
                                <c:if test="${requestScope.lesson != null}">
                                    onclick="window.open('../course/page?course=${param.id}&section=${param.section}&lesson=${requestScope.lesson.id}')"
                                </c:if>
                            </c:otherwise>
                       </c:choose>>Preview</button>    
                </div>
                
            </div>
        </nav>
    </div>
                <div class="modal" tabindex="-1" aria-hidden="true" id="confirmee">
                    <div class="modal-dialog modal-dialog-centered">
                        <div class="modal-content">
                            <div class="modal-body">
                                <div class="position-absolute top-0 end-0">
                                    <button class="btn p-2 pe-3" data-bs-dismiss="modal" aria-label="Close">
                                        <ion-icon class="fs-4" name="close-sharp"></ion-icon>
                                    </button>
                                </div>
                                <h5 class="fw-bold pb-3">Please confirm</h5>
                                <p>You are about to delete this item, note that you can not revert this action. 
                                    Are you sure you want to continue?</p>
                                <div class="d-flex justify-content-end">
                                    <button class="btn" type="button" data-bs-dismiss="modal"  aria-label="Close">
                                        Cancel
                                    </button>
                                    <button class="btn fw-bold text-danger" type="button" id="confirmee-btn"
                                            data-bs-dismiss="modal" aria-label="Close" onclick="
                                            <c:choose>
                                                <c:when test="${requestScope.quiz != null}">deleteQuiz()</c:when>
                                                <c:when test="${requestScope.lesson != null}">deleteLesson()</c:when>
                                                
                                            </c:choose>">
                                        Understood
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
    <div class="toast-container position-fixed bottom-0 end-0 p-3">
        <div id="toast" class="toast" role="alert" aria-live="assertive" aria-atomic="true">
            <div class="toast-body">
                <h6 class="fw-bold">Alert</h6>
                <p>Item has been updated</p>
                <div class="d-flex justify-content-end">
                    <button class="btn p-0 fw-bold" type="button" data-bs-dismiss="toast" aria-label="Close">Dismiss</button>
                </div>
            </div>
        </div>
    </div>
    <div class="container">
        <div class="row">
            <%@include file="elements/slidebar.jsp"%>
            <div class="col-9 pt-5 ps-5 border-start" style="min-height: 90vh;">
        <c:choose>
            <c:when test="${requestScope.quiz != null}">
                  <div class="row w-100 gy-3">
                        <div class="col-12">
                            <h5 class="fw-bold pb-2">Quiz</h5>
                            <input type="text" class="form-control ps-0 pe-0 fw-bold" placeholder="Enter a title"
                                   required minlength="4" maxlength="256" value="${requestScope.quiz.title}" id="title">
                        </div>
                        <div class="col-12">
                            <div class="btn-group-vertical w-100" role="group">
                                <button class="w-100 btn p-4 border fw-bold text-start position-relative"
                                        onclick="window.open('../quiz/manage?id=${quiz.id}')" id="editor-activator-btn">
                                            Manage questions
                                        <div class="position-absolute top-0 end-0 p-4">
                                            <ion-icon class="fs-5" name="add-sharp"></ion-icon>
                                        </div>
                                    </button>
                                <div class="btn p-0 border w-100">
                                    <button class="w-100 btn p-4 fw-bold text-start position-relative"
                                        onclick="callTextEditor()" id="editor-activator-btn">
                                            Description
                                        <div class="position-absolute top-0 end-0 p-4">
                                            <ion-icon class="fs-5" name="add-sharp"></ion-icon>
                                        </div>
                                    </button>
                                    <div class="pt-2 text-start d-none" id="text-editor">
                                        <div id="quill-editor" style="min-height: 40vh;">
                                            ${requestScope.quiz.description}
                                        </div>
                                        
                                    </div>
                                    
                                </div>
                            </div>
                        </div>  
                        <div class="col-12">
                            <div class="d-flex justify-content-end">
                                <button class="btn text-danger fw-bold" type="button" 
                                        data-bs-toggle="modal" data-bs-target="#confirmee">
                                    Delete
                                </button>
                                <button class="btn text-primary fw-bold" type="button" 
                                        onclick="modifyQuiz()">
                                    Save changes
                                </button>
                            </div>
                        </div>
                    </div>            
            </c:when>
            <c:when test="${requestScope.lesson != null}">
                <div class="row w-100 gy-3">
                        <div class="col-12">
                            <h5 class="fw-bold pb-2">Lesson</h5>
                            <input type="text" class="form-control ps-0 pe-0 fw-bold" placeholder="Enter a title"
                                   required minlength="4" maxlength="256" value="${requestScope.lesson.name}" id="title">
                        </div>
                        <div class="col-12">
                            <div class="btn-group-vertical w-100" role="group">
                                <div class="btn p-0 border w-100">
                                    <button class="w-100 btn p-4 fw-bold text-start position-relative"
                                        onclick="callVideoUploader()">
                                        Watching content
                                        <div class="position-absolute top-0 end-0 p-4">
                                            <ion-icon class="fs-5" name="add-sharp"></ion-icon>
                                        </div>
                                    </button>
                                    <div <c:if test="${requestScope.lesson.video == null}"> class="d-none"</c:if>>
                                        <div class="row p-4 text-start">
                                            <div class="col-5">
                                                <div class="card">
                                                    <div class="card-body p-0">
                                                        <div class="ratio ratio-21x9 rounded-top-2 bg-light border-bottom">
                                                           <img src="
                                                        <c:if test="${requestScope.lesson.video.type.startsWith('video/')}">
                                                            https://drive.google.com/thumbnail?id=${requestScope.lesson.video.path}      
                                                        </c:if>
                                                        <c:if test="${!requestScope.lesson.video.type.startsWith('video/')}">
                                                            ../view/assets/images/package.png
                                                        </c:if>
                                                           " class="w-100 rounded-top-2">
                                                        </div>
                                                        <div class="p-3">
                                                            <h6 class="fw-bold">${requestScope.lesson.video.name}</h6>
                                                            <span>Extension: ${requestScope.lesson.video.type}</span>
                                                        </div>

                                                    </div>
                                                </div>
                                            </div>
                                            <div class="col-7">
                                                <h6 class="fw-bold">Interactions<button class="btn p-0 text-primary ps-3" type="button" onclick="openHyperLink('add-interaction?lesson=${requestScope.lesson.id}')"><ion-icon name="add-circle-sharp"></ion-icon></button></h6>
                                                <div class="row p-2 gy-3" style="height: 27vh; overflow-y: auto;">
                                           <c:if test="${requestScope.interactionList.isEmpty()}">
                                               <p class="text-center pt-5">No results found.
                                                   <button class="btn fw-bold text-primary p-0" type="button"
                                                           onclick="openHyperLink('add-interaction?lesson=${requestScope.lesson.id}')">Add questions</button></p>
                                           </c:if>
                                           <c:if test="${!requestScope.interactionList.isEmpty()}">
                                                <c:forEach items="${requestScope.interactionList}" var="interaction">
                                                    <div class="col-12">
                                                        <div class="d-flex justify-content-start">
                                                            <h5 class="m-0"><span
                                                                    class="badge text-bg-warning rounded-0 rounded-top-2">${interaction.getFormatedTime()}</span>
                                                            </h5>
                                                            <div class="text-truncate w-75">
                                                                <h6 class="fw-bold ps-2 pt-1 m-0">${interaction.question.content}</h6>
                                                            </div>
                                                        </div>
                                                    <c:forEach items="${interaction.question.answers}" var="answer">
                                                        <c:if test="${answer.correctless}">
                                                            <div class="p-3 pb-2 rounded-2 bg-light"
                                                            style="border-top-left-radius: unset !important;">
                                                            <input class="form-check-input" type="radio" checked="true">
                                                            <label class="ps-1 w-75 text-truncate">${answer.content}<label>
                                                            </div>
                                                        </c:if>  
                                                    </c:forEach>        
                                                    </div>
                                                </c:forEach>
                                            </c:if>
                                                </div>
                                            </div>

                                        </div>
                                    </div>
                                    <div class="p-4 d-none" id="video-uploader">
                                        <form action="upload-video" method="post"" enctype="multipart/form-data" id="video-form">
                                            <input type="hidden" name="url" value="curriculum?id=${param.id}&section=${param.section}&lesson=${requestScope.lesson.id}"/>
                                            <input type="hidden" name="lesson" value="${requestScope.lesson.id}"/>
                                            <input class="d-none" type="file" name="package" id="video"
                                                   accept="video/*, application/x-zip-compressed, .h5p" onchange="submitForm()" required>
                                            <input type="hidden" name="duration" id="duration" value="0"/>
                                            <label class="btn text-center w-100 pt-5 pb-5 rounded-2"
                                                style="border: 3px dashed whitesmoke" for="video">
                                                <span class="btn btn-primary fw-bold mb-3">
                                                Browse files
                                                </span>
                                                <p>Your videos will be private until you publish them.<br>
                                                   We also support <a class="btn btn-base text-primary fw-bold" href="">SCORM</a> and <a class="btn btn-base text-primary fw-bold" href="">H5P</a> package.</p>
                                            </label>
                                        </form>    
                                    </div>
                                            

                                </div>
                                <div class="btn p-0 border w-100">
                                    <button class="w-100 btn p-4 fw-bold text-start position-relative"
                                        onclick="callTextEditor()" id="editor-activator-btn">
                                            Reading content
                                        <div class="position-absolute top-0 end-0 p-4">
                                            <ion-icon class="fs-5" name="add-sharp"></ion-icon>
                                        </div>
                                    </button>
                                    <div class="pt-2 text-start d-none" id="text-editor">
                                        <div id="quill-editor" style="min-height: 40vh;">
                                            ${requestScope.lesson.readingContent}
                                        </div>
                                        
                                    </div>
                                    
                                </div>
                            </div>                                    
                        </div>
                        <div class="col-12">
                            <div class="d-flex justify-content-end">
                                <button class="btn text-danger fw-bold" type="button" 
                                        data-bs-toggle="modal" data-bs-target="#confirmee">
                                    Delete
                                </button>
                                <button class="btn text-primary fw-bold" type="button" 
                                        onclick="modifyLesson()">
                                    Save changes
                                </button>
                            </div>
                        </div>
                </div>
            </c:when>
            <c:when test="${requestScope.section != null}">
                <form onsubmit="createItem(); return false;" id="item-form">
                        <div class="row p-2 g-3">
                            <div class="col-12 pb-3">
                                <h6 class="fw-bold">Item</h6>
                                <input type="text" class="form-control ps-0 pe-0 fw-bold" placeholder="Enter a title"
                                    required minlength="4" maxlength="256" id="title">
                            </div>
                            <div class="col-12">
                                <div class="btn-group-vertical w-100" role="group">
                                    <div class="btn border position-relative p-0" style="padding: 0.8rem;">
                                        <div class="position-absolute top-0 end-0 p-4">
                                            <input class="form-check-input" type="radio" value="lesson" id="lesson" name="item" required>
                                        </div>
                                        <label class="w-100 text-start p-4" for="lesson">
                                            <h6 class="fw-bold">
                                                Lesson
                                            </h6>
                                        </label>
                                    </div>
                                    <div class="btn border position-relative p-0" style="padding: 0.8rem;">
                                        <div class="position-absolute top-0 end-0 p-4">
                                            <input class="form-check-input" type="radio" value="quiz" id="quiz" name="item" required>
                                        </div>
                                        <label class="w-100 text-start p-4" for="quiz">
                                            <h6 class="fw-bold">
                                                Quiz
                                            </h6>
                                        </label>
                                    </div>
                                </div>
                            </div>
                            <div class="col-12 d-flex justify-content-end">
                                <button class="btn fw-bold" type="button" onclick="openHyperLink('curriculum?id=${param.id}')">
                                    Cancel
                                </button>
                                <button class="btn text-primary fw-bold" type="submit">
                                    Create
                                </button>
                            </div>
                        </div>
                    </form>
            </c:when>
            <c:when test="${requestScope.course != null}">
                    <h5 class="fw-bold pb-2">Curriculum</h5>
                    <div class="row p-2 btn-group-vertical w-100" role="group">
                    <c:set var="sectionCount" value="0"></c:set>
                    <c:set var="lessonCount" value="0"></c:set>
                    <c:set var="quizCount" value="0"></c:set>
                    <c:forEach items="${requestScope.course.sectionList}" var="section">
                        <details class="btn w-12 border p-0 text-start section" id="section-${section.id}" style="background-color: whitesmoke;">
                            <div class="p-4 rounded-2 d-none" style="background-color: white" id="modifier">
                                <form onsubmit="modifySection(${section.id}); return false;" >
                                    <div class="input-group p-0">
                                        <h6 class="input-group-text fw-bold p-0 pt-2 pe-3">Section ${sectionCount + 1}</h6>
                                    <input type="text" class="form-control fw-bold p-0"
                                           placeholder="Enter a title" id="title" required minlength="4" maxlength="256" value="${section.title}">
                                </div>
                                <div class="col-12 pt-2 d-flex justify-content-end">
                                    <button class="btn fw-bold" type="button" onclick="callSectionModifier(${section.id})">
                                        Cancel
                                    </button>
                                    <button class="btn text-primary fw-bold" type="submit"
                                            onclick="modifySection(${section.id})">
                                        Save
                                    </button>
                                </div>
                            </form>
                            </div>
                            
                            <summary class="p-4 w-100 position-relative tab">
                                <h6 class="fw-bold">
                                    <ion-icon class="fs-6" name="chevron-forward-sharp"></ion-icon>
                                    Section ${sectionCount + 1}: ${section.title}
                                </h6>
                                <div class="position-absolute top-0 end-0 p-4 subtab" style="transform: translateX(80%); z-index: 11;">
                                    <div class="dropdown drop-end">
                                        <button class="btn p-0" type="button" data-bs-toggle="dropdown" aria-expanded="false">
                                            <ion-icon name="ellipsis-vertical-sharp"></ion-icon>
                                        </button>
                                        <div class="dropdown-menu dropdown-menu-end" style="z-index: 11;">
                                            <button class="dropdown-item" type="button"<c:if test="${section.visibility}">onclick="setSectionState(${section.id}, 0)">
                                                    Unpublish</c:if><c:if test="${!section.visibility}">onclick="setSectionState(${section.id}, 1)">
                                                    Publish</c:if>
                                            </button>
                                            <button class="dropdown-item" type="button" onclick="callSectionModifier(${section.id})">
                                                Modify
                                            </button>
                                            <button class="dropdown-item" type="button" data-bs-toggle="modal" data-bs-target="#confirmee" onclick="openConfirmee(${section.id})">
                                                Delete
                                            </button>
                                        </div>
                                    </div>

                                </div>
                            </summary>
                        <c:forEach items="${section.itemList}" var="item">
                            <c:if test="${item.getClass().getName() == 'model.Lesson'}">
                            <div class="border-top p-4 position-relative lesson" style="background-color: white;"
                                 onclick="openHyperLink('curriculum?id=${requestScope.course.id}&section=${section.id}&lesson=${item.id}')">
                                <div class="ps-5">
                                    <h6 class="fw-bold">Lesson ${lessonCount + 1}: ${item.name}</h6>
                                </div>
                                <div class="position-absolute end-0 p-4" style="transform: translateY(-70%);">
                                    <ion-icon name="chevron-forward-sharp"></ion-icon>
                                </div>
                            </div>
                                <c:set var="lessonCount" value="${lessonCount + 1}"></c:set>
                                </c:if>
                            <c:if test="${item.getClass().getName() == 'model.Quiz'}">
                                <div class="border-top p-4 position-relative quiz" style="background-color: white;"
                                onclick="openHyperLink('curriculum?id=${requestScope.course.id}&section=${section.id}&quiz=${item.id}')">
                                <div class="ps-5">
                                    <h6 class="fw-bold">Quiz ${quizCount + 1}: ${item.title}</h6>
                                </div>
                                <div class="position-absolute end-0 p-4" style="transform: translateY(-70%);">
                                    <ion-icon name="chevron-forward-sharp"></ion-icon>
                                </div>
                            </div>
                            <c:set var="quizCount" value="${quizCount + 1}"></c:set>
                            </c:if>    
                        </c:forEach>
                            <div class="border-top" id="item-btn">
                                <button class="w-100 btn rounded-0 p-4 position-relative text-start" style="background-color: white;"
                                        onclick="openHyperLink('curriculum?id=${requestScope.course.id}&section=${section.id}')">
                                    <h6 class="ps-5 fw-bold">Add new items</h6>
                                    <div class="position-absolute top-0 end-0 p-4">
                                        <ion-icon class="fs-5" name="add-sharp"></ion-icon>
                                    </div>
                                </button>
                            </div>
                           
                        </details>
                            <c:set var="sectionCount" value="${sectionCount + 1}"></c:set>
                    </c:forEach>
                        <div class="btn w-100 text-start border fw-bold p-0">
                            <button class="w-100 btn p-4 position-relative text-start section-phrase" style="background-color: white;"
                                    onclick="callSectionCreator()">
                                    <h6 class="fw-bold">Add new sections</h6>
                                    <div class="position-absolute top-0 end-0 p-4">
                                        <ion-icon class="fs-5" name="add-sharp"></ion-icon>
                                    </div>
                           </button>
                            <div class="section-phrase d-none p-4">
                                <form onsubmit="createSection(); return false;" id="section-form">
                                    <div class="input-group p-0">
                                        <h6 class="input-group-text fw-bold p-0 pt-2 pe-3">Section ${sectionCount + 1}</h6>
                                    <input type="text" class="form-control fw-bold p-0"
                                           placeholder="Enter a title" id="section" required minlength="4" maxlength="256">
                                </div>
                                <div class="col-12 pt-2 d-flex justify-content-end">
                                    <button class="btn fw-bold" type="button" onclick="callSectionCreator()">
                                        Cancel
                                    </button>
                                    <button class="btn text-primary fw-bold" type="submit">
                                        Create
                                    </button>
                                </div>
                            </form>
                                
                            </div>
                        </div>
                </c:when>
            </c:choose>
                        
                    </div>
                </div>
            </div>
        </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"
        integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz"
        crossorigin="anonymous"></script>
    <script type="module" src="https://unpkg.com/ionicons@7.1.0/dist/ionicons/ionicons.esm.js"></script>
    <script nomodule src="https://unpkg.com/ionicons@7.1.0/dist/ionicons/ionicons.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/quill@2.0.2/dist/quill.js"></script>
    <script type="text/javascript" src="../view/assets/js/base.js"></script>
    <script>
    const toastBootstrap = bootstrap.Toast.getOrCreateInstance(toast);
    
    <c:choose>
        <c:when test="${requestScope.quiz != null}">
            const quill = new Quill('#quill-editor', {
            theme: 'snow'
        });
            function modifyQuiz() {
                var xhttp = new XMLHttpRequest();
                xhttp.onreadystatechange = function() {
                    if (this.readyState == 4 && this.status == 200) {
                        toastBootstrap.show();
                    }
                };
                var title = document.getElementById('title').value;
                var content =  quill.root.innerHTML;
                var jsonData = JSON.stringify({item: ${param.quiz}, type: 'quiz', title : title, content: content});
                xhttp.open("post", "update-item", true);
                xhttp.setRequestHeader('Content-Type', 'application/json');
                xhttp.send(jsonData);
            }
            function deleteQuiz() {
            var xhttp = new XMLHttpRequest();
            xhttp.onreadystatechange = function() {
                if (this.readyState == 4 && this.status == 200) {
                    openHyperLink('curriculum?id=${param.id}');
                }
            };
            
            xhttp.open("get", "update-item?type=quiz&id=" + ${requestScope.quiz.id}, true);
            xhttp.send();
        }  
        function callTextEditor() {
            const textEditor = document.querySelector('#text-editor');
            textEditor.classList.toggle('d-none');
        }
        
            <c:if test="${requestScope.quiz.description != null}">
            callTextEditor();                        
            </c:if>
        </c:when>
        <c:when test="${requestScope.lesson != null}">
        const quill = new Quill('#quill-editor', {
            theme: 'snow'
        });
        
        function modifyLesson() {
            var xhttp = new XMLHttpRequest();
            xhttp.onreadystatechange = function() {
                if (this.readyState == 4 && this.status == 200) {
                    toastBootstrap.show();
                }
            };
            var title = document.getElementById('title').value;
            var content =  quill.root.innerHTML;
            var jsonData = JSON.stringify({item: ${param.lesson}, type: 'lesson', title : title, content: content});
            xhttp.open("post", "update-item", true);
            xhttp.setRequestHeader('Content-Type', 'application/json');
            xhttp.send(jsonData);
        }
        function callVideoUploader() {
            const videoUploader = document.querySelector('#video-uploader');
            videoUploader.classList.toggle('d-none');
        }

        function callTextEditor() {
            const textEditor = document.querySelector('#text-editor');
            textEditor.classList.toggle('d-none');
        }
        
        function submitForm() {
            const file = document.getElementById('video').files[0];
            if (file) {
                if (file.type.startsWith('video/')) {
                    
                    const video = document.createElement('video');
                    video.preload = 'metadata';
                    video.onloadedmetadata = function() {
                        window.URL.revokeObjectURL(video.src);
                        const duration = video.duration;
                        document.getElementById('duration').value = video.duration;
                        document.getElementById('video-form').submit();
                    };
                    video.src = URL.createObjectURL(file);
                } else {
                 document.getElementById('video-form').submit();
                }
            }
        }
        
        function deleteLesson() {
            var xhttp = new XMLHttpRequest();
            xhttp.onreadystatechange = function() {
                if (this.readyState == 4 && this.status == 200) {
                    openHyperLink('curriculum?id=${param.id}');
                }
            };
            
            xhttp.open("get", "update-item?type=lesson&id=" + ${requestScope.lesson.id}, true);
            xhttp.send();
        }         
        <c:if test="${requestScope.lesson.readingContent != null}">
            callTextEditor();                        
        </c:if>
        </c:when>
        <c:when test="${requestScope.section != null}">
            function createItem() {
            var xhttp = new XMLHttpRequest();
            var form = document.getElementById('item-form');
            xhttp.onreadystatechange = function() {
                if (this.readyState == 4 && this.status == 200) {
                    var jsonObject = JSON.parse(this.responseText);
                    window.location.href= 'curriculum?id=${param.id}&section=${param.section}&' + jsonObject.type + '=' +jsonObject.id;
                }
            };
            var item = form.querySelector('input[name="item"]:checked').value;
            var title = form.querySelector('#title').value;
            var jsonData = JSON.stringify({section: ${param.section}, item: item, title: title});
            xhttp.open("post", "add-item", true);
            xhttp.setRequestHeader('Content-Type', 'application/json');
            xhttp.send(jsonData);
            }
        </c:when>
    </c:choose>
        function callSectionCreator() {
            const sectionPhrase = document.querySelectorAll('.section-phrase');
            sectionPhrase.forEach(element => {
                element.classList.toggle('d-none');
            });
        }

        function createSection() {
            var xhttp = new XMLHttpRequest();
            var form = document.getElementById('section-form');
            xhttp.onreadystatechange = function () {
                if (this.readyState == 4 && this.status == 200) {
                    window.location.reload();
                }
            };
            var section = form.querySelector('#section').value;
            var jsonData = JSON.stringify({ course: ${param.id}, section: section });
            xhttp.open("post", "add-section", true);
            xhttp.setRequestHeader('Content-Type', 'application/json');
            xhttp.send(jsonData);
        }
        
        function callSectionModifier(e) {
            const section = document.getElementById('section-' + e);
            
            section.open = 'true';
            section.querySelector('#item-btn').classList.toggle('d-none');
            section.querySelector('#modifier').classList.toggle('d-none');
            section.querySelector('summary').classList.toggle('d-none');
            section.querySelectorAll(".lesson").forEach(lesson => {
                lesson.classList.toggle('d-none');
            });
            
            section.querySelectorAll(".quiz").forEach(quiz => {
                quiz.classList.toggle('d-none');
            });
        }
        
        function modifySection(e) {
            var xhttp = new XMLHttpRequest();
            xhttp.onreadystatechange = function() {
                if (this.readyState == 4 && this.status == 200) {
                    window.location.reload();
                }
            };
            var title = document.getElementById('section-' + e).querySelector('#title').value;
            var jsonData = JSON.stringify({section: e, title : title});
            xhttp.open("post", "update-section", true);
            xhttp.setRequestHeader('Content-Type', 'application/json');
            xhttp.send(jsonData);
        }
        
        function openConfirmee(e) {
            document.getElementById('confirmee-btn').onclick = () => {
                deleteSection(e);
            };
        }
        
        function deleteSection(e) {
            var xhttp = new XMLHttpRequest();
            xhttp.onreadystatechange = function() {
                if (this.readyState == 4 && this.status == 200) {
                    window.location.reload();
                }
            };
            
            xhttp.open("get", "update-section?id=" + e, true);
            xhttp.send();
        }
        
        function setSectionState(e, i) {
            var xhttp = new XMLHttpRequest();
            xhttp.onreadystatechange = function() {
                if (this.readyState == 4 && this.status == 200) {
                    window.location.reload();
                }
            };

            xhttp.open("get", "../section/set-state?section=" + e + "&state=" + i, true);
            xhttp.send();
        }  
        document.getElementsByClassName('tab')[2].classList.add('here');
        document.getElementsByClassName('tab')[2].classList.add('btn-light');
    </script>
</body>

</html>
