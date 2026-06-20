<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="dto.*"%>

<%
    Account account = (Account) session.getAttribute("ACCOUNT");
    List<Vehicle> vehicleList = (List<Vehicle>) request.getAttribute("VEHICLE_LIST");
    List<Promotion> promoList = (List<Promotion>) request.getAttribute("PROMO_LIST");
    Tier tier = (Tier) request.getAttribute("TIER");
    Reward nextReward = (Reward) request.getAttribute("NEXTREWARD");
    Integer pointBalance = (Integer) request.getAttribute("POINT_BALANCE");
    Business business = (Business) session.getAttribute("BUS");
    if (account == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String fullname = account.getLastName() + " " + account.getFirstName();
    String initials
            = (account.getFirstName() != null && !account.getFirstName().isEmpty()
            ? account.getFirstName().substring(0, 1) : "")
            + (account.getLastName() != null && !account.getLastName().isEmpty()
            ? account.getLastName().substring(0, 1) : "");

    pageContext.setAttribute("busNavActive", "dashboard");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Business Dashboard | Elite Auto</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="css/style.css" rel="stylesheet">
    <link href="css/business.css" rel="stylesheet">
</head>
<body class="bus-page">

    <%@ include file="includes/business_nav.jsp" %>

    <div class="container py-5">

        <%
            String uploadMsg = (String) session.getAttribute("UPLOAD_MSG");
            if (uploadMsg != null) {
                session.removeAttribute("UPLOAD_MSG");
        %>
        <div class="alert alert-success rounded-3 border-0 shadow-sm mb-4">
            <i class="bi bi-check-circle-fill me-2"></i><%= uploadMsg %>
        </div>
        <% } %>

        <div class="mb-4">
            <h2 class="fw-bold tracking-tight mb-1">Welcome back, <%= account.getFirstName() %>!</h2>
            <p class="text-muted small mb-0">Manage your fleet, bookings and business rewards.</p>
        </div>

        <!-- STATS -->
        <div class="row g-4 mb-4">
            <div class="col-md-6 col-lg-3">
                <div class="bus-card bus-stat-card p-4 h-100">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <h6 class="text-muted small text-uppercase fw-bold m-0">Points</h6>
                        <div class="bg-light rounded-circle d-flex align-items-center justify-content-center" style="width:40px;height:40px;">
                            <i class="bi bi-star-fill text-dark"></i>
                        </div>
                    </div>
                    <h2 class="mb-0 fw-bold display-6"><%= pointBalance != null ? pointBalance : 0 %></h2>
                </div>
            </div>
            <div class="col-md-6 col-lg-3">
                <div class="bus-card bus-stat-card p-4 h-100">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <h6 class="text-muted small text-uppercase fw-bold m-0">Tier</h6>
                        <div class="bg-light rounded-circle d-flex align-items-center justify-content-center" style="width:40px;height:40px;">
                            <i class="bi bi-shield-check text-dark"></i>
                        </div>
                    </div>
                    <h4 class="mb-0 fw-bold"><%= tier != null ? tier.getTierName() : "Standard" %></h4>
                </div>
            </div>
            <div class="col-md-6 col-lg-3">
                <div class="bus-card bus-stat-card p-4 h-100">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <h6 class="text-muted small text-uppercase fw-bold m-0">Next Reward</h6>
                        <div class="bg-light rounded-circle d-flex align-items-center justify-content-center" style="width:40px;height:40px;">
                            <i class="bi bi-gift-fill text-dark"></i>
                        </div>
                    </div>
                    <h5 class="mb-0 fw-bold text-truncate"><%= nextReward != null ? nextReward.getRewardName() : "None" %></h5>
                </div>
            </div>
            <div class="col-md-6 col-lg-3">
                <a href="BusinessBookingHistoryController" class="text-decoration-none d-block h-100">
                    <div class="bus-card bus-stat-card p-4 h-100 border-top-dark">
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <h6 class="text-muted small text-uppercase fw-bold m-0">Fleet Bookings</h6>
                            <div class="bg-light rounded-circle d-flex align-items-center justify-content-center" style="width:40px;height:40px;">
                                <i class="bi bi-calendar2-check text-dark"></i>
                            </div>
                        </div>
                        <h2 class="mb-1 fw-bold display-6 text-dark"><%= request.getAttribute("ACTIVE_BOOKING_COUNT") != null ? request.getAttribute("ACTIVE_BOOKING_COUNT") : 0 %></h2>
                        <span class="btn btn-outline-dark btn-sm rounded-pill w-100 fw-medium">
                            <i class="bi bi-journal-text me-1"></i>View History
                        </span>
                    </div>
                </a>
            </div>
        </div>

        <!-- QUICK ACTION -->
        <div class="bus-card p-4 mb-4 d-flex flex-wrap justify-content-between align-items-center gap-3">
            <div>
                <h5 class="fw-bold mb-1">Fleet Booking</h5>
                <p class="text-muted small mb-0">Book multiple vehicles — one service, one invoice, one payment.</p>
            </div>
            <a href="BusinessBookingController" class="btn btn-black rounded-pill px-4 py-2">
                <i class="bi bi-calendar-plus me-2"></i>Book Fleet Wash
            </a>
        </div>

        <div class="row g-4 align-items-start">
            <!-- PROFILE -->
            <div class="col-lg-3">
                <div class="bus-card p-4 text-center">
                    <div class="bg-dark text-white rounded-circle d-flex align-items-center justify-content-center mx-auto mb-3"
                         style="width:72px;height:72px;font-size:1.25rem;font-weight:700;">
                        <%= initials.toUpperCase() %>
                    </div>
                    <h5 class="fw-bold mb-1"><%= fullname %></h5>
                    <p class="text-muted small mb-3">Business Account</p>
                    <hr class="my-3">
                    <div class="text-start small">
                        <div class="mb-2"><span class="text-muted">Email:</span> <span class="fw-medium"><%= account.getEmail() %></span></div>
                        <div><span class="text-muted">Phone:</span> <span class="fw-medium"><%= account.getPhone() %></span></div>
                    </div>
                    <form action="MainController" method="post" class="mt-3 mb-0">
                        <button type="submit" name="action" value="editprofile"
                                class="btn btn-outline-dark w-100 rounded-pill">
                            <i class="bi bi-pencil-square me-2"></i>Edit Profile
                        </button>
                    </form>
                </div>

                <div class="bus-card p-4 mt-4">
                    <h5 class="fw-bold mb-3"><i class="bi bi-building me-2 text-muted"></i>Business Info</h5>
                    <% if (business != null) { %>
                    <div class="small">
                        <div class="mb-3">
                            <div class="text-muted">Company Name</div>
                            <div class="fw-semibold"><%= business.getBusinessName() %></div>
                        </div>
                        <div class="mb-3">
                            <div class="text-muted">Tax Code</div>
                            <div class="fw-semibold"><%= business.getTaxCode() %></div>
                        </div>
                        <div>
                            <div class="text-muted">Company Address</div>
                            <div class="fw-semibold"><%= business.getCompanyAddress() %></div>
                        </div>
                    </div>
                    <% } else { %>
                    <p class="text-muted small mb-0">Business information not found.</p>
                    <% } %>
                </div>
            </div>

            <!-- VEHICLES -->
            <div class="col-lg-6">
                <div class="bus-card p-4 h-100">
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <h5 class="fw-bold m-0"><i class="bi bi-truck me-2 text-muted"></i>My Vehicles</h5>
                        <a href="MainController?action=AddBusinessVehicle_page" class="btn btn-black btn-sm rounded-pill px-3">
                            <i class="bi bi-plus-lg me-1"></i>Add Vehicles
                        </a>
                    </div>

                    <% if (vehicleList != null && !vehicleList.isEmpty()) { %>
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0 bus-table">
                            <thead>
                                <tr>
                                    <th>Vehicle</th>
                                    <th>Plate</th>
                                    <th>Status</th>
                                    <th>Image</th>
                                    <th class="text-end">Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (Vehicle v : vehicleList) {
                                    String vStatus = v.getStatus() != null ? v.getStatus() : "Unknown";
                                    String statusBadge = "bg-light text-dark border";
                                    String statusIcon = "bi-circle";
                                    if ("Active".equalsIgnoreCase(vStatus)) {
                                        statusBadge = "bg-success-subtle text-success border border-success-subtle";
                                        statusIcon = "bi-check-circle";
                                    } else if ("Pending".equalsIgnoreCase(vStatus)) {
                                        statusBadge = "bg-warning-subtle text-warning border border-warning-subtle";
                                        statusIcon = "bi-clock";
                                    } else if ("Frozen".equalsIgnoreCase(vStatus)) {
                                        statusBadge = "bg-secondary-subtle text-secondary border border-secondary-subtle";
                                        statusIcon = "bi-pause-circle";
                                    }
                                %>
                                <tr>
                                    <td>
                                        <div class="fw-semibold"><%= v.getBrandName() %> <%= v.getModelName() %></div>
                                        <div class="text-muted small"><%= v.getColor() %> · <%= v.getManufactureYear() != null ? v.getManufactureYear() : "—" %></div>
                                    </td>
                                    <td>
                                        <span class="badge bg-dark font-monospace"><%= v.getLicensePlate() %></span>
                                    </td>
                                    <td>
                                        <span class="badge <%= statusBadge %> rounded-pill px-3 py-2">
                                            <i class="bi <%= statusIcon %> me-1"></i><%= vStatus %>
                                        </span>
                                    </td>
                                    <td>
                                        <% if (v.getImageURL() != null && !v.getImageURL().isEmpty()) { %>
                                        <img src="<%= v.getImageURL() %>" alt="Vehicle" class="bus-vehicle-img">
                                        <% } else { %>
                                        <span class="text-muted small">No image</span>
                                        <% } %>
                                    </td>
                                    <td class="text-end text-nowrap">
                                        <form action="MainController" method="post" class="d-inline">
                                            <input type="hidden" name="action" value="UpdateVehicle_page">
                                            <input type="hidden" name="vehicleID" value="<%= v.getVehicleID() %>">
                                            <button type="submit" class="btn btn-sm btn-outline-dark rounded-pill" title="Edit">
                                                <i class="bi bi-pencil"></i>
                                            </button>
                                        </form>
                                        <form action="MainController" method="post" class="d-inline"
                                              onsubmit="return confirm('Remove this vehicle from your fleet?');">
                                            <input type="hidden" name="action" value="RemoveVehicle">
                                            <input type="hidden" name="vehicleID" value="<%= v.getVehicleID() %>">
                                            <button type="submit" class="btn btn-sm btn-outline-danger rounded-pill" title="Remove">
                                                <i class="bi bi-trash"></i>
                                            </button>
                                        </form>
                                    </td>
                                </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                    <% } else { %>
                    <div class="text-center py-5 text-muted">
                        <i class="bi bi-truck fs-1 d-block mb-3 opacity-50"></i>
                        <p class="mb-3">No vehicles in your fleet yet.</p>
                        <a href="MainController?action=AddBusinessVehicle_page" class="btn btn-black rounded-pill btn-sm px-4">Add Vehicles</a>
                    </div>
                    <% } %>
                </div>
            </div>

            <!-- PROMOTIONS -->
            <div class="col-lg-3">
                <div class="bus-card p-4 h-100">
                    <h5 class="fw-bold mb-3"><i class="bi bi-tag me-2 text-muted"></i>Promotions</h5>
                    <% if (promoList != null && !promoList.isEmpty()) { %>
                    <% for (Promotion p : promoList) { %>
                    <div class="border rounded-3 p-3 mb-2">
                        <div class="fw-semibold"><%= p.getPromotionName() %></div>
                        <div class="text-muted small mt-1"><%= p.getDescription() %></div>
                        <span class="badge bg-dark mt-2"><%= p.getDiscountPercent() %>% OFF</span>
                    </div>
                    <% } %>
                    <% } else { %>
                    <p class="text-muted small mb-0">No promotions available.</p>
                    <% } %>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>