<%-- 
    Document   : course
    Created on : May 14, 2024, 6:15:14 PM
    Author     : TuanPD
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!doctype html>
<html>

    <head>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
        <link href="view/assets/css/base.css" rel="stylesheet" />
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
        <style>

            .btn-group button {
                background-color: white;
                border: 1px solid black;
                color: black;
                padding: 10px 24px;
                cursor: pointer;
                float: left;
            }
            .btn-group button:not(:last-child) {
                border-right: none;
            }
            .btn-group:after {
                content: "";
                clear: both;
                display: table;
            }
            .btn-group button:hover {
                background-color: rgb(176,196,222);
            }
            .btn-group button{
                width: 250px;
                margin: 0px 0px;
                margin-top: 40px;
            }
        </style>
    </head>

    <body>
        <%@include file="elements/navbar.jsp"%>

        <div class="container pt-4 pb-4 d-flex" style="margin-left: 20%">
            <div class="row profile">
                <div class="col-6">
                    <h5>INSTRUCTOR</h5>
                    <h6>${requestScope.instructor.profile.name}</h5>
                        <h6>${requestScope.instructor.profile.headline}</h6>
                        <div class="d-flex">
                            <div>
                                <div>Total students</div>
                                <div>${requestScope.totalStudentInstructor.size()}</div>
                            </div>
                            <div style="margin-left: 15px;">
                                <div>Reviews</div>
                                <div>${requestScope.sumRatingOfCourses.size()}</div>
                            </div>
                        </div></br><br>
                        <h4 style="margin-bottom: -20px;">About me</h4></br>
                        <p>
                        <div class="mt-1">
                            <c:forEach items="${requestScope.instructor.biography}" var="i">
                                ${i}
                            </c:forEach>
                        </div>
                        </p></br></br>
                        <h4 style="margin-top: -20px;">My courses (${requestScope.listC.size()})</h4></br>
                        <c:forEach items="${requestScope.listC}" var="course" varStatus="status">
                            <c:if test="${status.index % 2 == 0}">
                                <div class="row">
                                </c:if>
                                <div class="col-6">
                                    <div class="card dropdown dropend" style="border: none">
                                        <div class="ratio ratio-16x9 dropdown dropend" onclick="openHyperLink(${course.id})">
                                            <img class="card-img-top" src="${course.thumbnail}" />
                                        </div>
                                        <div class="w-100 dropdown-menu p-3 ms-1" style="font-size: unset;">
                                            <h6>${course.name}</h6>
                                            <h6 class="d-inline"><span class="badge text-bg-warning">${course.badge}</span></h6>
                                            <span class="text-success" style="font-size: unset;">Updated on ${course.getLastUpdatedDate()}</span><br>
                                            <span class="text-secondary">${course.sectionList.size()} sections, 
                                                ${course.getSumOfLesson()} lessons</span>
                                            <hr>
                                            <span>${course.tagLine}</span><br>
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
                                <c:if test="${status.index % 2 == 1 || status.index == requestScope.listC.size() - 1}">
                                </div>
                            </c:if>
                        </c:forEach>
                </div>

                <div class="col-4">
                    <div>
                        <img  src="${requestScope.instructor.profile.picture}" alt="" style="width: 250px;height:200px"/>
                    </div>

                    <div class="btn-group">
                        <button>
                            <i style="font-size:15px" class="fa">&#xf082;</i>
                            Facebook</button>
                    </div></br>
                    <div class="btn-group">
                        <button>
                            <i style="font-size:15px" class="fa">&#xf08c;</i>
                            Linkedin</button>
                    </div></br>
                    <div class="btn-group">
                        <button>
                            <i style='font-size:15px' class='fab'>&#xf431;</i>
                            Youtobe</button>
                    </div>

                </div>
            </div>

        </div>
        <%@include file="elements/footer.jsp"%>
        <script>
            function openHyperLink(e) {
                window.location.href = "course/details?id=" + e;
            }
            ;
        </script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script type="module" src="https://unpkg.com/ionicons@7.1.0/dist/ionicons/ionicons.esm.js"></script>
        <script nomodule src="https://unpkg.com/ionicons@7.1.0/dist/ionicons/ionicons.js"></script>

    </body>

</html>