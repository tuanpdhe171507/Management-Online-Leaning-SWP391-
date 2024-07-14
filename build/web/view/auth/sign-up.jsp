<%-- 
    Document   : sign-up
    Created on : May 22, 2024, 6:28:05 PM
    Author     : HieuTC
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!doctype html>
<html lang="en">
    <head>
        <meta charset="utf-8"/>
        <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
        <title>EduPort | Sign up</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
        <link href="view/assets/css/hieutc.css" rel="stylesheet"/>
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
        <div class="d-flex justify-content-center p-5 body">
            <div style="width: 23%;">
                <h6 class="fw-bold mb-3">Sign up and start learning</h6>
                <form action="sign-up" method="post" id="form">
                <div class="page">   
                    <c:if test="${requestScope.error != null}">
                    <div class="alert alert-danger" role="alert">
                        ${requestScope.error}
                    </div>
                    </c:if>
                    <input type="hidden" name="os" id="os"/>
                    <input type="hidden" name="browser" id="browser"/>
                    <input type="hidden" name="ip" id="ip"/>
                    <div class="form-floating mb-3">
                        <input class="form-control" type="text" placeholder="abc" name="fullname" id="fullname"
                            value="${requestScope.fullname}" required value="${requestScope.email}"/>
                        <label class="fw-bold" for="fullname">Fullname</label>
                    </div>
                    <div class="form-floating mb-3">
                        <input class="form-control" type="email" placeholder="me@example.io" name="email" id="email"
                              maxlength="64" value="${requestScope.email}" required <c:if test="${requestScope.email != null}">readonly</c:if>/>
                        <label class="fw-bold" for="email">Email</label>
                    </div>
                    <c:if test="${requestScope.email != null}">
                        <button class="w-100 btn btn-dark p-3 fw-bold mb-3" type="button" onclick="next()">Continues</button>
                        <p>You need create your profile on the first time</p>
                    </c:if>
                    
                </div> 
                <div class="page">  
                    <div class="form-floating mb-1">
                        <input class="form-control" type="password" placeholder="pw" name="password" id="password"
                            minlength="6" maxlength="32" onkeyup="trigger();verify()" <c:if test="${requestScope.email == null}">required</c:if>/>
                        <label class="fw-bold" for="password">Password</label>
                    </div>
                    <div class="indicators mb-3">
                        <div class="indicator"></div>
                        <div class="indicator"></div>
                        <div class="indicator"></div>
                        <div class="indicator"></div>
                    </div>
                    <p id="text"></p>
                
                    <div class="form-floating mb-3">
                        <input class="form-control" type="password" placeholder="re-pw" id="re-password"
                            minlength="6" maxlength="32" onkeyup="verify()" <c:if test="${requestScope.email == null}">required</c:if>/>
                        <label class="fw-bold" for="password">Re-type password</label>
                    </div>
                    <input class="btn btn-dark fw-bold p-3 w-100 mb-3" type="submit" value="Sign up" id="submit" disabled="true"/>
                    <div class="form-check">
                    <input class="form-check-input" type="checkbox" id="agreement" onchange="verify();">
                    <label class="form-check-label" for="agreement">
                        Agree our <a class="fw-bold" href="">Terms of Use</a>
                        and <a class="fw-bold" href="">Privacy Policy</a>
                    </label> 
                    </div>
                    </div> 
                    
                </form>
                
                <hr>
                <span>Already have an account? <a class="fw-bold" href="<%=request.getContextPath() + "/log-in"%>">Log in</a></span><br>
            </div>
        </div>
        <%@include file="../elements/footer.jsp"%>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script type="module" src="https://unpkg.com/ionicons@7.1.0/dist/ionicons/ionicons.esm.js"></script>
        <script nomodule src="https://unpkg.com/ionicons@7.1.0/dist/ionicons/ionicons.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/clientjs@0.1.11/dist/client.min.js"></script>
        <script>
            var pages = document.getElementsByClassName("page");
            var submitBtn = document.getElementById("submit");
            <c:if test="${requestScope.email != null}">
            function back() {
                pages[0].style.display = "block";
                pages[1].style.display = "none";
                submitBtn.value = "Continues";
            }
            function next() {
                if (submitBtn.value === "Sign up") {
                     submitBtn.type = "submit";
                }
                pages[0].style.display = "none";
                pages[1].style.display = "block";
                submitBtn.value = "Sign up";
                verify();
            }
            back();
           </c:if>
            window.onload = function() {
                var client = new ClientJS();
                document.getElementById("os").value = client.getOS();
                document.getElementById("browser").value = client.getBrowser();
                getIPAddress(ip => {
                    document.getElementById("ip").value = ip;
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
            // At least 6 characters.
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
                var checkForm = document.getElementById("agreement");
                if (password !== "" && password === rePassword) {
                    if (checkForm.checked) {
                        submitBtn.removeAttribute("disabled");
                    } else {
                        submitBtn.disabled = "true";
                    }
                }else{
                    submitBtn.disabled = "true";
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
