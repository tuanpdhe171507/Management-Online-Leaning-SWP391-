<%-- 
    Document   : user-detail
    Created on : Jul 5, 2024, 5:50:23 PM
    Author     : Trongnd
--%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Edu-Port</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <style>
            th{
                cursor: pointer;
            }
            .table th {
                background-color: #343a40;
                color: #ffffff;
            }
        </style>
    </head>
    <body>
        <%@include file="../elements/navbar.jsp"%>
        <c:set value="${requestScope.infor}" var="infor"/>
        <c:set value="${requestScope.instrutorInfor}" var="instructorInfor"/>
        <c:set value="${requestScope.courses}" var="course"/>
        <div class="container mt-4 " style="min-height: 500px">
            <!-- Account page navigation-->
            <div class="row ">
                <div class="col-md-3">
                    <div class="card shadow-sm">
                        <div class="card-body text-center ">
                            <div class="rounded mx-auto d-block" >
                                <img class="mx-auto d-block rounded-circle mb-3"
                                     src="${infor.picture}" alt=""
                                     style="max-width:120px">
                            </div>
                            <div class="">                                
                                <h6>Account</h6>
                                <h5>${infor.name}</h5>
                            </div>
                            <div class=" d-flex justify-content-between align-items-center">
                                <div>
                                    Course: ${fn:length(course)}
                                </div>
                                <div>
                                    Report:
                                </div>
                            </div>  
                        </div>
                        <div class="card-body">
                            <nav class="nav flex-column nav-pills nav-gap-y-1">
                                <a class="nav-item btn tab mb-3" onclick="show(0)">

                                    User's Information
                                </a>
                                <a class="nav-item btn tab" onclick="show(1)">
                                    User's Course
                                </a>
                            </nav>
                        </div>
                    </div>
                </div>
                <div class="col-md-9">
                    <div class="container-fluid page">
                        <div class="row">
                            <div class="col-md-12">

                                <div class="card mb-4">
                                    <div class="card-header d-flex align-items-center justify-content-between" style="height: 80px"> 
                                        <h2 class="">User Profile</h2>

                                    </div>
                                    <div class="card-body">
                                        <form>
                                            <!-- Form Row-->
                                            <div class="row gx-3 mb-3">
                                                <!-- Form Group (first name)-->
                                                <div class="col-md-6">
                                                    <label class=" mb-1" for="inputFullname">Full
                                                        name</label>
                                                    <input class="form-control" id="inputFullname" type="text"
                                                           value="${infor.name}" disabled="">

                                                </div>
                                                <div class="col-md-6">
                                                    <label class=" mb-1" for="inputPhone">Gender</label>
                                                    <select class="form-select" disabled="">
                                                        <c:if test="${infor.gender}">
                                                            <option selected="" >Male</option>
                                                            <option  >Female</option>
                                                        </c:if>
                                                        <c:if test="${!infor.gender}">
                                                            <option  >Male</option>
                                                            <option  selected="">Female</option>
                                                        </c:if>
                                                    </select>
                                                </div>
                                            </div>

                                            <div class="row gx-3 mb-3">
                                                <div class="col-md-6">
                                                    <label class=" mb-1" for="inputEmail">Email</label>
                                                    <input class="form-control" id="inputEmail" type="Email"
                                                           placeholder="abc@gmail.com" value="${requestScope.email}" disabled="">
                                                </div>
                                                <div class="col-md-6">
                                                    <label class=" mb-1" for="youtubeLink">Youtube Link</label>
                                                    <input class="form-control" id="youtubeLink" type="text"
                                                           value="${instructorInfor.youtubeLink}" disabled="">
                                                </div>
                                            </div>
                                            <div class="row gx-3 mb-3">
                                                <div class="col-md-6">
                                                    <label class=" mb-1" for="headLine">Headline</label>
                                                    <input class="form-control" id="headLine" type="text"
                                                           value="${infor.headline}" disabled="">
                                                </div>
                                                <div class="col-md-6">
                                                    <label class=" mb-1" for="facebookLink">Facebook Link</label>
                                                    <input class="form-control" id="facebookLink" type="Email"
                                                           value="${instructorInfor.facebookLink}" disabled="">
                                                </div>

                                            </div>
                                            <div class="row gx-3 mb-3">                                                
                                                <div class="col-md-6">
                                                    <label class=" mb-1" for="enrollTime">Enroll Time</label>
                                                    <input class="form-control" id="enrollTime" type="text"
                                                           value="${infor.registerdTime}" disabled="">
                                                </div>
                                                <div class="col-md-6">
                                                    <label class=" mb-1" for="status">Status</label>
                                                    <select class="form-select w-50" id="status">                                                        
                                                        <option value="flase">Active</option>
                                                        <option value="true">Inactive</option>
                                                    </select>
                                                </div>
                                            </div>
                                            <div class="row gx-3 mb-3">                                                
                                                <div class="col-md-12">
                                                    <label class=" mb-1" for="biography">Biography</label>
                                                    <textarea class="form-control" id="biography" type="text"
                                                              disabled="">${instructorInfor.biography}</textarea>
                                                </div>

                                            </div>                                           

                                        </form>
                                    </div>
                                </div>
                            </div>   
                        </div>
                    </div>
                    <div class="container-fluid page">
                        <div class="card">
                            <div class="card-header d-flex align-items-center justify-content-between" style="height: 80px">
                                <h2>User's Course</h2>
                            </div>
                            <div class="card-body">
                                <form class="row mb-4">
                                    <div class="col-md-3">
                                        <label for="statusFilter" class="form-label">Status</label>
                                        <select id="statusFilter" class="form-select"onchange="filterTable()">
                                            <option value="">All</option>
                                            <option value="Draft">Draft</option>
                                            <option value="Public">Public</option>
                                            <option value="Private">Private</option>
                                        </select>
                                    </div>
                                    <div class="col-md-3">
                                        <label for="ratingFilter" class="form-label">Rating</label>
                                        <select id="ratingFilter" class="form-select"onchange="filterTable()">
                                            <option value="">All</option>
                                            <option value="3.0">3.0+</option>
                                            <option value="3.5">3.5+</option>
                                            <option value="4.0">4.0+</option>
                                            <option value="4.5">4.5+</option>

                                        </select>
                                    </div>
                                </form>
                                <div class="row">
                                    <div class="col">
                                        <table id="courseTable" class="table table-bordered table-hover">
                                            <thead>
                                                <tr>
                                                    <th>#</th>
                                                    <th>Course</th>
                                                    <th onclick="sortTable(2)">Student <span class="sort-icon">&#9650;</span></th>
                                                    <th onclick="sortTable(3)">Rating <span class="sort-icon">&#9650;</span></th>
                                                    <th onclick="sortTable(4)">Price <span class="sort-icon">&#9650;</span></th>                                                     
                                                    <th onclick="sortTable(5)">Report<span class="sort-icon">&#9650;</span></th>
                                                    <th onclick="sortTable(6)">Date of Publish<span class="sort-icon">&#9650;</span></th>
                                                    <th>Status</th>
                                                    <th>Action</th>                                                    
                                                </tr>
                                            </thead>
                                            <tbody id="courseTableBody">
                                                <c:forEach items="${requestScope.courses}" var="course" varStatus="loop">
                                                    <tr >
                                                        <td>${loop.index+1}</td>
                                                        <td class="d-flex align-items-center"><img class="mt-2 mb-2 me-2"
                                                                                                   src="${course.thumbnail}" alt=""
                                                                                                   style="max-width:50px">${course.name}</td>
                                                        <td>${course.getTotalStudents()}</td>

                                                        <td>${course.getCourseRating()}</td>
                                                        <td >${course.price}</td>
                                                        <td></td>
                                                        <td >${course.lastUpdatedTime}</td>
                                                        <c:if test="${course.visibility == 1}">
                                                            <td>Public</td>
                                                        </c:if>
                                                        <c:if test="${course.visibility == 0}">
                                                            <td>Draft</td>
                                                        </c:if>
                                                        <c:if test="${course.visibility == -1}">
                                                            <td>Private</td>
                                                        </c:if>  
                                                        <td><button class="btn btn-outline-dark btn-sm"> View </button></td>
                                                    </tr> 
                                                </c:forEach>


                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </div>
                        </div>

                    </div>
                </div>
            </div>
        </div>
        <%@include file="../elements/footer.jsp"%>
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/5.1.3/js/bootstrap.bundle.min.js"></script>
        <script type="module" src="https://unpkg.com/ionicons@7.1.0/dist/ionicons/ionicons.esm.js"></script>
        <script nomodule src="https://unpkg.com/ionicons@7.1.0/dist/ionicons/ionicons.js"></script>
        <script>
                                            function getStatus() {
                                                var statusSelected = document.getElementById('status');

                                                // is banded
            <c:if test="${!infor.status}">
                                                statusSelected.options[0].selected = true;
            </c:if>
                                                // not baned    
            <c:if test="${infor.status}">
                                                statusSelected.options[1].selected = true;
            </c:if>
                                            }
                                            getStatus();
                                            $(document).ready(function () {
                                                $('#status').on('change', function () {
                                                    var emailSelected = $('#inputEmail').val();
                                                    var ban = $('#status').val();
                                                    console.log(ban);
                                                    $.ajax({
                                                        url: 'user-detail',
                                                        type: 'Post',
                                                        data: {email: emailSelected, ban: ban},
                                                        success: function (response) {
                                                        },
                                                        error: function (jqXHR, textStatus, errorThrown) {
                                                            console.error('Error:', errorThrown);
                                                        }
                                                    });
                                                });
                                            });

                                            function filterTable() {
                                                const statusFilter = document.getElementById('statusFilter').value.toLowerCase();
                                                const ratingfilter = document.getElementById('ratingFilter').value.toLowerCase();
                                                const rows = document.getElementById('courseTableBody').getElementsByTagName('tr');
                                                console.log(rows);
                                                for (let i = 0; i < rows.length; i++) {
                                                    const status = rows[i].getElementsByTagName('td')[7].innerText.toLowerCase();
                                                    const rating = rows[i].getElementsByTagName('td')[3].innerText;
                                                    const showStatus = statusFilter === "" || statusFilter === status;
                                                    const showRating = ratingfilter === "" || rating >= ratingfilter;
                                                    rows[i].style.display = showStatus && showRating ? "" : "none";
                                                }

                                            }
                                             let sortDirection = [true, true, true];

                                        function sortTable(columnIndex) {
                                            const table = document.getElementById('courseTable');
                                            const tbody = table.getElementsByTagName('tbody')[0];
                                            const rows = Array.from(tbody.rows);
                                            const isNumeric = 5;

                                            rows.sort((a, b) => {
                                                const aText = a.cells[columnIndex].innerText;
                                                const bText = b.cells[columnIndex].innerText;

                                                return !isNumeric ?
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
                                                const table = document.getElementById('courseTable');
                                                const tbody = table.getElementsByTagName('tbody')[0];
                                                const rows = Array.from(tbody.rows);

                                                let index = 1;
                                                rows.forEach(row => {

                                                    row.cells[0].innerText = index++;

                                                });
                                            }
                                            var tabs = document.getElementsByClassName('tab');
                                            var pages = document.getElementsByClassName('page');
                                            function show(e) {
                                                for (let i = 0; i < pages.length; i++) {
                                                    if (i === e) {
                                                        pages[i].style.display = "block";
                                                        tabs[i].classList.add('btn-dark');
                                                    } else {
                                                        pages[i].style.display = "none";
                                                        tabs[i].classList.remove('btn-dark');
                                                    }
                                                }
                                            }
                                            show(0);
        </script>
    </body>
</html>
