<%-- 
    Document   : take-quiz
    Created on : Jun 5, 2024, 12:21:17 AM
    Author     : G5 5590
--%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
        <title>EduPort</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
        <link href="view/assets/css/base.css" rel="stylesheet"/>
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    </head>
    <body onload="startQuiz()">
        <%@include file="../elements/navbar.jsp"%>
        <div class="container-fluid border-bottom">
            <nav class="navbar">
                <div class="row p-2 w-100">
                    <div class="col-8 d-flex align-items-center">
                        <a class="btn btn-link" href="#" style="text-decoration: none;">
                            <ion-icon name="arrow-back-outline" role="img" class="md hydrated"></ion-icon> Go back
                        </a>
                        <h6 class="mb-0 ms-2"><span>Quiz Title</span></h6>
                    </div>
                    <div class="col-4 d-flex justify-content-end align-items-center">
                        <h6 class="mb-0">
                            <div id="timer">
                                <span style="color: red"> Time left: </span><span id="time"></span>
                            </div>
                        </h6>
                    </div>
                </div>
            </nav>
        </div>
        <div class="container align-items-center justify-content-end w-75">
            <form id="quizForm" action="takequiz" method="post">
                <input type="hidden" value="${param.course}" name="course">
                <input type="hidden" value="${param.section}" name="section">
                <c:forEach items="${requestScope.quiz.questions}" var="q" varStatus="loop">
                    <input type="hidden" name="quizId" value="${requestScope.quiz.id}" />
                    <div class="row row-cols-3 mt-5 ">
                        <div class="col-1 text-end">${loop.index + 1}.</div>
                        <div class="col-9 mb-4">
                            <div class="mb-4">
                                <span>${q.content}</span>
                            </div>
                            <input type="hidden" name="questionId" value="${q.id}" />
                            <c:forEach items="${q.answers}" var="a" varStatus="status">
                                <div class="form-check mt-2">                                    
                                    <input class="form-check-input rounded-5" type="radio" name="answer${loop.index}" id="radio${loop.index}${status.index}" value="${a.id}" />
                                    <label class="form-check-label" for="radio${loop.index}${status.index}">${a.content}</label>
                                </div>  
                            </c:forEach> 
                        </div>
                        <div class="col-1 text-end">1 point</div>
                    </div>
                </c:forEach>
                <div class="row mb-4">
                    <div class="col-1 text-end"></div>
                    <div class="col">
                        <button type="submit" class="btn btn-dark mt-3">Submit</button>
                    </div>
                </div>
            </form>
        </div>



        <script src="https://unpkg.com/ionicons@5.5.2/dist/ionicons/ionicons.js"></script>
        <%@include file="../elements/footer.jsp"%>
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script type="module" src="https://unpkg.com/ionicons@7.1.0/dist/ionicons/ionicons.esm.js"></script>
        <script nomodule src="https://unpkg.com/ionicons@7.1.0/dist/ionicons/ionicons.js"></script>
        <script>

        var timeString = '${requestScope.quiz.duration}';

        var timeComponents = timeString.split(':');
        var hours = parseInt(timeComponents[0], 10);
        var minutes = parseInt(timeComponents[1], 10);
        var seconds = parseInt(timeComponents[2], 10);

        var countdownTime = hours * 3600 + minutes * 60 + seconds;

        window.onload = function () {
            startCountdown();
        };

        function startCountdown() {
            var timerElement = document.getElementById('time');
            var quizForm = document.getElementById('quizForm');

            displayTime(countdownTime, timerElement);
            var countdown = setInterval(function () {
                countdownTime--;
                displayTime(countdownTime, timerElement);
                if (countdownTime <= 0) {
                    clearInterval(countdown);
                    quizForm.submit();
                }
            }, 1000);
        }

        function displayTime(seconds, timerElement) {
            var hours = Math.floor(seconds / 3600);
            var minutes = Math.floor((seconds % 3600) / 60);
            var remainingSeconds = seconds % 60;

            timerElement.textContent = (hours < 10 ? '0' : '') + hours + ':' +
                    (minutes < 10 ? '0' : '') + minutes + ':' +
                    (remainingSeconds < 10 ? '0' : '') + remainingSeconds;
        }
        </script>
    </body>
</html>

