<%-- 
    Document   : navbar
    Created on : Jul 6, 2024, 8:36:04 PM
    Author     : HieuTC
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="dao.UserContext" %>
<div class="container-fluid border-bottom">
            <div class="navbar p-3">
                <div class="container">
                    <div class="position-relative">
                    <form action="" method="get">
                        <div class="input-group">
                            <span class="input-group-text" id="icon">
                                <ion-icon class="fs-5" name="search-outline"></ion-icon>
                            </span>
                            <input class="form-control" type="text"
                                   placeholder="Search functions" id="search"/>
                        </div>

                    </form>
                    </div>
                    <div class="d-flex align-items-center">
                        <%@include file="../../elements/notification.jsp"%>

                        <div class="vr ms-3 me-3"></div>
                        <div class="d-inline-block pe-3">
                            <h6 class="m-0 text-end">${userContext.getProfile(sessionScope.user.email).name}</h6>
                        </div>
                        <img src="${userContext.getProfile(sessionScope.user.email).picture}"
                             class="rounded-circle" style="width: 2.5rem"/>
                        <div class="d-inline-block dropdown">
                            <button class="btn" type="button"
                                    data-bs-toggle="dropdown" aria-expanded="false">
                                <ion-icon name="chevron-down-sharp"></ion-icon>
                            </button>
                            <div class="dropdown-menu dropdown-menu-end">
                                <button class="dropdown-item" onclick="logOut()">Logout</button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>  
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
    </script>
    