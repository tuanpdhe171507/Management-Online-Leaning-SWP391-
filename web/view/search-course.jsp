<%-- 
    Document   : search-course
    Created on : May 27, 2024, 6:42:07 PM
    Author     : TuanPD
--%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="dao.AdministratorContext" %>
<!doctype html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
        <title>EduPort</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
        <link href="view/assets/css/hieutc.css" rel="stylesheet"/>
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
        <script>
            function updateSortOptions(selectElement) {
                var selectedValue = selectElement.value;
                var priceOptionsDiv = document.getElementById('priceOptions');
                var form = document.getElementById('courseFilterForm');
                form.submit();
            }

        </script>
        <style>
            .dropdown:hover .dropdown-menu {
                display: block;
            }
        </style>
    </head>
    <body>
        <%@include file="elements/navbar.jsp"%>
        <div class="container pt-5 pb-5">
            <div class="col-12">
                <h5 class="fw-bold">${requestScope.searchedCourses.size()} results for "${param.key}"</h5>
                <input type="hidden" name="key" value="${param.key}">
            </div>
            <div class="row">
                <div class="col-3">
                    <form id="courseFilterForm" action="search" method="get">
                        <input type="hidden" name="key" value="${param.key}">
                        <div class="d-flex">
                            <div>
                                <select class="p-3 rounded-2 w-auto" name="sort" onchange="updateSortOptions(this)" class="form-select" style="width: 150px;">
                                    <option value="rating" <c:if test="${param.sort == 'rating'}">selected="selected"</c:if>>Highest rated</option>
                                    <option value="newest" <c:if test="${param.sort == 'newest'}">selected="selected"</c:if>>Newest</option>
                                    <option value="highest" <c:if test="${param.sort == 'highest'}">selected="selected"</c:if>>Highest price first</option>
                                    <option value="lowest" <c:if test="${param.sort == 'lowest'}">selected="selected"</c:if>>Lowest price first</option>
                                    </select>
                                    <input type="hidden" id="sortInput" name="sortP" value="<c:out value='${param.sort}'/>"/>
                            </div>
                            <div>
                                <button class="btn text-secondary" type="button" onclick="clearFilters()">Clear filter</button>
                            </div>
                        </div>
                    </form>
                    <hr>
                    <form id="filterForm" method="GET" action="search">
                        <details open="true">
                            <summary>
                                <h5 class="fw-bold">Ratings</h5>
                            </summary>
                            <div class="form-check mb-2">
                                <input class="form-check-input rounded-5" type="radio" name="rating2" value="4.5" id="45up">
                                <label class="form-check-label" for="45up">
                                    4.5 & up
                                    <ion-icon name="star"></ion-icon>
                                    <ion-icon name="star"></ion-icon>
                                    <ion-icon name="star"></ion-icon>
                                    <ion-icon name="star"></ion-icon>
                                    <ion-icon name="star-half"></ion-icon>
                                </label>
                            </div>
                            <div class="form-check mb-2">
                                <input class="form-check-input rounded-5" type="radio" name="rating2" value="4.0" id="4up">
                                <label class="form-check-label" for="4up">
                                    4.0 & up
                                    <ion-icon name="star"></ion-icon>
                                    <ion-icon name="star"></ion-icon>
                                    <ion-icon name="star"></ion-icon>
                                    <ion-icon name="star"></ion-icon>
                                    <ion-icon name="star-outline"></ion-icon>
                                </label>
                            </div>
                            <div class="form-check">
                                <input class="form-check-input rounded-5 mb-2" type="radio" name="rating2" value="3.5" id="35up">
                                <label class="form-check-label" for="35up">
                                    3.5 & up
                                    <ion-icon name="star"></ion-icon>
                                    <ion-icon name="star"></ion-icon>
                                    <ion-icon name="star"></ion-icon>
                                    <ion-icon name="star-half"></ion-icon>
                                    <ion-icon name="star-outline"></ion-icon>
                                </label>
                            </div>
                        </details>
                        <hr>
                        <input type="hidden" name="key" value="${param.key}">
                        <details>
                            <summary>
                                <h5 class="fw-bold">Price</h5>
                            </summary>
                            <div class="form-check mb-2">
                                <input class="form-check-input" type="checkbox" value="true" name="paid" id="paid">
                                <label class="form-check-label" for="paid">
                                    Paid
                                </label>
                            </div>
                            <div class="form-check mb-2">
                                <input class="form-check-input" type="checkbox" value="true" name="free" id="free">
                                <label class="form-check-label" for="free">
                                    Free
                                </label>
                            </div>
                        </details>
                    </form>
                </div>

                <div class="col-9" style="margin-top: -0.4rem;" id="searchResults">
                    <%AdministratorContext dbContext = new AdministratorContext();
                    int rows = Integer.parseInt(dbContext.getValue("rows_per_page"));
                    request.setAttribute("rows", rows);%>
                    <div class="row gy-3 page">
                        <c:set var="courseCount" value="0"></c:set>
                        <c:set var="pageCount" value="1"></c:set>
                        <c:forEach items="${searchedCourses}" var="course">
                            <div class="col-12">
                                <div class="row">
                                    <div class="col-4">
                                        <div class="ratio ratio-16x9" onclick="openCourse(${course.id})">
                                            <img class="w-100 rounded-2" src="${course.thumbnail}">
                                        </div>                 
                                    </div>
                                    <div class="col-6">
                                        <h6 class="fw-bold">${course.name}</h6>
                                        <div class="text-truncate">
                                            <span>${course.tagLine}</span>
                                        </div>
                                        <span class="text-muted">${course.instructor.profile.name}</span><br>
                                        <span>
                                            <c:choose>
                                                <c:when test="${course.getCourseRating() < 0.5}">
                                                    <ion-icon name="star-outline"></ion-icon>
                                                    </c:when>
                                                    <c:when test="${course.getCourseRating() <= 0.5
                                                                    && course.getCourseRating() < 1.0}">
                                                    <ion-icon name="star-half-outline"></ion-icon>
                                                    </c:when>
                                                    <c:otherwise>
                                                    <ion-icon name="star"></ion-icon>
                                                    </c:otherwise>
                                                </c:choose>
                                                <c:choose>
                                                    <c:when test="${course.getCourseRating() < 1.5}">
                                                    <ion-icon name="star-outline"></ion-icon>
                                                    </c:when>
                                                    <c:when test="${course.getCourseRating() <= 1.5
                                                                    && course.getCourseRating() < 2.0}">
                                                    <ion-icon name="star-half-outline"></ion-icon>
                                                    </c:when>
                                                    <c:otherwise>
                                                    <ion-icon name="star"></ion-icon>
                                                    </c:otherwise>
                                                </c:choose>
                                                <c:choose>
                                                    <c:when test="${course.getCourseRating() < 2.5}">
                                                    <ion-icon name="star-outline"></ion-icon>
                                                    </c:when>
                                                    <c:when test="${course.getCourseRating() <= 2.5
                                                                    && course.getCourseRating() < 3.0}">
                                                    <ion-icon name="star-half-outline"></ion-icon>
                                                    </c:when>
                                                    <c:otherwise>
                                                    <ion-icon name="star"></ion-icon>
                                                    </c:otherwise>
                                                </c:choose>
                                                <c:choose>
                                                    <c:when test="${course.getCourseRating() < 3.5}">
                                                    <ion-icon name="star-outline"></ion-icon>
                                                    </c:when>
                                                    <c:when test="${course.getCourseRating() <= 3.5
                                                                    && course.getCourseRating() < 4.0}">
                                                    <ion-icon name="star-half-outline"></ion-icon>
                                                    </c:when>
                                                    <c:otherwise>
                                                    <ion-icon name="star"></ion-icon>
                                                    </c:otherwise>
                                                </c:choose>
                                                <c:choose>
                                                    <c:when test="${course.getCourseRating() < 4.5}">
                                                    <ion-icon name="star-outline"></ion-icon>
                                                    </c:when>
                                                    <c:when test="${course.getCourseRating() <= 4.5
                                                                    && course.getCourseRating() < 5.0}">
                                                    <ion-icon name="star-half-outline"></ion-icon>
                                                    </c:when>
                                                    <c:otherwise>
                                                    <ion-icon name="star"></ion-icon>
                                                    </c:otherwise>
                                                </c:choose>
                                                ${course.getCourseRating()} <span class="text-secondary">(${course.getRatings()} ratings)</span>
                                    </div>
                                    <div class="col-2">
                                        <c:choose>
                                            <c:when test="${course.price == 0.0}">
                                                Free
                                            </c:when>
                                            <c:otherwise>
                                                <ion-icon name="logo-usd"></ion-icon>${course.getCurrentPrice()}
                                                </c:otherwise>
                                            </c:choose>    
                                    </div>

                                </div>
                            </div>
                            <c:set var="courseCount" value="${courseCount + 1}"></c:set>
                            <c:if test="${courseCount % requestScope.rows == 0 && courseCount != searchedCourses.size()}">
                                <c:set var="pageCount" value="${pageCount + 1}"></c:set>
                                </div>
                                <div class="row gy-3 page">
                            </c:if>
                        </c:forEach>
                    </div>
                    <div class="w-100 mt-3">
                        <div class="btn-group" role="group">
                            <c:forEach begin="1" end="${pageCount > 2 ? 2 : pageCount}" var="page">
                                <button class="btn btn-light" type="button"
                                        onclick="go(${page - 1})">
                                    ${page}
                                </button>
                            </c:forEach>
                            <c:if test="${pageCount > 2}">
                                <div class="dropdown btn btn-light">
                                    ...
                                    <div class="dropdown-menu p-2">
                                        <c:forEach begin="3" end="${pageCount}" var="page">
                                            <button class="btn btn-light" type="button"
                                                    onclick="go(${page - 1})">
                                                ${page}
                                            </button>
                                        </c:forEach> 
                                    </div>
                                </div>
                            </c:if>   
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <%@include file="elements/footer.jsp"%>
    <script>
        function openCourse(e) {
            window.location.href = "course/details?id=" + e;
        }
        ;
        $(document).ready(function () {
            $('#paid, #free, input[name="rating2"]').on('change', function () {
                $.ajax({
                    url: $('#filterForm').attr('action'),
                    type: 'GET',
                    data: $('#filterForm').serialize(),
                    success: function (data) {
                        $('#searchResults').html($(data).find('#searchResults').html());
                    },
                    error: function (jqXHR, textStatus, errorThrown) {
                        console.error('Error during AJAX request', textStatus, errorThrown);
                    }
                });
            });
        });

        function clearFilters() {
            location.reload();

        }
        const pages = document.getElementsByClassName('page');

        function go(i) {
            for (let j = 0; j < pages.length; j++) {
                if (j !== i) {
                    pages[j].style.display = 'none';
                } else {
                    pages[j].style.display = 'block';
                }
            }
        }

        go(0);
    </script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script type="module" src="https://unpkg.com/ionicons@7.1.0/dist/ionicons/ionicons.esm.js"></script>
    <script nomodule src="https://unpkg.com/ionicons@7.1.0/dist/ionicons/ionicons.js"></script>
</body>
</html>