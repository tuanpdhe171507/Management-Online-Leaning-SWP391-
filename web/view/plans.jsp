<%-- 
    Document   : plan
    Created on : Jun 17, 2024, 3:13:53 PM
    Author     : Trongnd
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Compare Plans</title>

        <script async="" src="https://www.googletagmanager.com/gtag/js?id=G-M8S4MT3EYG"></script>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <link href="https://getbootstrap.com/docs/5.3/assets/css/docs.css" rel="stylesheet">
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
        <link href="view/assets/css/hieutc.css" rel="stylesheet" />
    </head>

    <body>
        <%@include file="elements/navbar.jsp"%>
        <div class="container mt-5 mb-5 w-75 body">
            <div class="mb-5 mt-3">
                <!-- heading -->
                <div class="text-center">
                    <h5 class="mb-3 fw-bold">A plan for every projects</h5>                        
                </div>
            </div>
            <!-- row -->
            <div class="row">                
                <c:forEach items="${requestScope.plans}" var="p">
                    <div class="col-4">
                        <div class="card mb-3 border  border-top-0">
                            <div class="card border rounded shadow-small">
                                <div class="card-body">
                                    <div class="my-3 pt-2 text-center mb-2">

                                    </div>
                                    <h3 class="card-title text-center text-capitalize mb-1">${p.name}</h3>
                                    <div class="text-center mb-3">
                                        <div class="d-flex justify-content-center">
                                            <h1 class="display-4 mb-0 text-primary fw-bold">$ ${p.price}</h1>
                                            <sub class="h6 pricing-duration mt-auto mb-2 text-muted fw-normal">/month</sub>
                                        </div>                              
                                    </div>
                                    <div class="d-flex justify-content-center mb-3">

                                        <form action="plans" method="post">
                                            <input type="hidden" value="${p.plan}" name="plan">
                                            <c:if test="${p.price eq 0}">
                                                <a href="<%=request.getContextPath()%>" class="btn btn-dark d-grid w-100" id="btn-register">Get Started</a> 
                                            </c:if>
                                            <c:if test="${p.plan eq 'month'}">
                                                <a href="<%=request.getContextPath()%>/VNPay?totalPrice=${p.price}&plan=${p.plan}" class="btn btn-dark d-grid w-100 plan" id="${p.plan}">Get purchase</a> 
                                            </c:if>
                                            <c:if test="${p.plan eq 'quarter'}">
                                                <a href="<%=request.getContextPath()%>/VNPay?totalPrice=${p.price*4}&plan=${p.plan}" class="btn btn-dark d-grid w-100 plan" id="${p.plan}">Get purchase</a> 
                                            </c:if>
                                        </form>
                                    </div>
                                    <ul class="ps-3 my-4 list-unstyled">
                                        <c:forEach items="${p.description}" var="des">
                                            <li class="mb-2 d-flex">
                                                <span class="badge badge-center w-px-20 h-px-20 rounded-pill bg-label-primary me-2">
                                                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-check-circle-fill" viewBox="0 0 16 16">
                                                    <path style="fill: green" d="M16 8A8 8 0 1 1 0 8a8 8 0 0 1 16 0m-3.97-3.03a.75.75 0 0 0-1.08.022L7.477 9.417 5.384 7.323a.75.75 0 0 0-1.06 1.06L6.97 11.03a.75.75 0 0 0 1.079-.02l3.992-4.99a.75.75 0 0 0-.01-1.05z"/>
                                                    </svg>
                                                </span>
                                                <span>${des}</span>
                                            </li>
                                        </c:forEach>
                                    </ul>             

                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>
        <%@include file="elements/footer.jsp"%>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script type="module" src="https://unpkg.com/ionicons@7.1.0/dist/ionicons/ionicons.esm.js"></script>
        <script nomodule src="https://unpkg.com/ionicons@7.1.0/dist/ionicons/ionicons.js"></script>
        <script>
            document.addEventListener('DOMContentLoaded', function () {
                const plans = document.getElementsByName('plan');

                for (let i = 0; i < plans.length; i++) {
                    if (plans[i].value === '${requestScope.planRegisted}') {
                        let parent = plans[i].parentElement;
                        let link = parent.getElementsByTagName('a')[0];
                        link.innerText = 'Current plan';
                        link.classList.remove('btn-dark');
                        link.classList.add('text-success');
                        link.classList.add('fw-bold');
                        link.setAttribute("disabled", true);
                        break; // Exit loop after finding the match
                    }
                }
            });

        </script>
    </body>

</html>
