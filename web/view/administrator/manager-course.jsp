<%-- 
    Document   : manager-course
    Created on : Jul 2, 2024, 4:19:16 PM
    Author     : TuanPD
--%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
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

            .table .course-info img {
                width: 100px;
                height: 50px;
                margin-right: 10px;
            }
            #report-cart {
                display: none; /* Ẩn cart ban đầu */
                position: absolute;
                right: 10px;
                top: 50px;
                width: 300px;
                background-color: white;
                border: 1px solid #ccc;
                box-shadow: 0 2px 5px rgba(0,0,0,0.15);
                padding: 10px;
                z-index: 1000;
            }

            #report-count {
                display: none; /* Ẩn số thông báo ban đầu */
                position: absolute;
                top: -5px;
                right: -10px;
                background-color: red;
                color: white;
                border-radius: 50%;
                padding: 2px 6px;
                font-size: 12px;
            }


            .highlighted-row {
                font-weight: bold;
                background-color: lightgreen !important;
            }
        </style>
    </head>
    <body>
        <%@include file="../elements/navbar.jsp"%>

        <div class="container mt-3">
            <div>
                <h3 style="text-align: center">Manager Course</h3>
            </div>
            <form id="search-form" action="manager-course" method="GET">
                <div style="display: flex;align-items: center;margin-bottom: 10px;background-color: grey;height: 40px">

                    <div>
                        Search: <input id="search-input" class="rounded-2" type="text" name="key" value="${key}" placeholder="Enter key" />
                    </div>
                    <div style="margin-left: 10px;">Report by date:</div>
                    <div>
                        <select id="sort-select" name="sort" class="form-select rounded-2 custom-select" style="width: 150px; height: 30px" onchange="submitSortForm()">
                            <option value="" selected disabled>Sort by</option>
                            <option value="newest" <c:if test="${param.sort == 'newest'}">selected="selected"</c:if>>Newest</option>
                            <option value="oldest" <c:if test="${param.sort == 'oldest'}">selected="selected"</c:if>>Oldest</option>
                            </select>
                        </div>

                        <div style="margin-left: auto; position: relative;">
                            <i class="bi bi-bell" onclick="toggleReportCart()" style="cursor: pointer; font-size: 24px;margin-right: 10px"></i>
                            <span id="report-count" style="display: none; position: absolute; top: -5px; right: -10px; background-color: red; color: white; border-radius: 50%; padding: 2px 6px; font-size: 12px;"></span>
                            <div id="report-cart" style="display: none; position: absolute; right: 10px; top: 50px; width: 400px; background-color: white; border: 1px solid #ccc; box-shadow: 0 2px 5px rgba(0,0,0,0.15); padding: 10px; z-index: 1000; max-height: 400px ;overflow-y: auto;">
                                <h3>Report Information</h3>
                                <p>Here are the details of the report...</p>
                                <table>
                                <c:forEach items="${requestScope.listMess}" var="a">
                                    <tr style="border-bottom: 1px solid #ccc;">
                                        <td>
                                            <img style="width: 30px;height: 30px" src="${a.profile.picture}"/>
                                        </td>
                                        <td>
                                            <span style="font-size: 15px;font-weight: bold">${a.profile.name}</span><br>
                                            <span style="font-size: 13px; cursor: pointer;" onclick="highlightReportedCourse('${a.course.name}')">Reported: ${a.course.name}</span><br>
                                            <span style="font-size: 13px;">Of: ${a.course.instructor.profile.name}</span></br>
                                            <span style="font-size: 13px; cursor: pointer; text-decoration: underline;" onclick="showReportDetails('${a.report.reportName}', '${a.report.reportType.typeName}')">Content report ...</span>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </table>
                        </div>
                        <div id="report-details" style="display: none; position: absolute; right: 420px; top: 50px; width: 300px; background-color: white; border: 1px solid #ccc; box-shadow: 0 2px 5px rgba(0,0,0,0.15); padding: 10px; z-index: 1000;">
                            <h3>Report Content</h3>
                            <p id="report-details-content">Report details will be shown here...</p>
                        </div>
                    </div>
                </div>
            </form>

            <table class="table table-striped table-hover" id="userTable">
                <thead>
                    <tr>
                        <th>Course</th>
                        <th>Price</th>
                        <th>Time Send</th>
                        <th>Instructor</th>
                        <th>Status</th>
                        <th>Change status</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${requestScope.listCourseReport}" var="i">
                        <tr>
                            <td>
                                <div class="course-info">
                                    <img src="${i.course.thumbnail}" alt="Course Thumbnail" />
                                    <span>${i.course.name}</span>
                                </div>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${i.course.price > 0}">
                                        ${i.course.price}$
                                    </c:when>
                                    <c:otherwise>
                                        Free
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>${i.sentTime}</td>
                            <td>${i.course.instructor.profile.name}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${i.course.visibility == 0}">
                                        <span style="color:red">Inactive</span> 
                                    </c:when>
                                    <c:when test="${i.course.visibility == 1}">
                                        <span style="color:green">Active</span> 
                                    </c:when>

                                </c:choose>
                            </td>        
                            <td>
                                <form action="manager-course" method="post">
                                    <input type="hidden" name="courseId" value="${i.course.id}" />
                                    <input type="hidden" name="emailinstructor" value="${i.course.instructor.email}" />

                                    <input type="hidden" name="currentVisibility" value="${i.course.visibility}" />
                                    <button type="submit" name="action" value="changeVisibility" style="background: none; border: 2px solid #a9a9a9" class="rounded-2" >Change</button>
                                </form>
                            </td>
                            <!--                            <td>
                                                                                            <i class="bi bi-trash3"></i>
                                                        </td>-->
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
            function highlightReportedCourse(courseName) {
                const tableRows = document.querySelectorAll('.table tbody tr');
                let selectedRow = null;

                tableRows.forEach(row => {
                    const courseNameCell = row.querySelector('td .course-info span');
                    if (courseNameCell) {
                        row.classList.remove('highlighted-row'); // Remove highlight from all rows
                    }
                    if (courseNameCell && courseNameCell.innerText.trim().toLowerCase() === courseName.trim().toLowerCase()) {
                        row.classList.add('highlighted-row');
                        row.parentNode.prepend(row);
                        selectedRow = row;
                    }
                });

                if (selectedRow) {
                    selectedRow.scrollIntoView({behavior: 'smooth', block: 'start'});
                }
            }
            function submitSortForm() {
                // Get the form and sort select elements
                const form = document.getElementById('search-form');
                const sortSelect = document.getElementById('sort-select');

                // Remove sort parameter if no option is selected
                if (!sortSelect.value) {
                    sortSelect.removeAttribute('name');
                }

                // Submit the form
                form.submit();
            }


            var newReportsCount = ${sessionScope.newReports};

            function updateReportCount() {
                var reportCountElement = document.getElementById('report-count');
                if (newReportsCount > 0) {
                    reportCountElement.innerText = newReportsCount;
                    reportCountElement.style.display = 'block';
                } else {
                    reportCountElement.style.display = 'none';
                }
            }

            function toggleReportCart() {
                var cart = document.getElementById('report-cart');
                var reportDetails = document.getElementById('report-details');

                if (cart.style.display === 'none' || cart.style.display === '') {
                    cart.style.display = 'block';
                    reportDetails.style.display = 'none';
                    newReportsCount = 0;
                } else {
                    cart.style.display = 'none';
                    reportDetails.style.display = 'none';
                }

                var reportCountElement = document.getElementById('report-count');
                reportCountElement.style.display = 'none';
            }

            function showReportDetails(reportId, type) {
                const reportDetails = getReportDetails(reportId, type);

                const reportDetailsCard = document.getElementById('report-details');
                const reportDetailsContent = document.getElementById('report-details-content');

                const formattedReportDetails = reportDetails.split('.').join('<br>');

                reportDetailsContent.innerHTML = formattedReportDetails;
                reportDetailsCard.style.display = 'block';
            }

            function getReportDetails(reportId, type) {
                return "Report: " + reportId + ".Report Type: " + type;
            }

            updateReportCount();
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

