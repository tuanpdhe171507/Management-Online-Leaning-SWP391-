<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <!-- The above 3 meta tags *must* come first in the head; any other head content must come *after* these tags -->
        <meta name="description" content="">
        <meta name="author" content="">
        <title>Checkout</title>

        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
        <link href="view/assets/css/base.css" rel="stylesheet"/>
        <script src="view/assets/js/huylq.js"></script>
        <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css">
        <style>
            .heading {
                font-size: 40px;
                margin-top: 35px;
                margin-bottom: 30px;
                padding-left: 20px
            }
            .card {
                margin-top: 60px;
                margin-bottom: 60px
            }
            .radio-group {
                position: relative;
                margin-bottom: 25px
            }
            .radio {
                display: inline-block;
                border-radius: 6px;
                box-sizing: border-box;
                border: 2px solid lightgrey;
                cursor: pointer;
                margin: 12px 25px 12px 0px;
                width: 150px;
            }
            .radio.selected {
                box-shadow: 0px 0px 0px 1px rgba(0, 0, 155, 0.4);
                border: 3px solid  #000000;
            }
            .label-radio {
                font-weight: bold;
                color: #000000
            }
        </style>
    </head>
    <body>
        <%@include file="../elements/navbar.jsp"%>
        <div class="container-fluid">
            <div class="row justify-content-center">
                <div class=" col-lg-6">
                    <div class="card p-3">
                        <h2 class=" text-center">Checkout</h2>
                        <form action="VNPay" id="frmCreateOrder" method="post">
                            <input type="hidden" value="${param.plan}" name="plan">
                            <div class="form-group ">
                                <h5 >Số tiền:</h5>
                                <span class="form-control" id="amount">${requestScope.totalPrice}</span>
                                <input type="hidden" class="form-control  " data-val="true"
                                       data-val-number="The field Amount must be a number."
                                       data-val-required="The Amount field is required." id="amount" max="100000000" min="1"
                                       name="amount" type="number" value="${requestScope.totalPrice}" />
                            </div>

                            <h4>Chọn phương thức thanh toán:</h4>
                            <div class="row justify-content-center radio-group">
                                <div class="col-5 row">
                                    <input class="d-none" type="radio" id="bankCode1"  name="bankCode" value="VNBANK">
                                    <label style="width:170px" for="bankCode1" class="radio mx-auto rounded" ><img style="width:150px; height:100px"
                                            src="https://vnpay.vn/s1/statics.vnpay.vn/2023/9/06ncktiwd6dc1694418196384.png"
                                            ><br>Thanh toán qua ngân hàng nội địa</label>
                                </div>
                                <div class="col-5 row" >
                                    <input class="d-none" type="radio" id="bankCode2" name="bankCode" value="INTCARD">
                                    <label style="padding-left: 10px;width:170px" class="radio mx-auto rounded"  for="bankCode2" ><img style="width:130px; height:100px"
                                            src="https://static.thenounproject.com/png/1878946-200.png" > Thanh toán qua thẻ quốc tế</label>
                                </div>
                            </div>
                            <div class=" form-group">
                                <h4>Chọn ngôn ngữ giao diện thanh toán:</h4>
                                <div class="col-12" style="padding-left: 235px;">
                                    <div class="custom-control custom-radio custom-control-inline">
                                        <input type="radio" class="custom-control-input" id="language_vn" name="language"
                                               value="vn" >
                                        <label for="language_vn" class="custom-control-label label-radio">Tiếng Việt</label>
                                    </div>
                                    <div  class="custom-control custom-radio custom-control-inline">
                                        <input type="radio" class="custom-control-input" id="language_en" name="language"
                                               value="en">
                                        <label for="language_en" class="custom-control-label label-radio">English</label>
                                    </div>
                                </div>
                            </div>
                            <div class="text-center">
                                <button type="submit" style="background-color: #000000; border: none;" class="btn btn-primary rounded">Thanh toán</button>
                            </div>

                        </form>
                    </div>
                </div>
            </div>
        </div>
        <%@include file="../elements/footer.jsp"%>
        <link href="https://pay.vnpay.vn/lib/vnpay/vnpay.css" rel="stylesheet" />
        <script src="https://pay.vnpay.vn/lib/vnpay/vnpay.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script type="module" src="https://unpkg.com/ionicons@7.1.0/dist/ionicons/ionicons.esm.js"></script>
        <script nomodule src="https://unpkg.com/ionicons@7.1.0/dist/ionicons/ionicons.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
        <script type="text/javascript">
            $("#frmCreateOrder").submit(function () {
                var postData = $("#frmCreateOrder").serialize();
                var submitUrl = $("#frmCreateOrder").attr("action");
                $.ajax({
                    type: "POST",
                    url: submitUrl,
                    data: postData,
                    dataType: 'JSON',
                    success: function (x) {
                        if (x.code === '00') {
                            if (window.vnpay) {
                                vnpay.open({width: 768, height: 600, url: x.data});
                            } else {
                                location.href = x.data;
                            }
                            return false;
                        } else {
                            alert(x.Message);
                        }
                    }
                });
                return false;
            });
            // Radio button
            $('.radio-group .radio').click(function () {
                $(this).parent().parent().find('.radio').removeClass('selected');
                $(this).addClass('selected');
            });
        </script>       
    </body>
</html>