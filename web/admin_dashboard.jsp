<%@page import="dto.Booking"%>
<%@page import="dto.Promotion"%>
<%@page import="dto.Service"%>
<%@page import="dto.Tier"%>
<%@page import="java.util.List"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="java.time.LocalDate"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<%
    Integer tCus = (Integer) request.getAttribute("TOTALCUSTOMER");
    int totalCustomer = (tCus != null) ? tCus : 0;

    Integer tAccPen = (Integer) request.getAttribute("TOTALACCPENDING");
    int totalAccPending = (tAccPen != null) ? tAccPen : 0;

    Integer tVeh = (Integer) request.getAttribute("TOTALVEHICLE");
    int totalVehicle = (tVeh != null) ? tVeh : 0;

    Integer tVehPen = (Integer) request.getAttribute("TOTALVEHICLEPENDING");
    int totalVehiclePending = (tVehPen != null) ? tVehPen : 0;

    Integer rDay = (Integer) request.getAttribute("REVENUEDAY");
    int revenueDay = (rDay != null) ? rDay : 0;

    Integer rMonth = (Integer) request.getAttribute("REVENUEMONTH");
    int revenueMonth = (rMonth != null) ? rMonth : 0;

    List<Tier> listTier = (List<Tier>) request.getAttribute("LISTOFTIER");
    List<Service> listServices = (List<Service>) request.getAttribute("LISTSERVICES");
    List<Promotion> listPromotion = (List<Promotion>) request.getAttribute("LISTOFPROMOTION");
    List<Booking> listBooking = (List<Booking>) request.getAttribute("LISTOFBOOKING");

    LocalDate today = LocalDate.now();
    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
%>

<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Dashboard Overview | Elite Auto</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">

        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">

        <link href="css/admin.css?v=1.0" rel="stylesheet">
    </head>
    <body class="admin-body">

        <aside class="sidebar p-4 shadow-sm">
            <a href="DashboardController" class="text-dark text-decoration-none fw-bold fs-4 mb-4 d-flex align-items-center">
                <i class="bi bi-vinyl-fill me-2 fs-3 text-dark"></i>EliteAuto
            </a>

            <div class="overflow-y-auto" style="scrollbar-width: none;">
                <ul class="nav flex-column gap-1" id="sidebarMenu">
                    <li class="nav-item">
                        <a class="nav-link active d-flex align-items-center" href="DashboardController"><i class="bi bi-grid-1x2-fill me-3"></i> Dashboard</a>
                    </li>

                    <li class="nav-item mt-3 mb-1">
                        <span class="text-muted small fw-bold text-uppercase" style="font-size: 0.65rem; padding-left: 1rem;">Operations</span>
                    </li>
                    <li class="nav-item"><a class="nav-link d-flex align-items-center" href="CarRequestsController"><i class="bi bi-car-front me-3"></i> Car Requests</a></li>
                    <li class="nav-item"><a class="nav-link d-flex align-items-center" href="BusinessRequestsController"><i class="bi bi-building me-3"></i> Business Requests</a></li>
                    <li class="nav-item"><a class="nav-link d-flex align-items-center" href="WashBayMgmtController"><i class="bi bi-droplet me-3"></i> Wash Bay Mgmt</a></li>
                    <li class="nav-item"><a class="nav-link d-flex align-items-center" href="SlotScheduleController"><i class="bi bi-calendar-range me-3"></i> Slot Schedule</a></li>

                    <li class="nav-item mt-3 mb-1">
                        <span class="text-muted small fw-bold text-uppercase" style="font-size: 0.65rem; padding-left: 1rem;">Management</span>
                    </li>
                    <li class="nav-item"><a class="nav-link d-flex align-items-center" href="UsersMgmtController"><i class="bi bi-people me-3"></i> Users Mgmt</a></li>
                    <li class="nav-item"><a class="nav-link d-flex align-items-center" href="RevenueController"><i class="bi bi-graph-up me-3"></i> Revenue</a></li>
                    <li class="nav-item"><a class="nav-link d-flex align-items-center" href="ManagePromotionsController"><i class="bi bi-ticket-perforated me-3"></i> Promos</a></li>

                    <li class="nav-item mt-3 mb-1">
                        <span class="text-muted small fw-bold text-uppercase" style="font-size: 0.65rem; padding-left: 1rem;">Growth & Loyalty</span>
                    </li>
                    <li class="nav-item"><a class="nav-link d-flex align-items-center" href="ManageTiersController"><i class="bi bi-star me-3"></i> Tier Rules & Rates</a></li>
                    <li class="nav-item"><a class="nav-link d-flex align-items-center" href="TargetedPromosController"><i class="bi bi-megaphone me-3"></i> Targeted Promos</a></li>

                    <li class="nav-item mt-3 mb-1">
                        <span class="text-muted small fw-bold text-uppercase" style="font-size: 0.65rem; padding-left: 1rem;">System</span>
                    </li>
                    <li class="nav-item"><a class="nav-link d-flex align-items-center" href="ReportsController"><i class="bi bi-file-earmark-bar-graph me-3"></i> Reports</a></li>
                    <li class="nav-item"><a class="nav-link d-flex align-items-center" href="SettingsController"><i class="bi bi-gear me-3"></i> Settings</a></li>
                </ul>
            </div>

            <div class="sidebar-profile d-flex align-items-center gap-3 cursor-pointer mt-3 border-top pt-3">
                <img src="https://ui-avatars.com/api/?name=Admin&background=000&color=fff" alt="Admin" class="rounded-circle" width="40" height="40">
                <div class="d-flex flex-column">
                    <span class="small fw-bold text-dark mb-0">Admin</span>
                    <span class="text-muted" style="font-size: 0.75rem;">Super Administrator</span>
                </div>
                <a href="LogoutController" class="ms-auto text-muted transition-hover">
                    <i class="bi bi-box-arrow-right" title="Logout"></i>
                </a>
            </div>
        </aside>

        <main class="main-wrapper p-4 p-lg-5 animate-fade-up">

            <div class="d-flex justify-content-between align-items-end mb-4 pb-2">
                <div>
                    <h2 class="fw-bold tracking-tight mb-1 text-dark">Dashboard</h2>
                    <p class="text-muted small mb-0">Overview of your car wash business</p>
                </div>

                <div class="bg-white border border-light shadow-sm rounded-pill px-4 py-2 d-flex align-items-center gap-3">
                    <span class="small fw-medium text-dark"><%= today.format(formatter)%></span>
                    <i class="bi bi-calendar3 text-muted"></i>
                </div>
            </div>

            <div class="row g-3 mb-4">
                <div class="col-6 col-md-4 col-lg-2">
                    <div class="bg-white p-4 rounded-4 shadow-sm border border-light h-100 transition-hover text-center">
                        <div class="kpi-icon bg-primary bg-opacity-10 text-primary mb-3 mx-auto"><i class="bi bi-people-fill"></i></div>
                        <div class="text-muted small mb-1">Total Users</div>
                        <h3 class="fw-bold mb-0 text-dark fs-3"><%= totalCustomer%></h3>
                    </div>
                </div>
                <div class="col-6 col-md-4 col-lg-2">
                    <div class="bg-white p-4 rounded-4 shadow-sm border border-light h-100 transition-hover text-center">
                        <div class="kpi-icon bg-success bg-opacity-10 text-success mb-3 mx-auto"><i class="bi bi-car-front-fill"></i></div>
                        <div class="text-muted small mb-1">Total Vehicles</div>
                        <h3 class="fw-bold mb-0 text-dark fs-3"><%= totalVehicle%></h3>
                    </div>
                </div>
                <div class="col-6 col-md-4 col-lg-2">
                    <div class="bg-white p-4 rounded-4 shadow-sm border border-light h-100 transition-hover text-center">
                        <div class="kpi-icon bg-warning bg-opacity-10 text-warning mb-3 mx-auto"><i class="bi bi-building-fill"></i></div>
                        <div class="text-muted small mb-1">Pending Business</div>
                        <h3 class="fw-bold mb-0 text-dark fs-3"><%= totalAccPending%></h3>
                    </div>
                </div>
                <div class="col-6 col-md-4 col-lg-2">
                    <div class="bg-white p-4 rounded-4 shadow-sm border border-light h-100 transition-hover text-center">
                        <div class="kpi-icon bg-danger bg-opacity-10 text-danger mb-3 mx-auto"><i class="bi bi-car-front-fill"></i></div>
                        <div class="text-muted small mb-1">Pending Cars</div>
                        <h3 class="fw-bold mb-0 text-dark fs-3"><%= totalVehiclePending%></h3>
                    </div>
                </div>
                
                <div class="col-6 col-md-4 col-lg-2">
                    <div class="bg-white p-4 rounded-4 shadow-sm border border-light h-100 transition-hover text-center">
                        <div class="kpi-icon bg-info bg-opacity-10 text-info mb-3 mx-auto"><i class="bi bi-cash-stack"></i></div>
                        <div class="text-muted small mb-1">Revenue Today</div>
                        <h4 class="fw-bold mb-0 text-dark fs-5 text-nowrap" style="margin-top: 5px;"><%= String.format("%,d", (long) revenueDay) %> đ</h4>
                    </div>
                </div>
                <div class="col-6 col-md-4 col-lg-2">
                    <div class="bg-white p-4 rounded-4 shadow-sm border border-light h-100 transition-hover text-center">
                        <div class="kpi-icon bg-dark bg-opacity-10 text-dark mb-3 mx-auto"><i class="bi bi-wallet-fill"></i></div>
                        <div class="text-muted small mb-1">Revenue Month</div>
                        <h4 class="fw-bold mb-0 text-dark fs-5 text-nowrap" style="margin-top: 5px;"><%= String.format("%,d", (long) revenueMonth) %> đ</h4>
                    </div>
                </div>
            </div>

            <div class="row g-4 mb-4 align-items-stretch">

                <div class="col-lg-8">
                    <div class="bg-white p-4 rounded-4 shadow-sm border border-light h-100 d-flex flex-column">

                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <h6 class="fw-bold m-0 text-dark">Loyalty Summary</h6>
                        </div>

                        <div class="flex-grow-1 mb-3">
                            <div class="row g-3">
                                <%
                                    if (listTier == null || listTier.isEmpty()) {
                                %>
                                <div class="col-12 d-flex justify-content-center align-items-center text-muted py-4">No loyalty tiers data available.</div>
                                <%
                                } else {
                                    for (Tier t : listTier) {
                                        String tierName = t.getTierName();
                                        String colorClass = "text-muted";

                                        if ("Silver".equalsIgnoreCase(tierName)) {
                                            colorClass = "text-secondary";
                                        } else if ("Gold".equalsIgnoreCase(tierName)) {
                                            colorClass = "text-warning";
                                        } else if ("Platinum".equalsIgnoreCase(tierName) || "Diamond".equalsIgnoreCase(tierName)) {
                                            colorClass = "text-info";
                                        }
                                %>
                                <div class="col-6 col-md-3">
                                    <div class="py-4 px-2 bg-light rounded-4 border text-center transition-hover h-100 d-flex flex-column justify-content-center">
                                        <i class="bi bi-award-fill <%= colorClass%> fs-3 mb-2 d-block"></i>

                                        <h6 class="fw-bold mb-1 text-dark text-truncate" style="font-size: 0.85rem;"><%= t.getTierName()%></h6>
                                        <div>
                                            <span class="fw-bold text-dark fs-5"><%= t.getTotalCus()%></span> 
                                            <span class="text-muted" style="font-size: 0.75rem;">users</span>
                                        </div>
                                    </div>
                                </div>
                                <%
                                        }
                                    }
                                %>
                            </div>
                        </div>

                        <a href="ManageTiersController" class="btn btn-dark w-100 rounded-pill py-2 mt-auto small fw-medium transition-hover text-decoration-none d-flex justify-content-center align-items-center">
                            <i class="bi bi-star me-2"></i>Manage Tiers
                        </a>

                    </div>
                </div>

                <div class="col-lg-4">
                    <div class="bg-white p-4 rounded-4 shadow-sm border border-light h-100 d-flex flex-column">
                        <%
                            int serviceCount = (listServices != null) ? listServices.size() : 0;
                        %>
                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <h6 class="fw-bold m-0 text-dark">Service Overview</h6>
                            <span class="badge bg-primary bg-opacity-10 text-primary border border-primary border-opacity-25 rounded-pill px-3 py-1">
                                Total: <%= serviceCount%>
                            </span>
                        </div>

                        <div class="flex-grow-1 mb-4">
                            <%
                                if (serviceCount == 0) {
                            %>
                            <div class="d-flex justify-content-center align-items-center h-100">
                                <p class="text-center text-muted mb-0">No service data available.</p>
                            </div>
                            <%
                            } else {
                            %>
                            <div class="d-flex flex-column">
                                <%
                                    int displayLimitSrv = Math.min(2, serviceCount);

                                    for (int i = 0; i < displayLimitSrv; i++) {
                                        Service s = listServices.get(i);
                                        boolean isActive = s.isStatus();
                                        String displayStatus = isActive ? "Active" : "Inactive";
                                        String badgeClass = isActive ? "bg-success bg-opacity-10 text-success border-success"
                                                : "bg-danger bg-opacity-10 text-danger border-danger";
                                %>
                                <div class="d-flex justify-content-between align-items-center mb-3 p-3 bg-light rounded-3 border transition-hover">
                                    <div class="d-flex align-items-center">
                                        <h6 class="fw-bold mb-0 text-dark small"><%= s.getName()%></h6>
                                    </div>
                                    <div class="text-end">
                                        <span class="badge <%= badgeClass%> border border-opacity-25" style="font-size: 0.65rem;">
                                            <%= displayStatus%>
                                        </span>
                                    </div>
                                </div>
                                <%
                                    }

                                    if (serviceCount > 2) {
                                        int remainingCountSrv = serviceCount - 2;
                                %>
                                <div class="text-center">
                                    <span class="text-muted fw-medium small bg-light px-3 py-1 rounded-pill border">
                                        +<%= remainingCountSrv%> more services
                                    </span>
                                </div>
                                <%
                                    }
                                %>
                            </div>
                            <%
                                }
                            %>
                        </div> 

                        <a href="ManageServiceController" class="btn btn-dark w-100 rounded-pill py-2 mt-auto small fw-medium transition-hover text-decoration-none d-flex justify-content-center align-items-center">
                            <i class="bi bi-gear me-2"></i>Manage Service
                        </a>
                    </div>
                </div>
            </div>

            <div class="row g-4 mb-4 align-items-stretch">

                <div class="col-lg-8">
                    <div class="bg-white p-4 rounded-4 shadow-sm border border-light h-100 d-flex flex-column">
                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <h6 class="fw-bold m-0 text-dark">Recent Bookings</h6>
                            <a href="ManageBookingsController" class="small text-muted text-decoration-none hover-dark">View All</a>
                        </div>

                        <% if (listBooking == null || listBooking.isEmpty()) { %>
                        <div class="d-flex justify-content-center align-items-center flex-grow-1">
                            <p class="text-center text-muted mb-0 py-5">No recent bookings found.</p>
                        </div>
                        <% } else { %>
                        <div class="table-responsive flex-grow-1">
                            <table class="table table-custom table-borderless table-hover mb-0 align-middle">

                                <thead>
                                    <tr class="border-bottom border-light">
                                        <th class="text-muted fw-medium pb-3 ps-2">ID</th>
                                        <th class="text-muted fw-medium pb-3">Customer</th>
                                        <th class="text-muted fw-medium pb-3">Car</th>
                                        <th class="text-muted fw-medium pb-3">Service</th>
                                        <th class="text-muted fw-medium pb-3">Time</th>
                                        <th class="text-muted fw-medium pb-3 text-center">Status</th>
                                    </tr>
                                </thead>

                                <tbody>
                                    <%
                                        int countBooking = listBooking.size();
                                        int displayLimitBooking = Math.min(5, countBooking);

                                        for (int i = 0; i < displayLimitBooking; i++) {
                                            Booking b = listBooking.get(i);

                                            String status = (b.getStatus() != null) ? b.getStatus() : "Pending";
                                            String badgeColor = "bg-secondary bg-opacity-10 text-secondary border-secondary";

                                            if ("Completed".equalsIgnoreCase(status)) {
                                                badgeColor = "bg-success bg-opacity-10 text-success border-success";
                                            } else if ("InProgress".equalsIgnoreCase(status)) {
                                                badgeColor = "bg-info bg-opacity-10 text-info border-info";
                                            } else if ("Confirmed".equalsIgnoreCase(status)) {
                                                badgeColor = "bg-primary bg-opacity-10 text-primary border-primary";
                                            } else if ("Pending".equalsIgnoreCase(status)) {
                                                badgeColor = "bg-warning bg-opacity-10 text-warning border-warning";
                                            } else if ("Cancelled".equalsIgnoreCase(status) || "NoShow".equalsIgnoreCase(status)) {
                                                badgeColor = "bg-danger bg-opacity-10 text-danger border-danger";
                                            }
                                    %>
                                    <tr class="border-bottom border-light">
                                        <td class="text-muted small ps-2"><%= b.getId()%></td>
                                        <td class="fw-medium text-dark"><%= b.getCusName()%></td>
                                        <td class="text-muted small"><%= b.getLicensePlate()%></td>
                                        <td class="text-dark small"><%= b.getService()%></td>
                                        <td class="text-muted small">
                                            <span class="d-block text-dark"><%= new java.text.SimpleDateFormat("dd/MM/yyyy").format(b.getBookingDate()) %></span>
                                        </td>
                                        <td class="text-center">
                                            <span class="badge <%= badgeColor%> border border-opacity-25" style="font-size: 0.7rem;">
                                                <%= status%>
                                            </span>
                                        </td>
                                    </tr>
                                    <% } // Đóng vòng lặp %>
                                </tbody>
                            </table>
                        </div>
                        <% } // Đóng if-else %>
                    </div>
                </div>

                <div class="col-lg-4">
                    <div class="bg-white p-4 rounded-4 shadow-sm border border-light h-100 d-flex flex-column">
                        <%
                            int promoCount = (listPromotion != null) ? listPromotion.size() : 0;
                        %>
                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <h6 class="fw-bold m-0 text-dark">Active Promotions</h6>
                            <span class="badge bg-primary bg-opacity-10 text-primary border border-primary border-opacity-25 rounded-pill px-3 py-1">
                                Running: <%= promoCount%>
                            </span>
                        </div>

                        <div class="flex-grow-1 mb-4">
                            <%
                                if (promoCount == 0) {
                            %>
                            <div class="d-flex justify-content-center align-items-center h-100">
                                <p class="text-center text-muted mb-0">No active promotions currently running.</p>
                            </div>
                            <%
                            } else {
                            %>
                            <div class="d-flex flex-column">
                                <%
                                    int displayLimitPromo = Math.min(3, promoCount);

                                    for (int i = 0; i < displayLimitPromo; i++) {
                                        Promotion promo = listPromotion.get(i);
                                        boolean isLastDisplayed = (i == displayLimitPromo - 1);
                                        boolean hasHiddenItems = (promoCount > 2);
                                        String borderClass = (!isLastDisplayed || hasHiddenItems) ? "mb-3 pb-3 border-bottom border-light" : "";
                                %>
                                <div class="d-flex align-items-start <%= borderClass%>">
                                    <i class="bi bi-circle-fill text-dark me-3" style="font-size: 0.4rem; margin-top: 0.4rem;"></i>
                                    <div>
                                        <h6 class="fw-bold mb-1 text-dark small"><%= promo.getPromotionName()%></h6>
                                        <span class="d-block text-dark fw-medium mb-1" style="font-size: 0.85rem;">
                                            <%= promo.getDescription()%>
                                        </span>
                                        <span class="d-block text-muted" style="font-size: 0.75rem;">
                                            Ends: <%= promo.getEndDate()%>
                                        </span>
                                    </div>
                               </div>
                                <%
                                    }

                                    if (promoCount > 3) {
                                        int remainingCountPromo = promoCount - 3;
                                %>
                                <div class="text-center">
                                    <span class="text-muted fw-medium small bg-light px-3 py-1 rounded-pill border">
                                        +<%= remainingCountPromo%> more promotions
                                    </span>
                                </div>
                                <%
                                    }
                                %>
                            </div>
                            <%
                                }
                            %>
                        </div>

                        <a href="ManagePromotionsController" class="btn btn-dark w-100 rounded-pill py-2 mt-auto small fw-medium transition-hover text-decoration-none d-flex justify-content-center align-items-center">
                            <i class="bi bi-megaphone me-2"></i>Manage Promotions
                        </a>
                    </div>
                </div>
            </div> 
        </main>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            document.addEventListener("DOMContentLoaded", function () {
                const sidebarLinks = document.querySelectorAll('.sidebar .nav-link');
                sidebarLinks.forEach(link => {
                    link.addEventListener('click', function (e) {
                        if (this.getAttribute('href') === '#') {
                            e.preventDefault();
                        }
                        sidebarLinks.forEach(l => l.classList.remove('active'));
                        this.classList.add('active');
                    });
                });
            });
        </script>
    </body>
</html>