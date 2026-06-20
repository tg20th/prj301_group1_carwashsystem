
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>


<!DOCTYPE html>
<c:if test="${empty sessionScope.ACCOUNT}">
    <jsp:forward page="index.jsp"/>
</c:if>
<html>

    <head>

        <meta charset="UTF-8">

        <title>Add Business Vehicles</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
              rel="stylesheet">

        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css"
              rel="stylesheet">

    </head>

    <body style="background:#f4f6f9;">
        <div class="position-absolute top-0 start-0 p-4">

            <a href="BusinessDashboardController"
               class="btn btn-light shadow rounded-pill px-4">

                <i class="bi bi-arrow-left"></i>
                Back Dashboard

            </a>

        </div>
        <div class="container py-5">

            <div class="row justify-content-center">

                <div class="col-lg-7">

                    <div class="card border-0 shadow-lg rounded-4">

                        <div class="card-body p-5">

                            <!-- HEADER -->
                            <div class="text-center mb-4">

                                <div class="bg-dark text-white rounded-circle
                                     d-flex align-items-center
                                     justify-content-center
                                     mx-auto mb-3"
                                     style="width:80px;height:80px;">

                                    <i class="bi bi-truck fs-1"></i>

                                </div>

                                <h2 class="fw-bold">

                                    Add Business Vehicles

                                </h2>

                                <p class="text-muted">

                                    Upload CSV data and ZIP image package

                                </p>

                            </div>

                            <!-- MESSAGE -->
                            <%
                                String success
                                        = (String) request.getAttribute("SUCCESS");

                                String error
                                        = (String) request.getAttribute("ERROR");
                            %>

                            <% if (success != null) {%>

                            <div class="alert alert-success rounded-3">

                                <i class="bi bi-check-circle-fill me-2"></i>

                                <%= success%>

                            </div>

                            <% } %>

                            <% if (error != null) {%>

                            <div class="alert alert-danger rounded-3">

                                <i class="bi bi-exclamation-triangle-fill me-2"></i>

                                <%= error%>

                            </div>

                            <% }%>

                            <!-- FORM -->
                            <form action="MainController"
                                  method="post"
                                  enctype="multipart/form-data">

                                <input type="hidden"
                                       name="action"
                                       value="AddBusinessVehicles">

                                <!-- CSV -->
                                <div class="mb-4">

                                    <label class="form-label fw-semibold">

                                        Vehicle CSV File

                                    </label>

                                    <input type="file"
                                           name="csvFile"
                                           accept=".csv"
                                           class="form-control form-control-lg rounded-3"
                                           required>

                                    <div class="form-text">

                                        Upload vehicle data in CSV format.

                                    </div>

                                </div>

                                <!-- ZIP -->
                                <div class="mb-4">

                                    <label class="form-label fw-semibold">

                                        Vehicle Images ZIP

                                    </label>

                                    <input type="file"
                                           name="zipFile"
                                           accept=".zip"
                                           class="form-control form-control-lg rounded-3"
                                           required>

                                    <div class="form-text">

                                        ZIP file must contain all vehicle images.

                                    </div>

                                </div>

                                <!-- GUIDE -->
                                <div class="alert alert-light border rounded-3">

                                    <h6 class="fw-bold mb-3">

                                        CSV Example

                                    </h6>

                                    <pre class="mb-0">
LicensePlate,Brand,Model,Color,Year,Image
51A12345,Toyota,Vios,Black,2022,51A12345.jpg
59B88888,Honda,City,White,2023,59B88888.png
                                    </pre>

                                </div>

                                <!-- BUTTON -->
                                <button type="submit"
                                        class="btn btn-dark w-100
                                        rounded-pill py-3 fw-semibold mt-4">

                                    <i class="bi bi-upload me-2"></i>

                                    Upload Vehicles

                                </button>

                            </form>

                        </div>

                    </div>

                </div>

            </div>

        </div>

    </body>

</html>

