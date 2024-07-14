<%-- 
    Document   : course-review
    Created on : Jul 5, 2024, 9:12:43 AM
    Author     : Trongnd
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Course Review</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
        <style>

            .table th {
                background-color: #343a40;
                color: #ffffff;
            }
            html, body {
                height: 100%;
                margin: 0;
            }
        </style>
    </head>
    <body>
        <%@include file="../elements/navbar.jsp"%>
        <div class="container mt-5" style="min-width: 500px">
            <div class="card shadow-sm">
                <div class="card-header mb-3"><h2 class="">Course Review</h2></div>
                <div class="card-body">
                    <div class="row mb-3">
                        <div class="col-md-10 d-flex">
                            <form class="d-flex" method="Post" action="course-review" id="filter-form">
                                <select id="categoryFilter" class="form-select me-2" name="category" onchange="filterTable()" >
                                    <option value="">All Category</option>
                                    <c:forEach items="${requestScope.category}" var="ca">
                                        <c:if test="${requestScope.categorySelected eq ca.name }">
                                            <option value="${ca.name}" selected="">${ca.name}</option>
                                        </c:if>                                
                                        <c:if test="${requestScope.categorySelected ne ca.name }">
                                            <option value="${ca.name}">${ca.name}</option>
                                        </c:if> 
                                    </c:forEach> 
                                </select>
                                <input class="form-control me-2" style="min-width: 250px" type="search" placeholder="Enter keyword to search" value="${requestScope.key}" aria-label="Search" id="input-search" name="key">
                                <button class="btn btn-outline-success" type="submit" id="search">Search</button>
                            </form>
                        </div>
                        <div class="col-md-2">
                            <select id="sortOrder" class="form-select" onchange="sortTable(this.value)">
                                <option value="newest">Newest</option>
                                <option value="oldest">Oldest</option>
                            </select>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col">
                            <table class="table table-bordered table-hover w-100" id="table">
                                <thead>
                                    <tr>
                                        <th>#</th>
                                        <th>Course</th>
                                        <th>Category</th>
                                        <th>Instructor</th>
                                        <th>Email</th>
                                        <th>Price</th>
                                        <th>Submission Time</th>
                                        <th>Action</th>
                                    </tr>
                                </thead>
                                <tbody id="courseTable">
                                    <c:forEach items="${requestScope.listCourse}" var="list" varStatus="loop">
                                        <tr id="${list.id}">
                                            <td class="index">${loop.index + 1}</td>
                                            <td class="d-flex align-items-center"><img class="mt-2 mb-2 me-2"
                                                                                       src="${list.course.thumbnail}" alt=""
                                                                                       style="max-width:50px">${list.course.name}</td>                                            
                                            <td>${list.course.category.name}</td>
                                            <td>${list.course.instructor.profile.name}</td>
                                            <td>${list.course.instructor.email}</td>
                                            <c:if test="${list.course.price == 0}">
                                                <td>Free</td>
                                            </c:if>
                                                <c:if test="${list.course.price != 0}">
                                                <td>${list.course.price}</td>
                                            </c:if>
                                            
                                            <td>${list.submitedTime}</td>
                                            <td class="d-flex align-items-start justify-content-center">
                                                <button class="btn btn-dark btn-sm me-1">View</button>
                                                <form action="course-review" method="post">
                                                    <input type="hidden" value="${list.course.instructor.email}" name="email">
                                                    <input type="hidden" value="${list.course.id}" name="courseId">
                                                    <input type="hidden" value="accept" name="action">
                                                    <button class="btn btn-outline-success btn-sm me-1" type="submit">Accept</button>
                                                </form>
                                                <button class="btn btn-outline-danger btn-sm reject" type="button"data-bs-toggle="modal" data-bs-target="#mes-reject" data-id="${list.course.id}">Reject</button>                                          
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
                    <div class="modal fade" id="mes-reject" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
                        <div class="modal-dialog modal-dialog-centered">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <h1 class="modal-title fs-5" id="exampleModalLabel">Reason for Course Rejection</h1>
                                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                </div>
                                <form action="course-review" method="post">
                                    <div class="modal-body">
                                        <input type="hidden" value="" name="courseId" id="input-courseId">   
                                        <input type="hidden" value="reject" name="action">
                                        <div class="form-check">
                                            <input class="form-check-input" type="checkbox" value="The course is not properly structured, lacks clear learning information, and has no learning details." 
                                                   id="flexCheckChecked" name="reason">
                                            <label class="form-check-label" for="flexCheckChecked">
                                                The course is not properly structured, lacks clear learning information, and has no learning details.
                                            </label>
                                        </div>
                                        <br><!-- comment -->
                                        <div class="form-check">
                                            <input class="form-check-input" type="checkbox" value="The content is not attractive enough or does not meet quality standards." 
                                                   id="flexCheckChecked" name="reason">
                                            <label class="form-check-label" for="flexCheckChecked">
                                                The content is not attractive enough or does not meet quality standards.
                                            </label>
                                        </div>
                                        <br><!-- comment -->
                                        <div class="form-check">
                                            <input class="form-check-input" type="checkbox" value="The course is not detailed enough or lacks depth in terms of specialized knowledge." 
                                                   id="flexCheckChecked" name="reason">
                                            <label class="form-check-label" for="flexCheckChecked">
                                                The course is not detailed enough or lacks depth in terms of specialized knowledge.
                                            </label>
                                        </div>
                                        <br><!-- comment -->
                                        <div class="form-check">
                                            <input class="form-check-input" type="checkbox" value="Course content violates copyright or does not have a valid license for use." 
                                                   id="flexCheckChecked" name="reason">
                                            <label class="form-check-label" for="flexCheckChecked">
                                                Course content violates copyright or does not have a valid license for use.
                                            </label>
                                        </div>
                                        <br><!-- comment -->
                                        
                                            <label for="floatingTextarea">Other</label>
                                            <textarea class="form-control" placeholder="Specify other reasons here..." name="reason"></textarea>                                            
                                        

                                    </div>
                                    <div class="modal-footer">
                                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                                        <button type="submit" class="btn btn-primary">Reject</button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
            </div>


        </div>
        <%@include file="../elements/footer.jsp"%>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script type="module" src="https://unpkg.com/ionicons@7.1.0/dist/ionicons/ionicons.esm.js"></script>
        <script nomodule src="https://unpkg.com/ionicons@7.1.0/dist/ionicons/ionicons.js"></script>
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
        <script>
            function moveRowToTop(row) {
            var table = document.getElementById('table');
            var tbody = table.getElementsByTagName('tbody')[0];
            row.classList.add('table-success');
            tbody.insertBefore(row, tbody.rows[0]);
        }
//        moveRowToTop(document.getElementById('3'));
                                const buttons = document.getElementsByClassName('reject');
                                for (const button of buttons) {
                                    button.addEventListener('click', function () {
                                        const id = this.getAttribute('data-id');
                                        document.getElementById('input-courseId').value = id;
                                    });
                                }


                                function filterTable() {
                                    const filter = document.getElementById('categoryFilter').value.toLowerCase();
                                    const rows = document.getElementById('courseTable').getElementsByTagName('tr');

                                    for (let i = 0; i < rows.length; i++) {
                                        const category = rows[i].getElementsByTagName('td')[2].textContent.toLowerCase();
                                        if (filter === "" || category === filter) {
                                            rows[i].style.display = "";
                                        } else {
                                            rows[i].style.display = "none";
                                        }
                                    }
                                    document.getElementById('filter-form').submit();
                                }

                                function sortTable(order) {                                    
                                    const rows = Array.from(document.getElementById('courseTable').getElementsByTagName('tr'));
                                    rows.sort((a, b) => {
                                        const dateA = new Date(a.getElementsByTagName('td')[6].textContent);
                                        const dateB = new Date(b.getElementsByTagName('td')[6].textContent);
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
                                    const rowPerPage = 10;
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
