
<%@page import="java.util.List"%>
<%@page import="dto.Business"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    List<Business> businessList
            = (List<Business>) request.getAttribute("BUSINESS_LIST");

    int totalBusiness = 0;

    if (businessList != null) {
        totalBusiness = businessList.size();
    }
%>

<!DOCTYPE html>

<html>

    <head>

        <meta charset="UTF-8">

        <title>Business Vehicle Requests</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
              rel="stylesheet">

        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css"
              rel="stylesheet">

        <link href="css/admin.css?v=1.1"
              rel="stylesheet">

    </head>

    <body class="admin-body">

        <div class="d-flex">

            <!-- SIDEBAR -->
            <jsp:include page="admin_sidebar.jsp"/>

            <div class="flex-grow-1">

                <!-- NAVBAR -->
                <jsp:include page="request_navbar.jsp"/>

                <main class="main-wrapper p-4 p-lg-5">

                    <!-- HEADER -->

                    <div class="mb-4">

                        <h2 class="fw-bold mb-1">

                            Business Vehicle Requests

                        </h2>

                        <p class="text-muted">

                            Review pending vehicles submitted by business customers

                        </p>

                    </div>

                    <!-- KPI -->

                    <div class="row g-3 mb-4">

                        <div class="col-lg-3">

                            <div class="bg-white rounded-4 shadow-sm border p-4">

                                <div class="d-flex align-items-center">

                                    <div class="bg-primary bg-opacity-10 rounded-4 p-3 me-3">

                                        <i class="bi bi-building-fill text-primary fs-4"></i>

                                    </div>

                                    <div>

                                        <div class="small text-muted">

                                            Businesses

                                        </div>

                                        <h3 class="fw-bold mb-0">

                                            <%= totalBusiness%>

                                        </h3>

                                    </div>

                                </div>

                            </div>

                        </div>

                    </div>

                    <!-- TABLE -->

                    <div class="bg-white rounded-4 shadow-sm border p-4">

                        <h4 class="fw-bold mb-4">

                            <i class="bi bi-building-fill me-2"></i>

                            Business Pending Vehicles

                        </h4>

                        <% if (businessList != null && !businessList.isEmpty()) { %>

                        <table class="table table-hover align-middle">

                            <thead>

                                <tr>

                                    <th>Company</th>

                                    <th>Tax Code</th>

                                    <th>Total Vehicles</th>

                                    <th class="text-end">Action</th>

                                </tr>

                            </thead>

                            <tbody>

                                <% for (Business b : businessList) {%>

                                <tr>

                                    <td>

                                        <strong>

                                            <%= b.getBusinessName()%>

                                        </strong>

                                    </td>

                                    <td>

                                        <%= b.getTaxCode()%>

                                    </td>

                                    <td>

                                        <span class="badge bg-primary">

                                            <%= b.getPendingVehicleCount()%>

                                        </span>

                                    </td>

                                    <td class="text-end">

                                        <button class="btn btn-dark"
                                                onclick="loadVehicles(<%= b.getCusID()%>)">

                                            <i class="bi bi-eye-fill"></i>

                                            View

                                        </button>

                                    </td>

                                </tr>

                                <% } %>

                            </tbody>

                        </table>

                        <% } else { %>

                        <div class="text-center py-5">

                            <i class="bi bi-building display-3 text-muted"></i>

                            <h4 class="mt-3 text-muted">

                                No Business Vehicle Requests

                            </h4>

                        </div>

                        <% }%>

                    </div>

                </main>

            </div>

        </div>

        <!-- MODAL -->

        <div class="modal fade"
             id="vehicleModal"
             tabindex="-1">

            <div class="modal-dialog modal-xl">

                <div class="modal-content">

                    <div class="modal-header">

                        <h5 class="modal-title">

                            Pending Vehicle List

                        </h5>

                        <button type="button"
                                class="btn-close"
                                data-bs-dismiss="modal">
                        </button>

                    </div>

                    <div class="modal-body"
                         id="vehicleModalBody">

                        Loading...

                    </div>

                </div>

            </div>

        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

       <script>
            // Hàm mở popup cũ của bạn
            function loadVehicles(customerID) {
                fetch("BusinessVehicleDetailController?customerID=" + customerID)
                    .then(response => response.text())
                    .then(html => {
                        document.getElementById("vehicleModalBody").innerHTML = html;
                        let modal = new bootstrap.Modal(document.getElementById("vehicleModal"));
                        modal.show();
                    })
                    .catch(error => {
                        document.getElementById("vehicleModalBody").innerHTML = 
                            "<div class='text-danger'>Failed to load vehicle data.</div>";
                    });
            }

            // HÀM MỚI CHUYỂN SANG ĐÂY
            function submitVehicleAction(event, form) {
                event.preventDefault(); // Chặn chuyển trang
                
                const formData = new URLSearchParams(new FormData(form));

                fetch(form.action, {
                    method: 'POST',
                    body: formData,
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded'
                    }
                })
                .then(response => response.text())
                .then(html => {
                    // Cập nhật lại HTML bên trong Modal
                    document.getElementById("vehicleModalBody").innerHTML = html;
                })
                .catch(error => {
                    console.error('Error submitting form:', error);
                    alert("Đã xảy ra lỗi khi xử lý yêu cầu.");
                });
            }
        </script>
    </body>
   

</html>

