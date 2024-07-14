<%-- 
    Document   : courses
    Created on : Jul 8, 2024, 5:05:19 PM
    Author     : HieuTC
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="dao.AdministratorContext" %>

<!doctype html>
<html lang="en">
    <head>
        <meta charset="utf-8"/>
        <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
        <title>EduPort</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
        <link href="view/assets/css/hieutc.css" rel="stylesheet"/>
    </head>
    <body>
        <%@include file="elements/navbar.jsp"%>
        <div class="container pt-5 pb-5 body">
            <h5 class="fw-bold pb-3">${requestScope.category.name} Courses</h5>
            <h5 class="fw-bold">Popular courses</h5>
            <div class="dropdown pb-3">
                <button class="btn btn-light fw-bold" type="button"
                        data-bs-toggle="dropdown" aria-expanded="false">
                    <c:choose>
                        <c:when test="${param.sort == 'highest'}">
                            Highest rated
                        </c:when>
                        <c:when test="${param.sort == 'most'}">
                            Most students
                        </c:when>
                        <c:otherwise>
                            Newest
                        </c:otherwise>
                    </c:choose> <ion-icon name="caret-down-sharp"></ion-icon>
                </button>
                <div class="dropdown-menu">
                    <a class="btn dropdown-item" href="?category=${param.category}&sort=highest">Highest rated</a>
                    <a class="btn dropdown-item" href="?category=${param.category}&sort=most">Most students</a>
                    <a class="btn dropdown-item" href="?category=${param.category}&sort=newest">Newest</a>
                </div>
            </div>
            <div class="row">
                <%AdministratorContext dbContext = new AdministratorContext();
                    int rows = Integer.parseInt(dbContext.getValue("rows_per_division"));
                    int columns = Integer.parseInt(dbContext.getValue("columns_per_row"));
                    request.setAttribute("columns", columns * rows);
                %>
                <c:if test="${requestScope.courseList.isEmpty()}">
                    <p class="text-center">No results found.</p>
                </c:if>
                <c:forEach items="${requestScope.courseList}" var="course">
                    <c:if test="${requestScope.courseList.indexOf(course) < columns}">
                    <div class="col-<%=12/columns%>">
                        <div class="card" style="border: unset !important;">
                            <div class="ratio ratio-16x9 dropdown dropend" onclick="openCourse(${course.id})">
                                <img class="border rounded-2" src="${course.thumbnail}"/>   
                            </div>
                            <div class="card-body p-0 pt-3">
                                <h6 class="fw-bold m-0">${course.name}</h6>
                                <span class="text-secondary">${course.instructor.profile.name}</span>
                                <h6 class="fw-bold text-warning">
                                    ${course.getCourseRating()}
                                                <c:choose>
                                                    <c:when test="${course.getCourseRating() < 0.5}">
                                                    <ion-icon name="star-outline"></ion-icon>
                                                    </c:when>
                                                    <c:when test="${course.getCourseRating() <= 0.5
                                                                    && course.getCourseRating() < 1.0}">
                                                    <ion-icon name="star-half-outline"></ion-icon>
                                                    </c:when>
                                                    <c:otherwise>
                                                    <ion-icon name="star"></ion-icon>
                                                    </c:otherwise>
                                                </c:choose>
                                                <c:choose>
                                                    <c:when test="${course.getCourseRating() < 1.5}">
                                                    <ion-icon name="star-outline"></ion-icon>
                                                    </c:when>
                                                    <c:when test="${course.getCourseRating() <= 1.5
                                                                    && course.getCourseRating() < 2.0}">
                                                    <ion-icon name="star-half-outline"></ion-icon>
                                                    </c:when>
                                                    <c:otherwise>
                                                    <ion-icon name="star"></ion-icon>
                                                    </c:otherwise>
                                                </c:choose>
                                                <c:choose>
                                                    <c:when test="${course.getCourseRating() < 2.5}">
                                                    <ion-icon name="star-outline"></ion-icon>
                                                    </c:when>
                                                    <c:when test="${course.getCourseRating() <= 2.5
                                                                    && course.getCourseRating() < 3.0}">
                                                    <ion-icon name="star-half-outline"></ion-icon>
                                                    </c:when>
                                                    <c:otherwise>
                                                    <ion-icon name="star"></ion-icon>
                                                    </c:otherwise>
                                                </c:choose>
                                                <c:choose>
                                                    <c:when test="${course.getCourseRating() < 3.5}">
                                                    <ion-icon name="star-outline"></ion-icon>
                                                    </c:when>
                                                    <c:when test="${course.getCourseRating() <= 3.5
                                                                    && course.getCourseRating() < 4.0}">
                                                    <ion-icon name="star-half-outline"></ion-icon>
                                                    </c:when>
                                                    <c:otherwise>
                                                    <ion-icon name="star"></ion-icon>
                                                    </c:otherwise>
                                                </c:choose>
                                                <c:choose>
                                                    <c:when test="${course.getCourseRating() < 4.5}">
                                                    <ion-icon name="star-outline"></ion-icon>
                                                    </c:when>
                                                    <c:when test="${course.getCourseRating() <= 4.5
                                                                    && course.getCourseRating() < 5.0}">
                                                    <ion-icon name="star-half-outline"></ion-icon>
                                                    </c:when>
                                                    <c:otherwise>
                                                    <ion-icon name="star"></ion-icon>
                                                    </c:otherwise>
                                                </c:choose>
                                                    <span class="text-secondary">(${course.getRatings()})</span>
                                </h6>
                                <h5>
                                    <span class="badge text-bg-warning rounded-0">${course.badge}</span>
                                </h5>
                            </div>
                        </div>
                                
                    </div>    
                    </c:if>
                </c:forEach>
                <h5 class="fw-bold pt-3">Popular instructors</h5>
                <div class="row">
                <c:if test="${requestScope.instructorList.isEmpty()}">
                    <p class="text-center pt-3 pb-3">No results found.</p>
                </c:if>
                <c:forEach items="${requestScope.instructorList}" var="instructor">
                    <div class="col-<%=12/columns%>">
                        <div class="card">
                            <div class="card-body">
                                <div class="row">
                                    <div class="col-3">
                                        <div class="ratio ratio-1x1">
                                            <img class="rounded-2 border" src="${instructor.profile.picture}"/>
                                        </div>
                                    </div>
                                    <div class="col-9">
                                        <h6 class="fw-bold m-0">${instructor.profile.name}</h6>
                                        <span>${instructor.profile.headline}</span>
                                        <h6 class="fw-bold text-warning m-0 pt-2"><ion-icon name="star-sharp"></ion-icon> ${instructor.getInstructorRating()}</h6>
                                        <h6>${instructor.getTotalStudents()} students</h6>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
                </div>
            </div>
        </div>
        <%@include file="elements/footer.jsp"%>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script type="module" src="https://unpkg.com/ionicons@7.1.0/dist/ionicons/ionicons.esm.js"></script>
        <script nomodule src="https://unpkg.com/ionicons@7.1.0/dist/ionicons/ionicons.js"></script>
        <script>
                            function openCourse(e) {
                                window.location.href = "course/details?id=" + e;
                            };
        </script>
    </body>
</html>
