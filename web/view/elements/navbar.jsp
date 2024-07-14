<%-- 
    Document   : navbar
    Created on : May 19, 2024, 9:58:06 PM
    Author     : HieuTC
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="dao.CourseContext" %>
<style>
    .position-relative {
        position: relative;
    }
    .position-absolute {
        position: absolute;
    }
    .translate-middle {
        transform: translate(-50%, -50%);
    }
    
    input {
        font-family: 'Epilogue';
    }
</style>
<div class="container-fluid border-bottom">
    <nav class="navbar">
        <div class="container pt-2 pb-2">
            <div>
                <a class="navbar-brand fw-bold fs-5" href="<%=request.getContextPath()%>"><h5 class="fw-bold d-inline-block">EduPort</h5></a>
                <form class="d-inline-block" style="width: 17rem;" action="search" method="get">
                    <div class="position-relative">
                        <input class="form-control rounded-2 fw-bold pe-5 border" name="key" placeholder="Keyword for searching" style="padding: .5rem;">
                        <div class="position-absolute end-0 top-0 pe-2" style="transform: translateY(27%)">
                            <ion-icon class="fs-5" name="search-outline" style="font-size: 1.1rem"></ion-icon>
                        </div>
                    </div>

                    <input class="d-none" type="submit">
                </form>
                <button class="btn ms-2 fw-bold" data-bs-toggle="collapse" data-bs-target="#collapse" aria-expanded="false" aria-controls="collapse">Categories <ion-icon name="caret-down-sharp"></ion-icon></button>
                <button class="btn ms-2 fw-bold" onclick="openHyperLink('plans')">Plans and pricing</button>
            </div>

            <div>
                <c:if test="${sessionScope.user != null}" >
                    <button class="btn position-relative me-2 fw-bold text-warning" onclick="openHyperLink('wishlist')">Cart</button>
                    <c:if test="${sessionScope.count} != null">
                        <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger" >
                            ${sessionScope.count}  <span class="visually-hidden">number of courses</span>
                        </span>
                    </c:if>
                </c:if>
                <c:if test="${sessionScope.user == null}">
                    <a class="btn position-relative me-2 fw-bold text-warning" href="javascript:void(0)" data-bs-toggle="modal" data-bs-target="#loginModal">Wishlist</a>
                    <div class="modal fade" id="loginModal" tabindex="-1" aria-labelledby="loginModalLabel" aria-hidden="true">
                        <div class="modal-dialog">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <h5 class="modal-title" id="loginModalLabel">Please login first</h5>
                                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                </div>
                                <div class="modal-body">
                                    <p>You must to log in to access your wishlist.</p>
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                                    <a href="<%=request.getContextPath()%>/log-in" class="btn btn-primary">Log In</a>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:if>
                <c:if test="${sessionScope.user == null}">
                    <button class="btn fw-bold me-2" onclick="openHyperLink('http://localhost:8080/SWP391/log-in')">Login</buttn>
                    <button class="btn btn-dark fw-bold"  onclick="openHyperLink('http://localhost:8080/SWP391/sign-up')">Get started 
                        <ion-icon name="arrow-forward-outline"></ion-icon></button>

                </c:if>

                <c:if test="${sessionScope.user != null}">
                     <%@include file="notification.jsp"%>
                    <div class="dropdown d-inline">
                        <button class="btn" type="btn" 
                                data-bs-toggle="dropdown" aria-expanded="false">
                            <ion-icon name="person-outline"></ion-icon>
                        </button>
                        <div class="mt-2 dropdown-menu dropdown-menu-end">
                            <a class="btn dropdown-item" href="<%=request.getContextPath() + "/instructor/courses"%>">Switch to instructor</a>
                            <a class="btn dropdown-item" href="<%=request.getContextPath() + "/my-courses"%>">My courses</a>
                            <a class="btn dropdown-item" href="<%=request.getContextPath() + "/account"%>">Account settings</a>
                            <hr class="dropdown-divider">
                            <button class="btn dropdown-item" type="button" onclick="logOut()">Logout</button>
                        </div>
                    </div>
                </c:if>

            </div>
        </div>
    </nav>
</div>
</div>
<div class="container-fluid border-bottom position-absolute z-2 collapse" style="background-color: white" id="collapse">
    <div class="container pt-3 pb-3 d-flex justify-content-between" id="categories">
    <%CourseContext courseContext = new CourseContext();
    request.setAttribute("courseContext", courseContext);%>
    <c:forEach items="${courseContext.getCategoryList()}" var="category">
        <button class="btn fw-bold" type="button"
           onclick="openHyperLink('http://localhost:8080/SWP391/courses?category=${category.id}')">
            ${category.name}
        </button>
    </c:forEach>
    </div>
</div>
<script src="http://localhost:8080/SWP391/view/assets/js/base.js"></script>
<script>
    function logOut() {
        const xhttp = new XMLHttpRequest();
        xhttp.onreadystatechange = function () {
            if (this.readyState === 4 && this.status === 200) {
                window.location.reload();
            }
        };
        xhttp.open("get", "<%=request.getContextPath() + "/log-out"%>", true);
        xhttp.send();
    }
    ;

    function sendIdToServlet(courseId) {
        let xhr = new XMLHttpRequest();
        xhr.open("POST", "<%=request.getContextPath() + "/wishlist"%>", true);
        xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");

        xhr.onreadystatechange = function () {
            if (xhr.readyState == 4 && xhr.status == 200) {
                window.location.reload();
            }
        };
        xhr.send("courseId=" + encodeURIComponent(courseId));
    }
    ;
    
    
</script>
