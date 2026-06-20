<%@ page pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<aside class="sidebar p-4 shadow-sm">
    <a class="text-dark text-decoration-none fw-bold fs-4 mb-4 d-flex align-items-center">
        <i class="bi bi-vinyl-fill me-2 fs-3 text-dark"></i>EliteAuto
    </a>

    <div class="overflow-y-auto flex-grow-1" style="scrollbar-width: none;">
        <ul class="nav flex-column gap-1" id="sidebarMenu">
            
            <li class="nav-item">
                <a class="nav-link px-3 py-2 d-flex align-items-center" href="MainController?action=admin_dashboard">
                    <i class="bi bi-grid-1x2-fill me-3"></i> Dashboard
                </a>
            </li>

            <li class="nav-item mt-3 mb-1">
                <span class="text-muted small fw-bold text-uppercase" style="font-size: 0.65rem; padding-left: 1rem;">Operations</span>
            </li>
            <li class="nav-item">
                <a class="nav-link px-3 py-2 d-flex align-items-center" href="MainController?action=booking_admin">
                    <i class="bi bi-calendar-check me-3"></i> Bookings
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link px-3 py-2 d-flex align-items-center" href="WashBayController?action=list">
                    <i class="bi bi-droplet me-3"></i> Wash Bays
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link px-3 py-2 d-flex align-items-center" href="MainController?action=timeslot_schedule">
                    <i class="bi bi-clock-history me-3"></i> Time Slot Management
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link px-3 py-2 d-flex align-items-center" href="ServiceController?action=list">
                    <i class="bi bi-tools me-3"></i> Services
                </a>
            </li>

            <li class="nav-item mt-3 mb-1">
                <span class="text-muted small fw-bold text-uppercase" style="font-size: 0.65rem; padding-left: 1rem;">Requests</span>
            </li>
            <li class="nav-item">
                <a class="nav-link px-3 py-2 d-flex align-items-center" href="MainController?action=vehicle_request">
                    <i class="bi bi-car-front me-3"></i> Car Requests
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link px-3 py-2 d-flex align-items-center" href="MainController?action=business_request">
                    <i class="bi bi-building-add me-3"></i> Business Requests
                </a>
            </li>

            <li class="nav-item mt-3 mb-1">
                <span class="text-muted small fw-bold text-uppercase" style="font-size: 0.65rem; padding-left: 1rem;">Customers</span>
            </li>
            <li class="nav-item">
                <a class="nav-link px-3 py-2 d-flex align-items-center" href="MainController?action=manage_user">
                    <i class="bi bi-people me-3"></i> Users Management
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link px-3 py-2 d-flex align-items-center" href="MainController?action=manage_tier">
                    <i class="bi bi-star me-3"></i> Membership Tiers
                </a>
            </li>

            <li class="nav-item mt-3 mb-1">
                <span class="text-muted small fw-bold text-uppercase" style="font-size: 0.65rem; padding-left: 1rem;">Sales & Marketing</span>
            </li>
            <li class="nav-item">
                <a class="nav-link px-3 py-2 d-flex align-items-center" href="MainController?action=Revenue">
                    <i class="bi bi-graph-up-arrow me-3"></i> Revenue
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link px-3 py-2 d-flex align-items-center" href="ManagePromotionsController">
                    <i class="bi bi-ticket-perforated me-3"></i> Promotions
                </a>
            </li>
            
        </ul>
    </div>

    <c:choose>
        <c:when test="${not empty sessionScope.ACCOUNT}">
            <c:set var="adminName" value="${sessionScope.ACCOUNT.lastName} ${sessionScope.ACCOUNT.firstName}" />
            <c:set var="adminEmail" value="${sessionScope.ACCOUNT.email}" />
        </c:when>
        <c:otherwise>
            <c:set var="adminName" value="Administrator" />
            <c:set var="adminEmail" value="admin@eliteauto.com" />
        </c:otherwise>
    </c:choose>

    <div class="sidebar-profile d-flex align-items-center gap-3 cursor-pointer mt-3 border-top pt-4 pb-2">
        <img src="https://ui-avatars.com/api/?name=${adminName}&background=0f172a&color=fff&bold=true" alt="${adminName}" class="rounded-circle shadow-sm" width="40" height="40">
        
        <div class="d-flex flex-column">
            <span class="small fw-bold text-dark mb-0 text-truncate" style="max-width: 120px;" title="${adminName}">${adminName}</span>
            <span class="text-muted text-truncate" style="font-size: 0.7rem; max-width: 120px;" title="${adminEmail}">${adminEmail}</span>
        </div>
        
        <a href="MainController?action=logout" class="ms-auto text-danger transition-hover" title="Logout">
            <i class="bi bi-box-arrow-right fs-5"></i>
        </a>
    </div>
</aside>

<script>
    document.addEventListener("DOMContentLoaded", function () {
        // Lấy tên Controller hiện tại
        let currentPath = window.location.pathname.split('/').pop();
        if (!currentPath) currentPath = 'AdminDashboardController';
        
        // Lấy tham số 'action' hiện hành trên URL (nếu có)
        let urlParams = new URLSearchParams(window.location.search);
        let currentAction = urlParams.get('action');

        let links = document.querySelectorAll('#sidebarMenu .nav-link');

        links.forEach(link => {
            let href = link.getAttribute('href');
            let isActive = false;

            if (href && href !== '#') {
                // Tách href thành Controller và phần Action
                let hrefPath = href.split('?')[0];
                let linkParams = new URLSearchParams(href.includes('?') ? href.split('?')[1] : '');
                let linkAction = linkParams.get('action');

                // Logic so sánh: Bắt buộc trùng Controller, và trùng luôn cả Action (nếu có)
                if (currentPath === hrefPath && currentAction === linkAction) {
                    isActive = true;
                }
            }

            // Đổi màu và thêm border-radius cho thẻ
            if (isActive) {
                link.classList.add('active', 'bg-dark', 'text-white', 'rounded-3', 'shadow-sm');
                link.classList.remove('text-dark');
            } else {
                link.classList.remove('active', 'bg-dark', 'text-white', 'rounded-3', 'shadow-sm');
                link.classList.add('text-dark');
            }
        });
    });
</script>