<%-- 
    Document   : discount-event
    Created on : Jun 29, 2024, 3:45:56 PM
    Author     : HuyLQ;
--%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>

    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>EduPort</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
        <style>
            .table th {
                background-color: #343a40;
                color: #ffffff;
            }

            html,
            body {
                height: 100%;
                margin: 0;
            }
        </style>
    </head>

    <body>
        <%@include file="../elements/navbar.jsp" %>
        <div class="modal fade" id="exampleModal" tabindex="-1" aria-labelledby="exampleModalLabel"
             aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h1 class="modal-title fs-5" id="exampleModalLabel">Join Event</h1>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"
                                aria-label="Close"></button>
                    </div>

                    <div class="modal-body">

                        <table class="table table-bordered table-hover w-100">
                            <c:forEach items="${requestScope.courseList}" var="course" >
                                <tr>
                                    <td>tickbox</td>
                                    <td>${course.name}</td>
                                    <td>img course</td>
                                    <td>${course.price}</td>
                                </tr>
                            </c:forEach>
                        </table>

                    </div>
                    <div class="modal-footer">
                        <button type="button" class="rounded btn btn-light"
                                data-bs-dismiss="modal">Close</button>
                        <button type="submit" class="rounded btn btn-primary">Save changes</button>
                    </div>
                </div>
            </div>
        </div>
        <div class="container mt-5 mb-5" style="height: 70%">
            <div class="card shadow-sm">
                <div class="card-header mb-3">
                    <h2 class="">Register Event</h2>
                </div>
                <div class="card-body">
                    <div class="row ">

                    </div>
                    <div class="row ">
                        <div class="col">
                            <table class="table table-bordered table-hover w-100" id="table">
                                <thead>
                                    <tr>
                                        <th>#</th>
                                        <th class="text-center">Title</th>
                                        <th class="text-center">Discount</th>
                                        <th class="text-center">Time Start</th>
                                        <th class="text-center">Time End</th>
                                        <th class="text-center">Courses Attended</th>
                                        <th class="text-center">Operation</th>

                                    </tr>
                                </thead>
                                <tbody id="courseTable">
                                    <c:forEach items="${requestScope.listEvent}" var="events" varStatus="loop">
                                        <tr>
                                            <td class="index">${loop.index + 1}</td>
                                            <td class="text-center">${events.event}</td>
                                            <td class="text-center"> <span class=" text-white bg-danger px-3 rounded">${events.discount}%</span></td>
                                            <td class="text-center">${events.startDate}</td>
                                            <td class="text-center">${events.endDate}</td>
                                            <td class="px-4 py-3 text-center">
                                                <label for="view" class="btn btn-dark rounded"> View</label>
                                                <button id="view" style="visibility: hidden"
                                                        data-bs-toggle="dropdown" aria-expanded="false">
                                                </button>
                                                <div class="w-100 dropdown-menu p-3 ms-1" style="font-size: unset;">
                                                   aaa
                                                </div>
                                            </td>
                                            <td class="px-3 py-3 text-center">
                                                <button type="button" class="rounded btn  btn-primary"
                                                        data-bs-toggle="modal" data-bs-target="#exampleModal">
                                                    Join
                                                </button>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                            <div class="d-flex justify-content-center align-items-center mt-3">
                                <div class="pagination" id="pagination"></div>
                            </div>

                        </div>
                    </div>

                </div>
            </div>

        </div>
        <%@include file="../elements/footer.jsp" %>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script type="module" src="https://unpkg.com/ionicons@7.1.0/dist/ionicons/ionicons.esm.js"></script>
        <script nomodule src="https://unpkg.com/ionicons@7.1.0/dist/ionicons/ionicons.js"></script>
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
        <script>
            function sortTable(order) {
                console.log("aaa");
                const rows = Array.from(document.getElementById('courseTable').getElementsByTagName('tr'));
                rows.sort((a, b) => {
                    const dateA = new Date(a.getElementsByTagName('td')[5].textContent);
                    const dateB = new Date(b.getElementsByTagName('td')[5].textContent);
                    return order === 'newest' ? dateB - dateA : dateA - dateB;
                });

                const tableBody = document.getElementById('courseTable');
                tableBody.innerHTML = '';
                rows.forEach((row, index) => {
                    row.getElementsByTagName('td')[0].textContent = index + 1; // Update the # column
                    tableBody.appendChild(row);
                });
            }

            document.addEventListener('DOMContentLoaded', () => {
                sortTable('newest'); // Default sort order

                // pagination
                const table = document.getElementById('table');
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
    </body>

</html>