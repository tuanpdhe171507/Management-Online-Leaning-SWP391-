<%-- 
    Document   : pricing
    Created on : Jun 17, 2024, 8:34:57 PM
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
                <c:if test="${requestScope.course != null}">
                    <a class="btn" type="button" href="settings?id=${requestScope.course.id}"><ion-icon class="fs-5" name="settings-outline"></ion-icon></a>
                </c:if>
            </div>
        </nav>
    </div>
    <div class="container">
        <div class="row">
            <%@include file="elements/slidebar.jsp"%>
            <div class="col-9 pt-5 ps-5 border-start" style="min-height: 100vh;">
                <h5 class="fw-bold pt-3">Price</h5>
                <p>Please set a price for you course or you course will be free by default.</p>
                <form action="pricing" method="post">
                    <input type="hidden" name="course" value="${requestScope.course.id}"/>
                  <div class="form-floating ">
                    <input class="form-control w-auto" type="number" min="0" name="price" id="price" placeholder="dollar"/>
                    <label for="price"><c:if test="${requestScope.course.price == 0}">Free</c:if><c:if test="${requestScope.course.price != 0}">${requestScope.course.price}</c:if></label>
                    </div>
                    <button class="btn btn-primary fw-bold p-3 mt-3" type="submit">Save price</button>  
                </form>
                
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
        document.getElementsByClassName('tab')[3].classList.add('here');
        document.getElementsByClassName('tab')[3].classList.add('btn-light');
    </script>
</body>

</html>
