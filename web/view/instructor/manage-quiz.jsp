<%-- 
    Document   : manage-quiz
    Created on : Jun 7, 2024, 1:28:25 AM
    Author     : Trongnd
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Manage Quiz</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <link href="https://getbootstrap.com/docs/5.3/assets/css/docs.css" rel="stylesheet">
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
        <link href="../view/assets/css/hieutc.css" rel="stylesheet" />

        <style>
            .fixed-centered {
                transform: translate(-50%, -50%);
                z-index: 101;
                width: 50%;
            }
            tr td{
                height: 35px;
            }

        </style>
    </head>
    <body>
        <%@include file="../elements/navbar.jsp"%>
        <div class="container pt-5 pb-5 w-100">

            <div class="row gx-3">
                <div class="col-2">                        
                    <div class="shadow-sm bg-body-tertiary p-2 rounded-3 border border-secondary-subtle header">
                        <h5>Course plan</h5>                        
                        <button class="btn d-block w-100 text-start tab mt-3 focus-ring focus-ring-dark" type="button" onclick="show(0)">Setting Quiz</button>
                        <button class="btn d-block w-100 text-start tab mt-3 focus-ring focus-ring-dark" type="button" onclick="show(1)" id="btn-manage-question">Question Management</button>

                    </div>
                </div>
                <div class="col-10">
                    <div class="container">
                        <div class="page w-75  p-3 pt-0">
                            <form action="manage" method="post" id="form">
                                <div class="card mb-3 shadow-sm">
                                    <div class="card-body d-flex justify-content-between">                                      
                                        <h4 class="modal-title">Setting</h4>
                                        <button class="btn btn-dark" type="submit" id="save-course">Save</button>
                                    </div>
                                </div>

                                <div class="card mb-3 shadow-sm" id="mySetting">                                    
                                    <div class="card-body  p-3 mb-3">
                                        <c:set value="${requestScope.quiz}" var="quiz"/>
                                        <input type="hidden" value="${quiz.id}" name="id">
                                        <table class="table table-borderless w-100">
                                            <tr>
                                                <td><span class="fw-bold ps-3">Quiz Title</span></td>
                                                <td><input type="text" class="form-control" value="${requestScope.quiz.title}" name="title" required=""></td>
                                            </tr>
                                            <tr>
                                                <td><span class="fw-bold ps-3">Random Question</span></td>
                                                <td>
                                                    <div class="form-check form-switch h3">
                                                        <c:if test="${quiz.questionRandomly}">
                                                            <input type="checkbox" class="form-check-input" id="checkbox" name="random" value="true" checked="">
                                                        </c:if>
                                                        <c:if test="${!quiz.questionRandomly}">
                                                            <input type="checkbox" class="form-check-input" id="checkbox" name="random" value="true">
                                                        </c:if>
                                                        <label class="form-check-label" for="checkbox"></label>
                                                    </div>
                                                </td>
                                            </tr>                            
                                            <tr>
                                                <td><span class="fw-bold ps-3">Passed Target</span></td>
                                                <td >
                                                    <div class="row">
                                                        <div class="col-4">
                                                            <input required="" type="number" class="form-control" id="num" min="0" max="100" name="passedTarget" value="${quiz.passedTarget}"> 

                                                        </div>
                                                        <div class="col"><p class="fw-bold h4">%</p></div>
                                                    </div>                                    
                                                </td>

                                            </tr>
                                            <tr>
                                                <td><span class="fw-bold ps-3 text-nowrap">Number of Question</span></td>
                                                <td><input required="" type="number" class="form-control w-25" id="inputNumberOfQuestionForQuiz" name="numberOfQuestion" value="${quiz.numberQuestion}" min="0" /></td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <span class="fw-bold ps-3">Duration</span>
                                                </td>
                                                <td>
                                                    <c:set value="${requestScope.time}" var="t"/>
                                                    <div class="d-flex">
                                                        <div class="me-1 ">               
                                                            <input class="form-control" placeholder="Hours" type="number" id="hours" name="hours" min="0" max="23" value="${t[0]}">
                                                        </div>
                                                        <div class=" me-1">
                                                            <input type="number" class="form-control" placeholder="minutes" id="minutes" name="minutes" min="0" max="59" value="${t[1]}">
                                                        </div>
                                                        <div class="me-3">
                                                            <input type="number"class="form-control" placeholder="seconds" id="seconds" name="seconds" min="0" max="59" value="${t[2]}">
                                                        </div>
                                                    </div>
                                                </td>
                                            </tr>
                                        </table>                        
                                    </div>
                                </div>
                            </form>
                        </div>
                        <div class="page" id="manage-question">
                            <div class="container p-3 pt-0">
                                <div class="row">
                                    <div class="col-12" id="quiz">
                                        <div class="card mb-4 shadow-sm">
                                            <div class="card-body d-flex justify-content-between align-items-center">
                                                <div class="">
                                                    <h3 class="text-break pe-5">${requestScope.quiz.title}</h3>
                                                    <div class="mt-2 ms-2">
                                                        <span class="d-flex text-center">
                                                            <span class="me-1">
                                                                <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-card-list" viewBox="0 0 16 16">
                                                                <path d="M14.5 3a.5.5 0 0 1 .5.5v9a.5.5 0 0 1-.5.5h-13a.5.5 0 0 1-.5-.5v-9a.5.5 0 0 1 .5-.5zm-13-1A1.5 1.5 0 0 0 0 3.5v9A1.5 1.5 0 0 0 1.5 14h13a1.5 1.5 0 0 0 1.5-1.5v-9A1.5 1.5 0 0 0 14.5 2z"/>
                                                                <path d="M5 8a.5.5 0 0 1 .5-.5h7a.5.5 0 0 1 0 1h-7A.5.5 0 0 1 5 8m0-2.5a.5.5 0 0 1 .5-.5h7a.5.5 0 0 1 0 1h-7a.5.5 0 0 1-.5-.5m0 5a.5.5 0 0 1 .5-.5h7a.5.5 0 0 1 0 1h-7a.5.5 0 0 1-.5-.5m-1-5a.5.5 0 1 1-1 0 .5.5 0 0 1 1 0M4 8a.5.5 0 1 1-1 0 .5.5 0 0 1 1 0m0 2.5a.5.5 0 1 1-1 0 .5.5 0 0 1 1 0"/>
                                                                </svg>                                            
                                                            </span>
                                                            <c:set var="questions" value="${requestScope.quiz.questions}" />
                                                            <span class="text-center" id="numberOfQuestion"></span>
                                                        </span>                                                            
                                                    </div>
                                                </div>
                                                <div class="d-flex">
                                                    <a href="../course/import-quiz?quizId=${requestScope.quiz.id}" class="btn btn-dark ps-3 pe-3" id="">Import</a>
                                                    <button class="btn btn-primary ps-3 pe-3 ms-2" onclick="location.reload()">Save</button>                                                    
                                                </div>
                                            </div>                                                                                                      
                                        </div>

                                        <c:forEach items="${requestScope.quiz.questions}" var="q" varStatus="i">
                                            <div class="card mb-3 shadow-sm card_question" id="question-container-${q.id}">
                                                <div class="card-body"> 
                                                    <input type="hidden" name="questionId" value="${q.id}" >
                                                    <div class="d-flex">
                                                        <small class="h5 me-1 index-question">${i.index+1}. </small>
                                                        <h5 class="mb-3 question-content">${q.content}</h5>
                                                    </div> 
                                                    <div class="list-group mb-3 " id="answer-container-question-${q.id}">
                                                        <c:forEach items="${q.answers}" var="a" varStatus="i">
                                                            <div class="list-group-item list-group-item-action" id="answer-${a.id}">                                        
                                                                <div class="d-flex ">
                                                                    <div class="form-check align-items-center d-flex ">
                                                                        <c:choose>
                                                                            <c:when test="${a.correctless}">
                                                                                <input type="radio" class="form-check-input me-2" value="${i.index}" name="radio-${q.id}" id="edit-radio-${i.index}" checked="" onclick="disabledClick(event)">
                                                                            </c:when>
                                                                            <c:otherwise>
                                                                                <input type="radio" class="form-check-input me-2" value="${i.index}" name="radio-${q.id}" id="edit-radio-${i.index}" onclick="disabledClick(event)">
                                                                            </c:otherwise>
                                                                        </c:choose> 
                                                                        <label class="form-check-label answer-content-${i.index}" for="radio">${a.content}</label>
                                                                    </div>
                                                                </div>                                        
                                                            </div>
                                                        </c:forEach>
                                                    </div>
                                                    <button class="btn btn-outline-danger delete-btn me-2" id="delete" data-id="${q.id}">Delete</button>
                                                    <button class="btn btn-primary edit"  data-bs-toggle="modal" data-bs-target="#exampleModal" data-id="${q.id}">Edit</button>

                                                </div>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </div>
                                <div class="p-2 mt2 d-flex">
                                    <button type="button" class="btn btn-dark me-3" id="addNewQuestion"">Add new question</button>                                  

                                </div>

                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!--  pop-up edit question -->
        <div div class="modal fade" id="exampleModal" data-bs-backdrop="static" data-bs-keyboard="false" aria-labelledby="staticBackdropLabel" tabindex="-1"  aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered modal-lg">
                <div class="modal-content">
                    <!-- modal body -->
                    <div class="modal-body">
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <h5 class="modal-title" id="addQuizQuestionModalLabel">Add Quiz Question</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"id="close-1"></button>
                        </div>
                        <div>
                            <!-- form -->
                            <form id="edit-form">
                                <input type="hidden" name="questionId" id="ids" value="">
                                <div class="mb-3">
                                    <div class="mb-2">
                                        <label class="form-label">Write your question</label>
                                        <input type="text" class="form-control" placeholder="Question" name="question" id="edit-question" required="">
                                    </div>
                                </div>
                                <div class="" >
                                    <h5 class="mb-2">Answer</h5>
                                    <div id="answers-container">

                                    </div>
                                    <button type="button" class="btn btn-outline-warning new-answer">Add new answer</button>
                                    <div class="d-flex justify-content-end">
                                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal" id="close-2">Cancel</button>
                                        <button type="button" class="btn btn-primary ms-2 update-question">Save</button>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>

                </div>
            </div>
        </div>
        <%@include file="../elements/footer.jsp"%>
        <script type="module" src="https://unpkg.com/ionicons@7.1.0/dist/ionicons/ionicons.esm.js"></script>
        <script nomodule src="https://unpkg.com/ionicons@7.1.0/dist/ionicons/ionicons.js"></script>
        <script>
            // click edit question
            $(document).ready(function () {
                $('#quiz').on('click', '.edit', function (e) {
                    e.preventDefault(); // Prevents the default action of the click event
                    var questionId = $(this).data('id'); // Retrieves the data-id attribute of the clicked element
                    clickEditQuestion(questionId);
                });
            });
            // Edit question
            $(document).ready(function () {
                $('#edit-form').on('click', '.update-question', function (event) {
                    event.preventDefault();
                // If the validation conditions are valid, call the submitQuestionUpdated function
                if(validateFormEditQuestion()){
                      submitQuestionUpdated();
                  }                  
                });
            });
            function validateFormEditQuestion() {
                // Check that the question cannot be left blank
                var questionInput = $('#edit-question').val().trim();
                if (questionInput === '') {
                    alert('Please do not leave questions blank.');
                    return false;
                }

                // Check that the answers are not empty
                var isAnswersValid = true;
                $('#edit-form').find('input[name="answer-question"]').each(function (index) {
                    var answerInput = $(this).val().trim();
                    if (answerInput === '') {
                        alert('Please do not leave the answer blank' + (index + 1) + '.');
                        isAnswersValid = false;
                        return false; // Stop loop if there is an empty answer
                    }
                });

                if (!isAnswersValid) {
                    return false;
                }

                // Check if the radio button selects the correct answer
                var isRadioSelected = false;
                $('#edit-form').find('input[name="radio-question"]').each(function () {
                    if ($(this).prop('checked')) {
                        isRadioSelected = true;
                        return false; // Stop the loop if a radio button is selected
                    }
                });

                if (!isRadioSelected) {
                    alert('Please choose the correct answer.');
                    return false;
                }
                if(isAnswersValid && isRadioSelected){
                    return true;
                }
            }
            // Delete question
            $(document).ready(function () {
                $('#quiz').on('click', '.delete-btn',function (event){
                                    event.preventDefault();
                var questionId = $(this).data('id');
                var $parent = $(this).parent().parent();
                deleteQuestion(questionId, $parent);
                });
            });
            // Add new question
            $(document).ready(function () {
                let count = $('.index-question').length;
                $('#addNewQuestion').on('click', function (event) {
                    event.preventDefault();
                    count++;
                    addNewQuestion(count);
                });
            });
            $(document).ready(function () {
                $('#edit-form').on('click', '.new-answer', addNewAnswerQuestion);
            });
            $(document).ready(function () {
                $('#edit-form').on('click', '.delete-answer', deleteAnswer);
            });
            function submitQuestionUpdated() {
                var questionId = $('#ids').val();
                var formData = $('#edit-form').serialize();
                console.log(formData);
                $.ajax({
                    url: 'question?id=' + questionId,
                    type: 'Post',
                    data: formData,
                    success: function (response) {
                        var questionContainer = $('#question-container-' + questionId);
                        if (questionContainer.length) {
                            questionContainer.find('.question-content').text(response.question.content);

                            response.answers.forEach(function (answer, index) {
                                var answerElement = questionContainer.find('.answer-content-' + index);
                                if (answerElement.length) {
                                    answerElement.text(answer.content);
                                    var radioInput = questionContainer.find('#edit-radio-' + index);
                                    if (answer.correctless) {
                                        radioInput.prop('checked', true);
                                    } else {
                                        radioInput.prop('checked', false);
                                    }
                                }
                            });
                        }                      
                        $('#exampleModal').modal('hide');
                        $('.modal-backdrop').remove();
                    },
                    error: function (xhr, status, error) {
                        console.error('Error:', error);
                    }
                });
            }
            function deleteQuestion(questionId, $parent) {
                console.log($parent);
                $.ajax({
                    url: 'question?action=delete&id=' + questionId,
                    type: 'Get',
                    success: function (response) {
                        if (response.success) {
                            $parent.remove();
                            updateQuestionNumbers();
                            $('#numberOfQuestion').text($('.index-question').length + ' Question');
                        } else {
                            alert('Question cannot be deleted. Please try again.');
                        }
                    },
                    error: function () {
                        alert('Error! An error occurred. Please try again..');
                    }
                });
            }
            function deleteAnswer(e) {
                e.preventDefault();
                var answerId = $(this).data('id');
                var parent = $(this).parent();

                console.log(parent);
                $.ajax({
                    url: 'question?action=delete-answer',
                    type: 'get',
                    data: {answerId: answerId},
                    success: function (response) {
                        if (response.success) {
                            parent.parent().remove();
                            $('#answer-' + answerId).remove();
                        } else {
                            alert('Question cannot be deleted. Please try again.');
                        }
                    },
                    error: function () {
                        alert('Error! An error occurred. Please try again..');
                    }
                });
            }

            function addNewAnswerQuestion(e) {
                e.preventDefault();
                var questionId = $('#ids').val();
                var count = $('input[name="answer-question"]').length;
                console.log(questionId);
                console.log(count);
                $.ajax({
                    url: "question?action=new-answer",
                    type: "get",
                    data: {id: questionId},
                    success: function (response) {
                        var htmlSnippet =
                                '<div class="mb-2">' +
                                '  <div class="mb-1 d-flex justify-content-between align-items-center me-5">' +
                                '      <h6 class="mb-0 fw-normal">Choice ' + (count + 1) + ' </h6>' +
                                '      <div>' +
                                '          <div class="d-flex align-items-center lh-1">' +
                                '              <span>Correct answer</span>' +
                                '              <div class="form-check form-switch ms-2">' +
                                '                  <input class="form-check-input me-0" type="radio" name="radio-question" value="' + count + '" role="switch" id="edit-radio-form-' + count + '">' +
                                '                  <label class="form-check-label" for="edit-radio-form-' + count + '"></label>' +
                                '              </div>' +
                                '          </div>' +
                                '      </div>' +
                                '  </div>' +
                                '  <div class="d-flex">' +
                                '      <input type="text" placeholder="Write the answer" class="form-control" id="edit-answer-' + count + '" name="answer-question" value="">' +
                                '      <button type="button" class="btn btn-outline-danger rounded-3 ms-2 delete-answer" data-id="' + response.answerId + '">' +
                                '          <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-x-lg" viewBox="0 0 16 16">' +
                                '              <path d="M2.146 2.854a.5.5 0 1 1 .708-.708L8 7.293l5.146-5.147a.5.5 0 0 1 .708.708L8.707 8l5.147 5.146a.5.5 0 0 1-.708.708L8 8.707l-5.146 5.147a.5.5 0 0 1-.708-.708L7.293 8z"/>' +
                                '          </svg>' +
                                '      </button>' +
                                '  </div>' +
                                '</div>';
                        $('#answers-container').append(htmlSnippet);

                        const listItem = $('<div class="list-group-item list-group-item-action" id="answer-' + response.answerId + '"></div>');
                        const answerDiv = $('<div class="d-flex"></div>');
                        const formCheck = $('<div class="form-check align-items-center d-flex"></div>');
                        const inputRadio = $('<input type="radio" class="form-check-input me-2" name="radio-' + questionId + '" id="edit-radio-' + count + '" onclick="disabledClick(event)">');
                        const inputText = $('<label class="form-check-label answer-content-' + count + '" for="radio">Answer ' + (count + 1) + '</label>');
                        formCheck.append(inputRadio);
                        formCheck.append(inputText);
                        answerDiv.append(formCheck);
                        listItem.append(answerDiv);
                        $('#answer-container-question-' + questionId).append(listItem);
                        console.log($('#answer-container-question-' + questionId));
                    },
                    error: function () {
                        alert('Error');
                    }
                });
            }
            function addNewQuestion(countQuestion) {
                $.ajax({
                    url: "question?action=add", // URL của servlet
                    type: "GET",
                    data: {quizId: ${requestScope.quiz.id}},
                    dataType: 'json',
                    success: function (data) {
                        const cardDiv = $('<div class="card mb-3 shadow-sm card_question" id="question-container-' + data.newQuestionId + '"></div>');
                        const cardBody = $('<div class="card-body"></div>');
                        const hidden = $('<input type="hidden" name="questionId" value="' + data.newQuestionId + '">');
                        cardBody.append(hidden);
                        const divFlex = $('<div class="d-flex"></div>');
                        const spanIndex = $(' <small class="h5 me-1 index-question"></small>');
                        const question = $('<h5 class="mb-3 question-content"><h5>');
                        divFlex.append(spanIndex);
                        divFlex.append(question);
                        cardBody.append(divFlex);
                        const listGroup = $('<div class="list-group mb-3" id="answer-container-question-' + data.newQuestionId + '"></div>');
                        var answers = data.answers;
                        for (var i = 0; i < answers.length; i++) {
                            const listItem = $('<div class="list-group-item list-group-item-action"></div>');
                            const answerDiv = $('<div class="d-flex"></div>');
                            const formCheck = $('<div class="form-check align-items-center d-flex"></div>');
                            const inputRadio = $('<input type="radio" class="form-check-input me-2" name="radio-' + data.newQuestionId + '" id="edit-radio-' + i + '" onclick="disabledClick(event)">');
                            const inputText = $('<label class="form-check-label answer-content-' + i + '" for="radio">Answer ' + (i + 1) + '</label>');
                            formCheck.append(inputRadio);
                            formCheck.append(inputText);
                            answerDiv.append(formCheck);
                            listItem.append(answerDiv);
                            listGroup.append(listItem);
                        }
                        cardBody.append(listGroup);
                        const deleteQues = $('<button class="btn btn-outline-danger delete-btn me-2" id="delete" data-id="' + data.newQuestionId + '">Delete</button>');
                        const editLink = $('<button class="btn btn-primary edit" data-bs-toggle="modal" data-bs-target="#exampleModal"data-id="' + data.newQuestionId + '">Edit</button>');
                        cardBody.append(deleteQues, editLink);
                        cardDiv.append(cardBody);
                        $('#quiz').append(cardDiv); // Append to the quiz container

                        clickEditQuestion(data.newQuestionId);
                        $('#exampleModal').modal('show');
                        $('.modal-backdrop').show();
                        updateQuestionNumbers();
                        $('#numberOfQuestion').text($('.index-question').length + ' Question');
                    },
                    error: function (xhr, status, error) {
                        console.error("Error: " + error);
                    }
                });
                $('#numberOfQuestion').text($('.index-question').length + ' Question');
            }

            function clickEditQuestion(questionId) {
                $.ajax({
                    url: 'question?action=edit&id=' + questionId,
                    type: 'GET',
                    success: function (response) {
                        // Update modal or form elements with question and answers data
                        $('#ids').val(response.question.id);
                        $('#addQuizQuestionModalLabel').text('Edit Quiz Question - ' + questionId);
                        $('#edit-question').val(response.question.content);
                        // Construct HTML for answers
                        let htmlSnippet = '';
                        for (let i = 0; i < response.answers.length; i++) {
                            htmlSnippet +=
                                    '<div class="mb-2">' +
                                    '  <div class="mb-1 d-flex justify-content-between align-items-center me-5">' +
                                    '      <h6 class="mb-0 fw-normal">Choice ' + (i + 1) + ' </h6>' +
                                    '      <div>' +
                                    '          <div class="d-flex align-items-center lh-1">' +
                                    '              <span>Correct answer</span>' +
                                    '              <div class="form-check form-switch ms-2">' +
                                    '                  <input class="form-check-input me-0" type="radio" name="radio-question" value="' + i + '" role="switch" id="edit-radio-form-' + i + '" ' + (response.answers[i].correctless ? 'checked' : '') + '>' +
                                    '                  <label class="form-check-label" for="edit-radio-form-' + i + '"></label>' +
                                    '              </div>' +
                                    '          </div>' +
                                    '      </div>' +
                                    '  </div>' +
                                    '  <div class="d-flex">' +
                                    '      <input type="text" placeholder="Write the answer" class="form-control" id="edit-answer-' + i + '" name="answer-question" value="' + (response.answers[i].content !== undefined ? response.answers[i].content : "") + '">' +
                                    '      <button type="button" class="btn btn-outline-danger rounded-3 ms-2 delete-answer" data-id="' + response.answers[i].id + '">' +
                                    '          <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-x-lg" viewBox="0 0 16 16">' +
                                    '              <path d="M2.146 2.854a.5.5 0 1 1 .708-.708L8 7.293l5.146-5.147a.5.5 0 0 1 .708.708L8.707 8l5.147 5.146a.5.5 0 0 1-.708.708L8 8.707l-5.146 5.147a.5.5 0 0 1-.708-.708L7.293 8z"/>' +
                                    '          </svg>' +
                                    '      </button>' +
                                    '  </div>' +
                                    '</div>';
                        }


                        // Set the HTML content of #answers-container
                        $('#answers-container').html(htmlSnippet);
                    },
                    error: function () {
                        alert('Error occurred while fetching question data.');
                    }
                });
            }


            function updateQuestionNumbers() {
                const small = document.querySelectorAll('.index-question');
                for (let i = 0; i < small.length; i++) {
                    small[i].textContent = i + 1 + ". ";
                }
                return small.length;
            }


            var tabs = document.getElementsByClassName("tab");
            var pages = document.getElementsByClassName("page");
            function show(e) {
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
            show(0);
            function disabledClick(event) {
                event.preventDefault();
            }
            document.getElementById('numberOfQuestion').textContent = (updateQuestionNumbers() + ' Question');
            const inputNum = document.getElementById('inputNumberOfQuestionForQuiz');
            inputNum.addEventListener('click', () => {
                let numQuestion = updateQuestionNumbers();
                if (numQuestion >= 1) {
                    inputNum.min = 1;
                    inputNum.max = numQuestion;
                } else {
                    inputNum.value = 0;
                    inputNum.min = 0;
                    inputNum.max = 0;
                }
            });
            $(document).ready(function () {
                $('#close-1').on('click', function (event){
                event.preventDefault();                                                        
                var questionId = $('#ids').val();
                console.log(questionId);
                var $parent = $('#question-container-'+questionId);
                if(!validateFormEditQuestion()){
                deleteQuestion(questionId, $parent);}
                });
                $('#close-2').on('click', function (event){
                event.preventDefault();                                                        
                var questionId = $('#ids').val();
                console.log(questionId);
                var $parent = $('#question-container-'+questionId);
                if(!validateFormEditQuestion()){
                deleteQuestion(questionId, $parent);}
                });
            });            
        </script>
    </body>
</html>
