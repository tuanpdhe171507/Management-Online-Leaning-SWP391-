<%-- 
    Document   : trust
    Created on : May 17, 2024, 11:21:48 PM
    Author     : HieuTC
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!doctype html>
<html lang="en">
    <head>
        <meta charset="utf-8"/>
        <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
        <title>EduPort | Trust browser</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
        <link href="view/assets/css/hieutc.css" rel="stylesheet"/>
    </head>
    <body>
        <div class="d-flex justify-content-center p-5" style="min-height: 80vh;">
            <div style="width: 23%;">
                <c:if test="${requestScope.done == null
                      && requestScope.error == null}">
                <div class="d-flex align-items-center">
                    <span>Please wait for some moment.<br>
                    We need to verify your link is valid or not.</span>
                    <div class="spinner-border spinner-sm rounded-5 ms-auto m-2" aria-hidden="true"></div>
                </div>
                </c:if>
                <c:if test="${requestScope.done}">
                    <h6 class="fw-bold">Trusted successfully</h6>
                    <span>Now you can log in on new browser.<br>
                    Have a great day!</span>
                </c:if>
                <c:if test="${requestScope.error}">
                    <h6 class="fw-bold">Something wrong</h6>
                    <span>There is a problem when we try to verify your link.
                        To understand more about this.<br>
                        Please contact <a class="fw-bold" href="" target="_blank">support</a>.</span>
                </c:if>
            </div>
        </div>
        <%@include file="../elements/footer.jsp"%>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script type="module" src="https://unpkg.com/ionicons@7.1.0/dist/ionicons/ionicons.esm.js"></script>
        <script nomodule src="https://unpkg.com/ionicons@7.1.0/dist/ionicons/ionicons.js"></script>
    </body>
</html>

