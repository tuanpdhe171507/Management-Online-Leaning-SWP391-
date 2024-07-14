<%-- 
    Document   : course-page
    Created on : Jun 14, 2024, 11:10:02 PM
    Author     : HieuTC
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%@ page import="dao.UserContext" %>
<%@ page import="model.User" %>
<%@ page import="model.Quiz" %>
<!doctype html>
<html lang="en">

    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>${requestScope.course.name} | EduPort</title>
        <link href="../view/assets/css/hieutc.css" rel="stylesheet" />
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"
              integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous" />
        <link href="https://cdn.jsdelivr.net/npm/quill@2.0.2/dist/quill.snow.css" rel="stylesheet">
        <script src="https://cdnjs.cloudflare.com/ajax/libs/progressbar.js/1.0.1/progressbar.min.js"></script>
        <style>
            input.form-check-input:checked {
                border-color: black;
                background-color: black;
            }

            input.form-check-input:disabled {
                opacity: unset;

            }

            .here {
                border-left: 3px solid black;
                background-color: whitesmoke;
            }

            button.btn:focus {
                border-color: white !important;
            }

            button.btn-base {
                color: rgb(0, 105, 255);
            }

            .ql-toolbar {
                border-radius: 0.5rem 0.5rem 0 0;
            }

            #quill-editor {
                border-radius: 0 0 0.5rem 0.5rem;
            }

            #video-container {
                position: relative;
            }

            #video-controller {
                position: absolute;
                bottom: 0;
                width: 100%;
                height: fit-content;
            }

            .video-insider {
                position: absolute;
                width: 100%;
                height: 100%;
                background-color: rgba(0, 0, 0, 0.3);
                z-index: 22;
                padding: 2rem;
            }

            #video-progress {
                transform: translateY(70%);
                width: 100%;
                border-radius: unset !important;
                border: unset !important;
            }

            #video-progress:hover, #video-progress:focus {
                cursor: pointer;
            }

            #video-progress::-webkit-slider-runnable-track {
                height: 0.27rem;
                border: unset !important;
                border-radius: unset !important;
            }

            #video-progress::-webkit-slider-thumb {
                transform: translateY(5%);
                height: 0.7rem;
                width: 0.7rem;
                background-color: black;
                box-shadow: unset;
                border: unset;
            }

            #video-progress::-webkit-slider-thumb:focus {
                box-shadow: unset;
            }

            #video-progress::-webkit-slider-thumb:hover {
                cursor: pointer;
            }

            .note-label {
                transform: translateY(22%);
            }

            .question-label {
                transform: translateY(24%);
            }

            #current-time, #duration {
                background-color: unset;
            }

            .btn:disabled {
                border-color: white;
            }

            .btn.p-0 {
                border: unset !important;
            }

            .btn.p-0:focus {
                border: unset !important;
            }
        </style>
    <head>
    <body>
        <div class="container-fluid border-bottom">
            <nav class="navbar">
                <div class="container-fluid p-2">
                    <div class="w-100 d-flex justify-content-between">
                        <h6 class="fw-bold pt-2">${requestScope.course.name}</h6>
                        <div>
                            <div class="d-inline-block" id="progress" style="width: 2rem;"></div>
                        </div>

                    </div>
                </div>
            </nav>
        </div>
        <%UserContext userContext =  new UserContext();
        request.setAttribute("userContext", userContext);%>
        <div class="container-fluid">
            <div class="row">
                <div class="col-9 p-0 border-end" id="main" style="min-height: 90vh;">
                    <c:choose>
                        <c:when test="${requestScope.lesson != null}">
                            <c:set var="localLesson" value="${requestScope.lesson}"></c:set>
                            <c:choose>
                                <c:when test="${localLesson.type.type == 'watching'}">
                                    <c:choose>
                                        <c:when test="${localLesson.video.type == 'H5P'}">            
                                            <div class="border-bottom" id='h5p-container'>
                                            </div>
                                        </c:when>
                                        <c:when test="${localLesson.video.type == 'SCORM'}"> 
                                            <div>
                                                <iframe id="iframe" class="w-100" height="720" src="../uploads/${localLesson.video.path}/index.html">   
                                                </iframe>
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="ratio ratio-21x9 border-bottom" id="video-container">    
                                                <video id="video">
                                                   <source src="video?id=${localLesson.video.path}" type="video/mp4">
                                                   
                                                </video>   
                                                <div class="position-absolute top-0 d-flex justify-content-center align-items-center" id="loading">
                                                    <div class="spinner-border" role="status">
                                                        <span class="visually-hidden">Loading...</span>
                                                    </div> 
                                                </div>
                                                <div id="insiders">
                                                    <c:forEach items="${requestScope.interactionList}" var="interaction">
                                                        <fmt:formatNumber type="number" maxFractionDigits="0" value="${Math.floor(interaction.atTime)}" var="localNumber"></fmt:formatNumber>
                                                        <div class="video-insider insider-${interaction.position} d-none question" id="interaction-at-${localNumber}">
                                                            <div class="insider-${interaction.size} position-relative">
                                                                <h5 class="fw-bold pb-4">Question</h5>
                                                                <form onsubmit="checkAnswer(${interaction.question.id}); return false;" id="question-${interaction.question.id}">
                                                                    <div class="insider-body w-100">
                                                                        <p>${interaction.question.content}</p>
                                                                        <c:forEach items="${interaction.question.answers}" var="answer">
                                                                            <c:if test="${answer.correctless}">
                                                                                <input type="hidden" name="correct-answer" value="${answer.id}">
                                                                            </c:if>
                                                                            <div class="form-check pb-2">
                                                                                <input class="form-check-input" type="radio" name="answer" value="${answer.id}" id="${answer.id}" required/>
                                                                                <label class="form-check-label" for="${answer.id}">
                                                                                    ${answer.content}
                                                                                </label>
                                                                            </div> 
                                                                        </c:forEach>
                                                                    </div>
                                                                    <div class="position-absolute bottom-0 end-0 d-flex justify-content-end p-3">
                                                                        <button class="btn fw-bold" type="button" onclick="skipQuestion(${localNumber})">Skip</button>
                                                                        <button class="btn text-primary fw-bold" type="submit" id="btn">Submit</button>
                                                                    </div>
                                                                </form> 
                                                            </div>
                                                        </div> 
                                                    </c:forEach>
                                                    <c:if test="${!requestScope.interactionList.isEmpty()}">
                                                        <fmt:formatNumber type="number" maxFractionDigits="0" value="${Math.floor(requestScope.lesson.video.time)}" var="localNumber"></fmt:formatNumber>
                                                        <div class="video-insider insider-center question d-none" id="interaction-at-${localNumber}">
                                                            <div class="insider-large position-relative">
                                                                <h5 class="fw-bold pb-4">Summary</h5>
                                                                <div class="insider-body d-flex justify-content-center align-items-center">
                                                                    <div class="row w-100">
                                                                        <div class="col-3">
                                                                            <canvas class="w-100 h-auto" id="pie"></canvas>
                                                                        </div>
                                                                        <div class="col-9 d-flex align-items-center">
                                                                            <div id="summary">
                                                                                <h6 class="fw-bold"><span id="correct">0</span> correct answers per <span id="selected">0</span> selected answers</h6>
                                                                                <c:forEach items="${requestScope.interactionList}" var="interaction">
                                                                                    <div class="form-check">
                                                                                        <input class="form-check-input" value="0" type="radio" disabled="true" id="q${interaction.question.id}"/>
                                                                                        <label class="text-truncate text-secondary" for="q${interaction.question.id}">
                                                                                            ${interaction.getFormatedTime()} - ${interaction.question.content}
                                                                                        </label>
                                                                                    </div>
                                                                                </c:forEach>     
                                                                            </div>

                                                                        </div>
                                                                    </div>

                                                                </div>
                                                                <div class="position-absolute bottom-0 end-0 d-flex justify-content-end p-3">
                                                                    <button class="btn fw-bold" type="button" onclick="skipQuestion(${localNumber})">Dismiss</button>
                                                                </div>
                                                                </form> 
                                                            </div>
                                                        </div> 
                                                    </c:if>
                                                </div>
                                                <div>         
                                                    <div id="video-controller" class="p-3 d-none">
                                                        <div class="position-relative">
                                                            <input type="range" class="form-range" value="0" onfocus="pauseVideo();" onchange="setVideoTime(this.value); document.getElementById('video-progress').blur(); playVideo();"
                                                                   step="1" id="video-progress"/>
                                                            <div>
                                                                <c:forEach items="${requestScope.interactionList}" var="interaction">
                                                                    <div class="position-absolute top-0 left-0 question-label" id="label-interaction-${interaction.id}" style="left: ${interaction.atTime * 100 / lesson.video.time}%;">
                                                                        <button class="btn p-0" type="button" onclick="setVideoTime(${interaction.atTime})">
                                                                            <ion-icon class="text-success p-0" name="caret-down-sharp"></ion-icon>
                                                                        </button>
                                                                    </div>
                                                                </c:forEach>
                                                            </div>
                                                            <div id="video-labels">

                                                            </div>

                                                        </div>
                                                        <div class="w-100 d-flex justify-content-between pt-3">
                                                            <div class="p-0">
                                                                <button class="btn p-0" type="button" onclick="callVideo()">
                                                                    <ion-icon class="fs-5" name="play-sharp" id="video-state"></ion-icon>
                                                                </button>

                                                            </div>
                                                            <div class="p-0">
                                                                <span class="fw-bold" id="current-time">0:00</span>
                                                                <span>/</span>
                                                                <span class="fw-bold" id="duration"></span>
                                                                <button class="btn p-0 ps-2" type="button" onclick="openLargeScreen()">
                                                                    <ion-icon class="fs-5" name="resize-sharp"></ion-icon>
                                                                </button>
                                                            </div>
                                                        </div>
                                                    </div>

                                                </div>
                                            </div>
                                        </c:otherwise>

                                    </c:choose>
                                    <div class="container" style="width: 50rem;">
                                        <div class="pb-3">
                                            <button class="btn fs-6 fw-bold p-3 rounded-0 content-tab <c:if test="${requestScope.lesson.readingContent == null}">
                                                    d-none
                                                </c:if>" type="button"
                                                onclick="showContent(0)">
                                                Reading content
                                            </button>
                                            <button class="btn fs-6 fw-bold p-3 rounded-0 content-tab<c:if test="${requestScope.lesson.video.type != 'video/mp4'}">
                                                    d-none
                                                </c:if>" type="button"
                                                onclick="showContent(1)">
                                                Notes
                                            </button>
                                        </div>
                                        <div class="content-page">
                                            ${localLesson.readingContent}
                                        </div>
                                        <div class="content-page">
                                            <div class="d-block pb-3 d-none" id="note-creator">
                                                <div class="row">
                                                    <div class="col-1">
                                                        <h5><span class="badge text-bg-warning" id="time-tag"></span></h5>
                                                    </div>
                                                    <div class="col-11">
                                                        <input type="hidden" type="text" id="time-real"/>
                                                        <div class="fs-6" id="quill-editor" style="height: fit-content;">

                                                        </div>
                                                    </div>
                                                    <div class="col-12 d-flex justify-content-end pt-2">
                                                        <button class="btn" type="button" onclick="cancelNoteCreator()">
                                                            Cancel
                                                        </button>
                                                        <button class="btn fw-bold text-success" type="button"
                                                                onclick="takeNote();" id="creator-btn">
                                                            Save note
                                                        </button>
                                                    </div>
                                                </div>
                                            </div>
                                            <button class="btn p-3 fw-bold border w-100 text-start position-relative mb-3" type="button" id="note-creator-btn"
                                                    onclick="openNoteCreator()">
                                                Add a new note at <input class="form-control fw-bold text-secondary p-0 border-0 d-inline-block" 
                                                                         value="0.00" name="time" readonly id="time"
                                                                         style="width: fit-content;">
                                                <div class="position-absolute top-0 end-0 p-3">
                                                    <ion-icon class="fs-5" name="add-sharp"></ion-icon>
                                                </div>
                                            </button>
                                            <div class="dropdown d-inline-block">
                                                <button class="btn p-3 fw-bold border text-start" type="button"
                                                        data-bs-toggle="dropdown" aria-expanded="false" id="query">
                                                    This lesson <ion-icon class="fs-6" name="chevron-down-sharp"></ion-icon>
                                                </button>
                                                <div class="dropdown-menu">
                                                    <button class="btn dropdown-item" onclick="loadAllLesson()">All lesson</button>
                                                    <button class="btn dropdown-item" onclick="loadThisLesson()">This lesson</button>
                                                </div>
                                            </div>
                                            <div class="dropdown d-inline-block ms-2">
                                                <button class="btn p-3 fw-bold border text-start" type="button"
                                                        data-bs-toggle="dropdown" aria-expanded="false" id="sort">
                                                    Sort by most recent 
                                                </button>
                                                <div class="dropdown-menu">
                                                    <button class="btn dropdown-item" onclick="loadMostRecent()">Sort by most recent</button>
                                                    <button class="btn dropdown-item" onclick="loadOldest()">Sort by oldest</button>
                                                </div>
                                            </div>
                                            <div class="row pt-3 pb-3 g-3" id="notes">

                                            </div>
                                        </div>
                                    </div>     
                                </c:when>
                                <c:when test="${localLesson.type.type == 'reading'}">
                                    <div class="container pt-5 pb-5" style="width: 50rem;">
                                        <h5 class="fw-bold">${localLesson.name}</h5>
                                        <p>${localLesson.readingContent}</p>
                                        <div class="w-100 d-flex justify-content-end">
                                            <button class="btn btn-primary fw-bold p-2" id="mark-btn" onclick="markAsCompleted()" <c:if test="${requestScope.userContext.isStudied(sessionScope.user.email, localLesson.id)}">disabled</c:if>>
                                                    Mark as completed
                                                </button>
                                            </div>
                                        </div>
                                </c:when>
                            </c:choose>
                        </c:when>
                        <c:when test="${requestScope.quiz != null}">
                            <c:set var="localQuiz" value="${requestScope.quiz}" ></c:set>
                                <div class="container pt-5 pb-5" style="width: 50rem;">
                                    <h5 class="fw-bold">${localQuiz.title}</h5>
                                <p>${localQuiz.description}</p>
                                <div class="w-100 pt-3 pb-3 border-bottom">
                                    <div class="row">
                                        <div class="col-8">
                                            <c:if test="${requestScope.quizSession == null}">
                                                <h6 class="fw-bold text-secondary">Not yet</h6>
                                                <span>Lastest submited None</span>
                                            </c:if>
                                            <c:if test="${requestScope.quizSession != null}">
                                                <c:if test="${requestScope.userContext.isPassed(sessionScope.user.email, localQuiz.id)}">
                                                    <h6 class="fw-bold text-success">Passed</h6>
                                                </c:if>
                                                <c:if test="${!requestScope.userContext.isPassed(sessionScope.user.email, localQuiz.id)}">
                                                    <h6 class="fw-bold text-danger">Not passed</h6>
                                                </c:if>
                                                <span>Lastest submited ${requestScope.quizSession.getDoneTimeDate()}</span>
                                            </c:if>

                                        </div>
                                        <div class="col-4 d-flex justify-content-end">
                                            <button class="btn btn-primary fw-bold" onclick="openHyperLink('http://localhost:8080/SWP391/takequiz?id=${localQuiz.id}&course=${requestScope.course.id}&section=${param.section}')">
                                                <c:if test="${requestScope.userContext.isPassed(sessionScope.user.email, localQuiz.id)}">
                                                    Retake quiz
                                                </c:if>
                                                <c:if test="${!requestScope.userContext.isPassed(sessionScope.user.email, localQuiz.id)}">
                                                    Take quiz
                                                </c:if>

                                            </button>
                                        </div>
                                    </div>
                                </div>
                                <div class="w-100 pt-3 pb-3 border-bottom">
                                    <div class="row">
                                        <div class="col-8">
                                            <h6 class="fw-bold">Pass target</h6>
                                            <span>${quiz.passedTarget}% or higher</span>
                                        </div>
                                        <div class="col-4">
                                            <h6 class="fw-bold">Your grade</h6>
                                            <c:if test="${requestScope.quizSession == null}">
                                                <span>None</span>
                                            </c:if>
                                            <c:if test="${requestScope.quizSession != null}">
                                                <span><%=userContext.getGrade(((User)session.getAttribute("user")).getEmail(), ((Quiz)request.getAttribute("quiz")).getId())%>%</span>
                                            </c:if>
                                                <button class="btn btn-base fw-bold p-0 pt-2 d-block" onclick="openHyperLink('../quiz/review?course=${requestScope.course.id}&section=${param.section}&id=${quiz.id}')" 
                                                    <c:if test="${requestScope.quizSession == null}">disabled="true"</c:if>>
                                                        View feedback
                                                    </button>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                        </c:when>
                        <c:otherwise>
                            <div class="container pt-5 pb-5" style="width: 50rem;">
                                <h6 class="text-center">Please select an item</h6>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>

                <div class="col-3 p-0 pt-0" id="menu">
                    <c:forEach items="${requestScope.course.sectionList}" var="section">
                        <c:if test="${section.visibility}">
                            <details class="col-12" <c:if test="${section.id == param.section}">open="true"</c:if>>
                                    <summary class="btn btn-light w-100 text-start rounded-0 p-3 border-bottom">
                                        <h6 class="fw-bold">
                                            <ion-icon class="fs-6" name="chevron-forward-sharp"></ion-icon>
                                            ${section.title}
                                    </h6>
                                    <span class="fw-bold text-secondary">${section.getTotalItem()} items</span>
                                </summary>
                                <c:forEach items="${section.itemList}" var="item">
                                    <c:if test="${item.getClass().getName() == 'model.Lesson'}">
                                    <div class="btn p-3 rounded-0 w-100 text-start border-bottom  <c:if test="${param.lesson == item.id}">here</c:if>"
                                         onclick="openHyperLink('page?course=${requestScope.course.id}&section=${section.id}&lesson=${item.id}')">
                                        <h6 class="fw-bold">
                                            <ion-icon class="fs-5"
                                                      <c:if test="${requestScope.userContext.isStudied(sessionScope.user.email, item.id)}">
                                                          name="checkmark-circle-sharp"
                                                      </c:if>
                                                      <c:if test="${!requestScope.userContext.isStudied(sessionScope.user.email, item.id)}">
                                                          name="radio-button-off-sharp" 
                                                      </c:if>
                                                      id="lesson-${item.id}"></ion-icon>    
                                            ${item.name}</h6>   
                                        <span class="fw-bold text-secondary">
                                            <c:choose>
                                                <c:when test="${item.type.type == 'watching'}">
                                                    ${item.type.name}<c:if test="${item.video.time != 0}"> | ${item.video.getMinutes()} minutes</c:if>
                                                </c:when>
                                                <c:otherwise>
                                                    ${item.type.name}
                                                </c:otherwise>
                                            </c:choose>
                                        </span>               
                                    </div>
                                        </c:if>
                                    <c:if test="${item.getClass().getName() == 'model.Quiz'}">
                                        <div class="btn p-3 rounded-0 w-100 text-start border-bottom <c:if test="${param.quiz == item.id}">here</c:if>"
                                         onclick="openHyperLink('page?course=${requestScope.course.id}&section=${section.id}&quiz=${item.id}')">
                                        <h6 class="fw-bold">
                                            <c:if test="${requestScope.userContext.isPassed(sessionScope.user.email, item.id)}">
                                                <ion-icon class="fs-5" name="checkmark-circle-sharp"></ion-icon>
                                                </c:if>
                                                <c:if test="${!requestScope.userContext.isPassed(sessionScope.user.email, item.id)}">
                                                <ion-icon class="fs-5" name="radio-button-off-sharp"></ion-icon>
                                                </c:if>
                                                ${item.title}</h6>   
                                        <span class="text-secondary fw-bold">Quiz</span>               
                                    </div>
                                    </c:if>
                                </c:forEach>
                            </details>
                        </c:if>
                    </c:forEach>
                </div>
            </div>
        </div>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"
                integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz"
        crossorigin="anonymous"></script>
        <script type="module" src="https://unpkg.com/ionicons@7.1.0/dist/ionicons/ionicons.esm.js"></script>
        <script nomodule src="https://unpkg.com/ionicons@7.1.0/dist/ionicons/ionicons.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/quill@2.0.2/dist/quill.js"></script>  
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
        <script type="text/javascript" src="../view/assets/h5p-standalone/main.bundle.js"></script>
        <script>

            <c:choose>
                <c:when test="${requestScope.lesson != null}">

                                             const contentTab = document.querySelectorAll('.content-tab');
                                             const contentPage = document.querySelectorAll('.content-page');

                                             function showContent(index) {
                                                 contentTab.forEach((tab, i) => {
                                                     if (i === index) {
                                                         tab.style.borderBottom = '3px solid black';
                                                     } else {
                                                         tab.style.borderBottom = 'none';
                                                     }
                                                 });
                                                 contentPage.forEach((page, i) => {
                                                     if (i === index) {
                                                         page.style.display = 'block';
                                                     } else {
                                                         page.style.display = 'none';
                                                     }
                                                 });
                                             }
                                             var thisLesson = ${localLesson.id};
                    <c:if test="${localLesson.type.type == 'watching'}">                                                                 
                    <c:choose>
                        <c:when test="${localLesson.video.type == 'H5P'}">
                                             const el = document.getElementById('h5p-container');
                                             const options = {
                                                 h5pJsonPath: '../uploads/${localLesson.video.path}',
                                                 frameJs: '../view/assets/h5p-standalone/frame.bundle.js',
                                                 frameCss: '../view/assets/h5p-standalone/styles/h5p.css'
                                             };
                                             new H5PStandalone.H5P(el, options);
                                             showContent(0);
                                             window.onload = function() {
                                                  markAsCompleted();
                                              };
                        </c:when>
                        <c:when test="${localLesson.video.type == 'SCORM'}">
                                             document.getElementById('iframe').scrollTop = document.getElementById('iframe').scrollHeight;
                                             showContent(0);
                                             window.onload = function() {
                                                  markAsCompleted();
                                              };
                        </c:when>
                        <c:otherwise>
                            showContent(1);
                                             const video = document.getElementById('video');
                                             const currentTime = document.getElementById('current-time');
                                             const duration = document.getElementById('duration');
                                             const videoProgress = document.getElementById('video-progress');
                                             const time = document.getElementById('time');
                                             const videoLabel = document.getElementById('video-label');
                                             const videoInsider = document.getElementById('video-insider');
                                             const videoController = document.getElementById('video-controller');
                                             const videoContainer = document.getElementById('video-container');
                                             const stopTimes = [<c:forEach items="${requestScope.interactionList}" var="interaction">
                                <fmt:formatNumber type="number" maxFractionDigits="0" value="${Math.floor(interaction.atTime)}" var="localNumber"></fmt:formatNumber>
                                ${localNumber}<c:if test="${requestScope.interactionList.indexOf(interaction) != requestScope.interactionList.size() - 1}">,</c:if></c:forEach> <c:if test="${!requestScope.interactionList.isEmpty()}">
                                <fmt:formatNumber type="number" maxFractionDigits="0" value="${Math.floor(requestScope.lesson.video.time)}" var="localNumber"></fmt:formatNumber>, ${localNumber}</c:if>];

                                             

                                             function openInsider() {
                                                 videoInsider.classList.remove('d-none');
                                                 pauseVideo();
                                             }

                                             function closeInsider() {
                                                 videoInsider.classList.add('d-none');
                                                 playVideo();
                                             }


                                             var marked = false;
                                             video.addEventListener('timeupdate', function () {
                                                 setTimeout(() => {
                                                     var stopPoint = Math.floor(video.currentTime);
                                                     if (stopTimes.includes(stopPoint)) {
                                                         openQuestion(stopPoint);
                                                         pauseVideo();
                                                     }
                                                     var formatedTime = formatTime(video.currentTime);
                                                     videoProgress.value = video.currentTime;
                                                     currentTime.innerText = formatedTime;
                                                     time.value = formatedTime;
                                                 }, 1000);

                                                 if (((video.currentTime * 100 / video.duration) >= 93) && !marked) {
                                                     markAsCompleted();
                                                     marked = true;
                                                 }
                                             });

                                             function formatTime(e) {
                                                 var second = Math.floor(e % 60);
                                                 return Math.floor(e / 60) + ":" + (second < 10 ? '0' + second : second);
                                             }

                                             video.addEventListener('loadedmetadata', function () {
                                                 document.getElementById('loading').classList.add('d-none');
                                                 document.getElementById('video-controller').classList.remove('d-none');
                                                 videoContainer.addEventListener('mousemove', function () {
                                                 if (videoController.classList.contains('d-none')) {
                                                     videoController.classList.remove('d-none');
                                                 }
                                             });

                                             videoController.addEventListener('mouseenter', function () {
                                                 if (videoController.classList.contains('d-none')) {
                                                     videoController.classList.remove('d-none');
                                                 }
                                             });

                                             videoController.addEventListener('mouseleave', function () {
                                                 setTimeout(() => {
                                                     videoController.classList.add('d-none');
                                                 }, 3000);
                                             });
                                                 videoProgress.max = video.duration;
                                                 duration.innerText = formatTime(video.duration);
                                                 loadNotes();

                                             });

                                             function callVideo() {
                                                 const videoState = document.getElementById('video-state');
                                                 if (video.paused) {
                                                     videoState.name = 'pause-sharp';
                                                     playVideo();
                                                 } else {
                                                     videoState.name = 'play-sharp';
                                                     pauseVideo();
                                                 }
                                             }

                                             function playVideo() {
                                                 video.play();
                                             }

                                             function pauseVideo() {
                                                 video.pause();
                                             }

                                             function setVideoTime(time) {
                                                 video.currentTime = time;
                                                 if (!video.paused) {
                                                     playVideo();
                                                 }

                                             }

                                             function refreshVideo() {
                                                 video.currentTime = 0;
                                                 playVideo();
                                             }

                                             const quill = new Quill('#quill-editor', {
                                                 theme: 'snow',
                                                 modules: {
                                                     toolbar: [
                                                         ['bold', 'italic', 'underline'],
                                                         [{'list': 'ordered'}, {'list': 'bullet'}],
                                                         ['link']
                                                     ]
                                                 }
                                             });
                                             function openNoteCreator() {
                                                 quill.focus();
                                                 video.pause();
                                                 document.getElementById('time-real').value = video.currentTime;
                                                 document.getElementById('time-tag').innerHTML = time.value;
                                                 document.getElementById('note-creator').classList.remove('d-none');
                                                 document.getElementById('note-creator-btn').classList.add('d-none');
                                                 document.getElementById('creator-btn').setAttribute('onclick', 'takeNote()');

                                             }

                                             function cancelNoteCreator() {
                                                 quill.deleteText(0, quill.getLength());
                                                 document.getElementById('note-creator').classList.add('d-none');
                                                 document.getElementById('note-creator-btn').classList.remove('d-none');
                                                 document.querySelectorAll('.note').forEach(note => {
                                                     if (note.classList.contains('d-none')) {
                                                         note.classList.remove('d-none');
                                                     }

                                                 });

                                             }

                                             function takeNote() {
                                                 var xhttp = new XMLHttpRequest();
                                                 xhttp.onreadystatechange = function () {
                                                     if (this.readyState == 4 && this.status == 200) {
                                                         loadNotes();
                                                         cancelNoteCreator();
                                                     }
                                                 };

                                                 var lesson = ${localLesson.id};
                                                 var time = document.getElementById('time-real').value;
                                                 var content = quill.root.innerHTML;
                                                 var jsonObject = JSON.stringify({
                                                     lesson: lesson,
                                                     time: time,
                                                     content: content
                                                 });

                                                 xhttp.open('POST', 'http://localhost:8080/SWP391/take-note', true);
                                                 xhttp.setRequestHeader('Content-Type', 'application/json');
                                                 xhttp.send(jsonObject);
                                             }

                                             function loadAllLesson() {
                                                 document.getElementById('query').innerHTML = 'All lesson <ion-icon class="fs-6" name="chevron-down-sharp"></ion-icon>';
                                                 query = 'all';
                                                 loadNotes();
                                             }

                                             function loadThisLesson() {
                                                 document.getElementById('query').innerHTML = 'This lesson <ion-icon class="fs-6" name="chevron-down-sharp"></ion-icon>';
                                                 query = ${localLesson.id};
                                                 loadNotes();
                                             }

                                             function loadMostRecent() {
                                                 document.getElementById('sort').innerHTML = 'Sort by most recent <ion-icon class="fs-6" name="chevron-down-sharp"></ion-icon>';
                                                 sort = 'newest';
                                                 loadNotes();
                                             }

                                             function loadOldest() {
                                                 document.getElementById('sort').innerHTML = 'Sort by oldest <ion-icon class="fs-6" name="chevron-down-sharp"></ion-icon>';
                                                 sort = 'oldest';
                                                 loadNotes();
                                             }


                                             function openLargeScreen() {
                                                 callMenu();
                                             }


                                             function deleteNote(note) {
                                                 var xhttp = new XMLHttpRequest();
                                                 xhttp.onreadystatechange = function () {
                                                     if (this.readyState == 4 && this.status == 200) {
                                                         loadNotes();
                                                     }
                                                 };
                                                 xhttp.open('get', 'http://localhost:8080/SWP391/update-note?note=' + note, true);
                                                 xhttp.send();
                                             }


                                             function openNoteUpdate(i) {
                                                 quill.setText(document.getElementById('note-' + i + '-content').innerText);
                                                 document.getElementById('note-' + i).classList.add('d-none');
                                                 document.getElementById('note-creator').classList.remove('d-none');
                                                 document.getElementById('note-creator-btn').classList.add('d-none');
                                                 document.getElementById('time-tag').innerText = document.getElementById('note-' + i + 'time').innerText;
                                                 document.getElementById('creator-btn').setAttribute('onclick', 'updateNode(' + i + ')');
                                             }

                                             function updateNode(i) {
                                                 var xhttp = new XMLHttpRequest();
                                                 xhttp.onreadystatechange = function () {
                                                     if (this.readyState == 4 && this.status == 200) {
                                                         loadNotes();
                                                         cancelNoteCreator();
                                                     }
                                                 };
                                                 var note = i;
                                                 var content = quill.root.innerHTML;
                                                 var jsonObject = JSON.stringify({
                                                     note: note,
                                                     content: content
                                                 });
                                                 xhttp.open('post', 'http://localhost:8080/SWP391/update-note', true);
                                                 xhttp.setRequestHeader('Content-Type', 'application/json');
                                                 xhttp.send(jsonObject);
                                             }
                                             var query = thisLesson;
                                             var sort = 'newest';

                                             function loadNotes() {
                                                 var xhttp = new XMLHttpRequest();
                                                 xhttp.onreadystatechange = function () {
                                                     if (this.readyState === 4 && this.status == 200) {
                                                         var jsonObjects = JSON.parse(this.responseText);
                                                         document.getElementById('notes').innerHTML = '';
                                                         document.getElementById('video-labels').innerHTML = '';
                                                         if (jsonObjects.length == 0) {
                                                             document.getElementById('notes').innerHTML = '<div class="col-12">'
                                                                     + '<div class="pt-3 pb-3">'
                                                                     + '<p class="text-center">Click the "Create a new note" box to make your first note.</p>'
                                                                     + '</div>'
                                                                     + '</div>';
                                                         }
                                                         for (let i = 0; i < jsonObjects.length; i++) {
                                                             var note = '<div class="col-12 note"  id="note-' + jsonObjects[i].id + '">'
                                                                     + '<div class="row g-1">'
                                                                     + '<div class="col-1" style="padding-right: 0.7rem;">'
                                                                     + '<button class="btn btn-warning fw-bold w-100 p-0" type="button"' + (thisLesson != jsonObjects[i].lessonId ? ' disabled="true"' : '') + '" onclick="setVideoTime(' + jsonObjects[i].atTime + ')" id="note-' + jsonObjects[i].id + 'time">' + formatTime(jsonObjects[i].atTime) + '</button>'
                                                                     + '</div>'
                                                                     + '<div class="col-11">'
                                                                     + '<div class="d-flex justify-content-between">'
                                                                     + '<div class="text-truncate w-75">'
                                                                     + '<h6 class="fw-bold pt-2">' + jsonObjects[i].lessonName + '</h6>'
                                                                     + '</div>'
                                                                     + '<div class="dropdown">'
                                                                     + '<button class="btn" type="button" data-bs-toggle="dropdown" aria-expanded="false">'
                                                                     + '<ion-icon class="fs-5" name="ellipsis-horizontal-sharp"></ion-icon>'
                                                                     + '</button>'
                                                                     + '<div class="dropdown-menu dropdown-menu-end">'
                                                                     + '<button class="dropdown-item" type="button" onclick="openNoteUpdate(' + jsonObjects[i].id + ')">Edit</button>'
                                                                     + '<button class="dropdown-item" type="button" onclick="deleteNote(' + jsonObjects[i].id + ')">Delete</button>'
                                                                     + '</div>'
                                                                     + '</div>'
                                                                     + '</div>'
                                                                     + '<div class="rounded-2 p-3" style="background-color: whitesmoke;" id="note-' + jsonObjects[i].id + '-content">'
                                                                     + jsonObjects[i].content
                                                                     + '</div>'
                                                                     + '</div>'
                                                                     + '</div>'
                                                                     + '</div>';
                                                             document.getElementById('notes').innerHTML += note;
                                                             if (thisLesson == jsonObjects[i].lessonId) {
                                                                 var label = '<div class="position-absolute top-0 note-label" id="label-note-' + jsonObjects[i].id + '">'
                                                                         + '<a class="btn p-0" type="button" onclick="pauseVideo(); setVideoTime(' + jsonObjects[i].atTime + ')" href="#label-note-' + jsonObjects[i].id + '">'
                                                                         + '<ion-icon class="text-warning" name="caret-down-sharp"></ion-icon>'
                                                                         + '</a>'
                                                                         + '</div>';

                                                                 document.getElementById('video-labels').innerHTML += label;
                                                             }
                                                             document.getElementById('label-note-' + jsonObjects[i].id).style.left = (jsonObjects[i].atTime * 100 / video.duration) + '%';
                                                         }
                                                     }
                                                 };

                                                 xhttp.open('get', 'http://localhost:8080/SWP391/take-note?query=' + query + '&sort=' + sort, true);
                                                 xhttp.send();
                                             }
                            <c:if test="${!requestScope.interactionList.isEmpty()}">
                                             const summary = document.getElementById('summary');
                                             var unselected;
                                             var correct;
                                             var incorrect;

                                             function refresh() {
                                                 correct = summary.querySelectorAll('input[type="radio"][value="1"]:checked').length;
                                                 incorrect = summary.querySelectorAll('input[type="radio"][value="1"]:not(:checked)').length;
                                                 unselected = summary.querySelectorAll('input[type="radio"][value="0"]').length;
                                                 document.getElementById('correct').innerText = correct;
                                                 document.getElementById('selected').innerText = correct + incorrect + unselected;
                                             }

                                             refresh();
                                             var pieChar;
                                             newChar(correct, incorrect, unselected);
                                             function checkAnswer(e) {
                                                 var question = document.getElementById('question-' + e);
                                                 var answers = question.querySelectorAll('input[name="answer"]');
                                                 var correctAnswer = question.querySelector('input[name="correct-answer"]').value;
                                                 var btn = question.querySelector('button[type="submit"]');
                                                 var summary = document.getElementById('summary');
                                                 for (var i = 0; i < answers.length; i++) {
                                                     if (answers[i].checked) {

                                                         if (answers[i].value == correctAnswer) {
                                                             answers[i].parentElement.classList.add('text-success');
                                                             btn.type = 'button';
                                                             btn.onclick = question.querySelector('button[type="button"]').onclick;
                                                             btn.innerText = 'Continue';
                                                             summary.querySelector('#q' + e).checked = true;
                                                             for (let j = 0; j < answers.length; j++) {
                                                                 if (j != i) {
                                                                     answers[j].disabled = true;
                                                                 }
                                                             }
                                                         } else {
                                                             answers[i].parentElement.classList.add('text-danger');
                                                             answers[i].disabled = true;
                                                             answers[i].checked = false;
                                                             btn.innerText = 'Resubmit';
                                                         }
                                                     }
                                                 }
                                                 var label = summary.querySelector('label[for="q' + e + '"]');
                                                 if (label.classList.contains('text-secondary')) {
                                                     label.classList.remove('text-secondary');
                                                 }
                                                 summary.querySelector('#q' + e).value = 1;
                                                 refresh();
                                                 pieChart.destroy();
                                                 newChar(correct, incorrect, unselected);
                                             }

                                             function openQuestion(e) {
                                                 const questions = document.getElementsByClassName('question');
                                                 for (let i = 0; i < questions.length; i++) {
                                                     var question = questions[i];
                                                     if (!question.classList.contains('d-none')) {
                                                         question.classList.add('d-none');
                                                     }
                                                 }

                                                 document.getElementById('interaction-at-' + e).classList.remove('d-none');
                                             }

                                             function skipQuestion(e) {
                                                 document.getElementById('interaction-at-' + e).classList.add('d-none');
                                                 playVideo();
                                             }
                                             function newChar(correct, incorrect, unselected) {
                                                 const pieData = {
                                                     labels: [
                                                         'Correct',
                                                         'Incorrect',
                                                         'No answered'
                                                     ],
                                                     datasets: [{
                                                             label: 'My First Dataset',
                                                             data: [correct, incorrect, unselected],
                                                             backgroundColor: [
                                                                 'rgb(54, 162, 235)',
                                                                 'rgb(255, 99, 132)',
                                                                 '#eee'
                                                             ],
                                                             hoverOffset: 4
                                                         }]
                                                 };

                                                 const pieConfig = {
                                                     type: 'doughnut',
                                                     data: pieData,
                                                     options: {
                                                         plugins: {
                                                             legend: {
                                                                 display: false // Hide the legend
                                                             }
                                                         }
                                                     }
                                                 };

                                                 var pieCtx = document.getElementById('pie').getContext('2d');
                                                 pieChart = new Chart(pieCtx, pieConfig);
                                             }
                            </c:if>
                        </c:otherwise>
                    </c:choose>
                        </c:if>     

                                             function markAsCompleted() {
                                                 var xhttp = new XMLHttpRequest();
                                                 xhttp.onreadystatechange = function () {
                                                     if (this.readyState == 4 && this.status == 200) {
                    <c:if test="${localLesson.type.type == 'reading'}">
                                                         document.getElementById('mark-btn').disabled = "true";
                    </c:if>
                                                         document.getElementById('lesson-' + thisLesson).name = 'checkmark-circle-sharp';
                                                     }
                                                 };
                                                 xhttp.open('get', 'http://localhost:8080/SWP391/mark-as-completed?lesson=' + thisLesson, true);
                                                 xhttp.send();
                                             }
                </c:when>
                <c:otherwise>
                    
                </c:otherwise>
            </c:choose>
                                             function callMenu() {
                                                 const main = document.getElementById('main');
                                                 const menu = document.getElementById('menu');
                                                 menu.classList.toggle('d-none');
                                                 main.classList.toggle('col-12');
                                             }


                                             function openHyperLink(link) {
                                                 window.location.href = link;
                                             }



                                             var progressBar = new ProgressBar.Circle(progress, {
                                                 strokeWidth: 12,
                                                 easing: 'easeInOut',
                                                 duration: 1400,
                                                 color: '#ffc107',
                                                 trailColor: '#eee',
                                                 trailWidth: 12,
                                                 svgStyle: null
                                             });

                                             progressBar.animate(${requestScope.progress});

                                             function openHyperLink(e) {
                                                 window.location.href = e;
                                             }
        </script>
    </body>
</html>
