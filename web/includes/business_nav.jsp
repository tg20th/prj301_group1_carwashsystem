<%@page import="dto.Account"%>
<%@page import="dto.Business"%>
<%
    Account navAccount = (Account) session.getAttribute("ACCOUNT");
    Business navBus = (Business) session.getAttribute("BUS");
    String navBrand = navBus != null && navBus.getBusinessName() != null
            ? navBus.getBusinessName() : "EliteAuto Business";
    String navUser = navAccount != null
            ? navAccount.getLastName() + " " + navAccount.getFirstName() : "";
    String navActive = "";
    if (pageContext.getAttribute("busNavActive") != null) {
        navActive = (String) pageContext.getAttribute("busNavActive");
    }
%>
<nav class="navbar navbar-expand-lg py-3 bg-white sticky-top shadow-sm border-bottom">
    <div class="container">
        <a class="navbar-brand fw-bold tracking-tight text-decoration-none text-dark" href="BusinessDashboardController">
            <i class="bi bi-building me-2"></i><%= navBrand %>
        </a>
        <button class="navbar-toggler border-0" type="button" data-bs-toggle="collapse" data-bs-target="#busNavbar">
            <i class="bi bi-list fs-4"></i>
        </button>
        <div class="collapse navbar-collapse" id="busNavbar">
            <ul class="navbar-nav ms-auto align-items-lg-center gap-1 gap-lg-2">
                <li class="nav-item">
                    <a href="BusinessDashboardController"
                       class="nav-link rounded-pill px-3 small bus-nav-link <%= "dashboard".equals(navActive) ? "active" : "" %>">
                        <i class="bi bi-grid me-1"></i>Dashboard
                    </a>
                </li>
                <li class="nav-item">
                    <a href="BusinessBookingController"
                       class="nav-link rounded-pill px-3 small bus-nav-link <%= "booking".equals(navActive) ? "active" : "" %>">
                        <i class="bi bi-calendar-plus me-1"></i>Book Fleet
                    </a>
                </li>
                <li class="nav-item">
                    <a href="BusinessBookingHistoryController"
                       class="nav-link rounded-pill px-3 small bus-nav-link <%= "history".equals(navActive) ? "active" : "" %>">
                        <i class="bi bi-journal-text me-1"></i>History
                    </a>
                </li>
                <li class="nav-item d-none d-lg-block text-muted small px-2">
                    <%= navUser %>
                </li>
                <li class="nav-item">
                    <a href="MainController?action=logout"
                       class="btn btn-outline-dark btn-sm rounded-pill px-3">
                        <i class="bi bi-box-arrow-right me-1"></i>Logout
                    </a>
                </li>
            </ul>
        </div>
    </div>
</nav>