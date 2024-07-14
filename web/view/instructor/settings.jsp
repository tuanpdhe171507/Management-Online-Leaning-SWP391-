<%-- 
    Document   : settings
    Created on : Jun 24, 2024, 10:09:21 PM
    Author     : HieuTC
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!doctype html>
<html lang="en">

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Pricing | ${requestScope.course.name}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"
        integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    <Link href="../view/assets/css/hieutc.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/quill@2.0.2/dist/quill.snow.css" rel="stylesheet">
    <style>
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
                         ${requestScope.course.name}
                    </h6>
                </div>
                
            </div>
        </nav>
    </div>
    <div class="container">
        <div class="row">
            <%@include file="elements/slidebar.jsp"%>
            <div class="col-9 pt-5 ps-5 border-start" style="min-height: 100vh;">
                <h5 class="fw-bold pt-3">Settings</h5>
                <p>This course is not published on the our marketplace</p>
                <div class="dropdown pb-3" style="width: 13rem;">
                    <button class="w-100 btn p-3 border text-start fw-bold" type="button" data-bs-toggle="dropdown" aria-expanded="false">
                        <c:choose>
                            <c:when test="${course.visibility == 0}">Daft</c:when>
                            <c:when test="${course.visibility == 1}">Public</c:when>
                            <c:when test="${course.visibility == 2}">Private</c:when>
                        </c:choose><ion-icon name="caret-down-sharp"></ion-icon>
                    </button <c:if test="${course.visibility == 0}">disabled="true"</c:if>>
                    <div class="dropdown-menu">
                        <button class="btn dropdown-item fw-bold"  type="button" onclick="setCourseState(2)">
                            Set to private<br>
                            <span class="fw-normal text-secondary">New students cannot find your course via search.</span>
                        </button>
                        <button class="btn dropdown-item fw-bold" type="button" onclick="setCourseState(1)">
                            Set to public<br>
                            <span class="fw-normal text-secondary">New students can search and enroll your course.</span>
                        </button>
                    </div>
                </div>
                <form action="curriculum" method="post" id="form">
                    <input type="hidden" name="course" value="${requestScope.course.id}"/>
                </form>    
                <button class="btn p-3 border text-start mb-3 fw-bold" style="width: 13rem;" type="button"
                        data-bs-toggle="modal" data-bs-target="#confirmee">
                    Delete course
                </button>
                
                
                <p>Note: students is all unenrolled from your course, every related data will be delete forever.</p>
            </div>
        </div>
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
                    <p>Are you sure you want to delete this course? This is permanent and cannot be undone.</p>
                    <div class="d-flex justify-content-end">
                        <button class="btn" type="button" data-bs-dismiss="modal"  aria-label="Close">
                            Cancel
                        </button>
                        <button class="btn fw-bold text-danger" type="button" id="confirmee-btn"
                                data-bs-dismiss="modal" aria-label="Close" onclick="deleteCourse();">
                            Understood
                        </button>
                    </div>
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
        function openHyperLink(e) {
            window.location.href = e;
        }
        
        function setCourseState(e) {
            var xhttp = new XMLHttpRequest();
            xhttp.onreadystatechange = function() {
                if (this.readyState == 4 && this.status == 200) {
                    window.location.reload();
                }
            };

            xhttp.open("get", "set-state?course=" + ${param.id} + "&state=" + e, true);
            xhttp.send();
        }
        
        function deleteCourse() {
            document.getElementById('form').submit();
        }
    </script>
</body>

</html>