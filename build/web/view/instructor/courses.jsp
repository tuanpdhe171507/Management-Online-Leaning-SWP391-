<%-- 
    Document   : courses
    Created on : Jun 17, 2024, 7:43:35 PM
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
    <link href="../view/assets/css/hieutc.css" rel="stylesheet" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"
        integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous" />
    <style>
        button.btn:focus {
            border-color: white !important
        }

        .here {
            background-color: #f8f9fa;
            border-bottom: 3px solid black;
            border-bottom-left-radius: 0;
            border-bottom-right-radius: 0;
        }

        .container {
            width: 70vw;
        }

        .badge {
            font-family: 'Epilogue' !important;
        }

        .item:hover {
            opacity: 30%;
            cursor: pointer;
        }

        input {
            font-family: 'Epilogue' !important;
        }
        
    </style>
</head>
<body>
    <div class="container-fluid p-0 border-bottom">
        <div class="navbar p-0">
            <div class="container pt-3">
                <div class="d-inline-block">
                    <button class="btn p-3 fw-bold" type="button" onclick="openHyperLink('overall')">
                        Overall
                    </button>
                    <button class="btn p-3 fw-bold here" type="button">
                        Courses
                    </button>
                </div>
                <%@include file="elements/navbar.jsp"%>
            </div>
        </div>
    </div>
    <div class="container pt-5 pb-5">
        <h5 class="fw-bold">Courses</h5>
        <form action="courses" method="get" id="form">
            <input type="hidden" name="sort" value="${param.sort}" id="sort"/>
            <div class="w-25">
                <div class="input-group mb-3 w-fit-content" role="group">
                    <input class="form-control border-end-0" type="text" name="query" placeholder="Search for your courses"/>
                    <button class="btn border border-start-0" type="button">
                        <ion-icon class="fs-5" name="search-outline"></ion-icon>
                    </button>
                </div>
            </div>
        </form>
        <div class="d-flex justify-content-between">
            <div class="dropdown">
                 Sort by:
                <button class="btn border-0" type="button"
                        data-bs-toggle="dropdown" aria-expanded="false">${param.sort}
                    <ion-icon class="fs-5" name="caret-down-sharp"></ion-icon>
                </button>
                <div class="dropdown-menu">
                    <button class="btn dropdown-item" type="button" onclick="submitForm('newest')">Newest</button>
                    <button class="btn dropdown-item" type="button" onclick="submitForm('oldest')">Oldest</button>
                    <button class="btn dropdown-item" type="button" onclick="submitForm('most')">Most common</button>
                    <button class="btn dropdown-item" type="button" onclick="submitForm('least')">Least common</button>
                    <button class="btn dropdown-item" type="button" onclick="submitForm('aToZ')">A - Z</button>
                    <button class="btn dropdown-item" type="button" onclick="submitForm('zToA')">Z - A</button>
                </div>
            </div>
            <button class="btn fw-bold btn-warning" type="button" onclick="openHyperLink('../course/create')">
                <ion-icon class="fs-5" name="add-sharp"></ion-icon> New course
            </button>   
        </div>
        
        <div class="row pt-3 g-3">
        <c:forEach items="${requestScope.courseList}" var="course">
            <div class="col-12">
                <div class="card position-relative">
                    <div class="row g-0">
                        <div class="col-7 item" onclick="openHyperLink('../course/curriculum?id=${course.id}')">
                            <div class="row">
                                <div class="col-5">
                                    <div class="ratio ratio-16x9">
                                        <img src="${course.thumbnail}" class="img-fluid" alt=""/>
                                    </div>
                                </div>
                                <div class="col-7 p-3">
                                    <h6 class="fw-bold">
                                        ${course.name}</h6>
                                    <h6><span class="badge text-bg-warning rounded-1">Badge</span> 
                                        <c:choose>
                                                <c:when test="${course.price == 0}">Free</c:when>
                                                <c:otherwise>${course.price}</c:otherwise>
                                            </c:choose></h6>
                                    <span>
                                        <c:if test="${course.visibility == 0}">Daft</c:if>
                                        <c:if test="${course.visibility == 1}">Public</c:if>
                                        <c:if test="${course.visibility == 2}">Private</c:if>
                                        </span>
                                </div>
                            </div>
                        </div>
                        <div class="col-5 p-3 border-start">
                            <div class="row">
                                <div class="col-6">
                                    <span class="fw-bold text-secondary">${course.getTotalEnrolledStudentsInCurrentMonth()}</span>
                                    <h6>Enrollment this month</h6>
                                    <span class="fw-bold text-secondary">${course.getTotalStudents()}</span>
                                    <h6>Total students</h6>
                                </div>
                                <div class="col-6">
                                    <span class="fw-bold text-secondary">${course.getCourseRating()} (${course.getRatings()})</span>
                                    <h6>Course ratings</h6>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </c:forEach>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"
    integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz"
    crossorigin="anonymous"></script>
    <script type="module" src="https://unpkg.com/ionicons@7.1.0/dist/ionicons/ionicons.esm.js"></script>
    <script nomodule src="https://unpkg.com/ionicons@7.1.0/dist/ionicons/ionicons.js"></script>
    <script>
        function openHyperLink(e) {
            window.location.href = e;
        }
        
        function submitForm(sort) {
            document.getElementById('sort').value = sort;
            document.getElementById('form').submit();
        }
    </script>
</body>
</html>