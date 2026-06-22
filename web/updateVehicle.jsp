
<%@page import="dto.Business"%>
<%@page import="dto.Account"%>
<%@page import="dto.Account"%>
<%@page import="dto.Vehicle"%>
<%@page import="dto.VehicleBrand"%>
<%@page import="dto.VehicleModel"%>
<%@page import="java.util.ArrayList"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    if (session.getAttribute("ACCOUNT") == null) {
        response.sendRedirect("index.jsp");
        return;
    }
    Vehicle vehicle = (Vehicle) request.getAttribute("VEHICLE");
    if (vehicle == null) {
        response.sendRedirect("MainController?action=dashboard");
        return;
    }
    ArrayList<VehicleBrand> brandList = (ArrayList<VehicleBrand>) request.getAttribute("BRAND_LIST");
    ArrayList<VehicleModel> modelList = (ArrayList<VehicleModel>) request.getAttribute("MODEL_LIST");
    Business bus = (Business) session.getAttribute("BUS");

    String dashboardURL;

    if (bus != null) {
        dashboardURL = "MainController?action=business_dashboard";
    } else {
        dashboardURL = "MainController?action=customer_dashboard";
    }
%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Update Vehicle</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css"rel="stylesheet">
    </head>
    <body style="background:#f5f7fa;">
        <div class="position-absolute top-0 start-0 p-4">
            <a href="<%= dashboardURL%>"
               class="btn btn-light shadow rounded-pill px-4">

                <i class="bi bi-arrow-left"></i>
                Back Dashboard
            </a>
        </div>
        <div class="container py-5 min-vh-100 d-flex align-items-center">
            <div class="row justify-content-center w-100">
                <div class="col-lg-7">
                    <div class="card border-0 shadow-lg rounded-4">
                        <div class="card-body p-5">
                            <div class="text-center mb-4">
                                <div class="bg-light rounded-circle
                                     d-flex align-items-center
                                     justify-content-center
                                     mx-auto mb-3"
                                     style="width:70px;height:70px;">
                                    <i class="bi bi-pencil-square fs-2"></i>
                                </div>
                                <h2 class="fw-bold">
                                    Update Vehicle
                                </h2>
                                <p class="text-muted">
                                    Update your vehicle information
                                </p>
                            </div>
                            <%
                                String error = (String) request.getAttribute("ERROR");
                                if (error != null) {
                            %>
                            <div class="alert alert-danger">
                                <%= error%>
                            </div>
                            <%
                                }
                            %>
                            <form action="MainController" method="post"
                                  enctype="multipart/form-data">
                                <input type="hidden" name="action" value="UpdateVehicle">
                                <input type="hidden" name="vehicleID" value="<%= vehicle.getVehicleID()%>">
                                <!-- IMAGE PREVIEW -->
                                <div class="mb-4 text-center">
                                    <label class="form-label fw-semibold d-block mb-3">
                                        Vehicle Image
                                    </label>
                                    <%
                                        String imageURL = vehicle.getImageURL();
                                        if (imageURL == null || imageURL.trim().isEmpty()) {
                                            imageURL = "images/no-image.png";
                                        }
                                    %>
                                    <img id="previewImage"
                                         src="<%= request.getContextPath() + "/" + imageURL%>"
                                         class="img-fluid rounded-4 shadow border"
                                         style=" width:100%;max-width:500px;height:320px; object-fit:cover; ">
                                </div>
                                <!-- LICENSE -->
                                <div class="mb-3">
                                    <label class="form-label fw-semibold">
                                        License Plate
                                    </label>
                                    <input type="text"
                                           name="licensePlate"
                                           value="<%= vehicle.getLicensePlate()%>"
                                           class="form-control form-control-lg rounded-3 text-uppercase"
                                           pattern="[0-9]{2}[A-Z]-[0-9]{5}"
                                           title="Format: 63A-12345 (2 digits, 1 letter, hyphen, 5 digits)"
                                           placeholder="e.g. 63A-12345"
                                           required>
                                </div>
                                <!-- BRAND -->
                                <div class="mb-3">
                                    <label class="form-label fw-semibold">
                                        Brand
                                    </label>
                                    <select id="brandSelect"
                                            class="form-select form-select-lg rounded-3">
                                        <%
                                            for (VehicleBrand b : brandList) {
                                        %>
                                        <option value="<%= b.getBrandID()%>">
                                            <%= b.getBrandName()%>
                                        </option>
                                        <%
                                            }
                                        %>
                                    </select>
                                </div>
                                <!-- MODEL -->
                                <div class="mb-3">
                                    <label class="form-label fw-semibold">
                                        Model
                                    </label>
                                    <select name="modelID"
                                            id="modelSelect"
                                            class="form-select form-select-lg rounded-3">
                                        <%
                                            for (VehicleModel m : modelList) {
                                        %>
                                        <option value="<%= m.getModelID()%>"
                                                data-brand="<%= m.getBrandID()%>"
                                                <%= m.getModelID() == vehicle.getModelID() ? "selected" : ""%>>
                                            <%= m.getModelName()%>
                                        </option>
                                        <%
                                            }
                                        %>
                                    </select>
                                </div>
                                <!-- COLOR -->
                                <div class="mb-3">
                                    <label class="form-label fw-semibold">
                                        Color
                                    </label>
                                    <input type="text"
                                           name="color"
                                           value="<%= vehicle.getColor()%>"
                                           class="form-control form-control-lg rounded-3">
                                </div>
                                <!-- YEAR -->
                                <div class="mb-4">
                                    <label class="form-label fw-semibold">
                                        Manufacture Year
                                    </label>
                                    <input type="number"
                                           name="manufactureYear"
                                           value="<%= vehicle.getManufactureYear()%>"
                                           class="form-control form-control-lg rounded-3">
                                </div>
                                <!-- IMAGE -->
                                <div class="mb-4">
                                    <label class="form-label fw-semibold">
                                        New Vehicle Image
                                    </label>
                                    <input type="file"
                                           name="vehicleImage"
                                           accept="image/*"
                                           class="form-control form-control-lg rounded-3"
                                           onchange="previewNewImage(event)">
                                </div>
                                <div class="alert alert-warning">
                                    <i class="bi bi-info-circle-fill me-2"></i>
                                    Updating vehicle requires admin approval again.
                                </div>
                                <button type="submit"
                                        class="btn btn-dark w-100 rounded-pill py-3 fw-semibold">
                                    <i class="bi bi-check-lg me-2"></i>
                                    Update Vehicle
                                </button>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <script>
            function previewNewImage(event) {
                const image = document.getElementById("previewImage");
                image.src = URL.createObjectURL(event.target.files[0]);
            }
            const brandSelect = document.getElementById("brandSelect");

            const modelSelect = document.getElementById("modelSelect");
            function filterModels() {
                const brandID = brandSelect.value;
                Array.from(modelSelect.options).forEach(option => {
                    option.style.display
                            = option.dataset.brand === brandID
                            ? "block"
                            : "none";

                });

            }
            brandSelect.addEventListener("change", filterModels);
            filterModels();

        </script>

    </body>

</html>

