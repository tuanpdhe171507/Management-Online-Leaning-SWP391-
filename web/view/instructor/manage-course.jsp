<%-- 
    Document   : manageCourse
    Created on : May 23, 2024, 1:32:23 PM
    Author     : Trongnd
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!doctype html>
<html lang="en">
    <head>
        <meta charset="utf-8"/>
        <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
        <title>EduPort</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
        <link href="../view/assets/css/base.css" rel="stylesheet"/>
        <style>
            .tool {
                display: inline;
            }
        </style>
    </head>
    <body>
        <div class="container-fluid border-bottom ">
            <nav class="navbar ">
                <div class="container pt-2 pb-2">
                    <div>
                        <a class="btn" href="../instructor/courses"><ion-icon name="arrow-back-outline"></ion-icon> Go back</a>
                        <h6 class="d-inline-block"><span class="badge text-bg-dark">Daft</span></h6>
                    </div>

                    <button class="btn" type="button" disabled="true">Preview</button>
                </div>
            </nav>
        </div>
        <div class="container pt-5 pb-5">
            <form action="manage" method="post" id="form" enctype="multipart/form-data">
                <div class="row gx-3">
                    <div class="col-3">
                        <h5>Course plan</h5>
                        <button class="btn d-block w-100 text-start tab" type="button" onclick="show(0)">Intended learners</button>
                        <button class="btn d-block w-100 text-start tab" type="button" onclick="show(1)">Loading page</button>
                        <button class="btn btn-dark w-100 mt-3" type="submit" id="save-course" disabled="true">Save</button>
                    </div>
                    <div class="col-9">
                        <div class="container w-75">

                            <input type="hidden" name="id" value="${param.id}">
                            <div class="page">                           
                                <h5 class="pb-2">Intended learners</h5>
                                <div class="row gy-4">
                                    <div class="col-12">
                                        <h6>What will students learn ?</h6>
                                        <p>At least 2 objectives or outcomes that learners can expect to achieve after completing your course</p>
                                        <div id="objective">
                                            <c:forEach items="${requestScope.course.objectives}" var="obj">
                                                <c:if test="${not empty obj}">
                                                    <input class="form-control mb-3" name="objective" placeholder="Example:" value="${obj}">

                                                </c:if>
                                            </c:forEach>
                                            <c:if test="${fn:length(requestScope.course.objectives) eq 0}">
                                                <input class="form-control mb-3" name="objective" placeholder="Example:" value="" required>
                                                <input class="form-control mb-3" name="objective" placeholder="Example:" value="" required>
                                            </c:if>
                                        </div>
                                        <button class="btn" type="button" onclick="addObjective()"><ion-icon name="add-outline"></ion-icon> Add more</button>
                                    </div>
                                    <div class="col-12">
                                        <h6>What should students learn before ?</h6>
                                        <p>List skills or knowledge that learners should have prior to taking your course.</p>
                                        <div id="prerequisite">
                                            <c:forEach items="${requestScope.course.prerequiresites}" var="pre">
                                                <c:if test="${not empty pre}">
                                                    <input class="form-control mb-3" name="prerequisite" placeholder="Example:" value="${pre}">

                                                </c:if>
                                            </c:forEach>
                                            <c:if test="${fn:length(requestScope.course.prerequiresites) eq 0}">
                                                <input class="form-control mb-3" name="prerequisite" placeholder="Example:" value="" required>

                                                <input class="form-control mb-3" name="prerequisite" placeholder="Example:" value="" required>

                                            </c:if>

                                        </div>
                                        <button class="btn" type="button" onclick="addPrerequisite()"><ion-icon name="add-outline"></ion-icon> Add more</button>
                                    </div>
                                    <div class="col-12">
                                        <h6>Who is this course for ?</h6>
                                        <p>Intended learner for your course who will find your course content valuable.</p>
                                        <div id="intended-learner">
                                            <c:forEach items="${requestScope.course.intentedLearners}" var="il">
                                                <c:if test="${not empty il}">
                                                    <input class="form-control mb-3" name="intended-learner" placeholder="Example:" value="${il}">

                                                </c:if>
                                            </c:forEach>
                                            <c:if test="${fn:length(requestScope.course.intentedLearners) eq 0}">
                                                <input class="form-control mb-3" name="intended-learner" placeholder="Example:" value=""required>

                                            </c:if>

                                        </div>
                                        <button class="btn" type="button" onclick="addIntendedLearner()"><ion-icon name="add-outline"></ion-icon> Add more</button>
                                    </div>
                                </div>
                            </div>
                            <div class="page">
                                <h5 class="pb-2">Loading page</h5>
                                <div class="row gy-4">
                                    <div class="col-12">
                                        <h6>Course title</h6>
                                        <p>Your title should be a mix of attention-grabbing, informative, and optimized for search</p>

                                        <input class="form-control" name="course-title" placeholder="Example:" value="${requestScope.course.name}">
                                    </div>
                                    <div class="col-12">
                                        <h6>Basic info</h6>
                                        <div class="row">
                                            <div class="col-6">
                                                <select class="form-select text-center" name="category">
                                                    <c:forEach items="${requestScope.categories}" var="category">
                                                        <c:if test="${category.id eq requestScope.course.category.id}">
                                                            <option value="${category.id}" selected>${category.name}</option>
                                                        </c:if>
                                                        <c:if test="${category.id ne requestScope.course.category.id}">
                                                            <option value="${category.id}">${category.name}</option>
                                                        </c:if>

                                                    </c:forEach>
                                                </select>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-12">
                                        <h6>Course description</h6>
                                        <div class="description">
                                            <div class="tool-list">
                                                <div class="tool">
                                                    <button type="button" data-command="bold" class="tool--btn">
                                                        <i class="fas fa-bold"></i>
                                                    </button>
                                                </div>
                                                <li class="tool">
                                                    <button type="button" data-command="italic" class="tool--btn">
                                                        <i class="fas fa-italic"></i>
                                                    </button>
                                                </li>
                                                <li class="tool">
                                                    <button type="button" data-command="underline" class="tool--btn">
                                                        <i class="fas fa-underline"></i>
                                                    </button>
                                                </li>
                                                <li class="tool">
                                                    <button type="button" data-command="insertOrderedList" class="tool--btn">
                                                        <i class="fas fa-list-ol"></i>
                                                    </button>
                                                </li>
                                                <li class="tool">
                                                    <button type="button" data-command="insertUnOrderedList" class="tool--btn">
                                                        <i class="fas fa-list-ul"></i>
                                                    </button>
                                                </li>
                                                </ul>
                                            </div>

                                            <div class="form-control mt-2" id="input-description" contenteditable="true" style="font-family: Kanit">
                                                <c:if test="${not empty requestScope.course.description}">
                                                    ${requestScope.course.description}
                                                </c:if>
                                            </div>
                                            <input type="hidden" id="html-content" class="course-description" name="course-description">
                                        </div>
                                        <div class="col-12">
                                            <h6>Course image</h6>
                                            <div class="row pt-2">
                                                <div class="col-6">
                                                    <div class="ratio ratio-16x9 border" style="border-color: black !important;">
                                                        <img src="${requestScope.course.thumbnail}" id="imageView" > 
                                                    </div>
                                                </div>
                                                <div class="col-6">
                                                    <p>Upload your course image here. It must meet our course image quality standards to be accepted. 
                                                        Important guidelines: .jpg, .jpeg,. gif, or .png. no text on the image.</p>
                                                    <input type="file" name="image" accept="image/*" onchange="chooseFile(this)"/>
                                                </div>
                                            </div>
                                        </div>                     
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </form>
        </div>
        <%@include file="../elements/footer.jsp"%>
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script type="module" src="https://unpkg.com/ionicons@7.1.0/dist/ionicons/ionicons.esm.js"></script>
        <script nomodule src="https://unpkg.com/ionicons@7.1.0/dist/ionicons/ionicons.js"></script>
        <script>
                                                        function chooseFile(fileInput) {
                                                            if (fileInput.files && fileInput.files[0]) {
                                                                var reader = new FileReader();
                                                                reader.onload = function (e) {
                                                                    $('#imageView').attr('src', e.target.result).show();
                                                                };
                                                                reader.readAsDataURL(fileInput.files[0]);
                                                            }
                                                        }
                                                        document.getElementById('imageView').addEventListener('error', hideImage);
                                                        function hideImage() {
                                                            $('#imageView').hide();
                                                        }

                                                        let inputEnter = document.getElementsByTagName('input');
                                                        for (let i of inputEnter) {
                                                            i.addEventListener('keydown', (event) => {
                                                                if (event.key === 'Enter') {
                                                                    event.preventDefault();
                                                                }
                                                            });
                                                        }

                                                        let output = document.getElementById("output");
                                                        let buttons = document.getElementsByClassName('tool--btn');
                                                        for (let btn of buttons) {
                                                            btn.addEventListener('click', () => {
                                                                let cmd = btn.dataset['command'];
                                                                document.execCommand(cmd, false, null);
                                                                document.getElementById('output').focus();
                                                            });
                                                        }
                                                        const content = document.getElementById("input-description");
                                                        content.addEventListener('input', () => {
                                                            let elements = content.getElementsByTagName("*");
                                                            for (let i = 0; i < elements.length; i++) {
                                                                elements[i].style.fontFamily = 'Kanit';
                                                                elements[i].style.fontSize = '0.9rem';
                                                                elements[i].style.color = 'black';
                                                            }
                                                        });
                                                        document.getElementById("save-course").addEventListener('click', () => {
                                                            console.log(content);
                                                            document.getElementById("html-content").value = content.innerHTML;
                                                        });

                                                        var tabs = document.getElementsByClassName("tab");
                                                        var pages = document.getElementsByClassName("page");
                                                        function show(e) {
                                                            for (let i = 0; i < pages.length; i++) {
                                                                if (i !== e) {
                                                                    tabs[i].style.borderLeft = "unset";
                                                                    pages[i].style.display = "none";
                                                                } else {
                                                                    tabs[i].style.borderLeft = "3px solid black";
                                                                    pages[i].style.display = "block";
                                                                }
                                                            }
                                                        }


                                                        function addObjective() {
                                                            let div = document.createElement("div");
                                                            let input = document.createElement("input");
                                                            input.type = "text";
                                                            input.className = "form-control mb-3";
                                                            input.value = "";
                                                            input.placeholder = "Example: ";
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
                                                            input.placeholder = "Example: ";
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
                                                            input.placeholder = "Example: ";
                                                            input.name = "intended-learner";
                                                            div.appendChild(input);

                                                            document.getElementById("intended-learner").appendChild(input);
                                                        }

                                                        show(0);
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
                                                        if (checkInputs(inputObj, 2) && checkInputs(document.getElementsByName('prerequisite'), 2) && checkInputs(document.getElementsByName('intended-learner'), 1)) {
                                                            save.disabled = false;
                                                        } else {
                                                            save.disabled = true;
                                                        }
                                                        document.getElementById('form').addEventListener('input', () => {
                                                            if (checkInputs(inputObj, 2) && checkInputs(document.getElementsByName('prerequisite'), 2) && checkInputs(document.getElementsByName('intended-learner'), 1)) {
                                                                save.disabled = false;
                                                            } else {
                                                                save.disabled = true;
                                                            }
                                                        });

        </script>
    </body>
</html>

