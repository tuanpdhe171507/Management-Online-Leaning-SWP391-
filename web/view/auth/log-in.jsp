<%-- 
    Document   : login
    Created on : May 16, 2024, 1:12:43 PM
    Author     : HieuTC
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!doctype html>
<html lang="en">
    <head>
        <meta charset="utf-8"/>
        <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
        <title>EduPort | Log in</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
        <link href="view/assets/css/hieutc.css" rel="stylesheet"/>
    </head>
    <body>
        <%@include file="../elements/navbar.jsp"%>
        <div class="d-flex justify-content-center p-5">
            <div style="width: 23%;">
                <h6 class="fw-bold mb-3">Log in to your EduPort account</h6>
                <form action="log-in" method="post" id="form">
                    <input type="hidden" name="os" id="os"/>
                    <input type="hidden" name="browser" id="browser"/>
                    <input type="hidden" name="ip" id="ip"/>
                    <div id="g_id_onload"
                         data-client_id="444175066040-vfraie2ohc68jei5v58b1il2kppqm0o4.apps.googleusercontent.com"
                         data-context="signin"
                         data-ux_mode="redirect"
                         data-login_uri="http://localhost:8080/SWP391/google-log-in"
                         data-auto_prompt="false">
                    </div>
                    <button class="w-100 btn p-3 border text-start mb-3 fw-bold" style="border-color: black;" id="custom-google-btn" type="button">
                        <img class="me-1" src="view/assets/images/google-icon.png" style="width: 1rem; transform: translateY(-10%);"/>
                        Continue with Google
                    </button>
                    <div class="g_id_signin d-none"
                         data-type="standard"
                         data-shape="rectangular"
                         data-theme="outline"
                         data-text="continue_with"
                         data-size="large"
                         data-logo_alignment="left">
                    </div>
                    <c:if test="${requestScope.error != null}">
                        <div class="alert alert-danger" role="alert">
                            ${requestScope.error}
                        </div>
                    </c:if>
                    <c:if test="${sessionScope.user == null}">
                    <div class="form-floating mb-3">
                        <input class="form-control" type="email" placeholder="me@example.io" name="email" id="email"
                            maxlength="64"  value="${requestScope.email}" required/>
                        <label class="fw-bold" for="email">Email</label>
                    </div>
                    <div class="form-floating mb-3">
                        <input class="form-control" type="password" placeholder="pw" name="password" id="password"
                            minlength="6" maxlength="32" required/>
                        <label class="fw-bold" for="password">Password</label>
                    </div>
                    </c:if>
                    <button class="btn btn-dark fw-bold p-3 w-100 mb-3" type="submit" <c:if test="${requestScope.redirect}">disabled="true"</c:if>>Login</button>
                </form>
                <span>By clicking log in, you accept our <a class="fw-bold" href="">Terms of Use</a>
                     and <a class="fw-bold" href="">Privacy Policy</a></span>
                <hr>
                <span>Don't have an account? <a class="fw-bold" href="<%=request.getContextPath() + "/sign-up"%>">Sign up</a></span><br>
                <span>Need a support? <a class="fw-bold" href="forgot-password">Forgot password</a></span>
            </div>
        </div>
        <%@include file="../elements/footer.jsp"%>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script type="module" src="https://unpkg.com/ionicons@7.1.0/dist/ionicons/ionicons.esm.js"></script>
        <script nomodule src="https://unpkg.com/ionicons@7.1.0/dist/ionicons/ionicons.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/clientjs@0.1.11/dist/client.min.js"></script>
        <script src="https://accounts.google.com/gsi/client" async></script>
        <script>
            window.onload = function() {
                var client = new ClientJS();
                document.getElementById("os").value = client.getOS();
                document.getElementById("browser").value = client.getBrowser();
                getIPAddress(ip => {
                    document.getElementById("ip").value = ip;
                    <c:if test="${sessionScope.user != null}">
                    document.getElementById("form").submit();
                    </c:if>
                });
                
            };
            function getIPAddress(callback) {
                fetch("https://api.ipify.org?format=json")
                        .then(response => response.json())
                        .then(data => {
                            callback(data.ip);
                        })
                        .catch(error => {
                            console.error('Error fetching IP address:', error);
                        callback(null);
            });
            }
            
            const googleBtn = document.getElementById('custom-google-btn');
            googleBtn.addEventListener('click', () => {
                document.querySelector('.g_id_signin div[role=button]').click();
            });
        </script>
    </body>
</html>