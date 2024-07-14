<%-- 
    Document   : overall
    Created on : Jun 17, 2024, 11:29:06 PM
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

        .form-check-input:focus {
            border-color: white !important;
        }
    </style>
</head>
<body>
    <div class="container-fluid p-0 border-bottom">
        <div class="navbar p-0">
            <div class="container pt-3">
                <div class="d-inline-block">
                    <button class="btn p-3 fw-bold here" type="button">
                        Overall
                    </button>
                    <button class="btn p-3 fw-bold" type="button" onclick="openHyperLink('courses')">
                        Courses
                    </button>
                </div>
                <%@include file="elements/navbar.jsp"%>
            </div>
        </div>
    </div>
    <div class="container pt-5 pb-5">
        <h5 class="fw-bold">Reports</h5>
        <div class="row gy-3">
            <div class="col-6">
                <canvas id="line" class="w-100 h-auto"></canvas>
            </div>
            <div class="col-3">
                <canvas id="one" class="w-100 h-auto"></canvas>
            </div>
            <div class="col-3">
                <canvas id="two" class="w-100 h-auto"></canvas>
            </div>
            <div class="col-6">
                <h6 class="text-center">Enrollments in most recent 4 months</h6>
            </div>
            <div class="col-3">
                <h6 class="text-center">Free/ paid course</h6>
            </div>
            <div class="col-3">
                <h6 class="text-center">Most common/ others</h6>
            </div>
        </div>
    </div>
    <div class="container pt-5 pb-5">
        <h5 class="fw-bold">Feedback</h5>
        <div class="pt-2 pb-3">
            <div class="dropdown d-inline-block">
                <button class="btn border" type="button"
                data-bs-toggle="dropdown" aria-expanded="false">Rating <ion-icon clas="fs-5" name="caret-down-sharp"></ion-icon></button>
                <div class="dropdown-menu">
                    <button class="dropdown-item" type="button">
                        <input type="checkbox" class="form-check-input" name="star" id="1-star" onchange="getRating()"/>
                        <label class="form-check-label ps-2 w-100" for="1-star">1 star</label>
                    </button>
                    <button class="dropdown-item" type="button">
                        <input type="checkbox" class="form-check-input" name="star" id="2-star" onchange="getRating()"/>
                        <label class="form-check-label ps-2 w-100" for="2-star">2 star</label>
                    </button>
                    <button class="dropdown-item" type="button">
                        <input type="checkbox" class="form-check-input" name="star" id="3-star" onchange="getRating()"/>
                        <label class="form-check-label ps-2 w-100" for="3-star">3 star</label>
                    </button>
                    <button class="dropdown-item" type="button">
                        <input type="checkbox" class="form-check-input" name="star" id="4-star" onchange="getRating()"/>
                        <label class="form-check-label ps-2 w-100" for="4-star">4 star</label>
                    </button>
                    <button class="dropdown-item" type="button">
                        <input type="checkbox" class="form-check-input" name="star" id="5-star" onchange="getRating()"/>
                        <label class="form-check-label ps-2 w-100" for="5-star">5 star</label>
                    </button>
                </div>
            </div>
            <div class="dropdown d-inline-block ps-2">
                <button class="btn border" type="button"
                data-bs-toggle="dropdown" aria-expanded="false">Sort <ion-icon clas="fs-5" name="caret-down-sharp"></ion-icon></button>
                <div class="dropdown-menu">
                    <button class="dropdown-item" type="button" onclick="sortRating('newest')">Newest first</button>
                    <button class="dropdown-item" type="button" onclick="sortRating('oldest')">Oldest first</button>
                </div>
            </div>
        </div>
        <div class="row gy-3" id="ratings">
            
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"
    integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz"
    crossorigin="anonymous"></script>
    <script type="module" src="https://unpkg.com/ionicons@7.1.0/dist/ionicons/ionicons.esm.js"></script>
    <script nomodule src="https://unpkg.com/ionicons@7.1.0/dist/ionicons/ionicons.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script>
        
        function openHyperLink(e) {
            window.location.href = e;
        }
        
        const labels = [<c:forEach items="${requestScope.reports}" var="report">'${report.month}'<c:if test="${requestScope.reports.indexOf(report) != requestScope.reports.size() - 1}">,</c:if> </c:forEach>];
        const line = {
            labels: labels,
            datasets: [{
                label: 'My First Dataset',
                data: [<c:forEach items="${requestScope.reports}" var="report">'${report.student}'<c:if test="${requestScope.reports.indexOf(report) != requestScope.reports.size() - 1}">,</c:if> </c:forEach>],
                fill: false,
                borderColor: 'rgb(75, 192, 192)',
                tension: 0.1
            }]
        };

        const lineConfig = {
            type: 'line',
            data: line,
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

        const pieOne = {
                labels: [
                <c:choose>
                        <c:when test="${requestScope.freeCourse == 0 && requestScope.paidCourse == 0}">
                            'No report'
                        </c:when>
                        <c:otherwise>
                            'Free course',
                            'Paid course'
                        </c:otherwise>
                    </c:choose>
                    
                ],
                datasets: [{
                    label: 'Enrollments: ',
                    data: [
                    <c:choose>
                        <c:when test="${requestScope.freeCourse == 0 && requestScope.paidCourse == 0}">
                            1
                        </c:when>
                        <c:otherwise>
                            ${requestScope.freeCourse}, ${requestScope.paidCourse}
                        </c:otherwise>
                    </c:choose>
                            ],
                    backgroundColor: [
                        <c:choose>
                        <c:when test="${requestScope.freeCourse == 0 && requestScope.paidCourse == 0}">
                            '#eee'
                        </c:when>
                        <c:otherwise>
                            '#ffc107',
                            '#eee'
                        </c:otherwise>
                    </c:choose>
                        
                    ],
                    hoverOffset: 4
                }]
            };

            const oneConfig = {
                type: 'doughnut',
                data: pieOne,
                options: {
                plugins: {
                    legend: {
                        display: false // Hide the legend
                        }
                    }
                }
            };

            var oneCtx = document.getElementById('one').getContext('2d');
            var oneChar = new Chart(oneCtx, oneConfig);
            
            const pieTwo = {
                labels: [
                <c:choose>
                        <c:when test="${requestScope.freeCourse == 0 && requestScope.paidCourse == 0}">
                            'No report'
                        </c:when>
                        <c:otherwise>
                            <c:forEach items="${requestScope.spots}" var="spot">
                                '${spot.name}',
                            </c:forEach>
                                'Others'
                        </c:otherwise>
                    </c:choose>
                ],
                datasets: [{
                    label: 'Enrollments:',
                    data: [
                        <c:choose>
                        <c:when test="${requestScope.freeCourse == 0 && requestScope.paidCourse == 0}">
                            1
                        </c:when>
                        <c:otherwise>
                            <c:forEach items="${requestScope.spots}" var="spot">
                            ${spot.enrollments},
                         </c:forEach>
                            ${requestScope.others}
                        </c:otherwise>
                    </c:choose>
                        
                    ],
                    backgroundColor: [
                        <c:choose>
                        <c:when test="${requestScope.freeCourse == 0 && requestScope.paidCourse == 0}">
                            '#eee'
                        </c:when>
                        <c:otherwise>
                            'rgb(255, 99, 132)',
                        'rgb(54, 162, 235)',
                        'rgb(255, 205, 86)',
                        '#eee'
                        </c:otherwise>
                    </c:choose>
                        
                    ],
                    hoverOffset: 4
                }]
            }; 
            
            const twoConfig = {
                type: 'doughnut',
                data: pieTwo,
                options: {
                plugins: {
                    legend: {
                        display: false // Hide the legend
                        }
                    }
                }
            };

            var twoCtx = document.getElementById('two').getContext('2d');   
            var twoChar = new Chart(twoCtx, twoConfig);


            var sort = 'newest';
            function getRating() {
                document.getElementById('ratings').innerHTML = '';
                var xhttp = new XMLHttpRequest();
                xhttp.onreadystatechange = function() {
                    if (this.readyState == 4 && this.status == 200) {
                        
                        var jsonObject = JSON.parse(this.responseText);
                        if (jsonObject.length == 0) {
                             document.getElementById('ratings').innerHTML = '<div class="col-12"><p class="pt-5 pb-5 text-center">No results found.</p></div>'
                                     return;
                        } 
                        for (var i = 0; i < jsonObject.length; i++) {
                        var rating = '<div class="col-12">'
            +    '<div class="card">'
            +   '<div class="card-body">'
            +            '<div class="d-flex justify-content-between">'
            +                '<h6 class="fw-bold">' + jsonObject[i].star +' stars</h6>'
            +                '<h6 class="text-success">' + jsonObject[i].ratedTime +'</h6>'
            +            '</div>' 
            +            '<h6 class="pb-3">' + jsonObject[i].courseName +'</h6>'
            +            '<div class="row">'
            +                '<div class="col-3">'
            +                    '<div class="d-flex justify-content-start mb-3">'
            +                        '<img class="border rounded-2" style="width: 3rem;" src="' + jsonObject[i].profile.picture + '" class="w-100 h-auto" alt="...">'
            +                        '<div class="ps-3">'
            +                            '<h6 class="fw-bold">' + jsonObject[i].profile.name +'</h6>'
            +                            '<span>' + jsonObject[i].profile.headline + '</span>'
            +                        '</div>'
            +                    '</div>'
            +                '</div>'
            +                '<div class="col-9 border-start">'
            +                    '<p>' + jsonObject[i].comment +'</p>'
            +                '</div>'
            +            '</div>'
            +       '</div>'
            +    '</div>'
            +'</div>';
                        document.getElementById('ratings').innerHTML += rating;
                            }
                            // scroll();
                    }
                };
                var stars = [];
                var param = '';
                for (var i = 1; i <= 5; i++) {
                    if (document.getElementById(i + '-star').checked) {
                        stars.push(i);
                    } 
                }
                for (var i = 0; i < stars.length; i++) {
                    param += 'star=' + stars[i] + '&';
                }
                console.log(param);
                xhttp.open("GET", "http://localhost:8080/SWP391/instructor/feedback?" + param + "sort=" + sort, true);
                xhttp.send();
            }

            function sortRating(e) {
                sort = e;
                getRating();
            }
            getRating()

            function scroll() {
                var element = document.getElementById('ratings');
                element.scrollIntoView({behavior: "smooth"});
            }
    </script>
</body>
</html>