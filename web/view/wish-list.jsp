<%-- 
    Document   : wishlist
    Created on : May 30, 2024, 2:34:01 PM
    Author     : HuyLQ;
--%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!doctype html>
<html lang="en">
    <head>
        <meta charset="utf-8"/>
        <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
        <title>EduPort</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
        <link href="view/assets/css/hieutc.css" rel="stylesheet"/>
    </head>
    <body>
        <%@include file="elements/navbar.jsp"%>
        <div class="container pt-5 pb-5 body">
            <div class="row d-flex justify-content-center align-items-center h-100">
                <div class="col-12">

                    <div class="card-body p-0">
                        <form action="VNPay" method="GET" id="form">
                        <div class="row g-0">
                            
                            <div class="col-lg-8">
                                <div class="">
                                    <div class="mb-4">
                                        <h5 class="mb-0 fw-bold">Shopping cart</h5>
                                    </div>
                                    <h6 class="fw-bold text-muted">Courses: ${requestScope.courseList.size()}</h6>
                                    <hr class="my-4">
                                    <div class="row">
                                        <div class="col-3">     
                                            <div class="form-check">
                                                <input class="form-check-input" value="true" type="checkbox" name="all" id="all"
                                                       onchange="selectAll()" checked="true"/>  
                                                <label class="fw-bold" for="all">Select all</label>
                                            </div>
                                        </div>
                                    </div>
                                        <c:forEach items="${requestScope.courseList}" var="course">
                                            <div class="row gx-3 mb-3">
                                                <div class="col-3 d-flex justify-content-between">
                                                    <input class="form-check-input m-0 me-2" value="${course.id}"
                                                           type="checkbox" name="course" onchange="select()" required/>
                                                    <div class="ratio ratio-16x9">
                                                        <img class="rounded-2 border" src="${course.thumbnail}" />   
                                                    </div>
                                                </div>
                                                <div class="col-5">
                                                    <h6 class="fw-bold">${course.name} </h6>
                                                    <span class="text-muted">Instructor: ${course.instructor.profile.name}</span>
                                                    <h6>
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
                                                                ${course.getCourseRating()} <span class="text-secondary">(${course.getRatings()} ratings)</span>
                                                    </h6>
                                                </div>
                                                <div class="col-2">
                                                    <a href="wishlist?id=${course.id}" style="color: black" >Remove</a>
                                                </div>
                                                <div class="col-2">
                                                    <h6 class="text-end text-warning"><ion-icon name="pricetag-sharp"></ion-icon> ${course.getCurrentPrice()}<i class="bi bi-currency-dollar"></i></h6>
                                                </div>
                                            </div>

                                        </c:forEach>

                                </div>
                            </div>
                            <div class="col-lg-4">

                                <div class="p-5">
                                    <h5 class="mt-2 fw-bold">Summary</h5>

                                    <hr class="my-4">
                                    <div class="d-flex justify-content-between mb-4">
                                        <h6 class="fw-bold">Total: ${courseCount}</h6>
                                        <h6>${requestScope.totalPrice}<i class="bi bi-currency-dollar"></i></h6>
                                        <input  type="hidden" name="totalPrice" value="${requestScope.totalPrice}" />
                                    </div>
                                    <button type="button" class="btn btn-dark w-100 p-3 fw-bold"
                                            onclick="checkout()">Checkout</button>
                                </div>

                            </div>

                        </div>
                        </form>
                    </div>

                </div>
            </div>
        </div>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script type="module" src="https://unpkg.com/ionicons@7.1.0/dist/ionicons/ionicons.esm.js"></script>
        <script nomodule src="https://unpkg.com/ionicons@7.1.0/dist/ionicons/ionicons.js"></script>
        <%@include file="elements/footer.jsp"%>
        <script>
            function checkout() {
                var notYet = false;
                var checkBoxs = document.getElementsByName('course');
                for (let i = 0; i < checkBoxs.length; i++) {
                    if (checkBoxs.checked === true) {
                        notYet = true;
                        break;
                    }
                }
                
                if (!notYet) {
                    document.getElementById('all').setAttribute('checked', true);
                }
                
                document.getElementById('form').submit();
            }
            
            function selectAll() {
                var btn = document.getElementById('all');
                var checkBoxs = document.getElementsByName('course');
                if (btn.checked == true) {
                    
                    for (let i = 0; i < checkBoxs.length; i++) {
                        checkBoxs[i].setAttribute('checked', true);
                    }
                } else {
                    for (let i = 0; i < checkBoxs.length; i++) {
                        checkBoxs[i].removeAttribute('checked');
                    }
                }
            }
            
            selectAll();
            
        </script>
    </body>
</html>