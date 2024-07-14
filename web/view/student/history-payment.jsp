<%-- 
    Document   : manager-course
    Created on : Jul 2, 2024, 4:19:16 PM
    Author     : TuanPD
--%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
        <title>EduPort</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
        <link href="view/assets/css/base.css" rel="stylesheet"/>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
        <style>
            .table th {
                font-weight: bold;
                text-align: center;
            }

            .table td, .table th {
                padding: 15px;
                border: 1px solid #dee2e6;
            }

            .table-hover tbody tr:hover {
                background-color: #f5f5f5;
            }

            .table-striped tbody tr:nth-of-type(odd) {
                background-color: #f9f9f9;
            }

            .table form {
                margin: 0;
            }

            .table button {
                margin-top: 5px;
            }
            .table .course-info {
                display: flex;
                align-items: center;
            }

            .form-container {
                display: flex;
                align-items: center;
                margin-bottom: 10px;
                height: 70px;
                gap: 15px;
            }

            .form-group {
                display: flex;
                flex-direction: column;
                margin-right: 15px;
            }

            .form-group label {
                margin-bottom: 5px;
            }

            .form-select,
            .form-input {
                width: 250px;
                height: 30px;
                padding: 5px;
                border: 1px solid #ced4da;
                border-radius: 4px;
            }

            .form-select.custom-select {
                width: 150px;
            }

            .btn-search {
                background-color: gainsboro;
                width: 50px;
                height: 30px;
                display: flex;
                align-items: center;
                justify-content: center;
                border: none;
                border-radius: 4px;
                cursor: pointer;
            }

            #search-container {
                display: none;
                margin-left: 10px;
            }

            #search-input {
                width: 200px;
            }
        </style>
    </head>
    <body>
        <%@include file="../elements/navbar.jsp"%>
        <div class="container mt-3">
            <div>
                <h3 style="color: red">Bill Payment</h3>
                <h5 style="font-weight: normal; color: #a0a0a0;">Payment History</h5>
            </div>
            <form id="search-form" action="payment-history" method="GET">
                <div class="form-container">
                    <div class="form-group">
                        <label for="service-category">Service Category</label>
                        <select id="service-category" style="width: 250px" name="serviceCategory" class="form-select custom-select" onchange="submitSearchForm()">
                            <option value="all">All</option>
                            <c:forEach items="${requestScope.listCategorys}" var="i">
                                <option 
                                    <c:if test="${i.id eq param.serviceCategory}">
                                        selected="selected"
                                    </c:if>
                                    value="${i.id}">${i.name}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="from-date">From Date</label>
                        <input style="width: 150px" type="date" id="from-date" name="fromdate" class="form-input"/>
                    </div>
                    <div class="form-group">
                        <label for="to-date">To Date</label>
                        <input style="width: 150px" type="date" id="to-date" name="todate" class="form-input"/>
                    </div>
                    <div class="form-group">
                        <label for="sort-select">Sort by date:</label>
                        <select id="sort-select" name="sort" class="form-select custom-select" onchange="submitSearchForm()">
                            <option value="" selected disabled>Sort by</option>
                            <option value="newest" ${param.sort == 'newest' ? 'selected' : ''}>Newest</option>
                            <option value="oldest" ${param.sort == 'oldest' ? 'selected' : ''}>Oldest</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <button id="toggle-button" type="button" class="btn-search rounded-2">
                            <i class="bi bi-search-heart-fill"></i>
                        </button>
                        <div id="search-container" style="margin-left:0px">
                            <input id="search-input" type="text" name="key" placeholder="Enter key" class="form-input"/>
                        </div>
                    </div>
                </div>
            </form>

            <c:set var="conversionRate" value="25417" />
            <table class="table table-striped table-hover" id="userTable">
                <thead>
                    <tr>
                        <th>Course</th>
                        <th>Price</th>
                        <th>Payment time</th>
                        <th>Instructor</th>
                        <th>Category</th>
                        <th>Status</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${requestScope.listAccessibleCourses}" var="i">
                        <tr>
                            <td>
                                <div class="course-info">
                                    <img style="width: 100px;height: 60px;margin-right: 5px" src="${i.course.thumbnail}" alt="Course Thumbnail" />
                                    <span>${i.course.name}</span>
                                </div>
                            </td>
                            <td>
                                <fmt:formatNumber value="${i.course.price * conversionRate}" pattern="###,### VND"/>
                            </td>
                            <td>${i.date}</td>
                            <td>${i.course.instructor.profile.name}</td>
                            <td>${i.course.category.name}</td>
                            <c:if test="${i.hiddenState == 0}">
                                <td style="color: green">Payment success</td>
                            </c:if>
                            <td>
                                <form action="payment-history" method="post">
                                    <input type="hidden" name="currentStatus" value="${i.hiddenState}" />
                                    <input type="hidden" name="courseId" value="${i.course.id}" />
                                    <button type="submit" name="action" value="changeStatus" style="border: none;background: none"><i class="bi bi-trash3"></i></button>
                                </form>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
            <div class="d-flex justify-content-center align-items-center mt-3 ">
                <div class="pagination" id="pagination"></div>
            </div>
        </div>
        <%@include file="../elements/footer.jsp"%>

        <script>
            document.getElementById('toggle-button').addEventListener('click', function (event) {
                event.preventDefault(); // Prevent the default button behavior
                var searchContainer = document.getElementById('search-container');
                if (searchContainer.style.display === 'none' || searchContainer.style.display === '') {
                    searchContainer.style.display = 'block';
                } else {
                    searchContainer.style.display = 'none';
                }
            });

            function submitSearchForm() {
                document.getElementById('search-form').submit();
            }
        </script>

        <script>
            document.addEventListener('DOMContentLoaded', () => {
                // pagination
                const table = document.getElementById('userTable');
                const pagination = document.getElementById('pagination');
                const rows = table.getElementsByTagName('tbody')[0].getElementsByTagName('tr');
                const rowPerPage = 5;
                const rowCount = rows.length;
                const pageCount = Math.ceil(rowCount / rowPerPage);
                let currentPage = 1;

                function displayPage(e) {
                    const start = (e - 1) * rowPerPage;
                    const end = start + rowPerPage;

                    for (let i = 0; i < rowCount; i++) {
                        if (i >= start && i < end) {
                            rows[i].style.display = '';
                        } else {
                            rows[i].style.display = 'none';
                        }
                    }
                    Array.from(pagination.children).forEach(button => {
                        button.classList.remove('active');
                    });
                    pagination.children[e - 1].classList.add('active');
                }
                function createPagination() {
                    for (let i = 1; i <= pageCount; i++) {
                        const button = document.createElement('button');
                        button.innerText = i;
                        button.classList.add('btn', 'btn-outline-primary', 'me-1');

                        button.addEventListener('click', function () {
                            currentPage = i;
                            displayPage(currentPage);
                        });
                        if (i === currentPage) {
                            button.classList.add('active');
                        }

                        pagination.appendChild(button);
                    }
                }
                createPagination();
                displayPage(currentPage);
            });
        </script>
        <script src="https://unpkg.com/ionicons@5.5.2/dist/ionicons/ionicons.js"></script>
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script type="module" src="https://unpkg.com/ionicons@7.1.0/dist/ionicons/ionicons.esm.js"></script>
        <script nomodule src="https://unpkg.com/ionicons@7.1.0/dist/ionicons/ionicons.js"></script>
    </body>
</html>