
<%@page import="java.util.ArrayList"%>
<%@page import="dto.VehicleModel"%>
<%@page import="dto.VehicleBrand"%>
<%@page import="dto.Vehicle"%>
<%@page import="dto.Customer"%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    Customer cus = (Customer) session.getAttribute("CUSTOMER");
    if (cus == null) {
        response.sendRedirect("index.jsp");
        return;
    }
    Vehicle v = (Vehicle) request.getAttribute("VEHICLE");
    if (v == null) {
        response.sendRedirect("CustomerDashBoardController");
        return;
    }
    ArrayList<VehicleBrand> brandList= (ArrayList<VehicleBrand>)request.getAttribute("BRAND_LIST");
    ArrayList<VehicleModel> modelList = (ArrayList<VehicleModel>) request.getAttribute("MODEL_LIST");
    String error= (String) request.getAttribute("ERROR");
%>

<!DOCTYPE html>

<html lang="en">

<head>

    <meta charset="UTF-8">

    <title>Update Vehicle</title>

    <!-- Bootstrap -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
          rel="stylesheet">

    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css"
          rel="stylesheet">

    <link href="css/style.css"
          rel="stylesheet">

</head>

<body style="background-color: var(--bg-card);">

    <!-- BACK -->
    <div class="position-absolute top-0 start-0 p-4">

        <a href="MainController?action=dashboard"
           class="btn btn-light shadow-sm rounded-pill px-4">

            <i class="bi bi-arrow-left me-2"></i>
            Back

        </a>

    </div>

    <!-- MAIN -->
    <div class="container py-5 min-vh-100 d-flex align-items-center justify-content-center">

        <div class="col-md-8 col-lg-6">

            <div class="bg-white p-5 rounded-4 shadow-sm border">

                <!-- HEADER -->
                <div class="text-center mb-4">

                    <div class="bg-light rounded-circle d-flex align-items-center justify-content-center mx-auto mb-3"
                         style="width:70px;height:70px;">

                        <i class="bi bi-pencil-square fs-2"></i>

                    </div>

                    <h3 class="fw-bold">
                        Update Vehicle
                    </h3>

                    <p class="text-muted small">
                        Update your vehicle information
                    </p>

                </div>

                <!-- ERROR -->
                <% if (error != null) { %>

                <div class="alert alert-danger">
                    <%= error %>
                </div>

                <% } %>

                <!-- FORM -->
                <form action="MainController"
                      method="post"
                      enctype="multipart/form-data">

                    <input type="hidden"
                           name="action"
                           value="UpdateVehicle">

                    <input type="hidden"
                           name="vehicleID"
                           value="<%= v.getVehicleID() %>">

                    <!-- LICENSE -->
                    <div class="mb-4">

                        <label class="form-label fw-semibold">

                            License Plate

                        </label>

                        <input type="text"
                               name="licensePlate"
                               class="form-control form-control-lg"
                               value="<%= v.getLicensePlate() %>"
                               required>

                    </div>

                    <!-- BRAND -->
                    <div class="mb-4">

                        <label class="form-label fw-semibold">

                            Vehicle Brand

                        </label>

                        <select class="form-select form-select-lg"
                                disabled>

                            <option>
                                <%= v.getBrandName() %>
                            </option>

                        </select>

                    </div>

                    <!-- MODEL -->
                    <div class="mb-4">

                        <label class="form-label fw-semibold">

                            Vehicle Model

                        </label>

                        <select name="modelID"
                                class="form-select form-select-lg"
                                required>

                            <% for (VehicleModel m : modelList) { %>

                            <option value="<%= m.getModelID() %>"
                                    <%= m.getModelID() == v.getModelID()
                                    ? "selected"
                                    : "" %>>

                                <%= m.getModelName() %>

                            </option>

                            <% } %>

                        </select>

                    </div>

                    <!-- COLOR -->
                    <div class="mb-4">

                        <label class="form-label fw-semibold">

                            Color

                        </label>

                        <input type="text"
                               name="color"
                               class="form-control form-control-lg"
                               value="<%= v.getColor() %>">

                    </div>

                    <!-- YEAR -->
                    <div class="mb-4">

                        <label class="form-label fw-semibold">

                            Manufacture Year

                        </label>

                        <input type="number"
                               name="manufactureYear"
                               class="form-control form-control-lg"
                               value="<%= v.getManufactureYear() %>">

                    </div>

                    <!-- CURRENT IMAGE -->
                    <div class="mb-4">

                        <label class="form-label fw-semibold">

                            Current Image

                        </label>

                        <div class="text-center">

                            <img src="<%= v.getImageURL() %>"
                                 class="img-fluid rounded-4 border shadow-sm"
                                 style="max-height:220px;">

                        </div>

                    </div>
                    <!-- NEW IMAGE -->
                    <div class="mb-4">

                        <label class="form-label fw-semibold">

                            Upload New Image

                        </label>

                        <input type="file"
                               name="image"
                               class="form-control form-control-lg"
                               accept="image/*">

                    </div>

                    <!-- BUTTON -->
                    <button type="submit"
                            class="btn btn-dark w-100 py-3 rounded-pill fw-semibold">

                        <i class="bi bi-check-circle me-2"></i>
                        Update Vehicle

                    </button>

                </form>

            </div>

        </div>

    </div>

</body>

</html>

