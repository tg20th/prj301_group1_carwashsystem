<%@ page pageEncoding="UTF-8" %>
<aside class="sidebar p-4 shadow-sm">
    <a href="AdminDashboardController" class="text-dark text-decoration-none fw-bold fs-4 mb-4 d-flex align-items-center">
        <i class="bi bi-vinyl-fill me-2 fs-3 text-dark"></i>EliteAuto
    </a>

    <div class="overflow-y-auto flex-grow-1" style="scrollbar-width: none;">
        <ul class="nav flex-column gap-1" id="sidebarMenu">
            
            <li class="nav-item">
                <a class="nav-link d-flex align-items-center" href="AdminDashboardController">
                    <i class="bi bi-grid-1x2-fill me-3"></i> Dashboard
                </a>
            </li>

            <li class="nav-item mt-3 mb-1">
                <span class="text-muted small fw-bold text-uppercase" style="font-size: 0.65rem; padding-left: 1rem;">Operations</span>
            </li>
            <li class="nav-item">
                <a class="nav-link d-flex align-items-center" href="ManageBookingsController">
                    <i class="bi bi-calendar-check me-3"></i> Bookings
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link d-flex align-items-center" href="WashBayMgmtController">
                    <i class="bi bi-droplet me-3"></i> Wash Bays
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link d-flex align-items-center" href="TimeSlotController">
                    <i class="bi bi-clock-history me-3"></i> Time Slot Management
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link d-flex align-items-center" href="ManageServiceController">
                    <i class="bi bi-tools me-3"></i> Services
                </a>
            </li>

            <li class="nav-item mt-3 mb-1">
                <span class="text-muted small fw-bold text-uppercase" style="font-size: 0.65rem; padding-left: 1rem;">Requests</span>
            </li>
            <li class="nav-item">
                <a class="nav-link d-flex align-items-center" href="CarRequestsController">
                    <i class="bi bi-car-front me-3"></i> Car Requests
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link d-flex align-items-center" href="BusinessRequestsController">
                    <i class="bi bi-building-add me-3"></i> Business Requests
                </a>
            </li>

            <li class="nav-item mt-3 mb-1">
                <span class="text-muted small fw-bold text-uppercase" style="font-size: 0.65rem; padding-left: 1rem;">Customers</span>
            </li>
            <li class="nav-item">
                <a class="nav-link d-flex align-items-center" href="UsersMgmtController">
                    <i class="bi bi-people me-3"></i> Users Mgmt
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link d-flex align-items-center" href="ManageTiersController">
                    <i class="bi bi-star me-3"></i> Membership Tiers
                </a>
            </li>

            <li class="nav-item mt-3 mb-1">
                <span class="text-muted small fw-bold text-uppercase" style="font-size: 0.65rem; padding-left: 1rem;">Sales & Marketing</span>
            </li>
            <li class="nav-item">
                <a class="nav-link d-flex align-items-center" href="RevenueController">
                    <i class="bi bi-graph-up-arrow me-3"></i> Revenue
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link d-flex align-items-center" href="ManagePromotionsController">
                    <i class="bi bi-ticket-perforated me-3"></i> Promotions
                </a>
            </li>
            
        </ul>
    </div>

    <div class="sidebar-profile d-flex align-items-center gap-3 cursor-pointer mt-3 border-top pt-4 pb-2">
        <img src="https://ui-avatars.com/api/?name=Admin&background=000&color=fff" alt="Admin" class="rounded-circle shadow-sm" width="40" height="40">
        <div class="d-flex flex-column">
            <span class="small fw-bold text-dark mb-0">Administrator</span>
            <span class="text-muted text-truncate" style="font-size: 0.7rem; max-width: 120px;">admin@eliteauto.com</span>
        </div>
        <a href="LogoutController" class="ms-auto text-danger transition-hover" title="Logout">
            <i class="bi bi-box-arrow-right fs-5"></i>
        </a>
    </div>
</aside>

<script>
    document.addEventListener("DOMContentLoaded", function () {
        let currentUrl = window.location.pathname.split('/').pop() || 'AdminDashboardController';
        
        if (currentUrl.includes('?')) {
            currentUrl = currentUrl.split('?')[0];
        }

        let links = document.querySelectorAll('#sidebarMenu .nav-link');
        let foundActive = false;

        links.forEach(link => {
            let href = link.getAttribute('href');
            if (href && href.includes(currentUrl)) {
                link.classList.add('active', 'bg-dark', 'text-white');
                link.classList.remove('text-dark');
                foundActive = true;
            } else {
                link.classList.remove('active', 'bg-dark', 'text-white');
                link.classList.add('text-dark');
            }
        });
    });
</script>