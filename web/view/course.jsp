<%-- 
    Document   : course
    Created on : May 29, 2024, 5:48:26 PM
    Author     : TuanPD
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!doctype html>
<html lang="en">
    <head>
        <meta charset="utf-8"/>
        <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
        <title>EduPort</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
        <link href="../view/assets/css/hieutc.css" rel="stylesheet"/>
        <style>
            .stars ion-icon {
                font-size: 1.2rem;
                color: #ffc107;
            }
            .border-bottom {
                border-bottom: 1px solid #ccc;
                width: 100%;
                display: block;
            }
            .rounded-progress {
                border-radius: 20px !important;
            }
            .rounded-progress .progress-bar {
                border-radius: 20px !important;
                background-color: #a65ae1;
            }
            .rating-container {
                margin-top: 30px;
                text-align: center;
            }
            .star {
                font-size: 36px;
                color: #f0f0f0;
                cursor: pointer;
            }
            .star.active {
                color: #ffc107;
            }
            .btn-submit {
                margin-top: 10px;
            }
            
            .tab {
                border-radius: unset !important;
            }
        </style>
    </head>
    <c:set var="courseId" value="${param.id}" />
    <body>
        <%@include file="elements/navbar.jsp"%>
        <div class="container">
            <div class="row">
                <div class="col-6">
                    <div class="ratio ratio-16x9">
                        <img class="w-100" src="${requestScope.course.thumbnail}"/>
                    </div>
                </div>
                <div class="col-6">
                    <div class="pt-4 w-75">
                        <h5 class="fw-bold">${requestScope.course.name}</h5>
                        <h6>${requestScope.course.tagLine}</h6>
                        <div class="pt-4">
                            <h6><c:if test="${requestScope.course.badge != null}">
                                <span class="badge text-bg-warning">
                                    ${requestScope.course.badge}</span></c:if>
                                    <c:choose>
                                                <c:when test="${requestScope.course.getCourseRating() < 0.5}">
                                                   <ion-icon name="star-outline"></ion-icon>
                                                </c:when>
                                                <c:when test="${requestScope.course.getCourseRating() <= 0.5
                                                           && requestScope.course.getCourseRating() < 1.0}">
                                                   <ion-icon name="star-half-outline"></ion-icon>
                                                </c:when>
                                                <c:otherwise>
                                                    <ion-icon name="star"></ion-icon>
                                                </c:otherwise>
                                            </c:choose>
                                             <c:choose>
                                                <c:when test="${requestScope.course.getCourseRating() < 1.5}">
                                                   <ion-icon name="star-outline"></ion-icon>
                                                </c:when>
                                                <c:when test="${requestScope.course.getCourseRating() <= 1.5
                                                           && requestScope.course.getCourseRating() < 2.0}">
                                                   <ion-icon name="star-half-outline"></ion-icon>
                                                </c:when>
                                                <c:otherwise>
                                                    <ion-icon name="star"></ion-icon>
                                                </c:otherwise>
                                            </c:choose>
                                            <c:choose>
                                                <c:when test="${requestScope.course.getCourseRating() < 2.5}">
                                                   <ion-icon name="star-outline"></ion-icon>
                                                </c:when>
                                                <c:when test="${requestScope.course.getCourseRating() <= 2.5
                                                           && requestScope.course.getCourseRating() < 3.0}">
                                                   <ion-icon name="star-half-outline"></ion-icon>
                                                </c:when>
                                                <c:otherwise>
                                                    <ion-icon name="star"></ion-icon>
                                                </c:otherwise>
                                            </c:choose>
                                            <c:choose>
                                                <c:when test="${requestScope.course.getCourseRating() < 3.5}">
                                                   <ion-icon name="star-outline"></ion-icon>
                                                </c:when>
                                                <c:when test="${requestScope.course.getCourseRating() <= 3.5
                                                           && requestScope.course.getCourseRating() < 4.0}">
                                                   <ion-icon name="star-half-outline"></ion-icon>
                                                </c:when>
                                                <c:otherwise>
                                                    <ion-icon name="star"></ion-icon>
                                                </c:otherwise>
                                            </c:choose>
                                            <c:choose>
                                                <c:when test="${requestScope.course.getCourseRating() < 4.5}">
                                                   <ion-icon name="star-outline"></ion-icon>
                                                </c:when>
                                                <c:when test="${requestScope.course.getCourseRating() <= 4.5
                                                           && requestScope.course.getCourseRating() < 5.0}">
                                                   <ion-icon name="star-half-outline"></ion-icon>
                                                </c:when>
                                                <c:otherwise>
                                                    <ion-icon name="star"></ion-icon>
                                                </c:otherwise>
                                            </c:choose>
                                    <span class="text-secondary"> (${requestScope.course.getCourseRating()}),
                                        ${requestScope.course.getTotalStudents()} students</span>
                            </h6>
                            <h6>Created by 
                                <a href="../instructor?emailAdress=${requestScope.course.instructor.email}">
                                   ${requestScope.course.instructor.profile.name}</a></h6>
                            <h6>Last updated <span class="text-success">
                                    ${requestScope.course.getLastUpdatedDate()}</span></h6>
                                 <c:choose>

                                    <c:when test="${not empty requestScope.accessibleCourse.email and not empty requestScope.accessibleCourse.course.id}">
                                        <button class="fw-bold" style="background-color: black;
                                                width: 100%;
                                                color: white;
                                                padding: 10px;
                                                transition: background-color 0.2s;
                                                border: none;
                                                border-radius: 5px" 
                                                    onmouseover="this.style.backgroundColor = 'gray'" 
                                                    onmouseout="this.style.backgroundColor = 'black'"
                                                    onclick="goToCourse()">Go to Course</button>
                                        </c:when>

                                        <c:otherwise>
                                            <c:choose>
                                                <c:when test="${requestScope.course.price > 0 and requestScope.email2 != requestScope.course.instructor.email}">
                                                    <button class="fw-bold" style="background-color: black;
                                                    width: 100%;
                                                    color: white;
                                                    padding: 10px;
                                                    transition: background-color 0.2s;
                                                    border: none;
                                                    border-radius: 5px" 
                                                        onmouseover="this.style.backgroundColor = 'gray'" 
                                                        onmouseout="this.style.backgroundColor = 'black'"
                                                        onclick="sendIdToServlet(${course.id})">Add to Cart</button>
                                                </c:when>
                                                <c:otherwise>
                                                    <c:if test="${requestScope.email2 != requestScope.course.instructor.email}">
                                                        <button  class="fw-bold" style="background-color: black;
                                                        width: 100%;
                                                        color: white;
                                                        padding: 10px;
                                                        transition: background-color 0.2s;
                                                        border: none;
                                                        border-radius: 5px;" 
                                                        onmouseover="this.style.backgroundColor = 'gray'" 
                                                        onmouseout="this.style.backgroundColor = 'black'"
                                                        onclick="enroll()">
                                                        Enroll now
                                                    </button>
                                                </c:if>
                                                <c:if test="${requestScope.email2 == requestScope.course.instructor.email}">
                                                    <button class="fw-bold" style="background-color: gray;
                                                            width: 100%;
                                                            color: white;
                                                            padding: 10px;
                                                            transition: background-color 0.2s;
                                                            border: none;
                                                            border-radius: 5px;
                                                            cursor: not-allowed;" 
                                                            disabled>
                                                        Your course
                                                    </button>
                                                </c:if>
                                            </c:otherwise>
                                        </c:choose>
                                    </c:otherwise>
                                </c:choose>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="container pb-5">
            <button class="btn p-3 m-0 tab fw-bold" type="button" onclick="show(0)">Overview</button>
            <button class="btn p-3 m-0 tab fw-bold" type="button" onclick="show(1)">Course content</button>
            <button class="btn p-3 m-0 tab fw-bold" type="button" onclick="show(2)">Reviews</button>
            <button class="btn p-3 m-0 tab fw-bold" type="button" onclick="show(3)">Instructor</button>
            <hr class="m-0">
            <div class="row">
                <div class="page col-8">
                    <h5 class="pt-3 fw-bold">What you'll learn</h5>
                    <ul>
                    <c:forEach items="${requestScope.course.objectives}" var="obj">
                         <li>${obj}</li>   
                    </c:forEach>
                    </ul>
                    <h5 class="pt-3 fw-bold">Description</h5>
                    <p>${requestScope.course.description}</p>
                    
                </div>
                <div class="page col-8">
                    <h5  class="pt-3 fw-bold">Requirements</h5>
                    <ul>
                    <c:forEach items="${requestScope.course.prerequiresites}" var="pre">
                         <li>${pre}</li>   
                    </c:forEach>
                    </ul>
                    <h5 class="pt-3 fw-bold">Sections</h5>
                    <span class="text-secondary fw-bold">${requestScope.course.sectionList.size()} sections, 
                            ${requestScope.course.getSumOfLesson()} lessons</span>
                    <button class="btn float-end p-0" type="button" onclick="expandAll()">
                        Expand all section</button>
                    <div class="pt-2">
                        <div class="btn-group-vertical w-100" role="group">
                    <c:forEach items="${requestScope.course.sectionList}" var="section">
                         <c:if test="${section.visibility}">
                        <details class="btn w-100 border text-start">
                            <summary class="p-3 w-100">
                               <h6 class="fw-bold"><ion-icon name="chevron-down-sharp"></ion-icon> ${section.title}</h6>
                            </summary>
                            <div class="p-4">
                                <c:forEach items="${section.itemList}" var="item">
                                        <c:forEach items="${section.itemList}" var="item">
                                            <c:if test="${item.getClass().getName() == 'model.Lesson'}">
                                                <h6 class="fw-bold">${item.name}</h6>
                                            </c:if>
                                            <c:if test="${item.getClass().getName() == 'model.Quiz'}">
                                                <h6 class="fw-bold">${item.title}</h6>
                                            </c:if>
                                        </c:forEach>
                                </c:forEach>
                            </div>
                            
                        </details>
                        </c:if>    
                    </c:forEach>  
                            </div> 
                    </div>
                </div>
                <div class="page col-6">
                    <h5 class="pt-3">Student feedback</h5>
                    <div class="row">
                        <div class="col-3">
                            <div class="text-center" style="width: fit-content;">
                                <h1>${requestScope.ratingStatistics.formatAverageRating()}</h1>
                                <div class="stars">
                                    <c:set var="averageRating" value="${requestScope.ratingStatistics.averageRating}" />
                                    <c:forEach var="i" begin="1" end="5">
                                        <c:choose>
                                            <c:when test="${i <= averageRating}">
                                                <ion-icon name="star"></ion-icon>
                                                </c:when>
                                                <c:otherwise>
                                                <ion-icon name="star-outline"></ion-icon>
                                                </c:otherwise>
                                            </c:choose>
                                        </c:forEach>
                                </div>
                                <h6>Course rating</h6>
                            </div>
                        </div>
                        <div class="col-8">
                            <div class="row">
                                <%-- Turn countdown from 5 to 1 --%>
                                <c:set var="counter" value="5" />

                                <c:forEach var="i" begin="1" end="5">
                                    <div class="col-12 mb-2">
                                        <div class="row align-items-center">
                                            <!-- Progress bar -->
                                            <div class="col-6">
                                                <div class="progress rounded-progress" role="progressbar" aria-valuenow="${requestScope.ratingStatistics.starPercentages[counter - 1]}"
                                                     aria-valuemin="0" aria-valuemax="100">
                                                    <div class="progress-bar" style="width: ${requestScope.ratingStatistics.starPercentages[counter - 1]}%"></div>
                                                </div>
                                            </div>
                                            <!-- Icons -->
                                            <div class="col-4">
                                                <div class="d-flex justify-content-end">
                                                    <div class="stars">
                                                        <c:forEach var="j" begin="1" end="5">
                                                            <ion-icon class="star-icon" 
                                                                      name="${j <= counter ? 'star' : 'star-outline'}"></ion-icon>
                                                            </c:forEach>
                                                    </div>
                                                </div>
                                            </div>
                                            <!-- Percentage -->
                                            <div class="col-2">
                                                <div class="text-secondary">
                                                    ${requestScope.ratingStatistics.formattedStarPercentages[counter - 1]}
                                                </div>
                                            </div>

                                        </div>
                                    </div>
                                    <%-- Decrease the counter variable to go to a lower rating level --%>
                                    <c:set var="counter" value="${counter - 1}" />
                                </c:forEach>
                            </div>
                        </div>
                        <c:if test="${not empty sessionScope.user}">
                            <div class="text-center mt-2">
                                <button href="#" <c:if test="${!sessionScope.isEnrolled}">data-bs-toggle="modal" 
                                                                                          data-bs-target="#enrollmentModal"</c:if> 
                                                 <c:if test="${sessionScope.isEnrolled}">data-bs-toggle="modal" 
                                                                                         data-bs-target="#dynamicModal" 
                                                                                         data-course-id="${courseId}"</c:if> 
                                        class="btn btn-dark">
                                        Rate this course
                                </button>
                            </div>
                        </c:if>
                        <c:if test="${empty sessionScope.user}">
                            <div class="text-center mt-2">
                                <a href="../log-in" class="btn btn-dark">Please login to rate this course</a>
                            </div>
                        </c:if>         
                        <div class="row">
                            <h5 class="pt-3">Comment</h5>
                            <div class="col-10">
                                <c:forEach var="rating" items="${requestScope.ratingList}">
                                    <div class="d-flex mb-2 border-bottom pb-2">
                                        <div class="col-2 me-3">
                                            <div class="ratio ratio-1x1">
                                                <img class="w-100 rounde-2" src="${rating.getProfile().getPicture()}" alt="Avatar" class="avatar">
                                            </div>
                                        </div>
                                        <div class="col">
                                            <div class="d-flex justify-content-between align-items-center mb-1">
                                                <div>${rating.getProfile().getName()}</div>
                                            </div>
                                            <div class="d-flex justify-content-between align-items-center ">
                                                <div class="stars">
                                                    <c:forEach begin="1" end="${rating.star}">
                                                        <ion-icon name="star"></ion-icon>
                                                        </c:forEach>
                                                        <c:forEach begin="${rating.star + 1}" end="5">
                                                        <ion-icon name="star-outline"></ion-icon>
                                                        </c:forEach>
                                                </div>
                                                <div class="text-secondary">${rating.getRatedTime()}</div>
                                            </div>
                                            <p>${rating.comment}</p>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </div>
                    </div>        
                </div>
                <div class="page col-6">
                    <div class="row">
                        <h5 class="pt-3">Instructor</h5>
                        <div class="col-3">
                            <img class="w-100" src="
                                ${requestScope.course.instructor.profile.picture}
                            "/>
                        </div>
                        <div class="col-9">
                            <h6>
                                <a href="../instructor?emailAdress=${requestScope.course.instructor.email}"> ${requestScope.course.instructor.profile.name}</a>
                            </h6>
                                <p>${requestScope.course.instructor.profile.headline}</p>
                                <span>Instructor Rating <span class="text-secondary">(?.?)</span></span><br>
                                <span>Students <span class="text-secondary">(?)</span></span><br>
                            
                        </div>
                        <div class="col-12">
                            <p>${requestScope.course.instructor.biography}</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
                        
        <!-- Modal -->
        <div class="modal fade" id="enrollmentModal" tabindex="-1" aria-labelledby="enrollmentModalLabel" aria-hidden="true">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="enrollmentModalLabel">Enrollment Required</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        You need to enroll in this course before you can rate it.
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-primary" data-bs-dismiss="modal">OK</button>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Rating modal -->
        <div class="modal fade" id="dynamicModal" tabindex="-1" aria-labelledby="dynamicModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="dynamicModalLabel">Rate This Course</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <div class="container">
                            <div id="ratingStars" class="rating-container">
                                <span class="star" id="star1">&#9733;</span>
                                <span class="star" id="star2">&#9733;</span>
                                <span class="star" id="star3">&#9733;</span>
                                <span class="star" id="star4">&#9733;</span>
                                <span class="star" id="star5">&#9733;</span>
                            </div>

                            <form id="ratingForm" action="../course/details" method="post">
                                <input type="hidden" id="courseId" name="courseId" value="${courseId}">
                                <input type="hidden" id="starRating" name="starRating">
                                <div class="form-group mt-3">
                                    <label for="comment">Comment:</label>
                                    <textarea class="form-control" id="comment" name="comment" rows="5" required></textarea>
                                </div>
                                <div class="d-flex justify-content-center mt-3">
                                    <button type="submit" class="btn btn-primary btn-submit">Submit Rating</button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>
                                
        <%@include file="elements/footer.jsp"%>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script type="module" src="https://unpkg.com/ionicons@7.1.0/dist/ionicons/ionicons.esm.js"></script>
        <script nomodule src="https://unpkg.com/ionicons@7.1.0/dist/ionicons/ionicons.js"></script>
        <script>
            var tabs = document.getElementsByClassName("tab");
                        var pages = document.getElementsByClassName("page");
                        function show(e) {
                            for (let i = 0; i < pages.length; i++) {
                                if (i !== e) {
                                    tabs[i].style.borderBottom = "unset";
                                    pages[i].style.display = "none";
                                } else {
                                    tabs[i].style.borderBottom = "3px solid black";
                                    pages[i].style.display = "block";
                                }
                            }
                        }
                        show(0);
            function expandAll() {
                var sections = document.getElementsByTagName("details");
                for (let i = 0; i < sections.length; i++) {
                    sections[i].open = true;
                }
            }
            
             function enroll() {
                            var courseId = "${requestScope.course.id}";
                            var categoryId = "${requestScope.course.category.id}";
                            var email = "${requestScope.course.instructor.email.trim()}";

                            var enrollUrl = "course-enroll?courseId=" + encodeURIComponent(courseId) + "&categoryId=" + encodeURIComponent(categoryId) + "&email=" + encodeURIComponent(email);
                            window.location.href = enrollUrl;

                        }
                        function  goToCourse() {
                            var courseId = "${requestScope.course.id}";
                            var enrollUrl = "http://localhost:8080/SWP391/course/page?course=" + encodeURIComponent(courseId);
                            window.location.href = enrollUrl;
                        }

                        function sendIdToServlet(courseId) {
                            var enrollUrl = "http://localhost:8080/SWP391/wishlist";
                            let xhr = new XMLHttpRequest();

                            xhr.open("POST", "<%=request.getContextPath() + "/wishlist"%>", true);
                            xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");

                            xhr.onreadystatechange = function () {
                                if (xhr.readyState == 4 && xhr.status == 200) {
                                    window.location.href = enrollUrl;
                                }
                            };

                            xhr.send("courseId=" + encodeURIComponent(courseId));
                        }
                        document.addEventListener('DOMContentLoaded', function () {
                            let currentRating = 0;
                            const stars = document.querySelectorAll('.star');

                            stars.forEach((star, index) => {
                                star.addEventListener('click', function () {
                                    currentRating = index + 1;
                                    updateStarColors();
                                    document.getElementById('starRating').value = currentRating;
                                });
                            });

                            function updateStarColors() {
                                stars.forEach((star, index) => {
                                    if (index < currentRating) {
                                        star.classList.add('active');
                                    } else {
                                        star.classList.remove('active');
                                    }
                                });
                            }
                        });
        </script>
    </body>
</html>
