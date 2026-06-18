<%@page import="java.util.List"%>
<%@page import="dto.Vehicle"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    List<Vehicle> vehicleList
            = (List<Vehicle>) request.getAttribute("INDIVIDUAL_LIST");
    int totalPending = 0;
    if (vehicleList != null) {
        totalPending = vehicleList.size();
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Customer Vehicle Requests</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css"rel="stylesheet">
        <link href="css/admin.css?v=1.1" rel="stylesheet">
    </head>
    <body class="admin-body">
        <div class="d-flex">
            <!-- ADMIN SIDEBAR -->
            <jsp:include page="admin_sidebar.jsp"/>
            <div class="flex-grow-1">
                <!-- REQUEST NAVBAR -->
                <jsp:include page="request_navbar.jsp"/>
                <main class="main-wrapper p-4 p-lg-5">
                    <!-- HEADER -->
                    <div class="mb-4">
                        <h2 class="fw-bold mb-1">Customer Vehicle Requests </h2>
                        <p class="text-muted">
                            Review and approve pending customer vehicles
                        </p>
                    </div>
                    <!-- KPI -->
                    <div class="row g-3 mb-4">
                        <div class="col-lg-3">
                            <div class="bg-white rounded-4 shadow-sm border p-4">
                                <div class="d-flex align-items-center">
                                    <div class="bg-primary bg-opacity-10 rounded-4 p-3 me-3">
                                        <i class="bi bi-car-front-fill text-primary fs-4"></i>
                                    </div>
                                    <div>
                                        <div class="small text-muted">
                                            Pending Vehicles
                                        </div>
                                        <h3 class="fw-bold mb-0">
                                            <%= totalPending%>
                                        </h3>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <!-- LIST -->
                    <div class="bg-white rounded-4 shadow-sm border p-4">
                        <h4 class="fw-bold mb-4">
                            <i class="bi bi-car-front-fill me-2"></i>
                            Pending Vehicle List
                        </h4>
                        <% if (vehicleList != null && !vehicleList.isEmpty()) { %>
                        
                        <% for (Vehicle v : vehicleList) {%>
                        <div class="border rounded-4 p-3 mb-3">

                            <div class="row align-items-center">
                                <!-- IMAGE -->
                                <div class="col-lg-1 col-md-2 col-3 text-center">

                                    <img src="<%= v.getImageURL()%>"
                                         class="rounded shadow-sm"
                                         style="width:80px;
                                         height:60px;
                                         object-fit:cover;">

                                </div>
                                <!-- INFO -->
                                <div class="col-lg-8 col-md-7 col-9">

                                    <div class="fw-bold fs-5">
                                        <%= v.getLicensePlate()%>
                                    </div>

                                    <div class="text-muted small">

                                        <span class="badge bg-dark me-1">
                                            <%= v.getBrandName()%>
                                        </span>

                                        <span class="badge bg-secondary me-2">
                                            <%= v.getModelName()%>
                                        </span>

                                        Color:
                                        <strong><%= v.getColor()%></strong>
                                        |
                                        Year:
                                        <strong><%= v.getManufactureYear()%></strong>
                                    </div>
                                </div>
                                <!-- ACTION -->
                                <div class="col-lg-3 col-md-3 mt-3 mt-md-0">
                                    <div class="d-flex justify-content-end gap-2">
                                        <form action="ApproveVehicleController"
                                              method="post">
                                            <input type="hidden"
                                                   name="vehicleID"
                                                   value="<%= v.getVehicleID()%>">

                                            <button type="submit"
                                                    class="btn btn-success btn-sm">

                                                <i class="bi bi-check-lg"></i>
                                                Approve
                                            </button>
                                        </form>
                                        <form action="RejectVehicleController"
                                              method="post">
                                            <input type="hidden"
                                                   name="vehicleID"
                                                   value="<%= v.getVehicleID()%>">
                                            <button type="submit"
                                                    class="btn btn-outline-danger btn-sm">
                                                <i class="bi bi-x-lg"></i>
                                                Reject
                                            </button>
                                        </form>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <% } %>
                        <% } else { %>
                        <div class="text-center py-5">
                            <i class="bi bi-car-front display-3 text-muted"></i>
                            <h4 class="mt-3 text-muted">
                                No Pending Vehicles
                            </h4>
                        </div>
                        <% }%>
                    </div>
                </main>
            </div>
        </div>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>