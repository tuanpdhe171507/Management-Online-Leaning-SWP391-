<%-- 
    Document   : slidebar
    Created on : Jul 6, 2024, 6:12:44 AM
    Author     : HieuTC
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<div class="col-3 pt-5 pe-5">
                <div class="pb-2">
                    <h5 class="fw-bold">Plan course</h5>
                    <button class="btn w-100 text-start p-3 fw-bold tab"
                            onclick="openHyperLink('intended-learner?id=${param.id}')">
                        Intended learner
                    </button>
                    <button class="btn w-100 text-start p-3 fw-bold tab"
                            onclick="openHyperLink('loading-page?id=${param.id}')">
                        Loading page
                    </button>
                </div>
                <div class="pb-2">
                    <h5 class="fw-bold">Create content</h5>
                    <button class="btn w-100 text-start p-3 fw-bold tab"
                            onclick="openHyperLink('curriculum?id=${param.id}')">
                        Curriculum
                    </button>
                    <button class="btn w-100 text-start p-3 fw-bold tab" 
                            onclick="openHyperLink('pricing?id=${param.id}')">
                        Pricing
                    </button>
                </div>
                <button class="btn btn-warning mt-3 text-center fw-bold p-3 w-100" type="button">
                    Submit for reviewing
                </button>
            </div>