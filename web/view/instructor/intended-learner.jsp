<%-- 
    Document   : intendedLearner
    Created on : Jul 6, 2024, 6:26:21 AM
    Author     : HieuTC
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
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
                        <button class="btn" type="button" onclick="openHyperLink('../instructor/courses')">
                                <ion-icon class="fs-5" name="arrow-back-sharp"></ion-icon></button>
                                ${requestScope.course.name} </h6>
                     
                </div>
<c:if test="${requestScope.course != null}">
                    <a class="btn" type="button" href="settings?id=${requestScope.course.id}"><ion-icon class="fs-5" name="settings-outline"></ion-icon></a>
                </c:if>
                
            </div>
        </nav>
    </div>
    <div class="container">
        <div class="row">
            <%@include file="elements/slidebar.jsp"%>
            <div class="col-9 pt-5 ps-5 pb-5 border-start" style="min-height: 90vh;">
                <form action="intended-learner" method="post" id="form">
                     <input type="hidden" name="id" value="${param.id}">
                <h5 class="fw-bold pb-2">Intended learner</h5>
                <h6 class="fw-bold pt-3">What will students learn ?</h6>
                <p>At least 2 objectives or outcomes that learners can expect to achieve after completing your course.</p>
                <div id="objective">
                <c:forEach items="${requestScope.course.objectives}" var="obj">
                    <c:if test="${not empty obj}">
                        <input class="form-control mb-3" name="objective" placeholder="Objective" value="${obj}">
                    </c:if>
                </c:forEach>
                <c:if test="${requestScope.course.objectives.size() eq 0}">
                    <input class="form-control mb-3" name="objective" placeholder="Objective 1" required>
                    <input class="form-control mb-3" name="objective" placeholder="Objective 2" required>
                </c:if>
                </div>
                <button class="btn fw-bold btn-light" type="button" onclick="addObjective()">
                    <ion-icon name="add-outline"></ion-icon> Add more
                </button>
                <h6 class="fw-bold pt-5">What should students learn before ?</h6>
                <p>List skills or knowledge that learners should have prior to taking your course.</p>
                <div id="prerequisite">
                <c:forEach items="${requestScope.course.prerequiresites}" var="pre">
                    <c:if test="${not empty pre}">
                        <input class="form-control mb-3" name="prerequisite" placeholder="Prerequiresite" value="${pre}">

                    </c:if>
                </c:forEach>
                <c:if test="${requestScope.course.prerequiresites.size() eq 0}">
                    <input class="form-control mb-3" name="prerequisite" placeholder="Prerequiresite 1" required>
                    <input class="form-control mb-3" name="prerequisite" placeholder="Prerequiresite 2" required>
                </c:if>
                </div>
                <button class="btn fw-bold btn-light" type="button" onclick="addPrerequisite()">
                    <ion-icon name="add-outline"></ion-icon> Add more
                </button>
                    <h6 class="fw-bold pt-5">Who is this course for ?</h6>
                    <p>Intended learner for your course who will find your course content valuable.</p>
                     <div id="intended-learner">
                    <c:forEach items="${requestScope.course.intentedLearners}" var="il">
                        <c:if test="${not empty il}">
                            <input class="form-control mb-3" name="intended-learner" placeholder="Intended learner" value="${il}">
                        </c:if>
                    </c:forEach>
                    <c:if test="${requestScope.course.intentedLearners.size() eq 0}">
                        <input class="form-control mb-3" name="intended-learner" placeholder="Intended learner" required>
                    </c:if>
                     </div>
                    <button class="btn fw-bold btn-light" type="button" onclick="addIntendedLearner()">
                    <ion-icon name="add-outline"></ion-icon> Add more
                </button>
                    <div class="d-flex justify-content-end">
                        <button class="btn btn-primary fw-bold p-3 mt-3" type="submit" id="save-course">Save changes</button>
                    </div> 
                </form>
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
                                                                function addObjective() {
                                                            let div = document.createElement("div");
                                                            let input = document.createElement("input");
                                                            input.type = "text";
                                                            input.className = "form-control mb-3";
                                                            input.value = "";
                                                            input.placeholder = "Objective";
                                                            input.name = "objective";
                                                            div.appendChild(input);
                                                            document.getElementById("objective").appendChild(div);
                                                        }
                                                        function addPrerequisite() {
                                                            let div = document.createElement("div");
                                                            let input = document.createElement("input");
                                                            input.type = "text";
                                                            input.className = "form-control mb-3";
                                                            input.value = "";
                                                            input.placeholder = "Prerequiresite";
                                                            input.name = "prerequisite";
                                                            div.appendChild(input);

                                                            document.getElementById("prerequisite").appendChild(input);
                                                        }

                                                        function addIntendedLearner() {
                                                            let div = document.createElement("div");
                                                            let input = document.createElement("input");
                                                            input.type = "text";
                                                            input.className = "form-control mb-3";
                                                            input.value = "";
                                                            input.placeholder = "Intended learner";
                                                            input.name = "intended-learner";
                                                            div.appendChild(input);

                                                            document.getElementById("intended-learner").appendChild(input);
                                                        }

                                                        const inputObj = document.getElementsByName('objective');
                                                        const save = document.getElementById('save-course');

                                                        const checkInputs = (element, num) => {
                                                            let count = 0;
                                                            for (let i = 0; i < element.length; i++) {
                                                                if (element[i].value.trim() !== '') {
                                                                    count++;
                                                                }
                                                            }
                                                            // number of value Element is not empty grater than num
                                                            if (count >= num) {
                                                                return true;
                                                            } else {
                                                                return false;
                                                            }

                                                        };
                                                        if (checkInputs(inputObj, 2) && checkInputs(document.getElementsByName('prerequisite'), 1) && checkInputs(document.getElementsByName('intended-learner'), 1)) {
                                                            save.disabled = false;
                                                        } else {
                                                            save.disabled = true;
                                                        }
                                                        document.getElementById('form').addEventListener('input', () => {
                                                            if (checkInputs(inputObj, 2) && checkInputs(document.getElementsByName('prerequisite'), 1) && checkInputs(document.getElementsByName('intended-learner'), 1)) {
                                                                save.disabled = false;
                                                            } else {
                                                                save.disabled = true;
                                                            }
                                                        });
        document.getElementsByClassName('tab')[0].classList.add('here');
        document.getElementsByClassName('tab')[0].classList.add('btn-light');
        </script>
    </body>
</html>
