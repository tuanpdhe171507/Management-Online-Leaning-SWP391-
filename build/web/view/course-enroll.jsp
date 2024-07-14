<%-- 
    Document   : course-enroll
    Created on : Jun 10, 2024, 11:55:46 PM
    Author     : TuanPD
--%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
        <title>EduPort</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
        <link href="../view/assets/css/base.css" rel="stylesheet"/>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css" rel="stylesheet">
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/5.1.3/css/bootstrap.min.css">
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>


    </head>
    <body>
        <%@include file="elements/navbar.jsp"%>
        <div class="container pt-2 pb-5">
            <div style="background-color:rgb(102,205,170); padding: 10px 10px">
                <span><i class="bi bi-check-circle-fill"></i></span>
                <span>Great choice, ${requestScope.profile.name}!</span>
            </div>
            <div>
                <h6 style="padding: 20px 0px">Jump right in</h6>
            </div>
            <div class="container">

                <div class="row" style="background-color:rgb(169,169,169);color: white;height: 190px">
                    <div class="col-4">
                        <div class="ratio ratio-16x9">
                            <img src="${requestScope.course.thumbnail}" style="object-fit: cover;width: 95%;height:90%;padding: 20px 0px;margin-left: 20px">
                        </div>
                    </div>
                    <div class="col-8">
                        <h6 style="padding-top:20px">${requestScope.course.name}</h6>
                        <p style="margin-bottom: 7px">${requestScope.course.instructor.profile.name}</p>
                        <h6 class="mt-0">Your progress</h6>
                        <div style="margin-bottom: 10px">
                            <% 
                                int now =0; 
                            %>
                            <div class="progress rounded-5">
                                <div class="progress-bar" role="progressbar" style="width: <%= now %>%;" aria-valuenow="<%= now %>" aria-valuemin="0" aria-valuemax="100">
                                    <%= now %>%
                                </div>
                            </div>
                        </div>
                        <button style="background-color: black; color: white; padding: 10px; transition: background-color 0.2s; border: none"
                                class="rounded-2"
                                onmouseover="this.style.backgroundColor = 'gray'" 
                                onmouseout="this.style.backgroundColor = 'black'"
                                onclick="enroll()">Start course</button>
                    </div>
                </div>
            </div>
            <div class="row">
            <h6 style="padding: 20px 10px">Top courses of <a href="../instructor?emailAdress=${requestScope.course.instructor.email}"> ${requestScope.course.instructor.profile.name}</a></h6>
                <c:forEach items="${requestScope.courseList}" var="course">
                    <div class="col-3">
                        <div class="card dropdown dropend" style="border: none">
                            <div class="ratio ratio-16x9 dropdown dropend" onclick="openHyperLink(${course.id})">
                                <img class="card-img-top" src="${course.thumbnail}" />   
                            </div>
                            <button class="btn btn-light position-absolute end-0 z-2" type="button" data-bs-toggle="dropdown" aria-expanded="false">
                                <ion-icon name="return-down-forward-outline"></ion-icon>
                                </span>
                            </button>
                            <div class="w-100 dropdown-menu p-3 ms-1" style="font-size: unset;">
                                <h6>${course.name}</h6>
                                <h6 class="d-inline"><span class="badge text-bg-warning">${course.badge}</span></h6>
                                <span class="text-success" style="font-size: unset;">Updated on ${course.getLastUpdatedDate()}</span><br>
                                <span class="text-secondary">${course.sectionList.size()} sections, 
                                    ${course.getSumOfLesson()} lessons</span>
                                <hr>
                                <span>${course.tagLine}</span><br>
                                <ul>
                                    <c:forEach items="${course.objectives.subList(0,
                                                        course.objectives.size() > 4 ? 2 : sliderList.size())}" var="objective">
                                               <li>${objective}</li>
                                               </c:forEach> 
                                </ul>
                                <button class="btn btn-dark" onclick="sendIdToServlet(${course.id})">Add to wishlist</button>
                            </div>
                            <div class="card-body" style="padding-left: 0px" onclick="openHyperLink(${course.id})">
                                <h6 class="m-0">${course.name}</h6>
                                <span class="text-secondary">${course.instructor.profile.name}</span>
                                <h6><c:choose>
                                        <c:when test="${course.price == 0}">Free</c:when>
                                        <c:otherwise>${course.getCurrentPrice()}</c:otherwise>
                                    </c:choose></h6>
                                <h6><span class="badge text-bg-warning">${course.badge}</span></h6>
                            </div>
                        </div>
                    </div>
                </c:forEach>

            </div>

            <div class="row">
                <h6>Top courses have a high quality rate</h6>
                <c:forEach items="${requestScope.courseListAllByStar}" var="course">
                    <div class="col-3">
                        <div class="card dropdown dropend" style="border: none">
                            <div class="ratio ratio-16x9 dropdown dropend" onclick="openHyperLink(${course.id})">
                                <img class="card-img-top" src="${course.thumbnail}" />   
                            </div>
                            <button class="btn btn-light position-absolute end-0 z-2" type="button" data-bs-toggle="dropdown" aria-expanded="false">
                                <ion-icon name="return-down-forward-outline"></ion-icon>
                                </span>
                            </button>
                            <div class="w-100 dropdown-menu p-3 ms-1" style="font-size: unset;">
                                <h6>${course.name}</h6>
                                <h6 class="d-inline"><span class="badge text-bg-warning">${course.badge}</span></h6>
                                <span class="text-success" style="font-size: unset;">Updated on ${course.getLastUpdatedDate()}</span><br>
                                <span class="text-secondary">${course.sectionList.size()} sections, 
                                    ${course.getSumOfLesson()} lessons</span>
                                <hr>
                                <span>${course.tagLine}</span><br>
                                <ul>
                                    <c:forEach items="${course.objectives.subList(0,
                                                        course.objectives.size() > 4 ? 2 : sliderList.size())}" var="objective">
                                               <li>${objective}</li>
                                               </c:forEach> 
                                </ul>
                                <button class="btn btn-dark" onclick="sendIdToServlet(${course.id})">Add to wishlist</button>
                            </div>
                            <div class="card-body" style="padding-left: 0px" onclick="openHyperLink(${course.id})">
                                <h6 class="m-0">${course.name}</h6>
                                <span class="text-secondary">${course.instructor.profile.name}</span>
                                <h6><c:choose>
                                        <c:when test="${course.price == 0}">Free</c:when>
                                        <c:otherwise>${course.getCurrentPrice()}</c:otherwise>
                                    </c:choose></h6>
                                <h6><span class="badge text-bg-warning">${course.badge}</span></h6>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>

        <%@include file="elements/footer.jsp"%>
        <script>
            function openHyperLink(e) {
                window.location.href = "details?id=" + e;
            }
            ;
            function  enroll() {
                var courseId = "${requestScope.course.id}";
                var enrollUrl = "http://localhost:8080/SWP391/course/page?course=" + encodeURIComponent(courseId);
                window.location.href = enrollUrl;
            }



        </script>
        <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.10.2/dist/umd/popper.min.js"></script>
        <script src="https://stackpath.bootstrapcdn.com/bootstrap/5.1.3/js/bootstrap.min.js"></script>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/5.1.3/js/bootstrap.bundle.min.js"></script>
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script type="module" src="https://unpkg.com/ionicons@7.1.0/dist/ionicons/ionicons.esm.js"></script>
        <script nomodule src="https://unpkg.com/ionicons@7.1.0/dist/ionicons/ionicons.js"></script>

    </body>
</html>
