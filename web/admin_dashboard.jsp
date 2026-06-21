<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<c:if test="${empty sessionScope.ACCOUNT}">
    <jsp:forward page="index.jsp"/>
</c:if>
    
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Dashboard Overview | Elite Auto</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">

        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">

        <link href="css/admin.css?v=1.1" rel="stylesheet">
        
        <style>
            /* Tổng quan nền */
            body { background-color: #f4f7fe; font-family: 'Inter', sans-serif; color: #334155; }

        </style>
    </head>
    <body class="admin-body">

        <jsp:include page="admin_sidebar.jsp"/>

        <jsp:useBean id="now" class="java.util.Date" />
        <fmt:formatDate value="${now}" pattern="dd/MM/yyyy" var="todayDate" />

        <main class="main-wrapper p-4 p-lg-5 animate-fade-up flex-grow-1" style="min-width: 0;">

            <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center mb-4 pb-2">
                <div>
                    <h2 class="fw-bolder tracking-tight mb-1 text-dark fs-2">Dashboard Overview</h2>
                    <p class="text-secondary fw-medium mb-0">Live metrics and overview of your car wash business</p>
                </div>

                <div class="bg-white border border-light shadow-sm rounded-pill px-4 py-2 d-flex align-items-center gap-3 mt-3 mt-md-0">
                    <i class="bi bi-calendar3 text-primary"></i>
                    <span class="small fw-bolder text-dark">${todayDate}</span>
                </div>
            </div>

            <div class="row g-3 mb-4">
                <div class="col-6 col-md-4 col-lg-2">
                    <div class="glass-card p-4 rounded-4 shadow-sm h-100 hover-scale text-center">
                        <div class="gradient-primary rounded-circle d-inline-flex align-items-center justify-content-center shadow-sm mb-3" style="width: 55px; height: 55px;">
                            <i class="bi bi-people-fill fs-4 text-white"></i>
                        </div>
                        <div class="text-muted fw-bold text-uppercase small mb-1" style="letter-spacing: 0.5px; font-size: 0.7rem;">Total Users</div>
                        <h3 class="fw-bolder text-dark mb-0 tracking-tight">${empty TOTALCUSTOMER ? 0 : TOTALCUSTOMER}</h3>
                    </div>
                </div>
                
                <div class="col-6 col-md-4 col-lg-2">
                    <div class="glass-card p-4 rounded-4 shadow-sm h-100 hover-scale text-center">
                        <div class="gradient-success rounded-circle d-inline-flex align-items-center justify-content-center shadow-sm mb-3" style="width: 55px; height: 55px;">
                            <i class="bi bi-car-front-fill fs-4 text-white"></i>
                        </div>
                        <div class="text-muted fw-bold text-uppercase small mb-1" style="letter-spacing: 0.5px; font-size: 0.7rem;">Total Vehicles</div>
                        <h3 class="fw-bolder text-dark mb-0 tracking-tight">${empty TOTALVEHICLE ? 0 : TOTALVEHICLE}</h3>
                    </div>
                </div>
                
                <div class="col-6 col-md-4 col-lg-2">
                    <div class="glass-card p-4 rounded-4 shadow-sm h-100 hover-scale text-center">
                        <div class="gradient-warning rounded-circle d-inline-flex align-items-center justify-content-center shadow-sm mb-3" style="width: 55px; height: 55px;">
                            <i class="bi bi-building-fill-exclamation fs-4 text-white"></i>
                        </div>
                        <div class="text-muted fw-bold text-uppercase small mb-1" style="letter-spacing: 0.5px; font-size: 0.7rem;">Pending Business</div>
                        <h3 class="fw-bolder text-dark mb-0 tracking-tight">${empty TOTALACCPENDING ? 0 : TOTALACCPENDING}</h3>
                    </div>
                </div>
                
                <div class="col-6 col-md-4 col-lg-2">
                    <div class="glass-card p-4 rounded-4 shadow-sm h-100 hover-scale text-center">
                        <div class="gradient-danger rounded-circle d-inline-flex align-items-center justify-content-center shadow-sm mb-3" style="width: 55px; height: 55px;">
                            <i class="bi bi-shield-lock-fill fs-4 text-white"></i>
                        </div>
                        <div class="text-muted fw-bold text-uppercase small mb-1" style="letter-spacing: 0.5px; font-size: 0.7rem;">Pending Cars</div>
                        <h3 class="fw-bolder text-dark mb-0 tracking-tight">${empty TOTALVEHICLEPENDING ? 0 : TOTALVEHICLEPENDING}</h3>
                    </div>
                </div>

                <div class="col-6 col-md-4 col-lg-2">
                    <div class="glass-card p-4 rounded-4 shadow-sm h-100 hover-scale text-center">
                        <div class="gradient-info rounded-circle d-inline-flex align-items-center justify-content-center shadow-sm mb-3" style="width: 55px; height: 55px;">
                            <i class="bi bi-cash-stack fs-4 text-white"></i>
                        </div>
                        <div class="text-muted fw-bold text-uppercase small mb-1" style="letter-spacing: 0.5px; font-size: 0.7rem;">Revenue Today</div>
                        <h4 class="fw-bolder text-dark mb-0 tracking-tight fs-5 text-nowrap mt-1">
                            <fmt:formatNumber value="${empty REVENUEDAY ? 0 : REVENUEDAY}" pattern="#,###" /> đ
                        </h4>
                    </div>
                </div>
                
                <div class="col-6 col-md-4 col-lg-2">
                    <div class="glass-card p-4 rounded-4 shadow-sm h-100 hover-scale text-center">
                        <div class="gradient-purple rounded-circle d-inline-flex align-items-center justify-content-center shadow-sm mb-3" style="width: 55px; height: 55px;">
                            <i class="bi bi-wallet-fill fs-4 text-white"></i>
                        </div>
                        <div class="text-muted fw-bold text-uppercase small mb-1" style="letter-spacing: 0.5px; font-size: 0.7rem;">Revenue Month</div>
                        <h4 class="fw-bolder text-dark mb-0 tracking-tight fs-5 text-nowrap mt-1">
                            <fmt:formatNumber value="${empty REVENUEMONTH ? 0 : REVENUEMONTH}" pattern="#,###" /> đ
                        </h4>
                    </div>
                </div>
            </div>

            <div class="row g-4 mb-4 align-items-stretch">
                
                <div class="col-lg-8">
                    <div class="glass-card p-4 rounded-4 shadow-sm h-100 d-flex flex-column">
                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <h5 class="fw-bolder m-0 text-dark tracking-tight"><i class="bi bi-stars text-warning me-2"></i> Loyalty Summary</h5>
                        </div>

                        <div class="flex-grow-1 mb-3">
                            <div class="row g-3 h-100">
                                <c:choose>
                                    <c:when test="${empty LISTOFTIER}">
                                        <div class="col-12 d-flex justify-content-center align-items-center text-muted py-4">No loyalty tiers data available.</div>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach var="t" items="${LISTOFTIER}">
                                            <c:set var="colorClass" value="text-muted" />
                                            <c:set var="tierNameLower" value="${fn:toLowerCase(t.tierName)}" />
                                            
                                            <c:choose>
                                                <c:when test="${tierNameLower == 'silver'}"><c:set var="colorClass" value="text-secondary" /></c:when>
                                                <c:when test="${tierNameLower == 'gold'}"><c:set var="colorClass" value="text-warning" /></c:when>
                                                <c:when test="${tierNameLower == 'platinum' || tierNameLower == 'diamond'}"><c:set var="colorClass" value="text-info" /></c:when>
                                            </c:choose>

                                            <div class="col-6 col-lg-3">
                                                <div class="py-4 px-2 bg-white shadow-sm rounded-4 border border-light text-center hover-scale h-100 d-flex flex-column align-items-center justify-content-center" style="min-height: 150px;">
                                                    <i class="bi bi-award-fill ${colorClass} display-6 mb-3 d-block"></i>
                                                    <h6 class="fw-bolder mb-2 text-dark text-truncate text-uppercase tracking-tight" style="font-size: 0.75rem; letter-spacing: 1px;">${t.tierName}</h6>
                                                    <div>
                                                        <span class="fw-bolder text-dark fs-3">${t.totalCus}</span> 
                                                        <span class="text-muted fw-bold ms-1" style="font-size: 0.65rem;">USERS</span>
                                                    </div>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>

                        <a href="MainController?action=manage_tier" class="btn btn-dark-custom w-100 rounded-pill py-2 mt-auto small fw-bold text-decoration-none d-flex justify-content-center align-items-center shadow-sm">
                            <i class="bi bi-gear-fill me-2"></i> Manage Tiers
                        </a>
                    </div>
                </div>

                <div class="col-lg-4">
                    <div class="glass-card p-4 rounded-4 shadow-sm h-100 d-flex flex-column">
                        <c:set var="serviceCount" value="${empty LISTSERVICES ? 0 : fn:length(LISTSERVICES)}" />
                        
                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <h5 class="fw-bolder m-0 text-dark tracking-tight"><i class="bi bi-tools text-primary me-2"></i> Services</h5>
                            <span class="badge gradient-primary rounded-pill px-3 py-1 shadow-sm">Total: ${serviceCount}</span>
                        </div>

                        <div class="flex-grow-1 mb-4">
                            <c:choose>
                                <c:when test="${serviceCount == 0}">
                                    <div class="d-flex justify-content-center align-items-center h-100">
                                        <p class="text-center text-muted mb-0">No service data available.</p>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="d-flex flex-column">
                                        <c:forEach var="s" items="${LISTSERVICES}" begin="0" end="2">
                                            <c:set var="displayStatus" value="${s.status ? 'Active' : 'Inactive'}" />
                                            <c:set var="badgeClass" value="${s.status ? 'bg-success text-white' : 'bg-danger text-white'}" />
                                            
                                            <div class="d-flex justify-content-between align-items-center mb-3 p-3 bg-white rounded-4 border border-light shadow-sm hover-scale">
                                                <div class="d-flex align-items-center">
                                                    <div class="bg-light rounded-circle d-flex align-items-center justify-content-center me-3" style="width: 35px; height: 35px;">
                                                        <i class="bi bi-droplet-fill text-primary"></i>
                                                    </div>
                                                    <h6 class="fw-bold mb-0 text-dark small">${s.name}</h6>
                                                </div>
                                                <div class="text-end">
                                                    <span class="badge ${badgeClass} rounded-pill shadow-sm" style="font-size: 0.65rem; letter-spacing: 0.5px;">
                                                        ${displayStatus}
                                                    </span>
                                                </div>
                                            </div>
                                        </c:forEach>
                                        
                                        <c:if test="${serviceCount > 3}">
                                            <div class="text-center mt-2">
                                                <span class="text-muted fw-bold small bg-light px-3 py-1 rounded-pill border">
                                                    +${serviceCount - 3} more services
                                                </span>
                                            </div>
                                        </c:if>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div> 

                        <a href="MainController?action=service_list" class="btn btn-dark-custom w-100 rounded-pill py-2 mt-auto small fw-bold text-decoration-none d-flex justify-content-center align-items-center shadow-sm">
                            <i class="bi bi-sliders me-2"></i> Manage Services
                        </a>
                    </div>
                </div>
            </div>

            <div class="row g-4 mb-4 align-items-stretch">
                
                <div class="col-lg-8">
                    <div class="glass-card p-4 rounded-4 shadow-sm h-100 d-flex flex-column">
                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <h5 class="fw-bolder m-0 text-dark tracking-tight"><i class="bi bi-journal-check text-success me-2"></i> Recent Bookings</h5>
                            <a href="MainController?action=booking_admin" class="small fw-bold text-primary text-decoration-none hover-scale px-3 py-1 bg-primary bg-opacity-10 rounded-pill">View All</a>
                        </div>

                        <c:choose>
                            <c:when test="${empty LISTOFBOOKING}">
                                <div class="d-flex justify-content-center align-items-center flex-grow-1">
                                    <p class="text-center text-muted mb-0 py-5">No recent bookings found.</p>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="table-responsive flex-grow-1">
                                    <table class="table table-borderless table-spaced mb-0 align-middle">
                                        <thead>
                                            <tr class="border-bottom border-light">
                                                <th class="text-muted fw-bold text-uppercase pb-3 ps-2" style="font-size: 0.7rem; letter-spacing: 1px;">ID</th>
                                                <th class="text-muted fw-bold text-uppercase pb-3" style="font-size: 0.7rem; letter-spacing: 1px;">Customer</th>
                                                <th class="text-muted fw-bold text-uppercase pb-3" style="font-size: 0.7rem; letter-spacing: 1px;">Car</th>
                                                <th class="text-muted fw-bold text-uppercase pb-3" style="font-size: 0.7rem; letter-spacing: 1px;">Service</th>
                                                <th class="text-muted fw-bold text-uppercase pb-3" style="font-size: 0.7rem; letter-spacing: 1px;">Time</th>
                                                <th class="text-muted fw-bold text-uppercase pb-3 text-center" style="font-size: 0.7rem; letter-spacing: 1px;">Status</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="b" items="${LISTOFBOOKING}" begin="0" end="4">
                                                <c:set var="status" value="${empty b.status ? 'Pending' : b.status}" />
                                                <c:set var="statusLower" value="${fn:toLowerCase(status)}" />
                                                <c:set var="badgeColor" value="bg-secondary text-white" />
                                                
                                                <c:choose>
                                                    <c:when test="${statusLower == 'completed'}"><c:set var="badgeColor" value="gradient-success" /></c:when>
                                                    <c:when test="${statusLower == 'inprogress'}"><c:set var="badgeColor" value="gradient-info" /></c:when>
                                                    <c:when test="${statusLower == 'confirmed'}"><c:set var="badgeColor" value="gradient-primary" /></c:when>
                                                    <c:when test="${statusLower == 'pending'}"><c:set var="badgeColor" value="gradient-warning text-dark" /></c:when>
                                                    <c:when test="${statusLower == 'cancelled' || statusLower == 'noshow'}"><c:set var="badgeColor" value="gradient-danger" /></c:when>
                                                </c:choose>
                                                
                                                <tr class="custom-row border-bottom border-light">
                                                    <td class="text-muted fw-bold font-monospace small ps-2 py-3">#${b.bookingID}</td>
                                                    <td class="fw-bolder text-dark py-3">${b.cusName}</td>
                                                    <td class="py-3"><span class="badge bg-light text-dark border px-2 py-1">${b.licensePlate}</span></td>
                                                    <td class="text-dark fw-medium small py-3">${b.service}</td>
                                                    <td class="text-muted small py-3">
                                                        <span class="d-block text-dark fw-bold"><i class="bi bi-clock me-1"></i> 
                                                            ${b.timeslot.start.hour}:${b.timeslot.start.minute < 10 ? '0' : ''}${b.timeslot.start.minute} - 
                                                            ${b.timeslot.start.dayOfMonth < 10 ? '0' : ''}${b.timeslot.start.dayOfMonth}/${b.timeslot.start.monthValue < 10 ? '0' : ''}${b.timeslot.start.monthValue}/${b.timeslot.start.year}
                                                        </span>
                                                    </td>
                                                    <td class="text-center py-3">
                                                        <span class="badge ${badgeColor} rounded-pill px-3 py-2 shadow-sm text-uppercase" style="font-size: 0.7rem; letter-spacing: 0.5px;">
                                                            ${status}
                                                        </span>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <div class="col-lg-4">
                    <div class="glass-card p-4 rounded-4 shadow-sm h-100 d-flex flex-column">
                        <c:set var="promoCount" value="${empty LISTOFPROMOTION ? 0 : fn:length(LISTOFPROMOTION)}" />
                        
                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <h5 class="fw-bolder m-0 text-dark tracking-tight"><i class="bi bi-megaphone-fill text-danger me-2"></i> Campaigns</h5>
                            <span class="badge gradient-danger rounded-pill px-3 py-1 shadow-sm">Running: ${promoCount}</span>
                        </div>

                        <div class="flex-grow-1 mb-4">
                            <c:choose>
                                <c:when test="${promoCount == 0}">
                                    <div class="d-flex justify-content-center align-items-center h-100">
                                        <p class="text-center text-muted mb-0">No active promotions currently running.</p>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="d-flex flex-column">
                                        <c:forEach var="promo" items="${LISTOFPROMOTION}" begin="0" end="2">
                                            <div class="d-flex align-items-start mb-3 p-3 bg-white shadow-sm rounded-4 border border-light hover-scale">
                                                <div class="bg-danger bg-opacity-10 rounded-circle d-flex align-items-center justify-content-center me-3 mt-1" style="width: 35px; height: 35px; min-width: 35px;">
                                                    <i class="bi bi-tag-fill text-danger"></i>
                                                </div>
                                                <div>
                                                    <h6 class="fw-bolder mb-1 text-dark small">${promo.promotionName}</h6>
                                                    <span class="d-block text-secondary fw-medium mb-1" style="font-size: 0.8rem; line-height: 1.3;">
                                                        ${promo.description}
                                                    </span>
                                                    <span class="d-inline-block text-danger fw-bold bg-danger bg-opacity-10 px-2 py-1 rounded" style="font-size: 0.7rem;">
                                                        Ends: ${promo.endDate}
                                                    </span>
                                                </div>
                                            </div>
                                        </c:forEach>
                                        
                                        <c:if test="${promoCount > 3}">
                                            <div class="text-center mt-2">
                                                <span class="text-muted fw-bold small bg-light px-3 py-1 rounded-pill border">
                                                    +${promoCount - 3} more campaigns
                                                </span>
                                            </div>
                                        </c:if>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <a href="MainController?action=manage_promotion" class="btn btn-dark-custom w-100 rounded-pill py-2 mt-auto small fw-bold text-decoration-none d-flex justify-content-center align-items-center shadow-sm">
                            <i class="bi bi-magic me-2"></i> Manage Campaigns
                        </a>
                    </div>
                </div>
            </div> 
        </main>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>