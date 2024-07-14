<%-- 
    Document   : browser-detection
    Created on : May 17, 2024, 9:13:16 PM
    Author     : HieuTC
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!doctype html>
<html lang="en">
    <head>
        <meta charset="utf-8"/>
        <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
        <title>EduPort</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
        <link href="view/assets/css/hieutc.css" rel="stylesheet"/>
    </head>
    <body>
        <%@include file="../elements/navbar.jsp"%>
        <div class="d-flex justify-content-center p-5" style="min-height: 70vh;">
            <div style="width: 23%;">
                <h6 class="fw-bold mb-3">A new browser is detected</h6>
                <span>Hey, you are logging in on new browser that you never use before.
                     Then please check the new mail send from us to authenticate it's you.<br>
                     Because of your benefits, thank!</span>
                     <p class="text-secondary">* Please resubmit request
                     if you don't receive our mail in 2 minutes</p>
                     <span>Back to <a class="fw-bold" href="log-in">Log in</a></span>
            </div>
        </div>
        <%@include file="../elements/footer.jsp"%>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script type="module" src="https://unpkg.com/ionicons@7.1.0/dist/ionicons/ionicons.esm.js"></script>
        <script nomodule src="https://unpkg.com/ionicons@7.1.0/dist/ionicons/ionicons.js"></script>
    </body>
</html>
