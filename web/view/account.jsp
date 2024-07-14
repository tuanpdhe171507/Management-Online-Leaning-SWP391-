<%-- 
    Document   : viewProfile
    Created on : May 19, 2024, 12:41:39 PM
    Author     : Huy
--%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!doctype html>
<html lang="en">
    <head>
        <meta charset="utf-8"/>
        <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
        <title>EduPort</title>
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
            
            .here {
                border-top-right-radius: 0.5rem;
                border-bottom-right-radius: 0.5rem;
                background-color: whitesmoke;
            }
        </style>
    </head>
    <body>
        <%@include file="elements/navbar.jsp"%>
        <div class="modal" tabindex="-1" aria-hidden="true" id="confirmee">
                    <div class="modal-dialog modal-dialog-centered">
                        <div class="modal-content">
                            <div class="modal-body">
                                <div class="position-absolute top-0 end-0">
                                    <button class="btn p-2 pe-3" data-bs-dismiss="modal" aria-label="Close">
                                        <ion-icon class="fs-4" name="close-sharp"></ion-icon>
                                    </button>
                                </div>
                                <h5 class="fw-bold pb-3">Are you sure ?</h5>
                                <p>You will no longer be logged in on the selected devices.</p>
                                <div class="d-flex justify-content-end">
                                    <button class="btn" type="button" data-bs-dismiss="modal" aria-label="Close">
                                        Cancel
                                    </button>
                                    <button class="btn fw-bold text-primary" type="button" id="confirmee-btn">
                                        Continue   
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
        <div class="modal" tabindex="-1" aria-hidden="true" id="devices">
                    <div class="modal-dialog modal-dialog-centered" style="min-width: 40rem !important">
                        <div class="modal-content rounded-2">
                            <div class="modal-body pt-4 pb-4 overflow-y-auto" style="height: 70vh;">
                                <div class="d-flex justify-content-between">
                                    <div>
                                        <button class="btn p-0 fw-bold" type="button" onclick="openPhrase(0)" id="return-btn">
                                            <ion-icon class="fs-5" name="arrow-back-sharp"></ion-icon>
                                        </button>  
                                    </div>
                                    
                                    <button class="btn p-0 fw-bold float-end" type="button"  data-bs-dismiss="modal" aria-label="Close">
                                        <ion-icon class="fs-5" name="close-sharp"></ion-icon>
                                    </button>
                                </div>
                                <div class="phrase">
                                    <h5 class="fw-bold pt-3">Account login activity</h5>  
                                    <p>You're currently logged in on these devices:</p>
                                    <div class="row gy-3">
                                        <div class="col-12">
                                            <button class="btn p-3 border w-100 text-start position-relative" type="button" disabled style="opacity: 100%">
                                                <h6 class="fw-bold">${requestScope.thisDevice.os} | ${requestScope.thisDevice.browser}</h6>
                                                <p class="m-0 fw-bold text-success">This device</p>
                                            </button>  
                                        </div>
                                        <h6 class="fw-bold">Logins on other devices</h6>
                                        <div class="col-12">
                                            <div class="btn-group-vertical w-100" role="group">
                                                <c:if test="${requestScope.deviceList.isEmpty()}">
                                                    <button class="btn fw-bold p-4 ps-3 border text-start position-relative" style="opacity: 100%" disabled="true" type="button">
                                                        No results found
                                                    </button>
                                                </c:if>
                                                <c:forEach items="${requestScope.deviceList}" var="device">
                                                <button class="btn p-3 border text-start position-relative" type="button"
                                                        onclick="openPhrase(2), openDevice(${requestScope.deviceList.indexOf(device)})">
                                                    <h6 class="fw-bold">${device.os} | ${device.browser}</h6>
                                                    <p class="m-0 fw-bold text-secondary">${device.getLastedActivity()}</p>
                                                    <div class="position-absolute top-0 end-0 pe-3" style="padding-top: 1.8rem;">
                                                        <ion-icon name="chevron-forward-sharp"></ion-icon>
                                                    </div>
                                                </button>
                                                </c:forEach>
                                                <button class="btn p-4 ps-3 border text-start position-relative" type="button" <c:if test="${requestScope.deviceList.isEmpty()}">disabled="true"</c:if> onclick="openPhrase(1)">
                                                    <h6 class="fw-bold text-danger m-0">Select devices to log out</h6>
                                                </button>
                                            </div>
                                        </div>
                                    </div>    
                                </div>
                                <div class="phrase">
                                    <h5 class="fw-bold pt-3">Log out on devices</h5>  
                                    <p>You will be logged out of your account on all selected devices.
                                        We'll help you secure your account in case you see a login you don't recognize.</p>
                                <div class="row gy-3">
                                        <div class="col-12 d-flex justify-content-end">
                                            <button class="btn fw-bold text-primary" onclick="selectAll()" type="button">Select all</button>
                                        </div>
                                        <div class="col-12">
                                            <div class="btn-group-vertical w-100" role="group">
                                                <c:set var="deviceCount" value="0"></c:set>
                                                <c:forEach items="${requestScope.deviceList}" var="device">
                                                <div class="btn border text-start position-relative p-0" type="button">
                                                    <div class="position-absolute end-0 top-0 p-3" style="transform: translateY(25%)">
                                                        <input class="form-check-input" type="checkbox" name="device" value="${device.ip}" id="device-${deviceCount}" required>
                                                    </div>
                                                    <label class="form-check-label p-3 w-100" for="device-${deviceCount}">
                                                       <h6 class="fw-bold">${device.os} | ${device.browser  }</h6>
                                                        <p class="m-0 fw-bold text-secondary">${device.getLastedActivity()}</p>
                                                    </label>
                                                </div>
                                                    <c:set var="deviceCount" value="${deviceCount + 1}"></c:set>
                                                </c:forEach>
                                            </div>
                                        </div>
                                    </div> 
                                    
                                </div>
                                <div class="phrase">
                                    <h5 class="fw-bold pt-3">Log out from device</h5>  
                                    <p>You will be logged out of your account on all selected devices.
                                        We'll help you secure your account in case you see a login you don't recognize.</p>
                                     <c:set var="deviceCount" value="0"></c:set>
                                     <c:forEach items="${requestScope.deviceList}" var="device">
                                    <div class="device" id="count-${deviceCount}">
                                        <div class="card m-0">
                                            <div class="card-body">
                                                <h6 class="fw-bold">${device.os} | ${device.browser}</h6>
                                                <span class="fw-bold text-secondary">${device.getLastedActivity()}</span> 
                                                <button class="btn p-3 text-center fw-bold rounded mt-3 w-100 border " data-bs-toggle="modal" data-bs-target="#confirmee"
                                                        onclick="setUp('${device.ip}')" type="button">Log out</button>
                                            </div>
                                        </div>
                                        
                                    </div>
                                      <c:set var="deviceCount" value="${deviceCount + 1}"></c:set>
                                     </c:forEach>
                                    
                                </div>
                                <div class="position-absolute bottom-0 start-0 w-100 p-3 d-none" style="background-color: white; z-index: 11;" id="log-out-btn">
                                        <button class="w-100 btn btn-primary fw-bold p-3" data-bs-toggle="modal" data-bs-target="#confirmee" onclick="setUpDevices()">
                                            Log out
                                        </button>
                                    </div>
                            </div>
                        </div>
                    </div>
                </div>
        <div class="container pt-5 pb-5">
            <div class="row">
                <div class="col-2 menu">
                    <h5 class="fw-bold">Account setting</h5>
                    <button class="btn d-block tab p-3 rounded-0 fw-bold w-100  text-start" type="button" onclick="show(0)">Profile</button>
                    <button class="btn d-block tab  p-3 rounded-0 fw-bold w-100 text-start" type="button" onclick="show(1)">Account security</button>
                    <button class="btn w-100 fw fw-bold rounded-0 text-start p-3 fw-bold  text-start" type="button" data-bs-toggle="modal" data-bs-target="#devices" onclick="openPhrase(0)">Devices</button>
                </div>
                <div class="col-10">
                    <div class="w-75">
                        <form action="account" method="post" enctype="multipart/form-data">
                            <div class="page">
                                <div class="row g-4">
                                    <h5 class="fw-bold">Basics</h5>
                                    <c:if test="${requestScope.pError != null}">
                                        <div class="alert alert-danger">
                                            ${requestScope.pError}
                                        </div>  
                                    </c:if>
                                    <c:if test="${requestScope.pDone != null}">
                                        <div class="alert alert-success">
                                            ${requestScope.pDone}
                                        </div>    
                                    </c:if>
                                    <div class=" form-container row">
                                        <div class="form-container row">  
                                            <div class="col-4">
                                                <h6 class="fw-bold">Picture</h6>
                                                <div class="ratio ratio-1x1 ">
                                                    <img class="w-100 rounde-2 rounded-1" src="${pageContext.request.contextPath}${requestScope.profile.picture}" alt="Avatar" class="avatar">
                                                </div>
                                                <div>
                                                    <input  class="d-none" name="profilePicture" id="file" type="file" accept="image/jpeg, image/png" required>
                                                    <label style="margin: 10px -2px -3px " class="btn btn-dark" for="file">Choose a picture</label><br>
                                                    <small class="form-text text-muted">Choose a JPEG or PNG (max 10MB)</small>

                                                </div>
                                            </div>
                                            <div class="form-fields col-8 ">
                                                <h6 class="fw-bold">Fullname:</h6>
                                                <input class="form-control mb-3 p-3" type="text" name="fullname" value="${requestScope.profile.name}">
                                                <h6 class="fw-bold">Headline:</h6>
                                                <input class="form-control mb-3 p-3" type="text" name="headline" value="${requestScope.profile.headline}" placeholder="University">
                                                <button class="btn btn-dark w-100 p-3 fw-bold" type="submit">Update</button>
                                            </div>

                                        </div>


                                    </div>
                                </div>
                            </div>
                        </form>
                        <input type="hidden" id="ip">
                        <form action="change-password" method="post">
                            <div class="page">
                                <h5 class="fw-bold">Login & recovery</h5>
                                <div class="row g-4">
                                    <div class="col-12">
                                        <h6 class="fw-bold">Your email: </h6>
                                        <input class="form-control p-3 mb-1" type="text" name="email" value="${sessionScope.user.email}" readonly>

                                        <p class="text-secondary">* Because of our <a href="" target="_blank">Terms of User</a>, you can change the email address on this time</p>
                                    </div>
                                    <div class="col-12">
                                        <h6 class="fw-bold">Password</h6>
                                        <c:if test="${requestScope.pwError != null}">
                                            <div class="alert alert-danger">
                                                ${requestScope.pwError}
                                            </div>     
                                        </c:if>
                                        <c:if test="${requestScope.pwDone != null}">
                                            <div class="alert alert-success">
                                                ${requestScope.pwDone}
                                            </div>   
                                        </c:if>
                                        <input class="form-control p-3 mb-3" type="password" name="currentPassword"
                                               minlength="6" maxlength="32" placeholder="Insert current password" required>
                                        <input class="form-control p-3 mb-3" type="password" name="password" 
                                               placeholder="Insert new password" id="password"
                                               minlength="6" maxlength="32" onkeyup="trigger();verify()" required>
                                        <div class="indicators mb-3">
                                            <div class="indicator"></div>
                                            <div class="indicator"></div>
                                            <div class="indicator"></div>
                                            <div class="indicator"></div>
                                        </div>
                                        <p id="text"></p>
                                        <input class="form-control p-3 mb-3" type="password"
                                               placeholder="Re-type new password" id="re-password"
                                               minlength="6" maxlength="32" onkeyup="verify()" required>
                                        <button class="btn btn-dark fw-bold p-3" type="submit" id="submit" disabled="true">Change password</button>
                                    </div>
                                </div>
                            </div>
                        </form> 
                    </div>
                </div>
            </div>
            <div class="modal" tabindex="-1" id="logout"
                 aria-hidden="true">
                <div class="modal-dialog modal-dialog-centered" style="width: 20rem;">
                    <div class="modal-content">
                        <div class="modal-body">
                            <h6>Sign out on <span id="os"></span></h6>
                            <p>This will remove access to your account from the device</p>
                            <button class="btn float-end" data-bs-dismiss="modal">Cancel</button>
                            <button class="btn text-danger float-end" onclick="remoteLogOut()">Log out</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <%@include file="elements/footer.jsp"%>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script type="module" src="https://unpkg.com/ionicons@7.1.0/dist/ionicons/ionicons.esm.js"></script>
    <script nomodule src="https://unpkg.com/ionicons@7.1.0/dist/ionicons/ionicons.js"></script>
    <script>
                                var tabs = document.getElementsByClassName("tab");
                                var pages = document.getElementsByClassName("page");
                                function show(e) {
                                    for (let i = 0; i < pages.length; i++) {
                                        if (i !== e) {
                                            tabs[i].style.borderLeft = "unset";
                                            pages[i].style.display = "none";
                                        } else {
                                            tabs[i].style.borderLeft = "3px solid black";
                                            pages[i].style.display = "block";
                                        }
                                    }
                                }
                                show(0);
        <c:if test="${requestScope.pwError != null
                      || requestScope.pwDone  != null}">
                                show(1);
        </c:if>

                                
                                function setUp(e) {
                                    document.getElementById('confirmee-btn').onclick = () => {
                                        remoteLogOut(e);
                                    };
                                }
                                
                                function setUpDevices() {
                                     document.getElementById('confirmee-btn').onclick = () => {
                                        remoteLogOutDevices();
                                    };
                                }
                                
                                function remoteLogOut(ip) {
                                    const xhttp = new XMLHttpRequest();
                                    xhttp.onreadystatechange = function () {
                                        if (this.readyState === 4 && this.status === 200) {
                                            window.location.reload();
                                        }
                                    };
                                    var data = JSON.stringify({
                                        ip: ip
                                    });
                                    xhttp.open("POST", "log-out", true); // Corrected line
                                    xhttp.setRequestHeader("Content-Type", "application/json"); // Add this line to set the content type
                                    xhttp.send(data);
                                }
                                
                                function remoteLogOutDevices() {
                                    const xhttp = new XMLHttpRequest();
                                    xhttp.onreadystatechange = function () {
                                        if (this.readyState === 4 && this.status === 200) {
                                            window.location.reload();
                                        }
                                    };
                                    var arr = document.querySelectorAll('input[name="device"]');
                                    var ip = '';
                                    for (let i = 0; i < arr.length; i++) {
                                        if (i < arr.length - 1) {
                                            ip += arr[i].value + "/";
                                        } else {
                                            ip += arr[i].value;
                                        }
                                    }
                                    var data = JSON.stringify({
                                        ip: ip
                                    });
                                    xhttp.open("POST", "log-out", true); // Corrected line
                                    xhttp.setRequestHeader("Content-Type", "application/json"); // Add this line to set the content type
                                    xhttp.send(data);
                                }
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
                                
        const phrase = document.getElementsByClassName('phrase');
        const logOutBtn = document.getElementById('log-out-btn');
        const returnBtn = document.getElementById('return-btn');
        function openPhrase(e) {
            if (e == 0) {
                returnBtn.classList.add('d-none');
            } if (e == 1) {
                if (logOutBtn.classList.contains('d-none')) {
                    logOutBtn.classList.remove('d-none');
                }
                returnBtn.classList.remove('d-none');
            } else {
                if (returnBtn.classList.contains('d-none')) {
                    returnBtn.classList.remove('d-none');
                }
                if (!logOutBtn.classList.contains('d-none')) {
                    logOutBtn.classList.add('d-none');
                }
            }
            for (let i = 0; i < phrase.length; i++) {
                if (i != e) {
                    if (!phrase[i].classList.contains('d-none')) {
                        phrase[i].classList.add('d-none');
                    }
                } else {
                   if (phrase[i].classList.contains('d-none')) {
                        phrase[i].classList.remove('d-none');
                    } 
                }
            }
        }
        
        function selectAll() {
            document.querySelectorAll('input[name="device"]').forEach(device => {
               device.checked = true; 
            });
        }
        
        function openDevice(e) {
            document.querySelectorAll(".device").forEach(device => {
               if (!device.classList.contains('d-none')) {
                   device.classList.add('d-none');
               } 
            });
            document.getElementsByClassName('device')[e].classList.remove('d-none');
        }
        
    </script>
</body>
</html>