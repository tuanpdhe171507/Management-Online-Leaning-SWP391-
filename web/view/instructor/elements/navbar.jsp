<%-- 
    Document   : navbar
    Created on : Jun 3, 2024, 9:25:12 AM
    Author     : HieuTC
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<div>
    <%@include file="../../elements/notification.jsp"%>
                <div class="dropdown d-inline-block">
                    <button class="btn" type="button" data-bs-toggle="dropdown" aria-expanded="false">
                        <ion-icon class="fs-6" name="person-outline"></ion-icon>
                    </button>
                    <div class="dropdown-menu dropdown-menu-end">
                        <button class="btn dropdown-item" onclick="openHyperLink('http://localhost:8080/SWP391/')" type="button">Switch to student</button>
                        <hr class="dropdown-divider">
                        <button class="btn dropdown-item" onclick="logOut()" type="button">Log out</button>
                    </div>
                </div>
    </div>
                
                <script>
                    function logOut() {
                const xhttp = new XMLHttpRequest();
                xhttp.onreadystatechange = function() {
                if (this.readyState === 4 && this.status === 200) {
                    window.location.reload();
                }
                };
                xhttp.open("get", "<%=request.getContextPath() + "/log-out"%>", true);
                xhttp.send();
            };
                </script>
