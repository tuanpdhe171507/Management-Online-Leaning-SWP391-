<%-- 
    Document   : check1
    Created on : May 26, 2024, 1:04:03 AM
    Author     : HuyLQ;
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8"/>
        <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
        <title>EduPort | Reset password</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
        <link href="view/assets/css/base.css" rel="stylesheet"/>
        <style>
            .indicators {
                width: 100%;
                height: 0.2rem;
                display: flex;
                align-items: center;
                justify-content: space-between;
            }

            .indicator {
                background: lightblue;
                width: 24%;
                height: 0.2rem;
            }
            
            .active{
                background-color: black;
            }
        </style>
    </head>
    <body>
        <%@include file="../elements/navbar.jsp"%>

        <div class="d-flex justify-content-center p-5" style="min-height: 70vh;">
            <div style="width: 23%;">
            <c:if test="${requestScope.wrong}">
                <h6 class="fw-bold">Something wrong</h6>
                <span>There is a problem when we try to verify your link.
                    To understand more about this.<br>
                    Please contact <a class="fw-bold" href="" target="_blank">support</a>.</span>
            </c:if>
            <c:if test="${requestScope.wrong == null}">
                <h6 class="fw-bold mb-3">Choose a new password</h6>
                <form action="reset-password" method="post" id="form">
                    <c:if test="${requestScope.error != null}">
                        <div class="alert alert-danger">
                            ${requestScope.error}
                        </div> 
                        <span>To understand more about this.<br>
                            Please contact <a class="fw-bold" href="" target="_blank">support</a>.</span><br>
                        <span>Back to <a class="fw-bold " href="log-in">Log in</a></span>
                    </c:if>
                    <c:if test="${requestScope.done != null}">
                        <div class="alert alert-success">
                            ${requestScope.done}
                        </div>  
                        <span>Click on <a class="fw-bold " href="log-in">Log in</a>
                        or wait for 5 seconds for automatically log in</span>
                    </c:if>
                    <c:if test="${requestScope.done == null
                          && requestScope.error == null}">
                    <div class="form-floating mb-3">
                        <input class="form-control" type="password" placeholder="pw" name="newPassword" id="password"
                               minlength="6" maxlength="32" onkeyup="trigger();verify()" required/>
                        <label class="fw-bold" for="password">Enter password</label>
                    </div>
                    <div class="indicators mb-3">
                        <div class="indicator"></div>
                        <div class="indicator"></div>
                        <div class="indicator"></div>
                        <div class="indicator"></div>
                    </div>
                    <p id="text"></p>
                    <div class="form-floating mb-3">
                        <input class="form-control" type="password" placeholder="pw" name="confirmPassword"
                               minlength="6" maxlength="32" onkeyup="verify()" id="re-password" required/>
                        <label class="fw-bold" for="password">Re-type password</label>
                    </div>
                    <input type="hidden" name="token" value="<%=request.getParameter("token") %>"/>
                    <input type="hidden" name="emailAddress" value="<%=request.getParameter("emailAddress") %>"/>
                    <input class="btn btn-dark fw-bold p-3 w-100 mb-3" type="submit" id="submit" value="Reset password" disabled="true"/>
                    </c:if>
                </form>
            </c:if>
            </div>
        </div>
        <%@include file="../elements/footer.jsp"%>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script type="module" src="https://unpkg.com/ionicons@7.1.0/dist/ionicons/ionicons.esm.js"></script>
        <script nomodule src="https://unpkg.com/ionicons@7.1.0/dist/ionicons/ionicons.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/clientjs@0.1.11/dist/client.min.js"></script>
        <script src="https://accounts.google.com/gsi/client" async></script>
        <script>
            <c:if test="${requestScope.done != null}">
                setTimeout(function () {
                    window.location.href = "log-in";
                }, 5000);
            </c:if>
            let weak = /.{6,}/;
            let medium = /^(?=.*[a-zA-Z])(?=.*\d).{6,}$/;
            let strong = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,}$/;
            let veryStrong = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*]).{10,}$/;
            var indicators = document.getElementsByClassName("indicator");
            var text = document.getElementById("text");
            function trigger() {
                var password = document.getElementById("password").value;
                if (password.match(veryStrong)) {
                   active(4);
                   text.textContent = "Very strong password";
                } else if (password.match(strong)) {
                   active(3);
                   text.textContent = "Strong password";
                } else if (password.match(medium)) {
                   active(2);
                   text.textContent = "Medium password";
                } else if (password.match(weak)) {
                   active(1);
                   text.textContent = "Weak password";
               } else {
                   active(0);
                   text.textContent = "";
               }
            }
            
            function verify() {
                var password = document.getElementById("password").value;
                var rePassword = document.getElementById("re-password").value;
                if (password !== "" && password === rePassword) {
                    document.getElementById("submit").removeAttribute("disabled");
                } else {
                    document.getElementById("submit").disabled = "true";
                }
            }
            
            function active(e) {
                for (let i = 0; i < indicators.length; i++) {
                    indicators[i].classList.remove("active");
                }
                for (let i = 0; i < e; i++) {
                    indicators[i].classList.add("active");
                }
            }
        </script>
    </body>
</html>