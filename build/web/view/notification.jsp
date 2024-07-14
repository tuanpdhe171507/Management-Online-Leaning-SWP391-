<%-- 
    Document   : notification
    Created on : Jul 7, 2024, 5:27:54 PM
    Author     : HieuTC
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!doctype html>
<html lang="en">

    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>EduPort</title>
        <link href="view/assets/css/hieutc.css" rel="stylesheet" />
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"
              integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous" />
    </head>
    <body>
        <%@include file="elements/navbar.jsp"%>
        <div class="container pt-5 pb-5 w-50">
            <h6 class="fw-bold pb-3">Notifications</h6>
            <div class="pb-3">
                <button class="btn <c:if test="${param.query.equalsIgnoreCase('all')}">btn-dark</c:if><c:if test="${!param.query.equalsIgnoreCase('all')}">btn-light</c:if> fw-bold" type="button"
                        onclick="openHyperLink('notification?rows=${param.rows}&query=all')">
                    All
                </button>
                <button class="btn <c:if test="${param.query.equalsIgnoreCase('unread')}">btn-dark</c:if><c:if test="${!param.query.equalsIgnoreCase('unread')}">btn-light</c:if> fw-bold" type="button"
                        onclick="openHyperLink('notification?rows=${param.rows}&query=unread')">
                    Unread
                </button>  
            </div>
            <c:if test="${requestScope.notifications.isEmpty()}">
                <p class="pt-3 text-center">No notifications.</p>
            </c:if>
             
            <div class="btn-group-vertical w-100" role="group">
            <c:forEach items="${requestScope.notifications}" var="noti">
                <div class="btn p-3 border text-start position-relative <c:if test="${!noti.read}">bg-light</c:if>" id="${noti.id}">
                    <div onclick="setNotification(${noti.id}, 'read', true); openHyperLink('${noti.hyperLink}')" style="width: 80%;">
                    <h6 class="fw-bold m-0">             
                        ${noti.message}</h6>
                    <span>${noti.getFormattedDatetime()}</span>
                    </div>
                    <div class="position-absolute top-0 end-0 pt-3 pe-2">
                        <div class="dropdown">
                            <button class="btn " type="button"
                                    data-bs-toggle="dropdown" aria-expanded="false">
                                <ion-icon class="fs-5" name="ellipsis-horizontal-sharp"></ion-icon>       
                            </button>
                            <div class="dropdown-menu d">
                                <button class="btn dropdown-item" type="button" id="btn-${noti.id}" <c:if test="${noti.read}">
                                        onclick="setNotification(${noti.id}, 'read', false)" >
                                    Mark as unread</c:if>
                                    <c:if test="${!noti.read}">
                                        onclick="setNotification(${noti.id}, 'read', true)">
                                    Mark as read</c:if>
                                </button>
                                <button class="btn dropdown-item" type="button"
                                        onclick="setNotification(${noti.id}, 'hiddenState', true)">
                                    Remove this notification
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
                </c:forEach>
            </div>
            <c:if test="${!param.rows.equalsIgnoreCase('all') && requestScope.notifications.size() >= param.rows}">
            <div class="d-flex justify-content-end pt-3">
                <a class="btn fw-bold" type="button"
                   href="notification?rows=<c:choose><c:when test="${param.rows == 5}">${10}</c:when><c:when test="${param.rows == 10}">all</c:when></c:choose>&query=${param.query}">
                    See more
                </a>
            </div>   
            </c:if>
            
        </div>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"
            integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz"
            crossorigin="anonymous"></script>
        <script type="module" src="https://unpkg.com/ionicons@7.1.0/dist/ionicons/ionicons.esm.js"></script>
        <script nomodule src="https://unpkg.com/ionicons@7.1.0/dist/ionicons/ionicons.js"></script>
        <script>
            function setNotification(id, attribute, value) {
                var xhttp = new XMLHttpRequest();
                xhttp.onreadystatechange = function () {
                    if (this.readyState === 4 && this.status === 200) {
                        var noti = document.getElementById('noti-' + id);
                        if (attribute == 'hiddenState') {
                            document.getElementById(id).remove();
                            if (noti !== null) {
                                noti.remove();
                            }    
                        } else if (attribute == 'read') {
                            var btn = document.getElementById('btn-' + id);
                            if (value) {
                                <c:if test="${param.query.equalsIgnoreCase('unread')}">
                                    document.getElementById(id).remove();             
                                </c:if>
                                <c:if test="${param.query.equalsIgnoreCase('all')}">
                                    document.getElementById(id).classList.remove('bg-light');
                                </c:if>
                                btn.innerHTML = 'Mark as unread';
                                btn.onclick = function() {
                                  setNotification(id, 'read', false);
                                };   
                                if (noti !== null) {
                                   if (noti.classList.contains('bg-light')) {
                                       noti.classList.remove('bg-light');
                                   } 
                                }     
                            } else {
                                    document.getElementById(id).classList.add('bg-light');
                                btn.innerHTML = 'Mark as read';
                                btn.onclick = function() {
                                  setNotification(id, 'read', true);
                                };
                                if (noti !== null) {
                                   if (!noti.classList.contains('bg-light')) {
                                       noti.classList.add('bg-light');
                                   } 
                                }   
                            }
                            
                        }
                    }
                };
                xhttp.open("get", 'http://localhost:8080/SWP391/set-notification?id=' + id
                + '&attribute=' + attribute + '&value=' + value, true);
                xhttp.send();
            }
        </script>
    </body>
</html>
