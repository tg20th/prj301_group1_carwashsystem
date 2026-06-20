<%@page import="dto.Reward"%>
<%@page import="dto.Customer"%>
<%@page import="dto.Vehicle"%>
<%@page import="dto.Tier"%>
<%@page import="dto.Account"%>
<%@page import="java.util.List"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    Account account = (Account) request.getSession().getAttribute("ACCOUNT");
    Tier tier = (Tier) request.getAttribute("TIER");
    List<Vehicle> vehicleList = (List) request.getAttribute("VEHICLES");
    Customer customer = (Customer) request.getAttribute("CUSTOMER");
    Reward nextReward = (Reward) request.getAttribute("NEXTREWARD");

    if (account == null) {
        response.sendRedirect("MainController?action=home");
        return;
    }

    String fullname = account.getLastName() + " " + account.getFirstName();
    String initials = (account.getFirstName() != null && !account.getFirstName().isEmpty() ? account.getFirstName().substring(0, 1) : "")
            + (account.getLastName() != null && !account.getLastName().isEmpty() ? account.getLastName().substring(0, 1) : "");
%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Dashboard | Elite Auto</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">

        <link href="css/style.css" rel="stylesheet">
    </head>
    <body style="background-color: var(--bg-card);"> 
        <nav class="navbar navbar-expand-lg py-3 bg-white sticky-top shadow-sm border-bottom">
            <div class="container">
                <a class="navbar-brand fw-bold fs-4 tracking-tight">
                    <i class="bi bi-vinyl-fill me-2"></i>EliteAuto
                </a>
                <button class="navbar-toggler border-0" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                    <i class="bi bi-list fs-2"></i>
                </button>
                <div class="collapse navbar-collapse" id="navbarNav">
                    <ul class="navbar-nav ms-auto align-items-center gap-4">
                        <li class="nav-item d-none d-md-block text-muted small">
                            Logged in as <strong class="text-dark ms-1"><%= fullname%></strong>
                        </li>
                        <li class="nav-item">
                            <a href="MainController?action=logout" class="btn btn-outline-dark rounded-pill px-4 py-2 fw-medium text-decoration-none small transition-hover">
                                <i class="bi bi-box-arrow-right me-1"></i> Logout
                            </a>
                        </li>
                    </ul>
                </div>
            </div>
        </nav>

        <div class="container py-5 animate-fade-up">

            <div class="d-flex justify-content-between align-items-end mb-4">
                <div>
                    <h2 class="fw-bold tracking-tight mb-1">Welcome back, <%= account.getFirstName()%>! 👋</h2>
                    <p class="text-muted small mb-0">Here's an overview of your fleet, points, and active rewards today.</p>
                </div>
            </div>

            <% String msg = (String) request.getAttribute("MESSAGE");
            if (msg != null) {%>
            <div id="autoDismissAlert" class="alert alert-success border-0 bg-white shadow-sm rounded-4 p-3 mb-4 d-flex align-items-center alert-dismissible fade show">
                <i class="bi bi-check-circle-fill fs-5 text-success me-3"></i>
                <span class="fw-medium text-dark"><%= msg%></span>
                <button type="button" class="btn-close ms-auto" data-bs-dismiss="alert"></button>
            </div>
            <% }%>

            <div class="row g-4 mb-4">
                <div class="col-md-6 col-lg-3 delay-1">
                    <div class="bg-white p-4 rounded-4 shadow-sm border border-light h-100 transition-hover">
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <h6 class="text-muted small text-uppercase fw-bold m-0 tracking-tight">Points Balance</h6>
                            <div class="bg-light rounded-circle d-flex align-items-center justify-content-center" style="width: 40px; height: 40px;">
                                <i class="bi bi-star-fill text-dark fs-5"></i>
                            </div>
                        </div>
                        <h2 class="mb-0 fw-bold display-6 tracking-tight"><%= request.getAttribute("POINT_BALANCE") != null ? request.getAttribute("POINT_BALANCE") : 0%></h2>
                    </div>
                </div>
                <div class="col-md-6 col-lg-3 delay-2">
                    <div class="bg-white p-4 rounded-4 shadow-sm border border-light h-100 transition-hover">
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <h6 class="text-muted small text-uppercase fw-bold m-0 tracking-tight">Membership Tier</h6>
                            <div class="bg-light rounded-circle d-flex align-items-center justify-content-center" style="width: 40px; height: 40px;">
                                <i class="bi bi-shield-check text-dark fs-5"></i>
                            </div>
                        </div>
                        <h2 class="mb-0 fw-bold display-6 tracking-tight"><%= tier != null ? tier.getTierName() : "Standard"%></h2>
                    </div>
                </div>
                <div class="col-md-6 col-lg-3 delay-3">
                    <div class="bg-white p-4 rounded-4 shadow-sm border border-light h-100 transition-hover" style="border-top: 4px solid var(--text-main) !important;">
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <h6 class="text-muted small text-uppercase fw-bold m-0 tracking-tight">Next Reward</h6>
                            <div class="bg-light rounded-circle d-flex align-items-center justify-content-center" style="width: 40px; height: 40px;">
                                <i class="bi bi-gift-fill text-dark fs-5"></i>
                            </div>
                        </div>
                        <h4 class="mb-0 fw-bold mt-2 tracking-tight text-truncate"><%= nextReward != null ? nextReward.getRewardName() : "No rewards yet"%></h4>
                    </div>
                </div>
                <div class="col-md-6 col-lg-3 delay-4">
                    <a href="CustomerBookingHistoryController" class="text-decoration-none d-block h-100">
                        <div class="bg-white p-4 rounded-4 shadow-sm border border-light h-100 transition-hover" style="border-top: 4px solid #0d6efd !important;">
                            <div class="d-flex justify-content-between align-items-center mb-3">
                                <h6 class="text-muted small text-uppercase fw-bold m-0 tracking-tight">My Bookings</h6>
                                <div class="bg-light rounded-circle d-flex align-items-center justify-content-center" style="width: 40px; height: 40px;">
                                    <i class="bi bi-calendar2-check text-dark fs-5"></i>
                                </div>
                            </div>
                            <h2 class="mb-1 fw-bold display-6 tracking-tight text-dark"><%= request.getAttribute("ACTIVE_BOOKING_COUNT") != null ? request.getAttribute("ACTIVE_BOOKING_COUNT") : 0%></h2>
                            <p class="text-muted small mb-3">Active appointments</p>
                            <span class="btn btn-outline-dark rounded-pill btn-sm w-100 fw-medium">
                                <i class="bi bi-journal-text me-1"></i> View History &amp; Status
                            </span>
                        </div>
                    </a>
                </div>
            </div>

            <div class="row g-4 delay-4">
                <div class="col-lg-3">
                    <div class="bg-white p-4 rounded-4 shadow-sm border border-light h-100 text-center transition-hover">
                        <div class="bg-dark text-white rounded-circle d-flex align-items-center justify-content-center mx-auto mb-3 shadow-sm float-anim" style="width: 80px; height: 80px; font-size: 1.8rem; font-weight: 700;">
                            <%= initials.toUpperCase()%>
                        </div>
                        <h5 class="fw-bold mb-1 tracking-tight"><%= fullname%></h5>
                        <span class="badge bg-light text-dark border px-3 py-1 mb-4 rounded-pill"><%= tier != null ? tier.getTierName() : "Standard"%></span>

                        <div class="text-start border-top pt-4">
                            <div class="mb-3">
                                <label class="text-muted small text-uppercase fw-bold d-block tracking-tight mb-1">Email</label>
                                <span class="small fw-medium text-dark text-break"><%= account.getEmail()%></span>
                            </div>
                            <div class="mb-4">
                                <label class="text-muted small text-uppercase fw-bold d-block tracking-tight mb-1">Phone</label>
                                <span class="small fw-medium text-dark"><%= account.getPhone()%></span>
                            </div>
                        </div>

                        <form action="MainController" method="post" class="mt-2">
                            <button type="submit" name="action" value="editprofile" class="btn btn-outline-dark rounded-pill py-2 w-100 fw-medium">
                                <i class="bi bi-pencil-square me-2"></i>Edit Profile
                            </button>
                        </form>
                    </div>
                </div>

                <div class="col-lg-9">
                    <div class="bg-white p-4 p-md-5 rounded-4 shadow-sm border border-light h-100 transition-hover">

                        <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center mb-4 pb-3 border-bottom">
                            <h4 class="mb-3 mb-md-0 fw-bold tracking-tight"><i class="bi bi-car-front-fill me-2 text-muted"></i>My Vehicles</h4>
                            <div class="d-flex gap-2">
                                <a href="CustomerBookingController" class="btn btn-dark rounded-pill py-2 px-4 fw-medium">
                                    <i class="bi bi-calendar-check me-1"></i> Book Service
                                </a>
                                <a href="MainController?action=AddVehicle_page" class="btn btn-black rounded-pill py-2 px-4 fw-medium">
                                    <i class="bi bi-plus-lg me-1"></i> Add Vehicle
                                </a>
                            </div>
                        </div>

                        <div class="pt-2">
                            <% if (vehicleList != null && !vehicleList.isEmpty()) { %>
                            <div class="table-responsive">
                                <table class="table align-middle table-hover mb-0">
                                    <thead class="table-light text-muted small text-uppercase tracking-tight">
                                        <tr>
                                            <th class="py-3 px-3 rounded-start">Vehicle Info</th>
                                            <th class="text-center py-3">License Plate</th>
                                            <th class="text-end py-3 px-3 rounded-end">Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody class="border-top-0">
                                        <% for (Vehicle v : vehicleList) {%>
                                        <tr>
                                            <td class="py-3 px-3">
                                                <div class="fw-bold text-dark fs-6"><%= v.getBrand()%> <%= v.getModel()%></div>
                                                <div class="text-muted small mt-1"><i class="bi bi-palette-fill me-1"></i><%= v.getColor()%></div>
                                            </td>
                                            <td class="text-center py-3">
                                                <span class="badge bg-dark rounded-pill px-3 py-2 border font-monospace text-uppercase shadow-sm" style="letter-spacing: 1px;"><%= v.getLicensePlate()%></span>
                                            </td>
                                            <td class="text-end py-3 px-3">
                                                <div class="d-flex justify-content-end gap-2">
                                                    <form action="MainController" method="post">
                                                        <input type="hidden" name="action" value="UpdateVehicle_page">
                                                        <input type="hidden" name="vehicleID" value="<%= v.getVehicleID()%>">                                                 
                                                        <button type="submit" class="btn btn-sm btn-light border rounded-3 text-dark transition-hover" title="Edit">
                                                            <i class="bi bi-pencil"></i>
                                                        </button>
                                                    </form>
                                                    <form action="MainController" method="post" onsubmit="return confirm('Are you sure you want to remove this vehicle?');">
                                                        <input type="hidden" name="action" value="RemoveVehicle">
                                                        <input type="hidden" name="vehicleID" value="<%= v.getVehicleID()%>"> 
                                                        <button type="submit" class="btn btn-sm btn-outline-danger rounded-3 transition-hover" title="Delete">
                                                            <i class="bi bi-trash"></i>
                                                        </button>
                                                    </form>
                                                </div>
                                            </td>
                                        </tr>
                                        <% } %>
                                    </tbody>
                                </table>
                            </div>
                            <% } else { %>
                            <div class="text-center py-5 my-4">
                                <div class="bg-light rounded-circle d-flex align-items-center justify-content-center mx-auto mb-3" style="width: 80px; height: 80px;">
                                    <i class="bi bi-car-front text-muted fs-1"></i>
                                </div>
                                <h5 class="text-dark mt-4 fw-bold tracking-tight">No vehicles registered yet</h5>
                                <p class="text-muted mb-0 small">Add your first vehicle to start booking washes and earning points.</p>
                            </div>
                            <% }%>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

        <script>
                                                                document.addEventListener('DOMContentLoaded', function () {
                                                                    var alertElement = document.getElementById('autoDismissAlert');

                                                                    if (alertElement) {
                                                                        setTimeout(function () {
                                                                            var bsAlert = new bootstrap.Alert(alertElement);
                                                                            bsAlert.close();
                                                                        }, 3000);
                                                                    }
                                                                });
        </script>
    </body>
</html>