<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@page contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>

    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
        <title>EduPort</title>
        <link href="view/assets/css/hieutc.css" rel="stylesheet" />
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
                        <h1 class="modal-title fs-5" id="exampleModalLabel">Create New Event</h1>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"
                                aria-label="Close"></button>
                    </div>
                    <form action="discount-event" method="post">
                        <div id="createEvent" class="modal-body-content">
                            <table class="table table-borderless w-100">
                                <tr>
                                    <td><span class="fw-bold ps-3">Event Title </span></td>
                                    <td>
                                        <input type="text" name="title" id="eventTitle" class="form-control rounded">
                                        <input type="hidden" id="eventTitle" name="eventCurrent">
                                    </td>
                                </tr>
                                <tr>
                                    <td><span class="fw-bold ps-3">Discount percent </span></td>
                                    <td>
                                        <div class="row">
                                            <div class="col-4">
                                                <input type="number" name="discount" id="eventDiscount" class="form-control rounded" min="0" max="100">
                                            </div>
                                            <div class="col">
                                                <p class="fw-bold h4">%</p>
                                            </div>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td><span class="fw-bold ps-3">Time Start</span></td>
                                    <td>
                                        <div class="input-group">
                                            <input class="form-control me-4" name="startDate" type="date">
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td><span class="fw-bold ps-3">Time End </span></td>
                                    <td>
                                        <div class="input-group">
                                            <input class="form-control me-4"  name="endDate" type="date">
                                        </div>
                                    </td>
                                </tr>
                            </table>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="rounded btn btn-danger"
                                    data-bs-dismiss="modal">Close</button>
                            <input type="hidden" name="action" value="1">
                            <button type="submit" class="rounded btn btn-primary">Save</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
        <div class="modal fade" id="exampleModal2" tabindex="-1" aria-labelledby="exampleModalLabel"
             aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h1 class="modal-title fs-5" id="exampleModalLabel">Edit Event</h1>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"
                                aria-label="Close"></button>
                    </div>
                    <form action="discount-event" method="post">
                        <div id="editEvent" class="modal-body-content">
                            <table class="table table-borderless w-100">
                                <tr>
                                    <td><span class="fw-bold ps-3">Event Title (Current)</span></td>
                                    <td> <input type="text" id="eventName" name="titleCurrent" class="form-control rounded" readonly>
                                    </td>
                                </tr>
                                <tr>
                                    <td><span class="fw-bold ps-3">Event Title (New)</span></td>
                                    <td><input type="text" name="titleNew" class="form-control rounded">

                                    </td>
                                </tr>
                                <tr>
                                    <td><span class="fw-bold ps-3">Discount percent (New)</span></td>
                                    <td>
                                        <div class="row">
                                            <div class="col-4">
                                                <input type="number" name="discountNew" class="form-control rounded" min="0" max="100">
                                            </div>
                                            <div class="col">
                                                <p class="fw-bold h4">%</p>
                                            </div>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td><span class="fw-bold ps-3">Time Start (New)</span></td>
                                    <td>
                                        <div class="input-group">
                                            <input class="form-control me-4" name="startDateNew" type="date">
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td><span class="fw-bold ps-3">Time End (New)</span></td>
                                    <td>
                                        <div class="input-group">
                                            <input class="form-control me-4"  name="endDateNew" type="date">
                                        </div>
                                    </td>
                                </tr>
                            </table>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="rounded btn btn-danger"
                                    data-bs-dismiss="modal">Close</button>
                            <input type="hidden" name="action" value="2">
                            <button type="submit" class="rounded btn btn-primary">Save change</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
        <div class="container mt-5" style="height: 100%">
            <div class="card shadow-sm">
                <div class="card-header mb-3">
                    <h2 class="">Manage Discount Event</h2>
                </div>
                <div class="card-body">
                    <div class="row ">
                        <div class="menu">
                            <button class="btn btn-light tab " type="button" onclick="show(0)">All
                                Event</button>
                            <button class="btn  btn-light tab " type="button" onclick="show(1)">Pending
                                Queue</button>
                            <button class="btn  btn-light tab " type="button" onclick="show(2)">Course Discounted</button>
                            <button type="button" class="btn  btn-light" data-bs-toggle="modal"
                                    data-bs-target="#exampleModal" onclick="showModalContent('createEvent')">
                                Create
                            </button>

                        </div>
                    </div>
                    <div class="row page">
                        <div class="col-md-10 d-flex">
                            <form id="search-form"  class="d-flex" method="get" action="discount-event">
                                <input class="form-control me-2" style="min-width: 250px" type="search"
                                       placeholder="Enter Name Event" 
                                       aria-label="Search"  name="eventName">
                                <select class="form-select me-2" onchange="submitSearchForm()" name="sort">
                                    <option selected disabled value="">Sort Discount...</option>
                                    <option value="asc" ${param.sort == 'asc' ? 'selected' : ''}>Low To High</option>
                                    <option value="desc" ${param.sort == 'desc' ? 'selected' : ''}>High To Low</option>
                                </select>
                                <div class="input-group ">
                                    <span class="input-group-text">From:</span>
                                    <input class="form-control me-1 "   name="fromdate" type="date">
                                </div>
                                <div class="input-group ">
                                    <span class="input-group-text">To:</span>
                                    <input class="form-control me-4"  name="todate" type="date">
                                </div>
                                <input type="hidden" value="filter" name="flag">
                            </form>
                        </div>
                        <table class="table table-bordered table-hover w-100 " id="table">
                            <thead>
                                <tr>
                                    <th>#</th>
                                    <th>Title</th>
                                    <th>Discount</th>
                                    <th>Time Start</th>
                                    <th>Time End</th>
                                    <th>Operation</th>

                                </tr>
                            </thead>
                            <tbody id="courseTable">
                                <c:forEach items="${requestScope.listEvent}" var="events" varStatus="loop">
                                    <tr>
                                        <td class="index">${loop.index + 1}</td>
                                        <td><img class="mt-2 mb-2 me-2">${events.event}</td>
                                        <td> <span class="text-white bg-danger px-3 rounded">${events.discount}%</span></td>
                                        <td>${events.startDate}</td>
                                        <td>${events.endDate}</td>
                                        <td>
                                            <button type="button" class="btn btn-primary btn-sm" data-bs-toggle="modal" data-bs-target="#exampleModal2" 
                                                    onclick="showEventContent('${events.event}')">Edit</button>
                                            <button class="btn btn-danger btn-sm" onclick="deleteEvent('${events.event}')">Delete</button>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>

                        </table>
                        <div class="d-flex justify-content-center align-items-center mt-3">
                            <div class="pagination" id="pagination"></div>
                        </div>
                    </div>
                    <div class="row page">
                        <div class="col-md-10 d-flex">
                            <form id="search-form"  class="d-flex" method="get" action="discount-event">
                                <input class="form-control me-2" style="min-width: 250px" type="search"
                                       placeholder="Enter Name Instructor"
                                       aria-label="Search" name="nameInstructor">
                                <select class="form-select me-2" onchange="submitSearchForm()" name="sort">
                                    <option selected disabled value="">Sort Queue...</option>
                                    <option value="asc" ${param.sort == 'asc' ? 'selected' : ''}>First To Last</option>
                                    <option value="desc" ${param.sort == 'desc' ? 'selected' : ''}>Last To First</option>
                                </select>
                            </form>
                        </div>
                        <table class="table table-bordered table-hover w-100" id="table">
                            <thead>
                                <tr>
                                    <th>#</th>
                                    <th> Title Event </th>
                                    <th> </th>
                                    <th> Course </th>
                                    <th>Instructor</th>
                                    <th> Discount</th>
                                    <th>Operation</th>
                                </tr>
                            </thead>
                            <tbody id="courseTable">

                                <c:set var="index" value="0" />
                                <c:forEach items="${requestScope.listCourseJoinEvented}" var="courseDiscounted" varStatus="loop">
                                    <c:if test="${courseDiscounted.approved == false}">
                                        <tr>
                                            <td class="index">${index + 1}</td>
                                            <c:set var="index" value="${index + 1}" />
                                            <td class="text-center">${courseDiscounted.discountEvent.event}</td>
                                            <td>
                                                <div>
                                                    <img style="height: 90px; width: 160px" src="${courseDiscounted.course.thumbnail}" />   
                                                </div>
                                            </td>     
                                            <td>${courseDiscounted.course.name}</td>
                                            <td>${courseDiscounted.course.instructor.profile.name}</td>
                                            <td>
                                                <span class="px-3 text-white bg-danger rounded">${courseDiscounted.discountEvent.discount}%</span>
                                            </td>
                                            <td>
                                                <form id="actionForm${loop.index}" action="discount-event" method="post">
                                                    <input type="hidden" name="courseId" value="${courseDiscounted.course.id}" id="courseId${loop.index}">
                                                    <input type="hidden" name="title" value="${courseDiscounted.discountEvent.event}" id="title${loop.index}">
                                                    <input type="hidden" name="action" id="actionInput${loop.index}">

                                                    <input type="submit" id="AcceptButton${loop.index}" style="display: none">
                                                    <label for="AcceptButton${loop.index}" class="btn btn-dark rounded btn-sm" onclick="submitForm(${loop.index}, '4')">Accept</label>

                                                    <input type="submit" id="RejectButton${loop.index}" style="display: none">
                                                    <label for="RejectButton${loop.index}" class="btn btn-danger rounded btn-sm" onclick="submitForm(${loop.index}, '3')">Reject</label>
                                                </form>
                                            </td>
                                        </tr>
                                    </c:if>
                                </c:forEach>
                            </tbody>
                        </table>
                        <div class="d-flex justify-content-center align-items-center mt-3">
                            <div class="pagination" id="pagination"></div>
                        </div>
                    </div>
                    <div class="row page">
                        <div class="col-md-10 d-flex">
                            <form id="search-form"  class="d-flex" method="get" action="discount-event">
                                <input class="form-control me-2" style="min-width: 250px" type="search"
                                       placeholder="Enter Name Instructor"
                                       aria-label="Search" name="nameInstructor">
                                <select class="form-select me-2" onchange="submitSearchForm()" name="sort">
                                    <option selected disabled value="">Sort Queue...</option>
                                    <option value="asc" ${param.sort == 'asc' ? 'selected' : ''}>First To Last</option>
                                    <option value="desc" ${param.sort == 'desc' ? 'selected' : ''}>Last To First</option>
                                </select>
                            </form>
                        </div>
                        <table class="table table-bordered table-hover w-100" id="table">
                            <thead>
                                <tr>
                                    <th>#</th>
                                    <th> Title Event </th>
                                    <th> </th>
                                    <th> Course </th>
                                    <th>Instructor</th>
                                    <th> Discount</th>
                                    <th> Price Old</th>
                                    <th> Price New</th>
                                    <th>Operation</th>
                                </tr>
                            </thead>
                            <tbody id="courseTable">
                                <c:set var="index" value="0" />
                                <c:forEach items="${requestScope.listCourseJoinEvented}" var="courseDiscounted" varStatus="loop">
                                    <c:if test="${courseDiscounted.approved == true}">
                                        <tr>
                                            <td class="index">${index + 1}</td>
                                            <c:set var="index" value="${index + 1}" />
                                            <td class="text-center">${courseDiscounted.discountEvent.event}</td>
                                            <td>
                                                <div>
                                                    <img style="height: 90px; width: 160px" src="${courseDiscounted.course.thumbnail}" />   
                                                </div>
                                            </td>
                                            <td>${courseDiscounted.course.name}</td>
                                            <td>${courseDiscounted.course.instructor.profile.name}</td>
                                            <td>
                                                <span class="px-3 text-white bg-danger rounded"> ${courseDiscounted.discountEvent.discount}%</span>
                                            </td>
                                            <td>
                                                <span class="rounded"> ${courseDiscounted.course.price}$</span>
                                            </td>
                                            <td>
                                                <span class="rounded">
                                                    <c:set var="priceNew" value="${courseDiscounted.course.price * (1 - courseDiscounted.discountEvent.discount / 100)}" />
                                                    <fmt:formatNumber value="${priceNew}" type="number" minFractionDigits="2" maxFractionDigits="2" />$
                                                </span>
                                            </td>
                                            <td>
                                                <form id="actionForm${loop.index}" action="discount-event" method="post">
                                                    <input type="hidden" name="courseId" value="${courseDiscounted.course.id}" id="courseId${loop.index}">
                                                    <input type="hidden" name="title" value="${courseDiscounted.discountEvent.event}" id="title${loop.index}">
                                                    <input type="hidden" name="action" id="actionInput${loop.index}">

                                                    <input type="submit" id="RejectButton${loop.index}" style="display: none">
                                                    <label for="RejectButton${loop.index}"class="btn btn-outline-danger rounded btn-sm" onclick="submitForm(${loop.index}, '3')">Ban</label>
                                                </form>
                                            </td>
                                        </tr>
                                    </c:if>
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
        <%@include file="../elements/footer.jsp" %>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script type="module" src="https://unpkg.com/ionicons@7.1.0/dist/ionicons/ionicons.esm.js"></script>
        <script nomodule src="https://unpkg.com/ionicons@7.1.0/dist/ionicons/ionicons.js"></script>
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
        <script
        src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-datepicker/1.9.0/js/bootstrap-datepicker.min.js"></script>
        <script>
                                                        function submitForm(index, actionValue) {
                                                            document.getElementById('actionInput' + index).value = actionValue;
                                                            document.getElementById(actionValue === '4' ? 'AcceptButton' + index : 'RejectButton' + index).click();
                                                        }

                                                        function submitSearchForm() {
                                                            // Reset giá trị của dropdown về mặc định
                                                            var sortSelect = document.querySelector('select[name="sort"]');
                                                            sortSelect.selectedIndex = 0;

                                                            // Submit form
                                                            document.getElementById('search-form').submit();
                                                        }



                                                        function deleteEvent(event) {
                                                            var flag = "delete";
                                                            window.location.href = '/SWP391/administrator/discount-event?eventDeleted=' + encodeURIComponent(event) + '&flag=' + encodeURIComponent(flag);
                                                        }

                                                        function showEventContent(event) {
                                                            document.getElementById('eventName').value = event;
                                                            console.log(event);
                                                        }


                                                        function showModalContent(contentId) {
                                                            // Hide all content
                                                            var contents = document.querySelectorAll('.modal-body-content');
                                                            contents.forEach(function (content) {
                                                                content.style.display = 'none';
                                                            });

                                                            // Show the selected content
                                                            var selectedContent = document.getElementById(contentId);
                                                            selectedContent.style.display = 'block';
                                                        }


                                                        var tabs = document.getElementsByClassName("tab");
                                                        var pages = document.getElementsByClassName("page");

                                                        function show(e) {
                                                            // Lưu trạng thái tab hiện tại vào LocalStorage
                                                            localStorage.setItem('currentTab', e);

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


                                                        document.addEventListener('DOMContentLoaded', (event) => {
                                                            var currentTab = localStorage.getItem('currentTab');
                                                            if (currentTab !== null) {
                                                                show(parseInt(currentTab));
                                                            } else {
                                                                show(0);
                                                            }
                                                        });
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