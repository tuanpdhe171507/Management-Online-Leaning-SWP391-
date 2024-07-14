<%-- 
    Document   : create_course
    Created on : May 26, 2024, 5:56:56 AM
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
            <div class="row pt-5">
                <form action="create" method="post" id="form">
                    <div class="page">
                        <div class="col-12 mb-5">
                            <div class="w-50 text-center" style="margin: 0 auto;">
                                <h4>How about a working title?</h4>
                                <p>It's ok if you can not think of a good title now
                                    You can change it later.</p>
                                <input class="form-control" type="text" name="name" id="title"
                                       placeholder="eg. Learn Python"/>
                            </div>
                        </div>
                    </div>
                    <div class="page">
                        <div class="col-12 mb-5">
                            <div class="w-50 text-center" style="margin: 0 auto;">
                                <h4>What category best fits the knowledge you'll share?</h4>
                                <p>It's ok if you can not think of a good title now
                                    You can change it later.</p>
                                <select class="form-select mt-3 p-2" name="category" required>
                                    <c:forEach items="${requestScope.categoryList}" var="category">
                                        <option value="${category.id}">${category.name}</option>
                                    </c:forEach>
                                </select>
                            </div>
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
                        if (currentPage === pages.length - 1) {
                            document.getElementById("form").submit();
                        }
                        if (currentPage < pages.length - 1) {
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

