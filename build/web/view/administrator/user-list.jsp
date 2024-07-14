<%-- 
    Document   : user-list
    Created on : Jul 5, 2024, 3:09:35 PM
    Author     : Trongnd
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>User List</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
        <style>
            th{
                cursor: pointer;
            }
            .table th {
                background-color: #343a40;
                color: #ffffff;
            }
            .fixed-width-column {
                width: 250px; /* Đặt chiều rộng cố định */
                word-wrap: break-word; /* Đảm bảo nội dung xuống dòng */
                white-space: normal; /* Cho phép xuống dòng */
            }
        </style>
    </head>
    <body>
        <%@include file="../elements/navbar.jsp"%>
        <div class="container mt-5 mb-5">
            <div class="card shadow-sm">
                <div class="card-header mb-3">
                    <h2>User List</h2>
                </div>
                <div class="card-body">
                    <form  method="Post" action="user-list" id="filter-form">
                        <input type="hidden" value="filter" name="action">
                        <div class="row mb-3">
                            <div class="col-md-5 d-flex">
                                <div class="me-1">
                                    <select id="filterGender" class="form-select" onchange="this.form.submit()" name="gender">
                                        <option value="" selected="">All Gender</option>
                                        <option value="1">Male</option>
                                        <option value="0">Female</option>
                                    </select>
                                </div>
                                <div class="me-1">
                                    <select id="filterRating" class="form-select" onchange="this.form.submit()" name="rating">
                                        <option value="">Rating</option>
                                        <option value="4.0">4.0+</option>
                                        <option value="4.5">4.5+</option>
                                        <option value="5.0">5.0</option>
                                    </select>
                                </div>
                                <div class="me-1">
                                    <select id="filterStatus" class="form-select" onchange="this.form.submit()" name="status">
                                        <option value="">All Status</option>
                                        <option value="0">Active</option>
                                        <option value="1">Inactive</option>
                                    </select>
                                </div>
                                <div class="me-1">
                                    <select id="filterRole" class="form-select" onchange="this.form.submit()" name="role">
                                        <option value="">All</option>
                                        <option value="Instructor">Instructor</option>
                                    </select>
                                </div> 
                            </div>
                            <div class="col-md-7 d-flex justify-content-end">
                                <input class="form-control me-2 w-50" type="search" placeholder="Enter keyword to search" value="${requestScope.key}" aria-label="Search" id="input-search" name="key">
                                <button class="btn btn-outline-success" type="submit" id="search">Search</button>
                            </div>
                        </div>
                    </form>
                    <div class="">
                        <table id="userTable" class="table table-bordered table-hover ">
                            <thead>
                                <tr>
                                    <th>Image</th>
                                    <th class="fixed-width-column">Fullname</th>
                                    <th >Gender</th>
                                    <th class="fixed-width-column" >Email</th>
                                    <th>Role</th>
                                    <th  onclick="sortTable(5)">Enroll Time <span class="sort-icon">&#9650;</span></th>                                
                                    <th onclick="sortTable(6)">Courses <span class="sort-icon">&#9650;</span></th>
                                    <th  onclick="sortTable(7)">Rating <span class="sort-icon">&#9650;</span></th>
                                    <th >Status</th>
                                    <th  >Action</th>
                                </tr>
                            </thead>
                            <tbody>

                                <c:forEach items="${requestScope.users}" var="entry" varStatus="loop">
                                    <tr>
                                        <td><img class=""
                                                 src="${entry.value.profile.picture}" alt=""
                                                 style="max-width:50px"></td>
                                        <td class="fixed-width-column">${entry.value.profile.name}</td>
                                        <td>
                                            <c:if test="${entry.value.profile.gender}">
                                                Male
                                            </c:if>
                                            <c:if test="${!entry.value.profile.gender}">
                                                Female
                                            </c:if>
                                        </td>
                                        <td class="fixed-width-column" style="word-wrap: break-word;">${entry.key.email}</td>
                                        <c:if test="${entry.value.email == null}">
                                            <td>Student</td>
                                        </c:if>
                                        <c:if test="${entry.value.email != null}">
                                            <td>Instructor</td>
                                        </c:if> 
                                        <td>${entry.value.profile.registerdTime}</td>

                                        <td>${entry.value.numberCourses}</td>
                                        <td>${entry.value.getRate()}</td>
                                        <c:choose>
                                            <c:when test="${!entry.value.profile.status}">
                                                <td class="text-success status">Active</td>
                                                <td>
                                                    <a href="user-detail?email=${entry.key.email}" class="btn btn-outline-dark btn-sm">View</a>
                                                    <button class="btn btn-outline-danger btn-sm ban" value="${entry.key.email}">Ban</button>
                                                </td>
                                            </c:when>
                                            <c:otherwise>
                                                <td class="text-danger status">Inactive</td>
                                                <td>
                                                    <a href="user-detail?email=${entry.key.email}" target="_blank" class="btn btn-outline-dark btn-sm">View</a>
                                                    <button class="btn btn-outline-warning btn-sm unban" value="${entry.key.email}">Unban</button>
                                                </td>
                                            </c:otherwise>                    
                                        </c:choose>

                                    </tr>
                                </c:forEach>                    
                            </tbody>
                        </table>
                    </div>  
                    <div class="d-flex justify-content-center align-items-center mt-3 ">
                        <div class="pagination" id="pagination"></div>
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
                                        $(document).ready(function () {
                                            $('#userTable').on('click', '.ban', function () {
                                                banOrUnban.call(this, 'ban');
                                            });
                                            $('#userTable').on('click', '.unban', function () {
                                                banOrUnban.call(this, 'unban');
                                            });
                                        });
                                        function banOrUnban(action) {
                                            var emailBan = this.value;
                                            var button = this;
                                            var status = $(button).parent().parent().find('.status');

                                            $.ajax({
                                                url: 'user-list',
                                                type: 'Post',
                                                data: {emailBan: emailBan, action: action},
                                                success: function (response) {
                                                    console.log(response.ban);
                                                    if (response.ban) {
                                                        $(button).removeClass('ban btn-outline-danger');
                                                        $(button).addClass('btn-outline-warning unban');
                                                        $(button).text('Unban');

                                                        $(status).text('Inactive').removeClass('text-success').addClass('text-danger');
                                                    } else {
                                                        $(button).removeClass('btn-outline-warning unban');
                                                        $(button).addClass('ban btn-outline-danger');
                                                        $(button).text('Ban');
                                                        $(status).text('Active').removeClass('text-danger').addClass('text-success');
                                                    }
                                                },
                                                error: function (jqXHR, textStatus, errorThrown) {
                                                    console.error('Error:', errorThrown);
                                                }
                                            });
                                        }

                                        let sortDirection = [true, true, true];

                                        function sortTable(columnIndex) {
                                            const table = document.getElementById('userTable');
                                            const tbody = table.getElementsByTagName('tbody')[0];
                                            const rows = Array.from(tbody.rows);
                                            const isNumeric = columnIndex === 7 || columnIndex === 6;

                                            rows.sort((a, b) => {
                                                const aText = a.cells[columnIndex].innerText;
                                                const bText = b.cells[columnIndex].innerText;

                                                return isNumeric ?
                                                        (sortDirection[columnIndex] ? aText - bText : bText - aText) :
                                                        (sortDirection[columnIndex] ? aText.localeCompare(bText) : bText.localeCompare(aText));
                                            });

                                            sortDirection[columnIndex] = !sortDirection[columnIndex];

                                            rows.forEach(row => tbody.appendChild(row));

                                            // Update the sort icon
                                            updateSortIcons(columnIndex);
                                        }
                                        function updateSortIcons(activeColumn) {
                                            const headers = document.querySelectorAll('th');
                                            headers.forEach((header, index) => {
                                                const icon = header.querySelector('.sort-icon');
                                                if (icon) {
                                                    icon.innerHTML = index === activeColumn && sortDirection[activeColumn] ? '&#9650;' : '&#9660;';
                                                }
                                            });
                                        }
                                        function resetIndices() {
                                            const table = document.getElementById('userTable');
                                            const tbody = table.getElementsByTagName('tbody')[0];
                                            const rows = Array.from(tbody.rows);

                                            let index = 1;
                                            rows.forEach(row => {

                                                row.cells[0].innerText = index++;

                                            });
                                        }

                                        document.addEventListener('DOMContentLoaded', () => {
                                            // pagination
                                            const table = document.getElementById('userTable');
                                            const pagination = document.getElementById('pagination');
                                            const rows = table.getElementsByTagName('tbody')[0].getElementsByTagName('tr');
                                            const rowPerPage = 8;
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
//                                            createPagination();
//                                            displayPage(currentPage);
                                            sortTable(5);
                                            function filter(selectId, selectedValue) {
                                                var selectElement = document.getElementById(selectId);
                                                for (var option of selectElement.options) {
                                                    if (option.value === selectedValue) {
                                                        option.selected = true;
                                                        break;
                                                    }
                                                }
                                            }                                            
                                            filter('filterGender', '${requestScope.genderSelected}');
                                            filter('filterStatus', '${requestScope.statusSelected}');
                                            filter('filterRole', '${requestScope.roleSelected}');
                                            filter('filterRating','${requestScope.ratingSelected}');
                                        });
        </script>
</html>
