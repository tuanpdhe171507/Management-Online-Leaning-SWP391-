<%-- 
    Document   : fogotPassword
    Created on : May 24, 2024, 11:54:22 PM
    Author     : HuyLQ;
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8"/>
        <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
        <title>EduPort | Fogot password</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
        <link href="view/assets/css/base.css" rel="stylesheet"/>
    </head>
    <body>
        <%@include file="../elements/navbar.jsp"%>

        <div class="d-flex justify-content-center p-5" style="min-height: 70vh;">
            <div style="width: 23%;">
                <c:if test="${requestScope.done == null}">
                <h6 class="fw-bold mb-3">Fogot Password</h6>
                <form action="forgot-password" method="post">
                    <div class="form-floating mb-3">
                        <input class="form-control" type="email" placeholder="me@example.io" name="email" id="email"
                               maxlength="64" value="${requestScope.email}" required/>
                               <label class="fw-bold" for="email">Email</label>
                        </div>
                    <input class="btn btn-dark fw-bold p-3 w-100" type="submit" value="Reset password" />
                    <hr>
                    <span>Back to <a class="fw-bold " href="log-in">Log in</a></span>
                </form>
                </c:if>
                <c:if test="${requestScope.done}">
                    <h6 class="fw-bold mb-3">Request has been sent</h6>
                    <span>Please check the new mail send from us that includes
                        the link for resetting password.</span>
                     <p class="text-secondary">* Please resubmit request
                     if you don't receive our mail in 2 minutes</p>
                     <span>Back to <a class="fw-bold" href="log-in">Log in</a></span>
                </c:if>
            </div>
        </div>
        <%@include file="../elements/footer.jsp"%>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script type="module" src="https://unpkg.com/ionicons@7.1.0/dist/ionicons/ionicons.esm.js"></script>
        <script nomodule src="https://unpkg.com/ionicons@7.1.0/dist/ionicons/ionicons.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/clientjs@0.1.11/dist/client.min.js"></script>
        <script src="https://accounts.google.com/gsi/client" async></script>
    </body>
</html>
