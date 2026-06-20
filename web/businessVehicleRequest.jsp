<%@page import="java.util.List"%>
<%@page import="dto.Business"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>


<!DOCTYPE html>
<c:if test="${empty sessionScope.ACCOUNT}">
    <jsp:forward page="index.jsp"/>
</c:if>
<%
    List<Business> businessList = (List<Business>) request.getAttribute("BUSINESS_LIST");
    int totalBusiness = 0;
    if (businessList != null) {
        totalBusiness = businessList.size();
    }
%>

<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Business Vehicle Requests | Elite Auto</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
        <link href="css/admin.css?v=1.1" rel="stylesheet">

        <style>
            /* Tổng quan nền */
            body { background-color: #f4f7fe; font-family: 'Inter', sans-serif; color: #334155; }
            
              </style>
    </head>
    <body class="admin-body">

        <jsp:include page="admin_sidebar.jsp"/>

        <main class="main-wrapper p-4 p-lg-5 animate-fade-up">

            <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center mb-4">
                <div>
                    <h2 class="fw-bolder text-dark mb-1 fs-2 tracking-tight">Business Approvals</h2>
                    <p class="text-secondary fw-medium mb-0">Review pending vehicles submitted by business partners.</p>
                </div>
                <div class="mt-3 mt-md-0">
                    <jsp:include page="request_navbar.jsp"/>
                </div>
            </div>

            <div class="row g-4 mb-4">
                <div class="col-md-4">
                    <div class="glass-card p-4 rounded-4 shadow-sm h-100 d-flex align-items-center gap-4 border-light">
                        <div class="gradient-primary rounded-circle d-flex align-items-center justify-content-center shadow" style="width: 65px; height: 65px;">
                            <i class="bi bi-buildings-fill fs-3 text-white"></i>
                        </div>
                        <div>
                            <div class="text-muted fw-bold text-uppercase small mb-1" style="letter-spacing: 1px;">Pending Businesses</div>
                            <h2 class="fw-bolder text-dark mb-0 tracking-tight" style="font-size: 2.2rem;"><%= totalBusiness %></h2>
                        </div>
                    </div>
                </div>
            </div>

            <div class="glass-card rounded-4 shadow-sm overflow-hidden d-flex flex-column p-4 border-light">
                <h5 class="fw-bolder text-dark mb-4 tracking-tight"><i class="bi bi-building-fill-exclamation text-primary me-2"></i> Business Vehicles List</h5>

                <% if (businessList != null && !businessList.isEmpty()) { %>
                    <div class="table-responsive">
                        <table class="table table-hover table-borderless align-middle mb-0">
                            <thead>
                                <tr class="border-bottom" style="border-color: #eaedf1;">
                                    <th class="text-muted text-uppercase fw-bold py-3 ps-4" style="font-size: 0.75rem; letter-spacing: 1px;">Company Profile</th>
                                    <th class="text-muted text-uppercase fw-bold py-3" style="font-size: 0.75rem; letter-spacing: 1px;">Tax Code</th>
                                    <th class="text-muted text-uppercase fw-bold py-3 text-center" style="font-size: 0.75rem; letter-spacing: 1px;">Total Requests</th>
                                    <th class="text-muted text-uppercase text-end fw-bold pe-4 py-3" style="font-size: 0.75rem; letter-spacing: 1px;">Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (Business b : businessList) { %>
                                    <tr class="business-row border-bottom" style="border-color: #f1f5f9;">
                                        <td class="ps-4 py-3">
                                            <div class="d-flex align-items-center gap-3">
                                                <div class="bg-dark text-white rounded-3 d-flex align-items-center justify-content-center fw-bold shadow-sm" style="width: 45px; height: 45px; font-size: 1.1rem;">
                                                    <i class="bi bi-building"></i>
                                                </div>
                                                <div class="fw-bolder text-dark" style="font-size: 1.05rem;">
                                                    <%= b.getBusinessName()%>
                                                </div>
                                            </div>
                                        </td>
                                        
                                        <td class="py-3">
                                            <span class="text-secondary fw-bold font-monospace bg-light border px-2 py-1 rounded">
                                                <%= b.getTaxCode()%>
                                            </span>
                                        </td>
                                        
                                        <td class="py-3 text-center">
                                            <span class="badge gradient-warning rounded-pill px-3 py-2 shadow-sm text-dark" style="font-size: 0.85rem;">
                                                <i class="bi bi-car-front-fill me-1"></i> <%= b.getPendingVehicleCount()%> Pending
                                            </span>
                                        </td>
                                        
                                        <td class="text-end pe-4 py-3">
                                            <button class="btn btn-dark-custom rounded-pill px-4 py-2 fw-bold shadow-sm" onclick="loadVehicles(<%= b.getCusID()%>)">
                                                <i class="bi bi-eye-fill me-1"></i> View Requests
                                            </button>
                                        </td>
                                    </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                <% } else { %>
                    <div class="text-center py-5 my-4">
                        <div class="gradient-success rounded-circle d-inline-flex align-items-center justify-content-center mb-3 shadow" style="width: 80px; height: 80px;">
                            <i class="bi bi-check2-all fs-1 text-white"></i>
                        </div>
                        <h4 class="fw-bold text-dark">All Caught Up!</h4>
                        <p class="text-muted">There are no pending business vehicle requests to review at the moment.</p>
                    </div>
                <% } %>
            </div>

        </main>

        <div class="modal fade" id="vehicleModal" tabindex="-1">
            <div class="modal-dialog modal-xl modal-dialog-centered">
                <div class="modal-content modal-content-custom shadow-lg">
                    <div class="modal-header modal-header-custom px-4 py-4">
                        <h5 class="modal-title fw-bolder text-dark">
                            <i class="bi bi-list-ul text-primary me-2"></i> Business Vehicle List
                        </h5>
                        <button type="button" class="btn-close shadow-none" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body p-4" id="vehicleModalBody" style="background-color: #f8fafc; min-height: 200px;">
                        <div class="text-center py-5">
                            <div class="spinner-border text-primary" role="status"></div>
                            <div class="mt-2 text-muted fw-medium">Loading vehicles...</div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

        <script>
            // Hàm mở popup Load danh sách xe vào Modal
            function loadVehicles(customerID) {
                // Hiển thị trạng thái loading trước khi fetch data
                document.getElementById("vehicleModalBody").innerHTML = `
                    <div class="text-center py-5">
                        <div class="spinner-border text-primary" role="status"></div>
                        <div class="mt-2 text-muted fw-medium">Loading vehicles...</div>
                    </div>
                `;
                
                // Mở modal
                let modal = new bootstrap.Modal(document.getElementById("vehicleModal"));
                modal.show();
                
                // Fetch HTML từ server
                fetch("BusinessVehicleDetailController?customerID=" + customerID)
                    .then(response => response.text())
                    .then(html => {
                        document.getElementById("vehicleModalBody").innerHTML = html;
                    })
                    .catch(error => {
                        document.getElementById("vehicleModalBody").innerHTML = 
                            "<div class='text-center text-danger py-5 fw-bold'><i class='bi bi-exclamation-triangle fs-1 d-block mb-2'></i> Failed to load vehicle data.</div>";
                    });
            }

            // Hàm Submit Form bên trong Modal bằng phương thức POST bằng AJAX (Không tải lại trang)
            function submitVehicleAction(event, form) {
                event.preventDefault(); // Chặn tải lại trang
                
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
                    // Cập nhật lại HTML bên trong Modal để thấy ngay kết quả
                    document.getElementById("vehicleModalBody").innerHTML = html;
                })
                .catch(error => {
                    console.error('Error submitting form:', error);
                    alert("An error occurred while processing the request.");
                });
            }
        </script>
    </body>
</html>