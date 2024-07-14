<%@page import="java.net.URLEncoder"%>
<%@page import="java.nio.charset.StandardCharsets"%>
<%@page import="util.Vnpay"%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.Collections"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Enumeration"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <!-- The above 3 meta tags *must* come first in the head; any other head content must come *after* these tags -->
        <title>Checkout</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
        <link href="view/assets/css/base.css" rel="stylesheet"/>
        <script type="text/javascript">
            if (!sessionStorage.getItem('refreshed')) {
                sessionStorage.setItem('refreshed', 'true');
                location.reload();
            }
        </script>

    </head>
    <body>
        <%@include file="../elements/navbar.jsp"%>
        <%
            //Begin process return from VNPAY
            Map fields = new HashMap();
            for (Enumeration params = request.getParameterNames(); params.hasMoreElements();) {
                String fieldName = URLEncoder.encode((String) params.nextElement(), StandardCharsets.US_ASCII.toString());
                String fieldValue = URLEncoder.encode(request.getParameter(fieldName), StandardCharsets.US_ASCII.toString());
                if ((fieldValue != null) && (fieldValue.length() > 0)) {
                    fields.put(fieldName, fieldValue);
                }
            }

            String vnp_SecureHash = request.getParameter("vnp_SecureHash");
            if (fields.containsKey("vnp_SecureHashType")) {
                fields.remove("vnp_SecureHashType");    
            }
            if (fields.containsKey("vnp_SecureHash")) {
                fields.remove("vnp_SecureHash");
            }
            String signValue = Vnpay.hashAllFields(fields);

        %>
        <div class="container text-center p-5 ">
            <div class="row">
                <div class="col-3"></div>
                <div class="col-6 rounded shadow" style="border: 1px solid;">
                    <h5>
                        <c:choose>
                            <c:when test="${signValue eq vnp_SecureHash}">
                                <c:choose>
                                    <c:when test="${requestScope.vnp_TransactionStatus eq '00'}">
                                        <i style="color:#007060; font-size: 4em;" class="bi bi-check-circle-fill"></i>
                                    </c:when>
                                    <c:otherwise>
                                        <i style="color:red; font-size: 4em;" class="bi bi-x-circle-fill"></i>
                                    </c:otherwise>
                                </c:choose>
                            </c:when>
                            <c:otherwise>
                                invalid signature
                            </c:otherwise>
                        </c:choose>
                    </h5>
                    <div class="row g-0 text-center">
                        <div class=" col-md-8"> <h2 style="margin-right: -180px" id="convertedAmount" ></h2> </div>
                        <div class=" col-md-4"> <i style="font-size: 1em; margin-left:-300px" class="bi bi-currency-dollar"></i></div>
                    </div>
                    <hr>
                    <div class="row">
                        <h5>
                            Mã giao dịch thanh toán: <span>${requestScope.vnp_TxnRef}</span> 
                        </h5>
                    </div>
                    <div class="row">
                        <h5>
                            Mã ngân hàng thanh toán: <span>${requestScope.vnp_BankCode}</span> 
                        </h5>
                    </div>
                    <div class="row">
                        <h5>
                            Thời gian thanh toán: <span id="formattedPayDate"></span>
                        </h5>
                    </div>
                    <a style="margin-bottom: 10px;" class="btn btn-dark" href="<%=request.getContextPath() + "/my-courses"%>">My courses</a>
                </div>
                <div class="col-3"></div>
            </div>
        </div>

        <%@include file="../elements/footer.jsp"%>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script type="module" src="https://unpkg.com/ionicons@7.1.0/dist/ionicons/ionicons.esm.js"></script>
        <script nomodule src="https://unpkg.com/ionicons@7.1.0/dist/ionicons/ionicons.js"></script>
        <script>
            var vnp_Amount = ${requestScope.vnp_Amount};
            var convertedAmount = vnp_Amount / 23000;
            document.getElementById('convertedAmount').innerText = convertedAmount.toFixed(2);


            var vnp_PayDate = "${requestScope.vnp_PayDate}";
            var year = vnp_PayDate.substring(0, 4);
            var month = vnp_PayDate.substring(4, 6);
            var day = vnp_PayDate.substring(6, 8);
            var formattedDate = day + "/" + month + "/" + year.substring(2);
            document.getElementById('formattedPayDate').innerText = formattedDate;
        </script>
    </body>
</html>
