<%-- 
    Document   : upload-video
    Created on : Jun 8, 2024, 6:19:31 PM
    Author     : HieuTC
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!doctype html>
<html lang="en">
    <head>
        <meta charset="utf-8"/>
        <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
        <title>EduPort</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
        <link href="../../view/assets/css/base.css" rel="stylesheet"/>
        <link href="../../view/assets/css/hieutc.css" rel="stylesheet"/>
        <link href="https://cdn.jsdelivr.net/npm/quill@2.0.2/dist/quill.snow.css" rel="stylesheet" />
        <style>
            .container {
                width: 50vw;
            }
        </style>
    <body class="container">
        <form action="../../upload" method="post" enctype="multipart/form-data">
        <input type="file" name="file" id="file">
        <input type="submit" value="Upload">
    </form>
        <form action="../../upload"
              enctype="multipart/form-data"
              method="post" id="form"/>
        <input class="d-none" type="file"
               id="file" onchange="document.getElementById('form').submit();"/>
        <label for="file">
            Select
        </label>
    </form>
    <div class="pt-2">
        <table class="table">
            <thead class="fw-bold">
                <tr>
                    <td>Filename</td>
                    <td>Type</td>
                    <td>Status</td>
                    <td>Date</td>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td colspan="4" class="text-center">
                        No results found.
                    </td>
                </tr>
            </tbody>
        </table>
    </div>
</body>
</html>
