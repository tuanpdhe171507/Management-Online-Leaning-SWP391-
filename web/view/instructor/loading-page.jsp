<%-- 
    Document   : loading-page
    Created on : Jul 6, 2024, 6:53:24 AM
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
           border-radius: 0.25rem 0.25rem 0 0;
        }

        .ql-container {
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
                <form action="loading-page" method="post" id="form">
                    <input type="hidden" name="id" value="${param.id}">
                    <h5 class="fw-bold pb-2">Loading page</h5>
                    <h6 class="fw-bold pt-3">Course title</h6>
                    <p>Your title should be a mix of attention-grabbing, informative, and optimized for search</p>
                    <input class="form-control mb-3" name="course-title" placeholder="Example:" value="${requestScope.course.name}">  
                    <select class="form-select text-start p-3" name="category">
                        <c:forEach items="${requestScope.categories}" var="category">
                            <c:if test="${category.id eq requestScope.course.category.id}">
                                <option value="${category.id}" selected>${category.name}</option>
                            </c:if>
                            <c:if test="${category.id ne requestScope.course.category.id}">
                                <option value="${category.id}">${category.name}</option>
                            </c:if>

                        </c:forEach>
                    </select>
                    <h6 class="fw-bold pt-3">Course description</h6>
                    <input type="hidden" id="description" name="course-description">
                    <div class="border rounded-bottom-2" id="quill-editor" style="min-height: 40vh;">
                        ${requestScope.course.description}
                    </div>
                    <div class="row pt-3">
                        <div class="col-5">
                            <div class="ratio ratio-16x9 rounded-2" 
                                 style="border: 3px dashed whitesmoke">
                            </div>
                        </div>
                        <div class="col-7">
                            <p>Upload your course image here. It must meet our course image quality standards to be accepted.<br> 
                                                        Important guidelines: .jpg, .jpeg,. gif, or .png. no text on the image.</p>
<!--                            <input type="file" class="d-none" name="image" accept="image/*" id="image"/>
                            <label class="btn btn-light fw-bold p-3 text-start" for="image">
                                Select file
                            </label>-->
                        </div>
                    </div>
                     <div class="d-flex justify-content-end">
                        <button class="btn btn-primary fw-bold p-3 mt-3" type="button"
                                onclick="submitForm();">Save changes</button>
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
        const quill = new Quill('#quill-editor', {
            theme: 'snow'
        });
        
        function submitForm() {
            document.getElementById('description').value = quill.root.innerHTML;
            document.getElementById('form').submit();
        }
        document.getElementsByClassName('tab')[1].classList.add('here');
        document.getElementsByClassName('tab')[1].classList.add('btn-light');
    </script>
    </body>
</html>

