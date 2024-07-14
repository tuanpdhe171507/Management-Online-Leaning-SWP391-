<%-- 
    Document   : course.jsp
    Created on : May 20, 2024, 3:04:04 PM
    Author     : HieuTC
--%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="dao.AdministratorContext" %>
<!doctype html>
<html lang="en">
    <head>
        <meta charset="utf-8"/>
        <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
        <title>EduPort</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
        <link href="view/assets/css/hieutc.css" rel="stylesheet"/>
        <style>
            .card {
                border: unset !important;
            }
        </style>
    </head>
    <body>
        <%@include file="elements/navbar.jsp"%>
        <div class="container mb-5">
            <div class="carousel slide" id="carousel">
                <div class="carousel-indicators">
                    <c:set var="sliderCount" value="0"/>
                    <c:forEach var="item" items="${requestScope.sliderList}">
                        <button type="button" data-bs-target="#carousel"
                                data-bs-slide-to="${sliderCount}" 
                                <c:if test="${sliderCount == 0}">class="active" aria-current="true"</c:if>></button>   
                        <c:set var="sliderCount" value="${sliderCount + 1}"/>
                    </c:forEach>
                </div>
                <div class="carousel-inner ">
                    <c:forEach items="${requestScope.sliderList}" var="slider">
                        <div class="carousel-item position-relative
                             <c:if test="${requestScope.sliderList.indexOf(slider) == 0}"> active</c:if>" data-bs-interval="1000">
                            <img class="w-100 d-block" src="${slider.imagePath}"/>
                            <div class="position-absolute text-dark start-0 bottom-0 p-3">
                                <h5>${slider.title}</h5>
                                <p>${slider.description}</p>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </div>
        <div class="container mb-5">
            <div class="mb-4">
                <h5 class="fw-bold">Leading courses</h5>
                <h6 class="fw-bold">Because you searched for "<a href="">a keyword</a>"</h6>
            </div>
            <div class="row gx-3">
                <%AdministratorContext dbContext = new AdministratorContext();
                    int rows = Integer.parseInt(dbContext.getValue("rows_per_division"));
                    int columns = Integer.parseInt(dbContext.getValue("columns_per_row"));
                    request.setAttribute("columns", columns * rows);
                %>
            <c:forEach items="${requestScope.courseList}" var="course">
                <c:if test="${requestScope.courseList.indexOf(course) < columns}">
                <div class="col-<%=12/columns%>">
                    <div class="card dropdown dropend">
                        <div class="ratio ratio-16x9 dropdown dropend" onclick="openCourse(${course.id})">
                            <img class="rounded-2" src="${course.thumbnail}"/>   
                        </div>
                        <button class="btn position-absolute end-0 z-2" type="button" data-bs-toggle="dropdown" aria-expanded="false">
                            <ion-icon class="fs-5" name="crop-sharp"></ion-icon>
                        </span>
                        </button>
                        <div class="w-100 dropdown-menu p-3 ms-1" style="font-size: unset;">
                            <h6 class="fw-bold">${course.name}</h6>
                            <h6 class="d-inline"><span class="badge text-bg-warning">${course.badge}</span></h6>
                            <span class="text-success fw-bold" style="font-size: unset;">Updated on ${course.getLastUpdatedDate()}</span><br>
                            <span class="text-secondary">${course.sectionList.size()} sections, 
                            ${course.getSumOfLesson()} lessons</span>
                            <hr>
                            <span>${course.tagLine}</span><br>
                            <ul>
                            <c:forEach items="${course.objectives.subList(0,
                                       course.objectives.size() > 2 ? 2 : course.objectives.size())}" var="objective">
                                <li>${objective}</li>
                            </c:forEach> 
                            </ul>
                            <button class="w-100 btn btn-dark fw-bold" onclick="sendIdToServlet(${course.id})">Add to wishlist</button>
                        </div>
                        <div class="card-body" onclick="openCourse(${course.id})">
                            <h6 class="m-0 fw-bold">${course.name}</h6>
                            <span class="text-secondary">${course.instructor.profile.name}</span>
                            <h6><c:choose>
                                    <c:when test="${course.price == 0}">Free</c:when>
                                    <c:otherwise>${course.getCurrentPrice()}</c:otherwise>
                            </c:choose></h6>
                            <h6><span class="badge text-bg-warning">${course.badge}</span></h6>
                        </div>
                    </div>
                </div>
                </c:if>
             </c:forEach>
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