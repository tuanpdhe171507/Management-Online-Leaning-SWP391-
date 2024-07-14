<%-- 
    Document   : dashboard
    Created on : Jul 6, 2024, 5:38:30 PM
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

            #search {
                border: unset !important;
            }

            #icon {
                border: unset;
                background-color: unset;
                padding: 0;
                transform: translateY(-10%);
            }

            .content {
                width: 70vw;
            }

            .icon {
                padding-left: 1.2rem !important;
                padding-right: 1.2rem !important;
            }
        </style>
    </head>
    <body>
        <%@include file="elements/navbar.jsp"%>
        <div class="container content pt-5 pb-5">
            <div class="pb-5">
                <button class="btn fw-bold ps-0 pe-0 m-0 rounded-0" type="button"
                        style="border-bottom: 3px solid black;"
                        onclick="openHyperLink('dashboard')">
                    Dashboard
                </button>
                <button class="btn fw-bold ps-0 pe-0 m-0 ms-3 text-secondary"
                        type="button"
                        onclick="openHyperLink('settings')">
                    Settings
                </button>
                <hr class="m-0">
            </div>
            <div class="row g-3">
                <div class="col-8">
                    <div class="card">
                        <div class="card-body">
                            <canvas id="line" class="w-100 h-auto"></canvas>
                        </div>
                    </div>
                   
                </div>
                <div class="col-4">
                    <div class="row g-3">
                        <div class="col-12">
                            <div class="card">
                                <div class="card-body">
                                    <div class="row">
                                        <div class="col-6">
                                           <h6>Total courses</h6>
                                           <span>${requestScope.totalCourse}</span> 
                                        </div>
                                        <div class="col-6 border-start ps-3">
                                            <h6>This month</h6>
                                            <span>
                                                <ion-icon class="
                                                <c:if test="${requestScope.numberCourseLastMonth < requestScope.numberCourseCurrentMonth}">
                                                     text-success" name="trending-up-sharp"
                                                </c:if>
                                                <c:if test="${requestScope.numberCourseLastMonth > requestScope.numberCourseCurrentMonth}">
                                                     text-danger" name="trending-down-sharp"
                                                </c:if>></ion-icon>
                                               ${requestScope.numberCourseCurrentMonth}</span>
                                        </div>
                                    </div>
                                    
                                </div>
                            </div>
                        </div>
                        <div class="col-12">
                            <div class="card">
                                <div class="card-body">
                                    <div class="row">
                                        <div class="col-6">
                                           <h6>Total students</h6>
                                            <span>${requestScope.totalStudent}</span> 
                                        </div>
                                        <div class="col-6 border-start ps-3">
                                            <h6>This month</h6>
                                            <span>
                                                
                                                <ion-icon class="
                                                <c:if test="${requestScope.numberStudentLastMonth < requestScope.numberStudentCurrentMonth}">
                                                     text-success" name="trending-up-sharp"
                                                </c:if>
                                                <c:if test="${requestScope.numberStudentLastMonth > requestScope.numberStudentCurrentMonth}">
                                                     text-danger" name="trending-down-sharp"
                                                </c:if>></ion-icon>
                                                ${requestScope.numberStudentCurrentMonth}</span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-12">
                            <div class="card">
                                <div class="card-body">
                                    <div class="row d-flex align-items-center">
                                        <div class="col-6">
                                           <canvas id="pie" class="w-100 h-auto"></canvas> 
                                        </div>
                                        <div class="col-6 border-start ps-3">
                                            <h6>This month</h6>
                                            <div class="pb-3">
                                                
                                                <h6>Positive</h6>
                                                <span>${requestScope.numberPositiveRatingCurrentMonth}</span>   
                                            </div>
                                            
                                            <h6>Negative</h6>
                                            <span>${requestScope.numberRatingCurrentMonth - requestScope.numberPositiveRatingCurrentMonth}</span>
                                        </div>
                                        
                                    </div>
                                    
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-12 pt-5">
                    <div class="row">
                        <div class="col-4">
                            <h6 class="fw-bold">Requests</h6>
                            <div class="row gy-2">
                                <div class="col-12 d-flex align-items-center">
                                    <div class="border rounded-2 p-3 icon">
                                        <ion-icon class="fs-4" name="telescope-sharp"></ion-icon>
                                    </div>
                                    <div class="ps-2">
                                        <h6 class="fw-bold m-0">Review</h6>
                                        <span class="text-secondary">View and evaluate course contents</span>
                                    </div>
                                </div>
                                <div class="col-12 d-flex align-items-center">
                                    <div class="border rounded-2 p-3 icon">
                                        <ion-icon class="fs-4" name="bug-sharp"></ion-icon>
                                    </div>
                                    <div class="ps-2">
                                        <h6 class="fw-bold m-0">Report</h6>
                                        <span class="text-secondary">Violate platform policies contents</span>
                                    </div>
                                </div>
                            </div>
                        </div>    
                        <div class="col-4">
                            <h6 class="fw-bold">Users</h6>
                            <div class="row gy-2">
                                <div class="col-12 d-flex align-items-center">
                                    <div class="border rounded-2 p-3 icon">
                                        <ion-icon class="fs-4" name="school-sharp"></ion-icon>
                                    </div>
                                    <div class="ps-2">
                                        <h6 class="fw-bold m-0">User management</h6>
                                        <span class="text-secondary">View and evaluate course contents</span>
                                    </div>
                                </div>
                            </div>
                        </div>  
                        <div class="col-4">
                            <h6 class="fw-bold">Courses</h6>
                            <div class="row gy-2">
                                <div class="col-12 d-flex align-items-center">
                                    <div class="border rounded-2 p-3 icon">
                                       <ion-icon class="fs-4" name="infinite-sharp"></ion-icon>
                                    </div>
                                    <div class="ps-2">
                                        <h6 class="fw-bold m-0">Course management</h6>
                                        <span class="text-secondary">View and evaluate course contents</span>
                                    </div>
                                </div>
                            </div>
                        </div>  
                        </div>
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
        <script src="../view/assets/js/base.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
        <script>
            const lineData = {
                labels: [<c:forEach items="${requestScope.spots}" var="spot">'${spot.month}'<c:if test="${requestScope.spots.indexOf(spot) != requestScope.spots.size() - 1}">,</c:if> </c:forEach>],
                datasets: [{
                    label: 'Enrollments',
                    data: [<c:forEach items="${requestScope.spots}" var="spot">${spot.enrollments}<c:if test="${requestScope.spots.indexOf(spot) != requestScope.spots.size() - 1}">,</c:if> </c:forEach>],
                    fill: false,
                    borderColor: 'rgb(75, 192, 192)',
                    tension: 0.1
                },{
                    label: 'Ratings',
                    data: [<c:forEach items="${requestScope.spots}" var="spot">${spot.ratings}<c:if test="${requestScope.spots.indexOf(spot) != requestScope.spots.size() - 1}">,</c:if> </c:forEach>],
                    fill: false,
                    borderColor: 'rgb(255, 99, 132)',
                    tension: 0.1
                }]
            };
            
            const lineConfig = {
                type: 'line',
                data: lineData,
                options: {
                    plugins: {
                        legend: {
                            display: false // Hide the legend
                        }
                    }
                }
            };
            
            const lineCtx = document.getElementById('line').getContext('2d');
            const lineChar = new Chart(lineCtx, lineConfig);
            
            const pieData = {
  labels: [
    'Negative',
    'Positive'
  ],
  datasets: [{
    label: 'Ratings',
    data: [${requestScope.totalRatings - requestScope.totalPositiveRatings}, ${requestScope.totalPositiveRatings}],
    backgroundColor: [
      'rgb(255, 99, 132)',
      'rgb(54, 162, 235)',
      'rgb(255, 205, 86)'
    ],
    hoverOffset: 4
  }]
};
const pieConfig = {
  type: 'doughnut',
  data: pieData,
  options: {
                    plugins: {
                        legend: {
                            display: false // Hide the legend
                        }
                    }
                }
};

 const pieCtx = document.getElementById('pie').getContext('2d');
            const pieChar = new Chart(pieCtx, pieConfig);
        </script>
    </body>
</html>
