<%-- 
    Document   : displayQuestions
    Created on : Jun 8, 2024, 2:28:07 PM
    Author     : HuyLQ;
--%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!doctype html> 
<html>
    <head>
        <meta charset="utf-8"/>
        <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
        <title>EduPort</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="../view/assets/css/base.css" rel="stylesheet"/>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/sweetalert/1.1.3/sweetalert.min.css">
        <script src="https://cdnjs.cloudflare.com/ajax/libs/sweetalert/1.1.3/sweetalert.min.js"></script>
    </head>
    <body>
        <%@include file="../elements/navbar.jsp"%>
        <div class="container pt-5 pb-5">
            <div class="row pt-5 rounded shadow " style="border: 1px solid; padding-bottom: 50px">
                <div class="col-12 mb-5">
                    <div class="w-75" style="margin: 0 auto;">
                        <h5>Create a new quiz</h5>
                        <div class="card">
                            <div class="card-body">
                                <p class="card-text">Instructors please enter the excel file address in your device </br>
                                    If this is your first time. Please download the template and use it</p>
                                <a href="../Template-Excel/Template_EduPort.xlsx" download>Template Excel</a>
                            </div>
                        </div>
                        <form action="import-quiz" method="post" enctype="multipart/form-data">
                            <input class="form-control" type="file" name="file"/>
                            <input type="hidden" name="quizId" value="${requestScope.quizId}"/>
                            <div class="d-flex align-items-center">
                                <button style="margin-bottom: 12px; margin-top: 12px" class="btn btn-primary" type="submit">Import</button>
                                <button type="button" class="btn btn-primary" style="margin-left: 12px;" data-bs-toggle="modal" data-bs-target="#staticBackdrop">View</button>
                                <c:if test="${requestScope.alert == '1'}">
                                    <div id="alertMessage" class="alert alert-success ms-3" role="alert" style="width: 200px; height:50px; margin-top: 20px" data-alert="true">
                                        <h6 class="alert-heading">Well done!</h6>
                                    </div>
                                </c:if>
                                <c:if test="${requestScope.alert == '0'}">
                                    <div id="alertMessage" class="alert alert-danger ms-3" role="alert" style="width: 75px; height:50px; margin-top: 20px" data-alert="false">
                                        <h6 class="alert-heading">Fail!</h6>
                                    </div>
                                </c:if>

                            </div>
                        </form>
                        <div class="modal fade" id="staticBackdrop" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="staticBackdropLabel" aria-hidden="true">
                            <div class="modal-dialog modal-xl">
                                <div class="modal-content">
                                    <form id="mainForm"  action="import-quiz" method="post" enctype="multipart/form-data">
                                        <div class="modal-header">
                                            <h1 class="modal-title fs-5" id="staticBackdropLabel">New Quiz</h1>
                                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                        </div>
                                        <div class="modal-body">
                                            <input type="hidden" name="quizId" value="${requestScope.quizId}"/>
                                            <c:forEach var="question" items="${questions}" varStatus="status">
                                                <div class="card mb-4" style="border: solid 1px black">
                                                    <div class="card-body">
                                                        <div>Question: ${question.content}</div>
                                                        <input type="hidden" name="questionContent" value="${question.content}"/>
                                                        <ul class="list-group">
                                                            <c:forEach var="answer" items="${question.answers}" varStatus="answerStatus">
                                                                <li class="list-group-item"
                                                                    style="<c:if test='${answer.correctless}'>background-color: #D1E7DD;</c:if>">
                                                                    Answer: ${answer.content}
                                                                    <input type="hidden" name="answerContent${status.index}" value="${answer.content}"/>
                                                                    <input type="hidden" name="correctLess${status.index}" value="${answer.correctless}"/>
                                                                    <c:if test="${answer.correctless}">
                                                                        <span class="float-end" style="color: green;">${answer.correctless}</span>
                                                                    </c:if>
                                                                </li>
                                                            </c:forEach>
                                                        </ul>
                                                    </div>
                                                </div>
                                            </c:forEach>
                                        </div>
                                        <div class="modal-footer">
                                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                                            <button type="submit" value="${requestScope.alert}" id="alertMessage" class="btn btn-primary" >Save</button>
                                        </div>
                                        <input  type="hidden" name="add" value="1"/>

                                    </form>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <%@include file="../elements/footer.jsp"%>                 
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css"></script>
        <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.bundle.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@10"></script>
        <script>
            (function ($) {
                showSwal = function (type) {
                    'use strict';
                    if (type === 'success-message') {
                        Swal.fire({
                            title: 'Congratulations!',
                            text: 'Import successfully!',
                            icon: 'success'
                        });
                    } else if (type === 'Fail') {
                        Swal.fire({
                            title: 'Fail!',
                            text: 'There are some questions that do not have any answers yet.!',
                            icon: 'error'
                        });
                    }
                };

              
                var alertElement = document.getElementById("alertMessage");
                if (alertElement && alertElement.getAttribute("data-alert") === 'true') {
                    showSwal('success-message');
                } else if (alertElement && alertElement.getAttribute("data-alert") === 'false') {
                    showSwal('Fail');
                }
            })(jQuery);


        </script>

    </body>
</html>


