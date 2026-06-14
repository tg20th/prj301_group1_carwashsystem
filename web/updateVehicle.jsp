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

    String error = (String) request.getAttribute("ERROR");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Update Vehicle | Elite Auto</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="css/style.css" rel="stylesheet">
</head>
<body style="background-color: var(--bg-card);">

    <div class="position-absolute top-0 start-0 p-4 z-3 animate-fade-up">
        <a href="MainController?action=dashboard" class="d-inline-flex align-items-center bg-white rounded-pill shadow-sm px-4 py-2 text-dark fw-medium text-decoration-none transition-hover border border-light">
            <i class="bi bi-arrow-left me-2"></i> Back to Dashboard
        </a>
    </div>

    <div class="container py-5 min-vh-100 d-flex flex-column justify-content-center animate-fade-up">
        
        <div class="row justify-content-center w-100 mx-0">
            <div class="col-md-8 col-lg-5">
                
                <div class="bg-white p-4 p-sm-5 rounded-4 shadow-sm border border-light transition-hover delay-1">
                    
                    <div class="text-center mb-4 pb-2">
                        <div class="bg-light rounded-circle d-flex align-items-center justify-content-center mx-auto mb-3 float-anim" style="width: 60px; height: 60px;">
                            <i class="bi bi-pencil-square text-dark fs-3"></i>
                        </div>
                        <h3 class="fw-bold tracking-tight mb-2">Update Vehicle</h3>
                        <p class="text-muted small mb-0">Update your vehicle information for a better service experience.</p>
                    </div>

                    <% if (error != null) { %>
                    <div class="alert alert-danger border-0 bg-danger bg-opacity-10 text-danger rounded-3 p-3 small mb-4 d-flex align-items-center alert-dismissible fade show" role="alert">
                        <i class="bi bi-exclamation-circle-fill me-2 fs-5"></i> <%= error %>
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                    <% } %>

                    <form action="MainController" method="post">
                        <input type="hidden" name="action" value="UpdateVehicle">
                        <input type="hidden" name="vehicleID" value="<%= v.getVehicleID()%>">

                        <div class="mb-3">
                            <label class="small text-muted mb-2 fw-medium">License Plate <span class="text-danger">*</span></label>
                            <input type="text" name="licensePlate" class="form-control form-control-lg border-0 bg-light shadow-sm rounded-3 transition-hover text-uppercase"
                                   value="<%= v.getLicensePlate()%>"
                                   placeholder="e.g. 63A-12345" maxlength="9" pattern="^[0-9]{2}[A-Za-z]-[0-9]{5}$"
                                   title="Format must be 63A-12345" required/>
                        </div>

                        <div class="row g-3 mb-3">
                            <div class="col-sm-6">
                                <label class="small text-muted mb-2 fw-medium">Brand <span class="text-danger">*</span></label>
                                <input type="text" name="brand" class="form-control form-control-lg border-0 bg-light shadow-sm rounded-3 transition-hover"
                                       value="<%= v.getBrand()%>"
                                       list="brandList" 
                                       pattern=".*\S.*"
                                       title="Cannot contain only spaces"
                                       placeholder="Select or type" required/>
                                <datalist id="brandList">
                                    <option value="Toyota">
                                    <option value="Honda">
                                    <option value="Hyundai">
                                    <option value="Mazda">
                                    <option value="Ford">
                                    <option value="BMW">
                                    <option value="Mercedes">
                                    <option value="Kia">
                                </datalist>
                            </div>
                            <div class="col-sm-6">
                                <label class="small text-muted mb-2 fw-medium">Model <span class="text-danger">*</span></label>
                                <input type="text" name="model" class="form-control form-control-lg border-0 bg-light shadow-sm rounded-3 transition-hover"
                                       value="<%= v.getModel()%>"
                                       list="modelList" 
                                       pattern=".*\S.*"
                                       title="Cannot contain only spaces"
                                       placeholder="Select or type" required/>
                                <datalist id="modelList">
                                    <option value="Camry">
                                    <option value="Corolla">
                                    <option value="Civic">
                                    <option value="CR-V">
                                    <option value="VF e34">
                                    <option value="VF8">
                                    <option value="Ranger">
                                    <option value="Everest">
                                    <option value="X5">
                                    <option value="320i">
                                </datalist>
                            </div>
                        </div>

                        <div class="mb-4 pb-2">
                            <label class="small text-muted mb-2 fw-medium">Color <span class="text-danger">*</span></label>
                            <input type="text" name="color" class="form-control form-control-lg border-0 bg-light shadow-sm rounded-3 transition-hover"
                                   value="<%= v.getColor()%>"
                                   list="colorList" 
                                   pattern=".*\S.*"
                                   title="Cannot contain only spaces"
                                   placeholder="Select or type color" required/>
                            <datalist id="colorList">
                                <option value="Black">
                                <option value="White">
                                <option value="Silver">
                                <option value="Gray">
                                <option value="Blue">
                                <option value="Red">
                            </datalist>
                        </div>

                        <button type="submit" class="btn btn-black w-100 rounded-pill py-3 fw-medium transition-hover">
                            <i class="bi bi-check-circle-fill me-1"></i> Update Vehicle
                        </button>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>