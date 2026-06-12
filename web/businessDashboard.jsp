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
%>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Business Dashboard</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    </head>

    <body style="background:#f5f7fa;">

        <!-- NAV -->
        <nav class="navbar bg-white shadow-sm border-bottom">
            <div class="container">
                <div class="fw-bold fs-4">
                    <i class="bi bi-building me-2"></i>Business Dashboard
                </div>

                <div class="d-flex align-items-center gap-3">
                    <span class="text-muted small">
                        <%= fullname%>
                    </span>

                    <a href="MainController?action=logout"
                       class="btn btn-outline-dark btn-sm rounded-pill px-3">
                        Logout
                    </a>
                </div>
            </div>
        </nav>

        <div class="container py-4">

            <!-- TOP INFO -->
            <div class="row g-3 mb-4">

                <div class="col-md-4">
                    <div class="bg-white p-3 rounded shadow-sm">
                        <div class="text-muted small">Points</div>
                        <h4><%= pointBalance != null ? pointBalance : 0%></h4>
                    </div>
                </div>

                <div class="col-md-4">
                    <div class="bg-white p-3 rounded shadow-sm">
                        <div class="text-muted small">Tier</div>
                        <h4><%= tier != null ? tier.getTierName() : "Standard"%></h4>
                    </div>
                </div>

                <div class="col-md-4">
                    <div class="bg-white p-3 rounded shadow-sm">
                        <div class="text-muted small">Next Reward</div>
                        <h5 class="text-truncate">
                            <%= nextReward != null ? nextReward.getRewardName() : "None"%>
                        </h5>
                    </div>
                </div>

            </div>

            <div class="row g-4">

                <!-- LEFT PROFILE -->
                <div class="col-lg-3">

                    <div class="bg-white p-4 rounded shadow-sm text-center">

                        <div class="bg-dark text-white rounded-circle d-flex align-items-center justify-content-center mx-auto mb-3"
                             style="width:70px;height:70px;font-size:20px;">
                            <%= initials.toUpperCase()%>
                        </div>

                        <h5><%= fullname%></h5>

                        <div class="text-muted small mb-3">Business Account</div>

                        <hr>

                        <div class="text-start small">
                            <div><b>Email:</b> <%= account.getEmail()%></div>
                            <div class="mt-2"><b>Phone:</b> <%= account.getPhone()%></div>
                        </div>

                    </div>
                </div>

                <!-- VEHICLES -->
                <div class="col-lg-6">

                    <div class="bg-white p-4 rounded shadow-sm">

                        <div class="d-flex justify-content-between mb-3">
                            <h5 class="m-0">My Vehicles</h5>

                            <a href="MainController?action=AddBusinessVehicle_page"
                               class="btn btn-dark btn-sm">
                                + Add
                            </a>
                        </div>

                        <% if (vehicleList != null && !vehicleList.isEmpty()) { %>

                        <table class="table table-hover align-middle">

                            <thead>
                                <tr>
                                    <th>Vehicle</th>
                                    <th>Plate</th>
                                    <th>Image</th>
                                    <th class="text-end">Action</th>
                                </tr>
                            </thead>

                            <tbody>

                                <% for (Vehicle v : vehicleList) {%>
                                <tr>

                                    <td>
                                        <b><%= v.getBrandName()%> <%= v.getModelName()%></b><br>
                                        <small class="text-muted">
                                            <%= v.getColor()%> - <%= v.getManufactureYear()%>
                                        </small>
                                    </td>

                                    <td>
                                        <span class="badge bg-dark">
                                            <%= v.getLicensePlate()%>
                                        </span>
                                    </td>

                                    <td>
                                        <img src="<%= v.getImageURL()%>"
                                             style="width:70px;height:50px;object-fit:cover;border-radius:6px;">
                                    </td>

                                    <td class="text-end">

                                        <!-- EDIT -->
                                        <form action="MainController" method="post" style="display:inline;">
                                            <input type="hidden" name="action" value="UpdateVehicle_page">
                                            <input type="hidden" name="vehicleID" value="<%= v.getVehicleID()%>">

                                            <button class="btn btn-sm btn-outline-primary">
                                                <i class="bi bi-pencil"></i>
                                            </button>
                                        </form>

                                        <!-- DELETE -->
                                        <form action="MainController" method="post"
                                              style="display:inline;"
                                              onsubmit="return confirm('Delete this vehicle?');">

                                            <input type="hidden" name="action" value="RemoveVehicle">
                                            <input type="hidden" name="vehicleID" value="<%= v.getVehicleID()%>">

                                            <button class="btn btn-sm btn-outline-danger">
                                                <i class="bi bi-trash"></i>
                                            </button>
                                        </form>

                                    </td>

                                </tr>
                                <% } %>

                            </tbody>
                        </table>

                        <% } else { %>

                        <div class="text-center text-muted py-4">
                            No vehicles found
                        </div>

                        <% } %>

                    </div>
                </div>

                <!-- PROMOTION -->
                <div class="col-lg-3">

                    <div class="bg-white p-4 rounded shadow-sm">

                        <h5 class="mb-3">Promotions</h5>

                        <% if (promoList != null && !promoList.isEmpty()) { %>

                        <% for (Promotion p : promoList) {%>

                        <div class="border rounded p-2 mb-2">

                            <b><%= p.getPromotionName()%></b><br>

                            <small class="text-muted">
                                <%= p.getDescription()%>
                            </small>

                            <div class="mt-2">
                                <span class="badge bg-dark">
                                    <%= p.getDiscountPercent()%>% OFF
                                </span>
                            </div>

                        </div>

                        <% } %>

                        <% } else { %>

                        <div class="text-muted small">
                            No promotions
                        </div>

                        <% }%>

                    </div>

                </div>

            </div>

        </div>

    </body>
</html>