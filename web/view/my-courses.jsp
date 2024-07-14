<%-- 
    Document   : my-courses
    Created on : Jun 08, 2024, 1:50:26 AM
    Author     : HaiNV
--%>
<%@ page language="java" contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta charset="utf-8"/>
        <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
        <link href="view/assets/css/base.css" rel="stylesheet"/>
        <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.10.5/font/bootstrap-icons.min.css" rel="stylesheet">

        <title>EduPort</title>
    </head>
    <style>
        .rounded-progress {
            border-radius: 20px !important;
        }
        .rounded-progress .progress-bar {
            border-radius: 20px !important;
            background-color: #a65ae1;
        }
        .card {
            margin-bottom: 20px;
        }

        #reportCard {
            position: fixed;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            z-index: 1000;
            background: white;
            width: 80%;
            max-width: 400px;
            padding: 20px;
            box-shadow: 0 0 15px rgba(0, 0, 0, 0.2);
        }
        #reportCard.card.d-none {
            display: none;
        }
        .alert-success {
            position: fixed; /* Position relative to the viewport */
            bottom: 270px; /* Position at the bottom */
            right: 20px;

            z-index: 1000; /* Ensure it appears on top */
            display: none;
            padding: 15px;
            border: 1px solid transparent;
            border-radius: 4px;
            color: #155724;
            background-color: #d4edda;
            border-color: #c3e6cb;
            text-align: right;
            max-width: 300px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }
    </style>
    <body>
        <%@include file="elements/navbar.jsp"%>
        <div class="container mb-5">
            <div class="mb-4" style="margin-top: 10px;">
                <h4>My courses</h4>
            </div>
            <div class="row gx-3">
                <c:forEach var="course" items="${requestScope.enrolledCourses}">
                    <c:if test="${requestScope.noEnrolledCourses}">
                        <div class="alert text-dark">
                            <h6>You haven't enrolled in any courses yet.</h6>
                        </div>
                    </c:if>
                    <div class="col-3">
                        <div class="card dropdown dropend border">

                            <div class="ratio ratio-16x9 dropdown dropend border" onclick="openHyperLink(${course.id})">
                                <img class="card-img-top" src="${course.thumbnail}" />   
                            </div>
                            <button class="btn btn-light position-absolute end-0 z-2" type="button" data-bs-toggle="dropdown" aria-expanded="false">
                                <i class="bi bi-three-dots-vertical"></i>

                            </button>

                            <div class="dropdown d-inline">

                                <div class="mt-2 dropdown-menu dropdown-menu-end">
                                    <div class="p-3">
                                        ${sessionScope.user.email}
                                    </div>
                                    <hr class="dropdown-divider">
                                    <button class="btn dropdown-item" onclick="openHyperLink5()">
                                        Payment history
                                    </button>
                                    <button class="btn dropdown-item" onclick="setCourseIDForReport(${course.id})">
                                        Report
                                    </button>

                                    <button class="btn dropdown-item" type="button" onclick="setCourseIdToUnenroll(${course.id})">Unenroll</button>
                                </div>
                            </div>

                            <div class="card-body" onclick="openHyperLink(${course.id})" style="height: 60px; overflow: hidden;">
                                <h6 class="m-0">${course.name}</h6>
                            </div>
                            <div class="card-title">
                                <div class="progress rounded-progress" style="margin-top: auto; height: 10px;">
                                    <div class="progress-bar" role="progressbar" 
                                         style="width: ${requestScope.completionPercentages[course.id]}%;" aria-valuenow="${requestScope.completionPercentages[course.id]}" 
                                         aria-valuemin="0" aria-valuemax="100">
                                        ${requestScope.completionPercentages[course.id]}%
                                    </div>
                                </div>
                            </div>

                        </div>  

                    </div>

                </c:forEach>
            </div>
            <div class="modal fade" id="confirmUnenrollModal" tabindex="-1" role="dialog" aria-labelledby="confirmUnenrollModalLabel" aria-hidden="true">
                <div class="modal-dialog" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title" id="confirmUnenrollModalLabel">Confirm Unenrollment</h5>
                            <button type="button" class="close" style="border:none;background-color:white;margin-left:50%;font-size:20px" data-dismiss="modal" aria-label="Close">
                                <ion-icon name="close-outline"></ion-icon>
                            </button>
                        </div>
                        <div class="modal-body">
                            Are you sure you want to unenroll from this course?
                            <input type="hidden" id="courseIdToUnenroll" value="">
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
                            <button type="button" class="btn btn-danger" id="confirmUnenrollButton">Unenroll</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>


        <div id="reportCard" class="card mt-3 d-none">
            <div class="card-body" style="max-height: 550px;overflow-y: auto;">

                <h5 class="card-title">Reports</h5>
                <hr>
                <form id="reportForm" action="my-courses" method="post">
                    <input type="hidden" name="courseID" id="courseID">

                    <c:forEach items="${requestScope.listReports}" var="report" varStatus="loop">
                        <c:if test="${!report.reportList.isEmpty()}">
                            <details id="details_${loop.index}" class="report-details">
                                <summary>
                                    <h6>
                                        <input type="radio" name="reportTypeSelection" id="report_${loop.index}" value="${report.typeId}"
                                               <c:if test="${report.reportList.size() > 0 &&  report.reportList.size() <= 1}">
                                                   onclick="selectReport(${report.reportList.get(0).reportId})"
                                               </c:if>>
                                        <label for="report_${loop.index}">
                                            ${report.typeName}
                                        </label>
                                    </h6>
                                </summary>
                                <c:if test="${report.reportList.size() > 0 && report.reportList.size() <=1 }">
                                    <input type="radio" name="reportSelection" class="d-none" value="${report.reportList.get(0).reportId}" id="report-${report.reportList.get(0).reportId}">
                                </c:if>
                                <c:if test="${report.reportList.size() > 1}">
                                    <div class="p-3">
                                        <label>Choose one</label>
                                        <hr class="dropdown-divider">
                                        <!-- Loop through reportTypesList -->

                                        <c:forEach items="${report.reportList}" var="type">
                                            <label>
                                                <input type="radio" name="reportSelection" value="${type.reportId}">
                                                ${type.reportName}
                                            </label><br>
                                        </c:forEach>

                                    </div>
                                </c:if> 
                            </details>
                        </c:if>
                    </c:forEach>

                    <!-- Buttons for Cancel and Submit -->
                    <div class="text-right mt-3">
                        <button type="button" class="btn btn-secondary mr-2 rounded-2" onclick="cancelReport()">Cancel</button>
                        <button type="submit" class="btn btn-primary rounded-2">Submit</button>
                    </div>
                </form>
            </div>
        </div>
        <div id="successMessage" class="alert alert-success">
            ${param.mess}
        </div>
        <%@include file="elements/footer.jsp"%>    
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script type="module" src="https://unpkg.com/ionicons@7.1.0/dist/ionicons/ionicons.esm.js"></script>
        <script nomodule src="https://unpkg.com/ionicons@7.1.0/dist/ionicons/ionicons.js"></script>
        <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.4/dist/umd/popper.min.js"></script>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>

        <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.9.2/dist/umd/popper.min.js"></script>
        <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
        <script>
                            function selectReport(i) {
                                document.getElementById('report-' + i).setAttribute("checked", true);
                            }
                            window.onload = function () {
                                const successMessage = document.getElementById('successMessage');
                                if (successMessage.innerText.trim().length > 0) {
                                    successMessage.style.display = 'block';
                                    setTimeout(function () {
                                        successMessage.style.display = 'none';
                                    }, 3000);
                                }
                            };

                            function showReportCard() {
                                document.getElementById('reportCard').classList.remove('d-none');
                            }

                            function hideReportCard() {
                                document.getElementById('reportCard').classList.add('d-none');
                            }

                            function cancelReport() {
                                hideReportCard();
                                location.reload();
                            }

                            function setCourseIDForReport(courseID) {
                                document.getElementById('courseID').value = courseID;
                                showReportCard();
                            }

                            document.addEventListener('DOMContentLoaded', function () {
                                const details = document.querySelectorAll('.report-details');

                                details.forEach(detail => {
                                    detail.addEventListener('click', function () {
                                        // Close all details except the clicked one
                                        details.forEach(otherDetail => {
                                            if (otherDetail !== detail) {
                                                otherDetail.removeAttribute('open');
                                            }
                                        });
                                    });
                                });
                            });

                            document.addEventListener('DOMContentLoaded', function () {
                                const summaries = document.querySelectorAll('details summary');
                                summaries.forEach(summary => {
                                    summary.addEventListener('click', function () {
                                        this.parentElement.toggleAttribute('open');
                                    });
                                });
                            });

                            function toggleReportCard() {
                                var reportCard = document.getElementById('reportCard');
                                reportCard.classList.toggle('d-none');
                            }

                            function openHyperLink(e) {
                                window.location.href = "course/details?id=" + e;
                            }


                            document.querySelector('#confirmUnenrollModal .modal-header .close').addEventListener('click', function () {
                                $('#confirmUnenrollModal').modal('hide');
                            });
                            document.querySelector('#confirmUnenrollModal .modal-footer .btn-secondary').addEventListener('click', function () {
                                $('#confirmUnenrollModal').modal('hide');
                            });


                            function setCourseIdToUnenroll(courseId) {
                                document.getElementById('courseIdToUnenroll').value = courseId;
                                $('#confirmUnenrollModal').modal('show');
                            }

                            document.getElementById('confirmUnenrollButton').addEventListener('click', function () {
                                var courseId = document.getElementById('courseIdToUnenroll').value;

                                var xhr = new XMLHttpRequest();
                                xhr.open('GET', 'my-courses?courseId=' + encodeURIComponent(courseId), true);
                                xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
                                xhr.onreadystatechange = function () {
                                    if (xhr.readyState === XMLHttpRequest.DONE) {
                                        if (xhr.status === 200) {
                                            $('#confirmUnenrollModal').modal('hide');
                                            location.reload();
                                        } else {
                                            alert('An error occurred while trying to unenroll. Please try again.');
                                        }
                                    }
                                };
                                xhr.send();
                            });
        </script>

        <script>
            function openHyperLink5() {
                window.location.href = "http://localhost:8080/SWP391/payment-history";
            }
            ;
        </script>


    </body>
</html>



