<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="isEdit" value="${not empty SERVICE}" />
<c:if test="${empty sessionScope.ACCOUNT}">
    <jsp:forward page="index.jsp"/>
</c:if>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>${isEdit ? "Edit Service" : "Add New Service"} | Elite Auto</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
        <link href="css/admin.css?v=1.0" rel="stylesheet">

        <style>
            .pricing-card {
                background: #fff;
                border: 1px solid #e5e7eb;
                border-radius: 16px;
            }

            .pricing-row {
                transition: background-color 0.15s ease;
            }

            .pricing-row:hover {
                background-color: #f8f9fa;
            }

            .form-control-custom {
                border: 0;
                background: #f3f4f6;
                border-radius: 0.75rem;
                padding: 0.6rem 0.9rem;
                font-size: 0.95rem;
            }

            .form-control-custom:focus {
                box-shadow: 0 0 0 3px rgba(0, 0, 0, 0.06);
                background: #fff;
            }

            .section-title {
                font-size: 0.95rem;
                letter-spacing: -.2px;
            }
        </style>
    </head>

    <body class="admin-body">

        <aside class="sidebar p-4 shadow-sm">
            <a href="DashboardController" class="text-dark text-decoration-none fw-bold fs-4 mb-4 d-flex align-items-center">
                <i class="bi bi-vinyl-fill me-2 fs-3 text-dark"></i>EliteAuto
            </a>

            <div class="overflow-y-auto" style="scrollbar-width: none;">
                <ul class="nav flex-column gap-1" id="sidebarMenu">
                    <li class="nav-item">
                        <a class="nav-link d-flex align-items-center" href="admin_dashboard.jsp">
                            <i class="bi bi-grid-1x2-fill me-3"></i> Dashboard
                        </a>
                    </li>

                    <li class="nav-item mt-3 mb-1">
                        <span class="text-muted small fw-bold text-uppercase" style="font-size: 0.65rem; padding-left: 1rem;">Operations</span>
                    </li>
                    <li class="nav-item"><a class="nav-link d-flex align-items-center" href="CarRequestsController"><i class="bi bi-car-front me-3"></i> Car Requests</a></li>
                    <li class="nav-item"><a class="nav-link d-flex align-items-center" href="BusinessRequestsController"><i class="bi bi-building me-3"></i> Business Requests</a></li>
                    <li class="nav-item"><a class="nav-link d-flex align-items-center" href="WashBayController?action=list"><i class="bi bi-droplet me-3"></i> Wash Bay Mgmt</a></li>
                    <li class="nav-item"><a class="nav-link d-flex align-items-center" href="SlotScheduleController"><i class="bi bi-calendar-range me-3"></i> Slot Schedule</a></li>

                    <li class="nav-item mt-3 mb-1">
                        <span class="text-muted small fw-bold text-uppercase" style="font-size: 0.65rem; padding-left: 1rem;">Management</span>
                    </li>
                    <li class="nav-item"><a class="nav-link d-flex align-items-center" href="UsersMgmtController"><i class="bi bi-people me-3"></i> Users Mgmt</a></li>
                    <li class="nav-item"><a class="nav-link d-flex align-items-center" href="RevenueController"><i class="bi bi-graph-up me-3"></i> Revenue</a></li>
                    <li class="nav-item"><a class="nav-link d-flex align-items-center" href="ManagePromotionsController"><i class="bi bi-ticket-perforated me-3"></i> Promos</a></li>
                    <li class="nav-item">
                        <a class="nav-link active d-flex align-items-center" href="ServiceController?action=list">
                            <i class="bi bi-tools me-3"></i> Service Management
                        </a>
                    </li>

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
                    <div class="d-flex align-items-center gap-2 mb-1">
                        <a href="ServiceController?action=list" class="text-muted text-decoration-none small d-flex align-items-center">
                            <i class="bi bi-arrow-left me-1"></i> Back to Services
                        </a>
                    </div>

                    <h2 class="fw-bold tracking-tight mb-1 text-dark">
                        <c:choose>
                            <c:when test="${isEdit}">Edit Service</c:when>
                            <c:otherwise>Add New Service</c:otherwise>
                        </c:choose>
                    </h2>

                    <p class="text-muted small mb-0">
                        <c:choose>
                            <c:when test="${isEdit}">
                                Update details and pricing configuration for
                                <strong class="text-dark">${SERVICE.name}</strong>
                            </c:when>
                            <c:otherwise>
                                Define a new service offering and set base prices per vehicle type
                            </c:otherwise>
                        </c:choose>
                    </p>
                </div>

                <c:if test="${isEdit}">
                    <div>
                        <span class="badge bg-dark bg-opacity-10 text-dark border border-dark border-opacity-25 rounded-pill px-3 py-1 small fw-medium">
                            #${SERVICE.id}
                        </span>
                    </div>
                </c:if>
            </div>

            <form action="ServiceController" method="post" id="serviceForm">

                <c:choose>
                    <c:when test="${isEdit}">
                        <input type="hidden" name="action" value="update">
                        <input type="hidden" name="serviceId" value="${SERVICE.id}">
                    </c:when>
                    <c:otherwise>
                        <input type="hidden" name="action" value="createService">
                    </c:otherwise>
                </c:choose>

                <!-- SERVICE DETAILS -->
                <div class="bg-white p-4 rounded-4 shadow-sm border border-light mb-4">
                    <div class="mb-3">
                        <div class="section-title fw-bold text-dark mb-3 d-flex align-items-center">
                            <i class="bi bi-info-circle me-2"></i> Service Information
                        </div>
                    </div>

                    <div class="row g-4">
                        <div class="col-md-6">
                            <label class="small text-muted fw-semibold mb-2 ms-1">
                                Service Name <span class="text-danger">*</span>
                            </label>
                            <input type="text"
                                   name="serviceName"
                                   class="form-control form-control-custom shadow-none"
                                   value="${isEdit ? SERVICE.name : ''}"
                                   placeholder="e.g. Premium Exterior Wash"
                                   required>
                        </div>

                        <div class="col-md-6">
                            <label class="small text-muted fw-semibold mb-2 ms-1">Status</label>
                            <select name="status" class="form-select form-control-custom shadow-none" style="cursor: pointer;">
                                <option value="true" ${!isEdit || SERVICE.status ? "selected" : ""}>Active</option>
                                <option value="false" ${isEdit && !SERVICE.status ? "selected" : ""}>Inactive</option>
                            </select>
                        </div>

                        <div class="col-12">
                            <label class="small text-muted fw-semibold mb-2 ms-1">Description</label>
                            <textarea name="description"
                                      rows="3"
                                      class="form-control form-control-custom shadow-none"
                                      placeholder="Describe what this service includes, recommended vehicle conditions, or any notes...">${isEdit ? SERVICE.description : ''}</textarea>
                        </div>
                    </div>
                </div>

                <!-- PRICING BY VEHICLE TYPE -->
                <div class="bg-white p-4 rounded-4 shadow-sm border border-light mb-4">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <div class="section-title fw-bold text-dark d-flex align-items-center">
                            <i class="bi bi-currency-dollar me-2"></i> Pricing by Vehicle Type
                        </div>
                        <span class="text-muted small">Base rates • All prices in VNĐ</span>
                    </div>

                    <div class="pricing-card p-2">
                        <table class="table table-borderless align-middle mb-0">
                            <thead>
                                <tr class="border-bottom">
                                    <th class="ps-3 text-muted fw-semibold small text-uppercase" style="width: 26%;">Vehicle Type</th>
                                    <th class="text-muted fw-semibold small text-uppercase text-end" style="width: 28%;">Price (VNĐ)</th>
                                    <th class="text-muted fw-semibold small text-uppercase text-center" style="width: 22%;">Duration (minutes)</th>
                                    <th class="text-end pe-3 text-muted fw-semibold small text-uppercase" style="width: 24%;">Quick Actions</th>
                                </tr>
                            </thead>

                            <tbody>
                                <c:choose>
                                    <c:when test="${not empty VEHICLE_TYPES}">
                                        <c:forEach var="vt" items="${VEHICLE_TYPES}">
                                            <c:set var="priceValue" value="0" />
                                            <c:set var="durationValue" value="0" />

                                            <c:if test="${isEdit && not empty SERVICE_PRICES}">
                                                <c:forEach var="sp" items="${SERVICE_PRICES}">
                                                    <c:if test="${sp.vehicleTypeID == vt.vehicleTypeID}">
                                                        <c:set var="priceValue" value="${sp.price}" />
                                                        <c:set var="durationValue" value="${sp.durations}" />
                                                    </c:if>
                                                </c:forEach>
                                            </c:if>

                                            <tr class="pricing-row border-bottom">
                                                <td class="ps-3 fw-semibold text-dark">
                                                    <i class="bi bi-car-front text-muted me-2"></i>${vt.typeName}
                                                    <input type="hidden" name="vehicleTypeID" value="${vt.vehicleTypeID}">
                                                </td>

                                                <td class="text-end">
                                                    <div class="input-group input-group-sm" style="max-width: 170px; margin-left: auto;">
                                                        <span class="input-group-text bg-light border-0 small text-muted" style="border-radius: 0.75rem 0 0 0.75rem;">
                                                            VNĐ
                                                        </span>
                                                        <input type="number"
                                                               name="price_${vt.vehicleTypeID}"
                                                               class="form-control form-control-custom text-end shadow-none"
                                                               value="${priceValue}"
                                                               min="1"
                                                               step="1"
                                                               required=""
                                                               style="border-radius: 0 0.75rem 0.75rem 0;">
                                                    </div>
                                                </td>

                                                <td class="text-center">
                                                    <div class="input-group input-group-sm" style="max-width: 110px; margin: 0 auto;">
                                                        <input type="number"
                                                               name="duration_${vt.vehicleTypeID}"
                                                               class="form-control form-control-custom text-center shadow-none"
                                                               value="${durationValue}"
                                                               min="1"
                                                               step="1"
                                                               required=""
                                                               style="border-radius: 0.75rem;">
                                                        <span class="input-group-text bg-light border-0 small text-muted" style="border-radius: 0 0.75rem 0.75rem 0;">
                                                            min
                                                        </span>
                                                    </div>
                                                </td>

                                                <td class="text-end pe-3">
                                                    <button type="button"
                                                            class="btn btn-sm btn-light border rounded-pill px-3 py-1 small fw-medium transition-hover"
                                                            onclick="copyPriceToAll(this)">
                                                        <i class="bi bi-files me-1"></i> Apply to all
                                                    </button>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>

                                    <c:otherwise>
                                        <tr>
                                            <td colspan="4" class="text-center text-muted py-4">
                                                <i class="bi bi-inbox fs-4 d-block mb-2"></i>
                                                No active vehicle types found.
                                            </td>
                                        </tr>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>

                    <div class="mt-3 px-1">
                        <small class="text-muted">
                            <i class="bi bi-lightbulb me-1"></i>
                            Each active vehicle type must have a price and duration greater than <strong>0</strong>.
                        </small>
                    </div>
                </div>

                <!-- ACTIONS -->
                <div class="d-flex gap-3">
                    <a href="ServiceController?action=list" class="btn btn-light rounded-pill px-4 py-2 fw-medium text-muted transition-hover">
                        Cancel
                    </a>

                    <button type="submit" class="btn btn-dark rounded-pill px-5 py-2 fw-medium shadow-sm transition-hover">
                        <i class="bi bi-check2-circle me-2"></i>
                        <c:choose>
                            <c:when test="${isEdit}">Save Changes</c:when>
                            <c:otherwise>Create Service</c:otherwise>
                        </c:choose>
                    </button>

                    <div class="ms-auto small text-muted d-flex align-items-center gap-1">
                        <i class="bi bi-info-circle"></i>
                        <span>Services use soft status. Set to <strong>Inactive</strong> to disable.</span>
                    </div>
                </div>
            </form>
        </main>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

        <script>
            document.addEventListener("DOMContentLoaded", function () {
                const sidebarLinks = document.querySelectorAll('.sidebar .nav-link');

                sidebarLinks.forEach(function (link) {
                    link.addEventListener('click', function (e) {
                        if (this.getAttribute('href') === '#') {
                            e.preventDefault();
                        }

                        sidebarLinks.forEach(function (l) {
                            l.classList.remove('active');
                        });

                        this.classList.add('active');
                    });
                });
            });

            function copyPriceToAll(btnEl) {
                const row = btnEl.closest('tr');

                if (!row) {
                    return;
                }

                const priceInput = row.querySelector('input[name^="price_"]');
                const durationInput = row.querySelector('input[name^="duration_"]');

                if (!priceInput || !durationInput) {
                    return;
                }

                const priceValue = priceInput.value;
                const durationValue = durationInput.value;

                const allRows = document.querySelectorAll('.pricing-row');

                allRows.forEach(function (r) {
                    const p = r.querySelector('input[name^="price_"]');
                    const d = r.querySelector('input[name^="duration_"]');

                    if (p && d) {
                        p.value = priceValue;
                        d.value = durationValue;

                        r.style.transition = 'background 0.1s';
                        r.style.background = '#f1f3f5';

                        setTimeout(function () {
                            r.style.background = '';
                        }, 320);
                    }
                });
            }
        </script>
    </body>
</html>