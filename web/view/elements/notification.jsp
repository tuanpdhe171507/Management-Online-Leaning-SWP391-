<%-- 
    Document   : notification
    Created on : Jul 8, 2024, 1:45:05 AM
    Author     : HieuTC
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="dao.UserContext" %>
<%@ page session="true"%>
<div class="dropdown d-inline-block">
    <button class="btn" type="button"
            data-bs-toggle="dropdown" aria-expanded="false">
        <ion-icon class="fs-5" name="notifications-outline"></ion-icon>
    </button>
    <div class="dropdown-menu dropdown-menu-end" style="width: 20rem !important;">
        <h6 class="p-2 fw-bold">Notifications</h6>
        <div id="notifications">
            <%UserContext userContext = new UserContext();
            request.setAttribute("userContext", userContext);%>
            <c:set var="notifications" value="${requestScope.userContext.getNotifications(sessionScope.user.email, 3)}"></c:set>
            <c:if test="${notifications.isEmpty()}">
                <div class="border-top border-bottom text-center p-3" id="nothing">
                    <p>No notifications.</p>
                </div>
            </c:if>
            <c:forEach items="${notifications}" var="noti">
            <button class="btn border-top border-bottom dropdown-item pt-3 pb-3 <c:if test="${!noti.read}">bg-light</c:if>" type="button"
                    onclick="readNotification(${noti.id}); openHyperLink('${noti.hyperLink}')" id="noti-${noti.id}">
                <div class="text-truncate">
                    <h6 class="fw-bold m-0">${noti.message}</h6> 
                </div>
                <span>${noti.getFormattedDatetime()}</span>
            </button>   
            </c:forEach>
        </div>

            <div class="d-flex justify-content-end pt-2">
            <a class="btn fw-bold" href="http://localhost:8080/SWP391/notification">
                See more
            </a>
        </div>
    </div>
</div>
<div class="toast-container position-fixed bottom-0 end-0 p-3">
    <div id="toast" class="toast" role="alert" aria-live="assertive" aria-atomic="true">
        <div class="toast-body">
            <h6 class="fw-bold">New notification</h6>
            <p id="content"></p>
            <div class="d-flex justify-content-end">
                <button class="btn p-0 fw-bold" type="button" onclick="callToast()">Dismiss</button>
            </div>
        </div>
    </div>
</div>      

<script>
    var notifications = document.getElementById('notifications');
    const socket = new WebSocket('ws://localhost:8080/SWP391/notify');
    socket.onopen = function (event) {
        document.getElementById('content').innerHTML = 'opened';
    };

    socket.onmessage = function (event) {
        var json = JSON.parse(event.data);
        append(json);
        if (notifications != null) {
            update(json);
        }
        
    };

    function append(json) {
        document.getElementById('content').innerHTML = json.message;
        callToast();
    }
    
    function callToast() {
        document.getElementById('toast').classList.toggle('d-block');
    }
    
    
    
    function update(json) {
        var nothing = notifications.querySelector('#nothing');
        if (nothing != null) {
            nothing.remove();
        }
        
        var content = notifications.innerHTML;
        
        notifications.innerHTML = `<button class="btn border-top border-bottom dropdown-item pt-3 pb-3 <c:if test="${!noti.read}">bg-light</c:if>" type="button"
                    onclick="readNotification(` + json.id + `); openHyperLink('` + json.hyperLink + `')" id="noti-` + json.id + `">
                <div class="text-truncate">
                    <h6 class="fw-bold m-0">` + json.message + `</h6> 
                </div>
                <span>` + formatDate(new Date(json.receivedTime)) + `</span>
            </button>   ` + content;
        
    }
    
    function readNotification(id) {
                var xhttp = new XMLHttpRequest();
                xhttp.onreadystatechange = function () {
                    if (this.readyState === 4 && this.status === 200) {
                    }
                };
                xhttp.open("get", 'http://localhost:8080/SWP391/set-notification?id=' + id
                + '&attribute=read&value=true', true);
                xhttp.send();
            }
            

    // Custom function to format the date
    function formatDate(date) {
        const options = { month: 'short', day: '2-digit', hour: '2-digit', minute: '2-digit', hour12: false };
        const formattedDate = date.toLocaleString('en-US', options);
        return formattedDate;
    }
</script>   

