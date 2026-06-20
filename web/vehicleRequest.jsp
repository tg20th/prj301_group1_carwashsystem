<%@page import="java.util.List"%>
<%@page import="dto.Vehicle"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<c:if test="account == null">
    <jsp:forward page="MainController?action=home"/>
</c:if>
<%
    List<Vehicle> vehicleList = (List<Vehicle>) request.getAttribute("INDIVIDUAL_LIST");
    int totalPending = 0;
    if (vehicleList != null) {
        totalPending = vehicleList.size();
    }
%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Customer Vehicle Requests | Elite Auto</title>
        
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
        <link href="css/admin.css?v=1.1" rel="stylesheet">
        
        <style>
            /* Tổng quan nền */
            body { background-color: #f4f7fe; font-family: 'Inter', sans-serif; color: #334155; }
            
            /* Typography */
            .tracking-tight { letter-spacing: -0.025em; }

            /* Gradients & Shadows cho KPI */
            .gradient-primary { background: linear-gradient(135deg, #6366f1 0%, #8b5cf6 100%); color: white; }
            .gradient-warning { background: linear-gradient(135deg, #f59e0b 0%, #d97706 100%); color: white; }
            .gradient-success { background: linear-gradient(135deg, #10b981 0%, #059669 100%); color: white; }

            /* Tùy chỉnh Nút Duyệt Xanh Lá (Success) */
            .btn-success-custom { background-color: #10b981; color: white; border: none; transition: transform 0.2s, box-shadow 0.2s; }
            .btn-success-custom:hover { background-color: #059669; transform: translateY(-2px); box-shadow: 0 10px 15px -3px rgba(16, 185, 129, 0.3); color: white; }

            /* Hiệu ứng nổi Card Hover */
            .glass-card { background: rgba(255, 255, 255, 0.95); backdrop-filter: blur(10px); border: 1px solid rgba(255,255,255,0.2); }
            .vehicle-row { transition: all 0.3s ease; border: 1px solid #eaedf1; }
            .vehicle-row:hover { background-color: #f8fafc; transform: scale(1.005); box-shadow: 0 10px 20px -5px rgba(0, 0, 0, 0.05); z-index: 10; position: relative; border-color: #cbd5e1; }

            /* Ảnh xe */
            .vehicle-img-wrapper { border-radius: 12px; overflow: hidden; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.1); }
            .vehicle-img-wrapper img { transition: transform 0.3s ease; }
            .vehicle-row:hover .vehicle-img-wrapper img { transform: scale(1.05); }

            /* Badges */
            .badge-brand { background-color: #0f172a; color: #fff; font-weight: 600; padding: 0.4em 0.8em; border-radius: 6px; letter-spacing: 0.5px; }
            .badge-model { background-color: #f1f5f9; color: #475569; font-weight: 600; padding: 0.4em 0.8em; border-radius: 6px; border: 1px solid #e2e8f0; }
        </style>
    </head>
    <body class="admin-body">
        
        <jsp:include page="admin_sidebar.jsp"/>
        
        <main class="main-wrapper p-4 p-lg-5 animate-fade-up">
            
            <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center mb-4">
                <div>
                    <h2 class="fw-bolder text-dark mb-1 fs-2 tracking-tight">Vehicle Approvals</h2>
                    <p class="text-secondary fw-medium mb-0">Review and verify new vehicles added by customers.</p>
                </div>
                <div class="mt-3 mt-md-0">
                    <jsp:include page="request_navbar.jsp"/>
                </div>
            </div>

            <div class="row g-4 mb-4">
                <div class="col-md-4">
                    <div class="glass-card p-4 rounded-4 shadow-sm h-100 d-flex align-items-center gap-4 border-light">
                        <div class="gradient-warning rounded-circle d-flex align-items-center justify-content-center shadow" style="width: 65px; height: 65px;">
                            <i class="bi bi-hourglass-split fs-3 text-white"></i>
                        </div>
                        <div>
                            <div class="text-muted fw-bold text-uppercase small mb-1" style="letter-spacing: 1px;">Pending Reviews</div>
                            <h2 class="fw-bolder text-dark mb-0 tracking-tight" style="font-size: 2.2rem;"><%= totalPending %></h2>
                        </div>
                    </div>
                </div>
            </div>

            <div class="glass-card rounded-4 shadow-sm overflow-hidden d-flex flex-column p-4 border-light">
                <h5 class="fw-bolder text-dark mb-4 tracking-tight"><i class="bi bi-car-front-fill text-primary me-2"></i> Pending Vehicle List</h5>
                
                <% if (vehicleList != null && !vehicleList.isEmpty()) { %>
                    
                    <div class="row g-3">
                        <% for (Vehicle v : vehicleList) { %>
                            <div class="col-12">
                                <div class="vehicle-row rounded-4 p-3 bg-white">
                                    <div class="row align-items-center">
                                        
                                        <div class="col-lg-2 col-md-3 col-4 text-center">
                                            <div class="vehicle-img-wrapper" style="width: 100%; height: 90px;">
                                                <img src="<%= v.getImageURL() != null && !v.getImageURL().isEmpty() ? v.getImageURL() : "images/default-car.png" %>" 
                                                     style="width: 100%; height: 100%; object-fit: cover;" 
                                                     alt="Vehicle Image"
                                                     onerror="this.src='https://placehold.co/400x300?text=No+Image';">
                                            </div>
                                        </div>
                                        
                                        <div class="col-lg-7 col-md-6 col-8">
                                            <div class="fw-bolder text-dark fs-4 mb-2 font-monospace tracking-tight">
                                                <%= v.getLicensePlate() %>
                                            </div>

                                            <div class="d-flex flex-wrap align-items-center gap-2 mb-2">
                                                <span class="badge-brand"><%= v.getBrandName() %></span>
                                                <span class="badge-model"><%= v.getModelName() %></span>
                                            </div>
                                            
                                            <div class="text-muted fw-medium small">
                                                <i class="bi bi-palette-fill me-1"></i> Color: <strong class="text-dark me-3"><%= v.getColor() %></strong>
                                                <i class="bi bi-calendar-event-fill me-1"></i> Year: <strong class="text-dark"><%= v.getManufactureYear() %></strong>
                                            </div>
                                        </div>
                                        
                                        <div class="col-lg-3 col-md-3 mt-3 mt-md-0">
                                            <div class="d-flex flex-column justify-content-center gap-2 h-100">
                                                
                                                <form action="ApproveVehicleController" method="post" class="m-0 p-0">
                                                    <input type="hidden" name="vehicleID" value="<%= v.getVehicleID() %>">
                                                    <button type="submit" class="btn btn-success-custom rounded-pill fw-bold w-100 shadow-sm" onclick="return confirm('Approve this vehicle?');">
                                                        <i class="bi bi-check-circle-fill me-1"></i> Approve
                                                    </button>
                                                </form>
                                                
                                                <form action="RejectVehicleController" method="post" class="m-0 p-0">
                                                    <input type="hidden" name="vehicleID" value="<%= v.getVehicleID() %>">
                                                    <button type="submit" class="btn btn-outline-danger rounded-pill fw-bold bg-white w-100 shadow-sm" onclick="return confirm('Reject this vehicle request?');">
                                                        <i class="bi bi-x-circle-fill me-1"></i> Reject
                                                    </button>
                                                </form>
                                                
                                            </div>
                                        </div>
                                        
                                    </div>
                                </div>
                            </div>
                        <% } %>
                    </div>

                <% } else { %>
                    <div class="text-center py-5 my-4">
                        <div class="gradient-success rounded-circle d-inline-flex align-items-center justify-content-center mb-3 shadow" style="width: 80px; height: 80px;">
                            <i class="bi bi-check2-all fs-1 text-white"></i>
                        </div>
                        <h4 class="fw-bold text-dark">All Caught Up!</h4>
                        <p class="text-muted">There are no pending vehicle requests to review at the moment.</p>
                    </div>
                <% } %>
                
            </div>
        </main>
        
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>