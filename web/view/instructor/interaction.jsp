<%-- 
    Document   : interaction
    Created on : Jun 18, 2024, 12:10:54 PM
    Author     : HieuTC
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!doctype html>
<html lang="en">

    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>EduPort</title>
        <link href="../view/assets/css/hieutc.css" rel="stylesheet" />
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"
              integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous" />
        <link href="https://cdn.jsdelivr.net/npm/quill@2.0.2/dist/quill.snow.css" rel="stylesheet">
        <style>
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
                transform: translateY(12%);
            }

            progress {
                height: 0.27rem;
                border-radius: unset;
            }

            progress::-webkit-progress-bar {
                background-color: whitesmoke;
            }

            progress::-webkit-progress-value {
                background-color: black;
            }

            #current-time, #duration {
                background-color: unset;
            }

            span {
                font-family: 'Epilogue';
            }

            .btn:disabled {
                border-color: white;
            }

            .video-insider {
                position: absolute;
                width: 100%;
                height: 100%;
                background-color: rgba(0, 0, 0, 0.3);
                z-index: 22;
                padding: 2rem;
            }

            .insider-small, .insider-large {
                background-color: white;
                border-radius: 0.25rem;
                padding: 1rem;

            }

            .insider-small {
                width: 40%;
                height: fit-content;

            }

            .insider-large {
                width: 70%;
            }

            .insider-body {
                overflow-y: auto;
            }

            .insider-large .insider-body {
                height: 16rem;
            }

            .insider-small .insider-body {
                height: 7rem;
            }
            .insider-left {
                display: flex;
                justify-content: flex-start;
            }

            .insider-right {
                display: flex;
                justify-content: flex-end;
            }

            .insider-center {
                display: flex;
                justify-content: center;
            }

            input.form-control {
                border-color: white !important;
                border-bottom: 2px solid whitesmoke !important;
                border-radius: unset !important;
            }

            input.form-control:focus {
                border-color: white !important;
                border-bottom: 2px solid black !important;
                border-radius: unset !important;
            }

            label.form-check-label:hover {
                cursor: pointer;
            }

            .nav {
                display: none;
                transform: translate(80%, 15%);
            }

            .item:hover .nav {
                display: block;
            }

            button:focus {
                border-color: white !important;
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
            
            .question-label {
                transform: translateY(24%);
            }
            
        </style>
    </head>
    <body>
        <div class="container-fluid">
            <nav class="navbar">
                <div class="container pt-3 ps-5 pe-5">
                    <div class="w-100 d-flex justify-content-between">
                        <div class="text-truncate w-75">
                            <h6 class="fw-bold pt-2"></button>${requestScope.lesson.name}</h6>
                        </div>
                        <button class="btn" type="button"><ion-icon class="fs-5" name="close-sharp"></ion-icon></button>
                    </div>
                </div>
            </nav>
        </div>
        <div class="container p-5">
            <div class="ratio ratio-21x9 border"  id="video-container">    
                <video id="video">
                    <source src="video?id=${localLesson.video.path}" type="video/mp4">
                </video> 
                <div class="position-absolute top-0 d-flex justify-content-center align-items-center" id="loading">
                                                    <div class="spinner-border" role="status">
                                                        <span class="visually-hidden">Loading...</span>
                                                    </div> 
                                                </div>
                <div class="video-insider insider-center d-none" id="insider-position">
                    <div class="insider-large position-relative" id="insider-size">
                        <h5 class="fw-bold pb-4">
                            Question
                        </h5>
                        <p id="preview-question">1 && 0 || 0</p>
                        <form onsubmit="return false;">
                            <div id="preview-answers">
                                <div class="form-check pb-2">
                                    <input class="form-check-input" type="radio" name="answer" value="" id="0">
                                    <label class="form-check-label preview-answer" for="0">
                                        0
                                    </label>
                                </div>
                                <div class="form-check pb-2">
                                    <input class="form-check-input" type="radio" name="answer" value="" id="1">
                                    <label class="form-check-label preview-answer" for="1">
                                        1
                                    </label>
                                </div>
                            </div>
                        </form>
                    </div>
                </div> 
                <div id="insiders">
                    <c:forEach items="${requestScope.interactionList}" var="interaction">
                        <fmt:formatNumber type="number" maxFractionDigits="0" value="${Math.floor(interaction.atTime)}" var="localNumber"></fmt:formatNumber>
                        <div class="video-insider insider-${interaction.position} d-none question" id="interaction-at-${localNumber}">
                            <div class="insider-${interaction.size} position-relative">
                                <h5 class="fw-bold pb-4">Question</h5>
                                <form onsubmit="checkAnswer(${interaction.question.id}); return false;" id="question-${interaction.question.id}">
                                    <div class="insider-body">
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
                </div>
                <div>         
                    <div id="video-controller" class="p-3 pb-4 d-none">
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
            <div class="container" style="width: 50rem;">
                <div class="pt-3 pb-3 d-none" id="question-creator">
                    <div class="row">
                        <div class="col-1">
                            <h5><span class="badge text-bg-warning" id="time-tag">1:00</span></h5>
                        </div>
                        <div class="col-11">
                            <div class="w-100">
                                <div class="dropdown d-inline-block">
                                    <button class="btn border fw-bold p-3" type="button" data-bs-toggle="dropdown" aria-expanded="false">
                                        Position <ion-icon name="caret-down-sharp"></ion-icon>
                                    </button>
                                    <div class="dropdown-menu">
                                        <button class="dropdown-item" type="button" onclick="changePosition('left')">Left</button>
                                        <button class="dropdown-item" type="button" onclick="changePosition('center')">Center</button>
                                        <button class="dropdown-item" type="button" onclick="changePosition('right')">Right</button>
                                    </div>
                                </div>
                                <div class="dropdown d-inline-block ps-2">
                                    <button class="btn border fw-bold p-3" type="button" data-bs-toggle="dropdown" aria-expanded="false">
                                        Size <ion-icon name="caret-down-sharp"></ion-icon>
                                    </button>
                                    <div class="dropdown-menu">
                                        <button class="dropdown-item" type="button" onclick="changeSize('small')">Small</button>
                                        <button class="dropdown-item" type="button" onclick="changeSize('large')">Large</button>
                                    </div>
                                </div>
                            </div>
                            <div class="pt-3 pb-3">
                                <form action="add-interaction" method="post">
                                    <input type="hidden" name="lesson" id="lesson" value="${param.lesson}"/>
                                    <input type="hidden" name="video" id="video" value="${requestScope.lesson.video.id}"/>
                                    <input type="hidden" name="time" id="time-real"/>
                                    <input type="hidden" name="position" id="position"  value="center"/>
                                    <input type="hidden" name="size" id="size" value="large"/>
                                    <textarea class="form-control pt-3" placeholder="..." minlength="5" maxlength="256" required name="question" id="question"></textarea>
                                    <div class="row pt-3 g-3" id="answers">
                                        <div class="col-12 position-relative item">
                                            <div class="rounded-2 border">
                                                <div class="p-2 border-bottom d-flex justify-content-between answer">
                                                    <input class="form-check-input mt-2 mb-0 option" type="radio" value="0" name="correct" required>
                                                    <label class="form-check-label fw-bold p-1 ps-2">A</label>
                                                    <input class="form-control p-1 answer-input" type="text" name="answer" minlength="1" maxlength="256" placeholder="..." onblur="fix(0)" required="true">
                                                </div>
                                            </div>
                                            <div class="position-absolute top-0 end-0 nav">
                                                <button class="btn remove-btn" type="button"
                                                        onclick="removeOption(0)"><ion-icon class="fs-5" name="close-sharp"></ion-icon></button>
                                            </div>
                                        </div>
                                        <div class="col-12 position-relative item">
                                            <div class="rounded-2 border">
                                                <div class="p-2 border-bottom d-flex justify-content-between answer">
                                                    <input class="form-check-input mt-2 mb-0 option" type="radio" value="1" name="correct" required>
                                                    <label class="form-check-label fw-bold p-1 ps-2">B</label>
                                                    <input class="form-control p-1 answer-input" type="text" name="answer" minlength="1" maxlength="256" placeholder="..." onblur="fix(1)" required="true">
                                                </div>
                                            </div>
                                            <div class="position-absolute top-0 end-0 nav">
                                                <button class="btn remove-btn" type="button"
                                                        onclick="removeOption(1)"><ion-icon class="fs-5" name="close-sharp"></ion-icon></button>
                                            </div>
                                        </div>
                                    </div>
                                    <button class="btn btn-light mt-3" type="button" id="answer-btn" onclick="addAnswer();"><ion-icon class="fs-5" name="add-sharp"></ion-icon> More option</button>
                                    <div class="d-flex justify-content-end">
                                        <button class="btn fw-bold text-primary" type="button" onclick="cancelQuestionCreator();">Cancel</button>
                                        <button class="btn fw-bold text-primary" type="submit">Save question</button>
                                    </div>
                                </form>
                            </div>


                        </div>
                    </div>
                </div>
                <button class="btn p-3 fw-bold border w-100 text-start position-relative mt-3 mb-3" type="button" id="question-creator-btn"
                        onclick="openQuestionCreator()">
                    Add a new question at <input class="form-control fw-bold text-secondary p-0 d-inline-block" style="border: unset !important; width: fit-content;"
                                                 value="0:00" name="time" readonly id="time"
                                                 style="width: fit-content;">
                    <div class="position-absolute top-0 end-0 p-3">
                        <ion-icon class="fs-5" name="add-sharp"></ion-icon>
                    </div>
                </button>
                <div class="dropdown d-inline-block">
                    <button class="btn p-3 fw-bold border text-start" type="button"
                            data-bs-toggle="dropdown" aria-expanded="false" id="query">
                        Sort <ion-icon class="fs-6" name="chevron-down-sharp"></ion-icon>
                    </button>
                    <div class="dropdown-menu">
                        <button class="btn dropdown-item" onclick="sort('newest')">Newest first</button>
                        <button class="btn dropdown-item" onclick="sort('oldest')">Oldest first</button>
                        <button class="btn dropdown-item" onclick="sort('up')">Up</button>
                        <button class="btn dropdown-item" onclick="sort('down')">Down</button>
                    </div>
                </div>
                <div class="row pt-3 g-3">
                    <c:if test="${requestScope.interactionList.isEmpty()}">
                        <p class="text-center pt-2 pb-2">Click the "Create a new question" box to make your first question.</p>
                    </c:if>
                    <c:forEach items="${requestScope.interactionList}" var="interaction">
                        <div class="col-12"  id="interaction-${interaction.id}">
                            <input type="hidden" name="time" value="${interaction.atTime}">
                            
                            <div class="row g-1">
                                <div class="col-1" style="padding-right: 0.7rem;">
                                    <button class="btn btn-warning fw-bold w-100 p-0" type="button" onclick="setVideoTime(${interaction.atTime})">${interaction.getFormatedTime()}</button>
                                </div>
                                <div class="col-11">
                                    <div class="d-flex justify-content-between">
                                        <div class="w-75 text-truncate">
                                            <h6 class="fw-bold">${interaction.question.content}</h6>
                                        </div>
                                        <div class="dropdown">
                                            <button class="btn" type="button" data-bs-toggle="dropdown" aria-expanded="false">
                                                <ion-icon class="fs-5" name="ellipsis-horizontal-sharp"></ion-icon>
                                            </button>
                                            <div class="dropdown-menu dropdown-menu-end">
                                                <button class="dropdown-item d-none" type="button">Edit</button>
                                                <button class="dropdown-item" type="button" onclick="deleteQuestion(${interaction.id})">Delete</button>
                                            </div>
                                        </div>

                                    </div>
                                    <div class="btn-group-vertical w-100" role="group">
                                        <c:forEach items="${interaction.question.answers}" var="answer">
                                            <div class="btn border position-relative" style="padding: 0.8rem;">
                                                <div class="position-absolute top-0 end-0 p-3">
                                                    <input class="form-check-input" type="radio" disabled="true" name="question-${interaction.question.id}" <c:if test="${answer.correctless}">checked="true"</c:if> id="answer-${answer.id}">
                                                    </div>
                                                    <label class="w-100 text-start" for="answer-${answer.id}">${answer.content}</label>
                                            </div>
                                        </c:forEach>            
                                    </div>
                                </div>
                            </div>
                        </div>
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
        <script>
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
                ${localNumber}<c:if test="${requestScope.interactionList.indexOf(interaction) != requestScope.interactionList.size() - 1}">,</c:if></c:forEach>
];
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
                                                            var formatedTime = formatTime(video.currentTime)
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

                                                    function openQuestionCreator() {
                                                        video.pause();
                                                        document.getElementById('time-real').value = video.currentTime;
                                                        document.getElementById('time-tag').innerHTML = time.value;
                                                        document.getElementById('question-creator').classList.remove('d-none');
                                                        document.getElementById('question-creator-btn').classList.add('d-none');
                                                        document.getElementById('insider-position').classList.remove('d-none');
                                                    }

                                                    function cancelQuestionCreator() {
                                                        video.play();
                                                        document.getElementById('question-creator').classList.add('d-none');
                                                        document.getElementById('question-creator-btn').classList.remove('d-none');
                                                        document.getElementById('insider-position').classList.add('d-none');
                                                    }

                                                    function changePosition(position) {
                                                        var insider = document.getElementById('insider-position');
                                                        insider.classList.remove('insider-left');
                                                        insider.classList.remove('insider-center');
                                                        insider.classList.remove('insider-right');
                                                        insider.classList.add('insider-' + position);
                                                        document.getElementById('position').value = position;
                                                    }

                                                    function changeSize(size) {
                                                        var insider = document.getElementById('insider-size');
                                                        insider.classList.remove('insider-small');
                                                        insider.classList.remove('insider-large');
                                                        insider.classList.add('insider-' + size);
                                                        document.getElementById('size').value = size;
                                                    }

                                                    const alphabet = ['A', 'B', 'C', 'D', 'E', 'F', 'G'];
                                                    function reallocation() {
                                                        const answers = document.getElementsByClassName('answer');
                                                        const options = document.getElementsByClassName('option');
                                                        const removeBtns = document.getElementsByClassName('remove-btn');
                                                        const answerInputs = document.getElementsByClassName('answer-input');
                                                        for (var i = 0; i < answers.length; i++) {
                                                            answers[i].querySelector('label').innerText = alphabet[i];
                                                            options[i].value = i;
                                                            removeBtns[i].onclick = function () {
                                                                removeOption(i - 1);
                                                            };
                                                            answerInputs[i].onblur = function () {
                                                                fix(i - 1);
                                                            };
                                                        }

                                                    }

                                                    function addAnswer() {
                                                        var answers = document.getElementById('answers');

                                                        var answer = document.createElement('div');
                                                        answer.classList.add('col-12');
                                                        answer.classList.add('position-relative');
                                                        answer.classList.add('item');
                                                        answer.innerHTML = `<div class="rounded-2 border">
                                                <div class="p-2 border-bottom d-flex justify-content-between answer">
                                                    <input class="form-check-input mt-2 mb-0 option" type="radio" value="0" name="correct" required>
                                                    <label class="form-check-label fw-bold p-1 ps-2">C</label>
                                                    <input class="form-control p-1 answer-input" type="text" name="answer" minlength="1" maxlength="256" placeholder="..." required="true">
                                                </div>
                                            </div>
                                            <div class="position-absolute top-0 end-0 nav">
                                                <button class="btn remove-btn" type="button"
                                                        ><ion-icon class="fs-5" name="close-sharp"></ion-icon></button>
                                            </div>`;
                                                        answers.appendChild(answer);
                                                        reallocation();
                                                        if (answers.children.length >= 7) {
                                                            document.getElementById('answer-btn').classList.add('d-none');
                                                        }
                                                    }

                                                    function fix(e) {
                                                        var answers = document.getElementsByClassName('answer-input');
                                                        var previewAnswers = document.getElementsByClassName('preview-answer');
                                                        if (previewAnswers.length < answers.length) {
                                                            document.getElementById('preview-answers').innerHTML += `
                                <div class="form-check pb-2">
                                    <input class="form-check-input" type="radio" name="answer" id="` + previewAnswers.length + `">
                                    <label class="form-check-label preview-answer" for="` + previewAnswers.length + `">
                                        ...
                                    </label>
                                </div>`;

                                                        }
                                                        previewAnswers[e].innerText = answers[e].value;
                                                    }

                                                    document.getElementById('question').addEventListener('input', function () {
                                                        document.getElementById('preview-question').innerText = this.value;
                                                    });

                                                    function checkAnswer(e) {
                                                        var question = document.getElementById('question-' + e);
                                                        var answers = question.querySelectorAll('input[name="answer"]');
                                                        var correctAnswer = question.querySelector('input[name="correct-answer"]').value;
                                                        var btn = question.querySelector('button[type="submit"]');
                                                        for (var i = 0; i < answers.length; i++) {
                                                            if (answers[i].checked) {
                                                                if (answers[i].value == correctAnswer) {
                                                                    answers[i].parentElement.classList.add('text-success');
                                                                    btn.type = 'button';
                                                                    btn.onclick = question.querySelector('button[type="button"]').onclick;
                                                                    btn.innerText = 'Continue';

                                                                } else {
                                                                    answers[i].parentElement.classList.add('text-danger');
                                                                    answers[i].disabled = true;
                                                                }
                                                            }
                                                        }
                                                    }

                                                    function skipQuestion(e) {
                                                        console.log(e);
                                                        document.getElementById('interaction-at-' + e).classList.add('d-none');
                                                        playVideo();
                                                    }

                                                    function deleteQuestion(e) {
                                                        var xhttp = new XMLHttpRequest();
                                                        xhttp.onreadystatechange = function () {
                                                            if (this.readyState == 4 && this.status == 200) {
                                                                window.location.reload();
                                                            }
                                                        };
                                                        xhttp.open('get', 'update-interaction?interaction=' + e, true);
                                                        xhttp.send();
                                                    }

                                                    function sort(e) {
                                                        window.location.href = 'add-interaction?lesson=${param.lesson}&sort=' + e;
                                                    }

                                                    function removeOption(i) {
                                                        const items = document.getElementsByClassName('item');
                                                        var previewAnswers = document.getElementsByClassName('preview-answer');
                                                        if (items.length > 2) {
                                                            if (previewAnswers.length >= items.length) {
                                                                previewAnswers[i].parentElement.remove();
                                                            }
                                                            items[i].remove();
                                                        }
                                                        reallocation();
                                                    }
        </script>
    </body>
</html>