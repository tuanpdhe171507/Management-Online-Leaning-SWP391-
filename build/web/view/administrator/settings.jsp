<%-- 
    Document   : newjsp
    Created on : Jul 6, 2024, 4:58:00 AM
    Author     : HieuTC
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="dao.AdministratorContext" %>
<!doctype html>
<html lang="en">

    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>EduPort</title>
        <link href="../view/assets/css/hieutc.css" rel="stylesheet" />
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"
              integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous" />
        <style>
            button.btn:focus {
                border-color: white !important
            }

            #search {
                border: unset !important;
            }

            #icon {
                border: unset;
                background-color: unset;
                padding: 0;
                transform: translateY(-10%);
            }

            .content {
                width: 70vw;
            }

            .icon {
                padding-left: 1.2rem !important;
                padding-right: 1.2rem !important;
            }
            
            button:disabled {
                border-color: white !important;
            }
        </style>
    </head>
    <body>
        <%@include file="elements/navbar.jsp"%>
        <div class="container content pt-5 pb-5">
            <div class="pb-5">
                <button class="btn fw-bold ps-0 pe-0 m-0 text-secondary" type="button"
                         onclick="openHyperLink('dashboard')">
                    Dashboard
                </button>
                <button class="btn fw-bold ps-0 pe-0 m-0 ms-3 rounded-0"
                        type="button" style="border-bottom: 3px solid black;"
                        onclick="openHyperLink('settings')">
                    Settings
                </button>
                <hr class="m-0">
            </div>
            <div class="row g-3">
                <div class="col-12 pb-4">
                    <h6 class="fw-bold">Context paths</h6>
                    <div class="pt-3 pb-3">
                        <a class="btn <c:if test="${param.query.equalsIgnoreCase('all')}">btn-dark</c:if><c:if test="${!param.query.equalsIgnoreCase('all')}">btn-light</c:if> fw-bold" type="button"
                           href="settings?row=${param.row}&query=all">
                            All
                        </a>
                        <a class="btn <c:if test="${param.query.equalsIgnoreCase('disabled')}">btn-dark</c:if><c:if test="${!param.query.equalsIgnoreCase('disabled')}">btn-light</c:if> fw-bold" type="button"
                           href="settings?row=${param.row}&query=disabled">
                            Disabled
                        </a>
                    </div>
                    <div class="btn-group-vertical w-100 page" role="group">
                        <c:if test="${requestScope.pathList.isEmpty()}">
                            <p class="text-center pt-3 pb-3">No results found.</p>
                        </c:if>
                    <c:set var="pathCount" value="0"></c:set>
                    <c:forEach items="${requestScope.pathList}" var="path">
                        <div class="btn p-3 border text-start">
                            <div class="row">
                                <div class="col-4 text-truncate ">
                                    <ion-icon id="signal-path-${pathCount}" class="fs-5 <c:if test="${path.availableState}">text-success</c:if><c:if test="${!path.availableState}">text-danger</c:if>" name="radio-button-on-sharp"></ion-icon>${path.description}
                                </div>
                                <div class="col-4 text-truncate ">
                                    ${path.path}
                                </div>
                                <div class="col-4 d-flex justify-content-end">
                                        
                                    <button type="button" class="p-0 btn fw-bold" id="btn-path-${pathCount}" <c:if test="${path.availableState}"> 
                                            onclick="setPath(${pathCount}, '${path.path}', false)">
                                        Deactivate </c:if><c:if test="${!path.availableState}">
                                            onclick="setPath(${pathCount}, '${path.path}', true)"> Activate
                                        </c:if> 
                                    </button>
                                </div>
                            </div>
                        </div>
                        <c:set var="pathCount" value="${pathCount + 1}"></c:set>
                        <c:if test="${param.row != 'all' && pathCount % param.row == 0}">
                        </div>
                        <div class="btn-group-vertical w-100 page" role="group">
                        </c:if>
                    </c:forEach>
                    </div>
                    <div class="d-flex justify-content-end pt-3">
                        <div class="dropdown">
                            Rows per page
                            <button class="btn" type="button"
                                    data-bs-toggle="dropdown"
                                    aria-expanded="false">
                            ${param.row} <ion-icon name="caret-down-sharp"></ion-icon>
                            </button>
                            <div class="dropdown-menu">
                                <a class="btn dropdown-item" type="button"
                                   href="?row=5">
                                    5
                                </a>
                                <a class="btn dropdown-item" type="button"
                                   href="?row=10">
                                    10
                                </a>
                                <a class="btn dropdown-item" type="button"
                                   href="?row=all">
                                    all
                                </a>
                            </div>
                        </div>
                        <button class="btn" type="button" onclick="back()" id="back-btn">
                            <ion-icon name="chevron-back-sharp"></ion-icon>
                        </button>
                        <button class="btn" type="button" onclick="next()" id="next-btn">
                            <ion-icon name="chevron-forward-sharp"></ion-icon>
                        </button>
                    </div>

                </div>
                <div class="col-8">
                    <%AdministratorContext dbContext = new AdministratorContext();
                    int rows = Integer.parseInt(dbContext.getValue("rows_per_division"));
                    int columns = Integer.parseInt(dbContext.getValue("columns_per_row"));%>
                    <div class="row gy-3">
                        <div class="col-12">
                            <h6 class="fw-bold">Layout customize</h6>
                            <div class="row g-3">
                                <div class="col-6">
                                    <div class="ps-3 border-start">
                                    <h6>Columns per row</h6>
                                    <p>Home screen, the number course will be displayed in a row at.</p>
                                    <div class="dropdown">
                                        <button class="btn fw-bold btn-light" type="button" data-bs-toggle="dropdown"
                                                aria-expanded="false">
                                            <span id="columns_per_row"><%=columns%></span> <ion-icon name="caret-down-sharp"></ion-icon>
                                        </button>
                                        <div class="dropdown-menu">
                                            <button class="dropdown-item" onclick="setAttributes('columns_per_row', 3)">3</button>
                                            <button class="dropdown-item" onclick="setAttributes('columns_per_row', 4)">4</button>
                                            <button class="dropdown-item" onclick="setAttributes('columns_per_row', 6)">6</button>
                                        </div>
                                    </div>
                                    </div>          
                                </div>
                                <div class="col-6">
                                    <div class="ps-3 border-start">
                                    <h6>Rows per division</h6>
                                    <p>Home screen, the rows for course list will be displayed in a division.</p>
                                    <div class="dropdown">
                                        <button class="btn fw-bold btn-light" type="button" data-bs-toggle="dropdown"
                                                aria-expanded="false">
                                            <span id="rows_per_division"><%=rows%></span> <ion-icon name="caret-down-sharp"></ion-icon>
                                        </button>
                                        <div class="dropdown-menu">
                                            <button class="dropdown-item" onclick="setAttributes('rows_per_division', 1)">1</button>
                                            <button class="dropdown-item" onclick="setAttributes('rows_per_division', 2)">2</button>
                                        </div>
                                    </div>
                                    </div>
                                </div>
                            
                                        <%rows = Integer.parseInt(dbContext.getValue("rows_per_page"));%>
                                        <div class="col-6">
                                    <div class="ps-3 border-start">
                                    <h6>Rows per page</h6>
                                    <p>Search screen, how many course/ rows will be display in a page.</p>
                                    <div class="dropdown">
                                        <button class="btn fw-bold btn-light" type="button" data-bs-toggle="dropdown"
                                                aria-expanded="false">
                                            <span id="rows_per_page"><%=rows%></span> <ion-icon name="caret-down-sharp"></ion-icon>
                                        </button>
                                        <div class="dropdown-menu">
                                            <button class="dropdown-item" onclick="setAttributes('rows_per_page', 4)">4</button>
                                            <button class="dropdown-item" onclick="setAttributes('rows_per_page', 6)">6</button>
                                            <button class="dropdown-item" onclick="setAttributes('rows_per_page', 8)">8</button>
                                        </div>
                                    </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-4">
                    <h6 class="fw-bold">Another</h6>
                    <div class="row g-3">
                        <div class="col-12 d-flex align-items-center">
                                    <div class="border rounded-2 p-3 icon">
                                        <ion-icon class="fs-4" name="pricetag-sharp"></ion-icon>
                                    </div>
                                    <div class="ps-2">
                                        <h6 class="fw-bold m-0">Discount event</h6>
                                        <span class="text-secondary">Events improve sales</span>
                                    </div>
                                </div>
                        <div class="col-12 d-flex align-items-center">
                                    <div class="border rounded-2 p-3 icon">
                                        <ion-icon class="fs-4" name="layers-sharp"></ion-icon>
                                    </div>
                                    <div class="ps-2">
                                        <h6 class="fw-bold m-0">Sliders</h6>
                                        <span class="text-secondary">Banners appear on home screen</span>
                                    </div>
                                </div>
                    </div>
                    

                </div>
            </div>
        </div>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"
                integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz"
        crossorigin="anonymous"></script>
        <script type="module" src="https://unpkg.com/ionicons@7.1.0/dist/ionicons/ionicons.esm.js"></script>
        <script nomodule src="https://unpkg.com/ionicons@7.1.0/dist/ionicons/ionicons.js"></script>
        <script src="../view/assets/js/base.js"></script>
        <script>
            var currentPage = 0;
            const pages = document.getElementsByClassName('page');
            var backBtn = document.getElementById('back-btn');
            var nextBtn =  document.getElementById('next-btn');
            function go(i) {
                if (i === 0) {
                    backBtn.setAttribute('disabled', true);
                } else {
                    backBtn.removeAttribute('disabled');
                }
                
                if (i === pages.length - 1) {
                    nextBtn.setAttribute('disabled', true);
                } else {
                    nextBtn.removeAttribute('disabled');
                }
                
                for (let j = 0; j < pages.length; j++) {
                    if (j !== i) {
                        pages[j].style.display = 'none';
                    } else {
                        pages[j].style.display = 'block';
                    }
                }
                
            }
            
            function check() {
                const paths = document.getElementsByName('path');
                for (let i = 0; i < paths.length; i++) {
                    if (paths[i].checked === false) {
                        selectBox.checked = false;
                        return;
                    }
                }
                selectBox.checked = true;
            }
            function back() {
               
                currentPage -= 1;
                go(currentPage);
            }
            
            function next() {
                currentPage += 1;
                go(currentPage);
            }
            go(0);
            
            function setPath(i, path, state) {
                var xhttp = new XMLHttpRequest();
                xhttp.onreadystatechange = function() {
                if (this.readyState == 4 && this.status == 200) {
                    var btn = document.getElementById('btn-path-' + i);
                    var signal = document.getElementById('signal-path-' + i);
                    if (state) {
                        signal.classList.remove('text-danger');
                        signal.classList.add('text-success');
                        btn.onclick = function() {
                          setPath(i, '${path.path}', false);
                        };
                        btn.innerText = 'Deactivate';
                    } else {
                        signal.classList.remove('text-success');
                        signal.classList.add('text-danger');
                        btn.onclick = function() {
                          setPath(i, '${path.path}', true);
                        };
                        btn.innerText = 'Activate';
                    }
                   
                }
            };
            
            xhttp.open("get", "set-path?path=" + path + '&state=' + state, true);
            xhttp.send();
            }
            
            function setAttributes(param, value) {
                var xhttp = new XMLHttpRequest();
                xhttp.onreadystatechange = function() {
                if (this.readyState == 4 && this.status == 200) {
                    document.getElementById(param).innerText = value;
                }
            };
            
            xhttp.open("get", "set-attribute?var=" + param + '&val=' + value, true);
            xhttp.send();
            }
        </script>
    </body>
</html>
