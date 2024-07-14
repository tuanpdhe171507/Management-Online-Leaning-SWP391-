<%-- 
    Document   : register
    Created on : May 24, 2024, 10:41:57 PM
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
        <link href="../view/assets/css/base.css" rel="stylesheet"/>
    </head>
    <body>
        <%@include file="../elements/navbar.jsp"%>
        <div class="container pt-5 pe-5">
            <div class="row">
                <form action="register" method="post" id="form">
                <div class="page">
                    <div class="col-12 mb-5">
                        <div class="w-50">
                            <h4>Share your knowledge</h4>
                            <p>Whether you have experience teaching, or it's your first time,
                                we'll help you package your knowledge into an online course that improves student live.</p>
                        </div>
                    </div>
                    <div class="col-5">
                        <h6>What kind of teaching have you done before ?</h6>
                        <div class="border p-2 mb-3">
                            <div class="form-check" style="transform: translateY(10%);">
                                <input class="form-check-input rounded-5" type="radio" name="experience" value="1" id="experience_1">
                                <label class="form-check-lable" for="experience_1">
                                    In personal, informally
                                </label>
                            </div>
                        </div>
                        <div class="border p-2 mb-3">
                            <div class="form-check" style="transform: translateY(10%);">
                                <input class="form-check-input rounded-5" type="radio" name="experience" value="2" id="experience_1">
                                <label class="form-check-lable" for="experience_2">
                                    In personal, professionally
                                </label>
                            </div>
                        </div>
                        <div class="border p-2 mb-3">
                            <div class="form-check" style="transform: translateY(10%);">
                                <input class="form-check-input rounded-5" type="radio" name="experience" value="0" id="experience_3">
                                <label class="form-check-lable" for="experience_3">
                                    Other
                                </label>
                            </div>
                        </div>
                    </div>
                    <div class="col-5">

                    </div>
                </div>
                <div class="page">
                    <div class="col-12 mb-5">
                        <div class="w-50">
                            <h4>Expand your reach</h4>
                            <p>Once you publish your course, you can grow your student audience
                            and make an impact with the support of our marketplace promotions
                            and also through your own marketing efforts. Together,
                            we'll help the right student discover your course.</p>
                        </div>
                    </div>
                    <div class="col-5">
                        <h6>Do you have an audience to share your course with ?</h6>
                        <div class="border p-2 mb-3">
                            <div class="form-check" style="transform: translateY(10%);">
                                <input class="form-check-input rounded-5" type="radio" name="reach" value="0" id="reach_1">
                                <label class="form-check-lable" for="reach_1">
                                    Not at the moment
                                </label>
                            </div>
                        </div>
                        <div class="border p-2 mb-3">
                            <div class="form-check" style="transform: translateY(10%);">
                                <input class="form-check-input rounded-5" type="radio" name="reach" value="1" id="reach_2">
                                <label class="form-check-lable" for="reach_1">
                                    I have a small following
                                </label>
                            </div>
                        </div>
                        <div class="border p-2 mb-3">
                            <div class="form-check" style="transform: translateY(10%);">
                                <input class="form-check-input rounded-5" type="radio" name="reach" value="2" id="teaching_3">
                                <label class="form-check-lable" for="reach_3">
                                    I have a sizeable following
                                </label>
                            </div>
                        </div>
                    </div>
                    <div class="col-5">

                    </div>
                </div>
                </form>    
            </div> 
        </div>
        <div class="position-fixed bottom-0 w-100 border-top" style="background-color: white">
            <div class="container pt-3 pb-3 d-flex justify-content-between">
                <button class="btn btn-outline-secondary border" type="button" onclick="previousPage()" id="previous">Previous</button>
                <button class="btn btn-secondary" type="button" onclick="continuePage()" id="continue">Continue</button>
                
            </div>
        </div>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script type="module" src="https://unpkg.com/ionicons@7.1.0/dist/ionicons/ionicons.esm.js"></script>
        <script nomodule src="https://unpkg.com/ionicons@7.1.0/dist/ionicons/ionicons.js"></script>
        <script>
            var pages = document.getElementsByClassName("page");
            var currentPage = 0;
            
            var previousBtn = document.getElementById("previous");
            var continueBtn = document.getElementById("continue");
            
            function previousPage() {
                if (currentPage === 1) {
                    previousBtn.style.display = "none";
                }
                if (currentPage > 0) {
                    goToPage(-1);
                }
                
            }
            
            function continuePage() {
                if (currentPage === pages.length -1) {
                    document.getElementById("form").submit();
                }
                if (currentPage < pages.length -1) {
                    goToPage(1);
                    previousBtn.style.display = "block";
                }
            }
            
            function goToPage(e) {
                for (var i = 0; i < pages.length; i++) {
                    if (i === currentPage + e) {
                        pages[i].style.display = "block";
                    } else {
                        pages[i].style.display = "none";
                    }
                }
                currentPage += e;
            }
            
            goToPage(0);
            previousBtn.style.display = "none";
        </script>
    </body>
</html>

