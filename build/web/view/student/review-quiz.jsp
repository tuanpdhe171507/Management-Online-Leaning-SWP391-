<%-- 
    Document   : quizz
    Created on : Jun 3, 2024, 1:23:28 PM
    Author     : Trongnd
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
    </head>
    <body>
        <%@include file="../elements/navbar.jsp"%>
        <div class="container-fluid border-bottom">
            <nav class="navbar">
                <div class="row p-2 w-100">
                    <div class="col-8 d-flex align-items-center">
                        <a class="btn btn-link" href="<%=request.getContextPath() + "/course/page?course="%>${param.course}&section=${param.section}&quiz=${param.id}" style="text-decoration: none;">
                            <ion-icon name="arrow-back-outline" role="img" class="md hydrated"></ion-icon> Go back
                        </a>
                        <h6 class="mb-0 ms-2"><span>${requestScope.quiz.title}</span></h6>
                    </div>
                    <div class="col-4 d-flex justify-content-end align-items-center">
                        <h6 class="mb-0"><span>Due ${requestScope.quizSession.takedTime}</span></h6>
                    </div>
                </div>
            </nav>
        </div>
        <div class="container-fluid p-4 border-bottom"id="notify">
            <div class="container">
                <div class="row align-items-center">
                    <div class="col d-flex align-items-center">
                        <div class="me-2" id="icon">                            
                            
                        </div>
                        <div>
                            <h5 class="mb-0">Congratulations! You passed!</h5>
                        </div>
                    </div>
                </div>
                <div class="row mt-2" style="margin-left: 24px">
                    <div class="col">
                        <div>Grade received <span class="fw-bold text-success">${requestScope.mark}%</span></div>
                    </div>
                    <div class="col">
                        <div>To pass <span class="fw-bold">${requestScope.quiz.passedTarget}%</span> or higher</div>
                    </div>
                    <div class="col text-end">
                        <a  class="btn btn-dark" id="btnNextOrTry"></a>
                    </div>
                </div>
            </div>
        </div>
        <div>
        </div>
        <form action="review" method="post">
            <div class="container mt-5 mb-5 w-75 justify-content-center align-items-center">
                <c:set var="result" value="${requestScope.result}"/>    
                <c:forEach items="${result.entrySet()}" var="entry" varStatus="status">
                    <div class="row row-cols-3 mt-4">
                        <c:set var="flag" value="${false}"/>
                        <div class="col-1 text-end fw-medium">${status.index+1}. </div>   
                        <div class="col-9 mb-4">
                            <div class="mb-4 fw-medium" id="${entry.key.id}">
                                <span>${entry.key.content}</span>
                            </div>

                            <c:forEach items="${entry.key.answers}" var="a">
                                <c:choose>
                                    <c:when test="${a.id eq entry.value}">
                                        <c:if test="${a.correctless}">
                                            <div class="form-check mt-2 bg-success-subtle">                                    
                                                <input class="form-check-input rounded-5" type="radio" value="" id="radio" name="radio-${entry.key.id}" checked="" />
                                                <label class="form-check-label" for="radio">${a.content}</label>
                                            </div>
                                            <c:set var="flag" value="${true}"/>
                                        </c:if>
                                        <c:if test="${!a.correctless}">
                                            <div class="form-check mt-2 bg-danger">                                    
                                                <input class="form-check-input rounded-5" type="radio" value="" id="radio" name="radio-${entry.key.id}" checked=""/>
                                                <label class="form-check-label" for="radio">${a.content}</label>
                                            </div>  
                                        </c:if>
                                    </c:when>
                                    <c:otherwise>
                                        <c:if test="${a.correctless}">
                                            <div class="form-check mt-2 bg-success-subtle">                                    
                                                <input class="form-check-input rounded-5" type="radio" value="" id="radio" name="radio-${entry.key.id}" />
                                                <label class="form-check-label" for="radio">${a.content}</label>
                                            </div>  
                                        </c:if>
                                        <c:if test="${!a.correctless}">
                                            <div class="form-check mt-2">                                    
                                                <input class="form-check-input rounded-5" type="radio" value="" id="radio" name="radio-${entry.key.id}"/>
                                                <label class="form-check-label" for="radio">${a.content}</label>
                                            </div>  
                                        </c:if>
                                    </c:otherwise>
                                </c:choose>
                            </c:forEach>
                        </div>
                        <c:choose>
                            <c:when test="${flag}">
                                <div class="col-1 text-end fw-medium">1/1 point</div>
                            </c:when>
                            <c:otherwise>
                                <div class="col-1 text-end fw-medium ">0/1 point</div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </c:forEach>
            </div>

        </form>
        <script>
            const notify = document.getElementById('notify');
            const icon = document.getElementById('icon');
            const btnNextOrTry = document.getElementById('btnNextOrTry');
            <c:choose>
                <c:when test="${requestScope.mark >= requestScope.quiz.passedTarget}">
            notify.classList.add('bg-success-subtle');
            icon.innerHTML = "<svg xmlns=" + "http://www.w3.org/2000/svg" + "width='24' height='24' fill='currentColor' class='bi bi-check-circle' viewBox='0 0 16 16'  style='color:green '>"
                    + "<path d='M15.854 5.854a.5.5 0 0 0-.708-.708L7 13.293 3.354 9.646a.5.5 0 1 0-.708.708l4 4a.5.5 0 0 0 .708 0l8-8z'/>"
                    + "<path d='M16 8A8 8 0 1 1 8 0a8 8 0 0 1 8 8zM1 8a7 7 0 1 0 14 0A7 7 0 0 0 1 8z'/>"
                    + "</svg>";
            btnNextOrTry.disabled="true";
                </c:when>
                <c:otherwise>
            notify.classList.add('bg-danger-subtle');
            icon.innerHTML = "<svg xmlns='http://www.w3.org/2000/svg' width='24' height='24' fill='currentColor' class='bi bi-x-circle' viewBox='0 0 16 16'  style='color:red '>"
                            +"<path d='M8 15A7 7 0 1 1 8 1a7 7 0 0 1 0 14m0 1A8 8 0 1 0 8 0a8 8 0 0 0 0 16'/>"
                            +"<path d='M4.646 4.646a.5.5 0 0 1 .708 0L8 7.293l2.646-2.647a.5.5 0 0 1 .708.708L8.707 8l2.647 2.646a.5.5 0 0 1-.708.708L8 8.707l-2.646 2.647a.5.5 0 0 1-.708-.708L7.293 8 4.646 5.354a.5.5 0 0 1 0-.708'/>"
                            +"</svg>";
            btnNextOrTry.innerHTML="Try again";
            btnNextOrTry.href="http://localhost:8080/SWP391/takequiz?course=${param.course}&section=${param.section}&id=${param.id}";
                </c:otherwise>
            </c:choose>
            const radio = document.getElementsByClassName('form-check-input');
            for (let i of radio) {
                i.addEventListener('click', function (event) {
                    event.preventDefault();
                });
            }
        </script>
        <%@include file="../elements/footer.jsp"%>
        <script src="https://unpkg.com/ionicons@5.5.2/dist/ionicons/ionicons.js"></script>
    </body>
</html>
