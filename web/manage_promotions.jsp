<%@page import="java.util.List"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Promotions Management | Elite Auto</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
        <link href="css/admin.css?v=1.1" rel="stylesheet">

        <link href="css/manage_promotions.css" rel="stylesheet">

        <style>
            body {
                background-color: #f4f7fe;
                font-family: 'Inter', sans-serif;
                color: #334155;
            }
        </style>
    </head>
    <body class="admin-body">

        <jsp:include page="admin_sidebar.jsp"/>

        <main class="main-wrapper p-4 p-lg-5 animate-fade-up">

            <c:set var="totalPromos" value="${empty TOTAL_PROMO ? 0 : TOTAL_PROMO}" />
            <c:set var="activePromos" value="${empty ACTIVE_PROMO ? 0 : ACTIVE_PROMO}" />
            <c:set var="expiredPromos" value="${empty EXPIRED_PROMO ? 0 : EXPIRED_PROMO}" />

            <c:if test="${not empty error}">
                <div class="alert alert-danger border-0 bg-danger bg-opacity-10 text-danger rounded-4 p-3 mb-4 shadow-sm d-flex align-items-center">
                    <i class="bi bi-exclamation-circle-fill me-2 fs-5"></i>
                    <div class="fw-bold">${error}</div>
                    <button type="button" class="btn-close ms-auto shadow-none" data-bs-dismiss="alert"></button>
                </div>
            </c:if>
            <c:if test="${not empty success}">
                <div class="alert alert-success border-0 bg-success bg-opacity-10 text-success rounded-4 p-3 mb-4 shadow-sm d-flex align-items-center">
                    <i class="bi bi-check-circle-fill me-2 fs-5"></i>
                    <div class="fw-bold">${success}</div>
                    <button type="button" class="btn-close ms-auto shadow-none" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center mb-4 pb-2">
                <div>
                    <h2 class="fw-bolder text-dark mb-1 fs-2 tracking-tight">Marketing & Promotions</h2>
                    <p class="text-secondary fw-medium mb-0">Create vibrant campaigns to boost sales and loyalty</p>
                </div>
                <div class="mt-3 mt-md-0">
                    <button class="btn btn-dark-custom rounded-pill px-4 py-2 fw-bold d-flex align-items-center gap-2 shadow-sm" data-bs-toggle="modal" data-bs-target="#promoModal" onclick="openAddModal()">
                        <i class="bi bi-magic fs-5"></i> Create Campaign
                    </button>
                </div>
            </div>

            <div class="row g-4 mb-4">
                <div class="col-md-4">
                    <div class="glass-card p-4 rounded-4 shadow-sm h-100 d-flex align-items-center gap-4">
                        <div class="gradient-primary rounded-circle d-flex align-items-center justify-content-center shadow" style="width: 65px; height: 65px;">
                            <i class="bi bi-megaphone-fill fs-3"></i>
                        </div>
                        <div>
                            <div class="text-muted fw-bold text-uppercase small mb-1" style="letter-spacing: 1px;">Total Campaigns</div>
                            <h2 class="fw-bolder text-dark mb-0 tracking-tight" style="font-size: 2.2rem;">${totalPromos}</h2>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="glass-card p-4 rounded-4 shadow-sm h-100 d-flex align-items-center gap-4">
                        <div class="gradient-success rounded-circle d-flex align-items-center justify-content-center shadow" style="width: 65px; height: 65px;">
                            <i class="bi bi-broadcast fs-3"></i>
                        </div>
                        <div>
                            <div class="text-muted fw-bold text-uppercase small mb-1" style="letter-spacing: 1px;">Running Now</div>
                            <h2 class="fw-bolder text-dark mb-0 tracking-tight" style="font-size: 2.2rem;">${activePromos}</h2>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="glass-card p-4 rounded-4 shadow-sm h-100 d-flex align-items-center gap-4">
                        <div class="gradient-danger rounded-circle d-flex align-items-center justify-content-center shadow" style="width: 65px; height: 65px;">
                            <i class="bi bi-calendar-x-fill fs-3"></i>
                        </div>
                        <div>
                            <div class="text-muted fw-bold text-uppercase small mb-1" style="letter-spacing: 1px;">Expired / Inactive</div>
                            <h2 class="fw-bolder text-dark mb-0 tracking-tight" style="font-size: 2.2rem;">${expiredPromos}</h2>
                        </div>
                    </div>
                </div>
            </div>

            <div class="glass-card rounded-4 shadow-sm overflow-hidden d-flex flex-column">

                <div class="p-4 border-bottom border-light">
                    <form action="ManagePromotionsController" method="POST" id="filterForm" class="m-0 p-0 d-flex flex-column flex-md-row justify-content-between align-items-center gap-3">
                        <input type="hidden" name="action" value="filter">
                        <input type="hidden" id="pageInput" name="page" value="${empty param.page ? 1 : param.page}">

                        <div class="position-relative w-100" style="max-width: 400px;">
                            <i class="bi bi-search position-absolute text-muted" style="top: 50%; transform: translateY(-50%); left: 18px; font-size: 1rem;"></i>
                            <input type="text" name="search" value="${param.search}" class="form-control vibrant-input rounded-pill ps-5 w-100" placeholder="Search by Code or Name..." onkeypress="if (event.key === 'Enter') {
                                        document.getElementById('pageInput').value = 1;
                                        this.form.submit();
                                        return false;
                                    }">
                        </div>

                        <div class="d-flex gap-2 w-100 justify-content-md-end">
                            <select name="targetType" class="form-select vibrant-input rounded-pill cursor-pointer" style="width: auto; min-width: 150px;" onchange="document.getElementById('pageInput').value = 1; this.form.submit()">
                                <option value="ALL" ${param.targetType == 'ALL' || empty param.targetType ? 'selected' : ''}>Target: All</option>
                                <option value="All" ${param.targetType == 'All' ? 'selected' : ''}>General (All)</option>
                                <option value="Tier" ${param.targetType == 'Tier' ? 'selected' : ''}>Loyalty Tiers</option>
                            </select>

                            <select name="status" class="form-select vibrant-input rounded-pill cursor-pointer" style="width: auto; min-width: 140px;" onchange="document.getElementById('pageInput').value = 1; this.form.submit()">
                                <option value="ALL" ${param.status == 'ALL' ? 'selected' : ''}>Status: All</option>
                                <option value="1" ${param.status == '1' ? 'selected' : ''}>Active</option>
                                <option value="0" ${param.status == '0' ? 'selected' : ''}>Inactive</option>
                            </select>
                        </div>
                    </form>
                </div>

                <div class="table-responsive flex-grow-1" style="min-height: 400px;">
                    <table class="table table-borderless mb-0">
                        <thead>
                            <tr class="border-bottom" style="border-color: #eaedf1;">
                                <th class="text-muted text-uppercase fw-bold ps-4 py-3" style="font-size: 0.75rem; letter-spacing: 1px;">Campaign Info</th>
                                <th class="text-muted text-uppercase fw-bold py-3" style="font-size: 0.75rem; letter-spacing: 1px;">Discount Value</th>
                                <th class="text-muted text-uppercase fw-bold py-3" style="font-size: 0.75rem; letter-spacing: 1px;">Target Audience</th>
                                <th class="text-muted text-uppercase fw-bold py-3" style="font-size: 0.75rem; letter-spacing: 1px;">Duration</th>
                                <th class="text-muted text-uppercase fw-bold py-3" style="font-size: 0.75rem; letter-spacing: 1px;">Status</th>
                                <th class="text-muted text-uppercase text-end fw-bold pe-4 py-3" style="font-size: 0.75rem; letter-spacing: 1px;">Actions</th>
                            </tr>
                        </thead>
                        <tbody>

                            <c:if test="${empty LISTOFPROMOTION}">
                                <tr>
                                    <td colspan="6" class="text-center py-5">
                                        <div class="gradient-warning rounded-circle d-inline-flex align-items-center justify-content-center mb-3 shadow" style="width: 80px; height: 80px;">
                                            <i class="bi bi-ticket-detailed fs-1 text-white"></i>
                                        </div>
                                        <h4 class="fw-bold text-dark">No Promotions Found</h4>
                                        <p class="text-muted">No campaigns match your filters or database is empty.</p>
                                    </td>
                                </tr>
                            </c:if>

                            <c:forEach var="promo" items="${LISTOFPROMOTION}">
                                <tr class="promo-row border-bottom" style="border-color: #f1f5f9;">

                                    <td class="ps-4 py-3">
                                        <div class="d-flex align-items-center gap-3">
                                            <div class="bg-dark text-white rounded-3 d-flex align-items-center justify-content-center fw-bold shadow-sm" style="width: 50px; height: 50px; font-size: 1.2rem;">
                                                <i class="bi bi-tags"></i>
                                            </div>
                                            <div>
                                                <div class="fw-bolder text-dark" style="font-size: 1.1rem;">${promo.promotionName}</div>
                                                <div class="text-muted fw-bold font-monospace mt-1" style="font-size: 0.85rem;"><i class="bi bi-upc-scan me-1"></i>${empty promo.promoCode ? 'AUTO-APPLY' : promo.promoCode}</div>
                                            </div>
                                        </div>
                                    </td>

                                    <td class="py-3 align-middle">
                                        <span class="badge badge-discount bg-success text-white px-3 py-2">
                                            <i class="bi bi-percent me-1"></i> ${promo.discountPercent}% OFF
                                        </span>
                                    </td>

                                    <td class="py-3 align-middle">
                                        <c:choose>
                                            <c:when test="${promo.targetType == 'Tier'}">
                                                <span class="badge-target target-tier"><i class="bi bi-star-fill me-1"></i> TIER BASED</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge-target target-all"><i class="bi bi-globe me-1"></i> GENERAL (ALL)</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>

                                    <td class="py-3 align-middle">
                                        <div class="text-dark fw-bold small"><i class="bi bi-calendar-event text-primary me-2"></i>${promo.startDate}</div>
                                        <div class="text-dark fw-bold small mt-1"><i class="bi bi-calendar-x text-danger me-2"></i>${promo.endDate}</div>
                                    </td>

                                    <td class="py-3 align-middle">
                                        <c:choose>
                                            <c:when test="${promo.active}">
                                                <div class="fw-bolder text-success small"><span class="status-dot bg-success shadow-sm"></span> RUNNING</div>
                                            </c:when>
                                            <c:otherwise>
                                                <div class="fw-bolder text-danger small"><span class="status-dot bg-danger shadow-sm"></span> INACTIVE</div>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>

                                    <td class="text-end pe-4 py-3 align-middle">
                                        <div class="d-flex justify-content-end gap-2">
                                            <button type="button" class="btn btn-light rounded-pill px-3 fw-bold text-dark border shadow-sm"
                                                    onclick="openEditModal('${promo.promotionID}', '${promo.promoCode}', '${promo.promotionName}', '${promo.targetType}', '${promo.discountPercent}', '${promo.startDate}', '${promo.endDate}', '${promo.description}')">
                                                <i class="bi bi-pencil-square"></i>
                                            </button>

                                            <form action="ManagePromotionsController" method="POST" class="m-0 p-0">
                                                <input type="hidden" name="action" value="toggleStatus">
                                                <input type="hidden" name="id" value="${promo.promotionID}">
                                                <c:choose>
                                                    <c:when test="${promo.active}">
                                                        <button type="submit" class="btn btn-outline-danger rounded-pill px-3 fw-bold bg-white" title="Deactivate" onclick="return confirm('Stop this promotion?');">
                                                            <i class="bi bi-pause-circle-fill"></i> Stop
                                                        </button>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <button type="submit" class="btn btn-dark rounded-pill px-3 fw-bold shadow-sm" title="Activate" onclick="return confirm('Start this promotion?');">
                                                            <i class="bi bi-play-circle-fill"></i> Start
                                                        </button>
                                                    </c:otherwise>
                                                </c:choose>
                                            </form>
                                        </div>
                                    </td>

                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>

                <c:set var="currentPage" value="${empty param.page ? 1 : param.page}" />
                <c:set var="totalFiltered" value="${empty TOTAL_FILTERED ? 0 : TOTAL_FILTERED}" />
                <fmt:parseNumber var="totalPages" integerOnly="true" value="${(totalFiltered + 9) / 10}" />
                <c:if test="${totalPages == 0}"><c:set var="totalPages" value="1" /></c:if>

                    <div class="bg-transparent p-4 border-top d-flex flex-column flex-md-row justify-content-between align-items-center">
                        <span class="text-muted fw-bold small">
                            Showing page <strong class="text-dark">${currentPage}</strong> of <strong class="text-dark">${totalPages}</strong>
                        (Total: ${totalFiltered} records)
                    </span>

                    <div class="d-flex gap-2 mt-3 mt-md-0">
                        <button type="button" onclick="goToPage(${currentPage - 1})" class="btn btn-light rounded-circle fw-bold shadow-sm border ${currentPage <= 1 ? 'disabled opacity-50' : ''}" style="width: 40px; height: 40px; pointer-events: ${currentPage <= 1 ? 'none' : 'auto'}">
                            <i class="bi bi-chevron-left"></i>
                        </button>

                        <c:forEach begin="1" end="${totalPages}" var="i">
                            <button type="button" onclick="goToPage(${i})" class="btn rounded-circle fw-bold shadow-sm ${currentPage == i ? 'btn-dark-custom border-0' : 'btn-light border text-dark'}" style="width: 40px; height: 40px;">
                                ${i}
                            </button>
                        </c:forEach>

                        <button type="button" onclick="goToPage(${currentPage + 1})" class="btn btn-light rounded-circle fw-bold shadow-sm border ${currentPage >= totalPages ? 'disabled opacity-50' : ''}" style="width: 40px; height: 40px; pointer-events: ${currentPage >= totalPages ? 'none' : 'auto'}">
                            <i class="bi bi-chevron-right"></i>
                        </button>
                    </div>
                </div>

            </div>
        </main>

        <div class="modal fade" id="promoModal" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-lg modal-dialog-centered">
                <div class="modal-content shadow-lg">
                    <div class="modal-header px-4 py-4">
                        <h5 class="modal-title fw-bolder text-dark" id="modalTitle"><i class="bi bi-magic text-dark me-2"></i>Create New Campaign</h5>
                        <button type="button" class="btn-close shadow-none" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <form action="ManagePromotionsController" method="POST">
                        <input type="hidden" name="action" id="formAction" value="add">
                        <input type="hidden" name="promoId" id="modalPromoId">

                        <div class="modal-body px-4 py-4" style="background-color: #f8fafc;">
                            <div class="row g-4">
                                <div class="col-md-5">
                                    <label class="fw-bold text-dark mb-2 small text-uppercase">Promo Code</label>
                                    <input type="text" class="form-control vibrant-input text-uppercase font-monospace" name="promoCode" id="modalPromoCode" placeholder="SUMMER25 (Leave blank for Auto)">
                                </div>
                                <div class="col-md-7">
                                    <label class="fw-bold text-dark mb-2 small text-uppercase">Campaign Name <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control vibrant-input" name="promoName" id="modalPromoName" placeholder="e.g. Hot Summer Deals" required>
                                </div>

                                <div class="col-md-6">
                                    <label class="fw-bold text-dark mb-2 small text-uppercase">Target Audience <span class="text-danger">*</span></label>
                                    <select name="targetType" id="modalTargetType" class="form-select vibrant-input cursor-pointer" onchange="toggleTargetInputs()" required>
                                        <option value="All">General (Applies to everyone)</option>
                                        <option value="Tier">Loyalty Tiers (Specific Tiers)</option>
                                    </select>
                                </div>
                                <div class="col-md-6 d-none fade-in" id="wrapTierSelection">
                                    <label class="fw-bold text-dark mb-2 small text-uppercase">Select Tier <span class="text-danger">*</span></label>
                                    <select name="tierId" id="modalTierId" class="form-select vibrant-input cursor-pointer">
                                        <option value="1">Member</option>
                                        <option value="2">Silver</option>
                                        <option value="3">Gold</option>
                                        <option value="4">Platinum</option>
                                    </select>
                                </div>

                                <div class="col-md-12 p-4 rounded-4" style="background: white; border: 1px dashed #cbd5e1;">
                                    <label class="fw-bold text-dark mb-3 small text-uppercase">Discount Value (%) <span class="text-danger">*</span></label>
                                    <div class="input-group">
                                        <input type="number" class="form-control vibrant-input" name="discountPercent" id="modalDiscountPercent" placeholder="e.g. 20" min="1" max="100" required>
                                        <span class="input-group-text fw-bolder bg-light text-dark border-0">% OFF</span>
                                    </div>
                                </div>

                                <div class="col-md-6">
                                    <label class="fw-bold text-dark mb-2 small text-uppercase">Start Date</label>
                                    <input type="date" class="form-control vibrant-input" name="startDate" id="modalStartDate">
                                </div>
                                <div class="col-md-6">
                                    <label class="fw-bold text-dark mb-2 small text-uppercase">End Date</label>
                                    <input type="date" class="form-control vibrant-input" name="endDate" id="modalEndDate">
                                </div>

                                <div class="col-12">
                                    <label class="fw-bold text-dark mb-2 small text-uppercase">Description</label>
                                    <textarea class="form-control vibrant-input" name="description" id="modalDescription" rows="2" placeholder="Write a catchy description for the campaign..."></textarea>
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer px-4 py-3 border-0 bg-white">
                            <button type="button" class="btn btn-light rounded-pill px-4 fw-bold" data-bs-dismiss="modal">Cancel</button>
                            <button type="submit" class="btn btn-dark-custom rounded-pill px-5 fw-bold shadow-sm">Save Campaign</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

        <script>
                                        function goToPage(pageNumber) {
                                            document.getElementById('pageInput').value = pageNumber;
                                            document.getElementById('filterForm').submit();
                                        }

                                        function toggleTargetInputs() {
                                            const targetType = document.getElementById('modalTargetType').value;
                                            const wrapTier = document.getElementById('wrapTierSelection');
                                            const inputTier = document.getElementById('modalTierId');

                                            if (targetType === 'Tier') {
                                                wrapTier.classList.remove('d-none');
                                                inputTier.required = true;
                                            } else {
                                                wrapTier.classList.add('d-none');
                                                inputTier.required = false;
                                            }
                                        }

                                        function openAddModal() {
                                            document.getElementById('modalTitle').innerHTML = '<i class="bi bi-magic text-dark me-2"></i>Create New Campaign';
                                            document.getElementById('formAction').value = 'add';
                                            document.getElementById('modalPromoId').value = '';
                                            document.getElementById('modalPromoCode').value = '';
                                            document.getElementById('modalPromoName').value = '';

                                            document.getElementById('modalTargetType').value = 'All';
                                            toggleTargetInputs(); // Khởi tạo ẩn ô chọn Tier

                                            document.getElementById('modalDiscountPercent').value = '';
                                            document.getElementById('modalStartDate').value = '';
                                            document.getElementById('modalEndDate').value = '';
                                            document.getElementById('modalDescription').value = '';
                                        }

                                        function openEditModal(id, code, name, target, percent, start, end, desc, tierId) {
                                            document.getElementById('modalTitle').innerHTML = '<i class="bi bi-pencil-square text-dark me-2"></i>Edit Campaign';
                                            document.getElementById('formAction').value = 'edit';
                                            document.getElementById('modalPromoId').value = id;
                                            document.getElementById('modalPromoCode').value = (code !== 'null') ? code : '';
                                            document.getElementById('modalPromoName').value = name;

                                            document.getElementById('modalTargetType').value = target;
                                            toggleTargetInputs();
                                            if (target === 'Tier' && tierId && tierId !== 'null') {
                                                document.getElementById('modalTierId').value = tierId;
                                            }

                                            document.getElementById('modalDiscountPercent').value = (percent !== 'null') ? percent : '';
                                            document.getElementById('modalStartDate').value = (start !== 'null') ? start : '';
                                            document.getElementById('modalEndDate').value = (end !== 'null') ? end : '';
                                            document.getElementById('modalDescription').value = (desc !== 'null') ? desc : '';

                                            new bootstrap.Modal(document.getElementById('promoModal')).show();
                                        }

                                        document.addEventListener("DOMContentLoaded", function () {
                                            setTimeout(function () {
                                                let alerts = document.querySelectorAll('.alert');
                                                alerts.forEach(function (alert) {
                                                    alert.style.transition = "opacity 0.5s ease-out, transform 0.5s ease-out";
                                                    alert.style.opacity = "0";
                                                    alert.style.transform = "translateY(-10px)";
                                                    setTimeout(() => {
                                                        if (alert.parentNode)
                                                            alert.parentNode.removeChild(alert);
                                                    }, 500);
                                                });
                                            }, 4000);
                                        });
        </script>
    </body>
</html>