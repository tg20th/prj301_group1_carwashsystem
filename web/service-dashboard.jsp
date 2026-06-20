<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<fmt:setLocale value="fr_FR" />

<!DOCTYPE html>
<c:if test="account == null">
    <jsp:forward page="MainController?action=home"/>
</c:if>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Service Management</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
        <link href="css/admin.css?v=1.0" rel="stylesheet">

        <style>
            body.admin-body.page-fullwidth {
                display: block;
            }

            body.admin-body.page-fullwidth .page-content {
                margin-left: 0;
                width: 100%;
                max-width: 100%;
            }

            .service-row {
                cursor: pointer;
                transition: all 0.2s ease;
            }

            .service-row:hover {
                background-color: #f8f9fa !important;
            }

            .service-name {
                transition: color 0.2s ease;
            }

            .service-row:hover .service-name {
                color: #0a0a0a;
            }

            .price-modal .modal-content {
                border-radius: 1.5rem;
            }

            .price-table th,
            .price-table td {
                vertical-align: middle;
            }

            .price-badge {
                font-size: 0.85rem;
                font-weight: 600;
            }
        </style>
    </head>

    <body class="admin-body">

        <jsp:include page="admin_sidebar.jsp"/>

        <main class="main-wrapper p-4 p-lg-5 animate-fade-up">

            <div class="d-flex justify-content-between align-items-end mb-4 pb-2">
                <div>
                    <h2 class="fw-bold tracking-tight mb-1 text-dark">Service Management</h2>
                    <p class="text-muted small mb-0">
                        Manage available wash services, pricing per vehicle type, and activation status
                    </p>
                </div>

                <a href="ServiceController?action=AddNewService"
                   class="btn btn-dark rounded-pill px-4 py-2 d-flex align-items-center gap-2 fw-medium transition-hover text-decoration-none">
                    <i class="bi bi-plus-lg"></i> Add New Service
                </a>
            </div>

            <c:if test="${param.saved == 'true'}">
                <div id="globalSuccessAlert"
                     class="alert alert-success border-0 bg-success bg-opacity-10 text-success rounded-4 p-3 small mb-4 d-flex align-items-center justify-content-between auto-dismiss-alert">
                    <div class="d-flex align-items-center">
                        <i class="bi bi-check-circle-fill me-2"></i>Changes saved successfully.
                    </div>
                    <button type="button" class="btn-close shadow-none small"
                            onclick="dismissAlertElement('globalSuccessAlert')"></button>
                </div>
            </c:if>

            <c:if test="${param.statusUpdated == 'true'}">
                <div id="globalDeleteAlert"
                     class="alert alert-warning border-0 bg-warning bg-opacity-10 text-warning rounded-4 p-3 small mb-4 d-flex align-items-center justify-content-between auto-dismiss-alert">
                    <div class="d-flex align-items-center">
                        <i class="bi bi-exclamation-triangle-fill me-2"></i>Service status has been updated.
                    </div>
                    <button type="button" class="btn-close shadow-none small"
                            onclick="dismissAlertElement('globalDeleteAlert')"></button>
                </div>
            </c:if>

            <div class="bg-white p-4 rounded-4 shadow-sm border border-light">
                <div class="d-flex justify-content-between align-items-center mb-3 px-1">
                    <h6 class="fw-bold m-0 text-dark">All Services</h6>

                    <span class="badge bg-primary bg-opacity-10 text-primary border border-primary border-opacity-25 rounded-pill px-3 py-1 small">
                        <c:choose>
                            <c:when test="${not empty SERVICES}">
                                ${fn:length(SERVICES)} services
                            </c:when>
                            <c:otherwise>
                                0 services
                            </c:otherwise>
                        </c:choose>
                    </span>
                </div>

                <div class="table-responsive">
                    <table class="table table-custom table-borderless table-hover mb-0 align-middle">
                        <thead>
                            <tr class="border-bottom border-light">
                                <th class="text-muted small fw-bold text-uppercase ps-3" style="width: 60px;">ID</th>
                                <th class="text-muted small fw-bold text-uppercase">Service Name</th>
                                <th class="text-muted small fw-bold text-uppercase">Description</th>
                                <th class="text-muted small fw-bold text-uppercase text-center" style="width: 120px;">Status</th>
                                <th class="text-muted small fw-bold text-uppercase text-center" style="width: 120px;">Pricing</th>
                                <th class="text-muted small fw-bold text-uppercase text-end rounded-end pe-3" style="width: 160px;">Actions</th>
                            </tr>
                        </thead>

                        <tbody>
                            <c:choose>
                                <c:when test="${not empty SERVICES}">
                                    <c:forEach var="s" items="${SERVICES}">
                                        <c:set var="priceList" value="${PRICE_MAP[s.id]}" />

                                        <tr class="border-bottom border-light service-row"
                                            onclick="showPriceModal('${s.id}', '${s.name}')">

                                            <td class="text-muted small fw-medium ps-3">
                                                #${s.id}
                                            </td>

                                            <td class="fw-bold text-dark service-name">
                                                <i class="bi bi-droplet-half me-2 text-primary"></i>${s.name}
                                            </td>

                                            <td class="text-muted small text-truncate" style="max-width: 480px;" title="${s.description}">
                                                <c:choose>
                                                    <c:when test="${empty s.description}">
                                                        No description
                                                    </c:when>
                                                    <c:otherwise>
                                                        ${s.description}
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>

                                            <td class="text-center">
                                                <c:choose>
                                                    <c:when test="${s.status}">
                                                        <span class="badge bg-success bg-opacity-10 text-success border-success border border-opacity-25 px-3 py-1"
                                                              style="font-size: 0.7rem;">
                                                            Active
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-danger bg-opacity-10 text-danger border-danger border border-opacity-25 px-3 py-1"
                                                              style="font-size: 0.7rem;">
                                                            Inactive
                                                        </span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>

                                            <td class="text-center">
                                                <c:set var="priceCount" value="${not empty priceList ? fn:length(priceList) : 0}" />
                                                <c:set var="totalTypes" value="${not empty VEHICLE_TYPES ? fn:length(VEHICLE_TYPES) : 0}" />
                                                <c:choose>
                                                    <c:when test="${totalTypes == 0}">
                                                        <span class="badge bg-light text-muted border border-light px-3 py-1"
                                                              style="font-size: 0.7rem;"
                                                              title="No vehicle types available">
                                                            —
                                                        </span>
                                                    </c:when>
                                                    <c:when test="${priceCount == 0}">
                                                        <span class="badge bg-secondary bg-opacity-10 text-secondary border-secondary border border-opacity-25 px-3 py-1"
                                                              style="font-size: 0.7rem;"
                                                              title="0 of ${totalTypes} vehicle types priced">
                                                            0/${totalTypes}
                                                        </span>
                                                    </c:when>
                                                    <c:when test="${priceCount >= totalTypes}">
                                                        <span class="badge bg-primary bg-opacity-10 text-primary border-primary border border-opacity-25 px-3 py-1"
                                                              style="font-size: 0.7rem;"
                                                              title="${priceCount} of ${totalTypes} vehicle types priced">
                                                            ${priceCount}/${totalTypes}
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-info bg-opacity-10 text-info border-info border border-opacity-25 px-3 py-1"
                                                              style="font-size: 0.7rem;"
                                                              title="${priceCount} of ${totalTypes} vehicle types priced">
                                                            ${priceCount}/${totalTypes}
                                                        </span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>

                                            <td class="text-end pe-3" onclick="event.stopPropagation();">
                                                <a href="ServiceController?action=showEdit&id=${s.id}"
                                                   class="btn btn-sm bg-warning bg-opacity-10 text-warning border-0 rounded-circle transition-hover me-1"
                                                   style="width: 34px; height: 34px; display: inline-flex; align-items: center; justify-content: center;"
                                                   title="Edit service & pricing">
                                                    <i class="bi bi-pencil-fill" style="font-size: 0.85rem;"></i>
                                                </a>

                                                <c:choose>
                                                    <c:when test="${s.status}">
                                                        <a href="ServiceController?action=deactive&id=${s.id}"
                                                           class="btn btn-sm bg-danger bg-opacity-10 text-danger border-0 rounded-circle transition-hover"
                                                           style="width: 34px; height: 34px;"
                                                           onclick="return confirm('Deactivate this service?');"
                                                           title="Deactivate service">
                                                            <i class="bi bi-eye-slash-fill" style="font-size: 0.85rem;"></i>
                                                        </a>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <a href="ServiceController?action=active&id=${s.id}"
                                                           class="btn btn-sm bg-success bg-opacity-10 text-success border-0 rounded-circle transition-hover"
                                                           style="width: 34px; height: 34px;"
                                                           onclick="return confirm('Activate this service?');"
                                                           title="Activate service">
                                                            <i class="bi bi-eye-fill" style="font-size: 0.85rem;"></i>
                                                        </a>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>

                                <c:otherwise>
                                    <tr>
                                        <td colspan="6" class="text-center text-muted py-5">
                                            <i class="bi bi-inbox fs-4 d-block mb-2"></i>
                                            No services found.
                                        </td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>

                    <c:if test="${not empty SERVICES}">
                        <c:forEach var="s" items="${SERVICES}">
                            <c:set var="priceList" value="${PRICE_MAP[s.id]}" />

                            <template id="price-template-${s.id}">
                                <c:choose>
                                    <c:when test="${not empty priceList}">
                                        <c:forEach var="p" items="${priceList}">
                                            <c:set var="typeName" value="Unknown" />
                                            <c:forEach var="vt" items="${VEHICLE_TYPES}">
                                                <c:if test="${p.vehicleTypeID == vt.vehicleTypeID}">
                                                    <c:set var="typeName" value="${vt.typeName}" />
                                                </c:if>
                                            </c:forEach>
                                            <tr class="border-bottom">
                                                <td class="ps-2 fw-medium text-dark">
                                                    ${typeName}
                                                </td>
                                                <td class="text-end fw-semibold text-dark">
                                                    <fmt:formatNumber value="${p.price}" type="number" groupingUsed="true" maxFractionDigits="0" minFractionDigits="0" /> VNĐ
                                                </td>
                                                <td class="text-center text-muted small">
                                                    ${p.durations} minutes
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>

                                    <c:otherwise>
                                        <tr>
                                            <td colspan="3" class="text-center text-muted py-4">
                                                <i class="bi bi-inbox fs-4 d-block mb-2"></i>
                                                No pricing set for this service.
                                            </td>
                                        </tr>
                                    </c:otherwise>
                                </c:choose>
                            </template>
                        </c:forEach>
                    </c:if>
                </div>

                <div class="mt-3 px-1">
                    <small class="text-muted">
                        Click any service row to view detailed pricing by vehicle type.
                    </small>
                </div>
            </div>
        </main>

        <div class="modal fade" id="priceModal" tabindex="-1" aria-labelledby="priceModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered modal-lg">
                <div class="modal-content border-0 shadow price-modal">
                    <div class="modal-header border-0 px-4 pt-4 pb-2">
                        <div>
                            <h5 class="modal-title fw-bold text-dark fs-4" id="priceModalLabel">Service Pricing</h5>
                            <p class="text-muted small mb-0" id="priceModalSubtitle">
                                Prices &amp; estimated duration by vehicle type
                            </p>
                        </div>
                        <button type="button" class="btn-close bg-light rounded-circle p-2 shadow-none"
                                data-bs-dismiss="modal"></button>
                    </div>

                    <div class="modal-body px-4 pt-2 pb-4">
                        <div class="table-responsive">
                            <table class="table price-table table-borderless align-middle mb-0">
                                <thead>
                                    <tr class="border-bottom">
                                        <th class="text-muted fw-semibold small text-uppercase ps-2" style="width: 38%;">Vehicle Type</th>
                                        <th class="text-muted fw-semibold small text-uppercase text-end">Price (VNĐ)</th>
                                        <th class="text-muted fw-semibold small text-uppercase text-center">Duration</th>
                                    </tr>
                                </thead>

                                <tbody id="priceTableBody">
                                    <tr>
                                        <td colspan="3" class="text-center text-muted py-4">
                                            <i class="bi bi-info-circle fs-4 d-block mb-2"></i>
                                            Pricing data will be connected in the next step.
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>

                        <div class="mt-4 pt-3 border-top">
                            <div class="d-flex align-items-center justify-content-between small">
                                <div class="text-muted">
                                    <i class="bi bi-info-circle me-1"></i>
                                    Prices shown are base rates. Actual price may vary with promotions.
                                </div>

                                <a href="#" class="text-decoration-none small fw-medium text-dark"
                                   onclick="goToEditFromModal(); return false;">
                                    Edit pricing <i class="bi bi-arrow-right-short"></i>
                                </a>
                            </div>
                        </div>
                    </div>

                    <div class="modal-footer border-0 px-4 pb-4 pt-1">
                        <button type="button"
                                class="btn btn-light rounded-pill px-4 py-2 small fw-medium text-muted transition-hover"
                                data-bs-dismiss="modal">
                            Close
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

        <script>
                                       let currentModalServiceId = null;

                                       function showPriceModal(serviceId, serviceName) {
                                           currentModalServiceId = serviceId;

                                           document.getElementById('priceModalLabel').innerText = serviceName;
                                           document.getElementById('priceModalSubtitle').innerHTML =
                                                   'Prices & estimated duration by vehicle type <span class="text-muted">— Service #' + serviceId + '</span>';

                                           const tbody = document.getElementById('priceTableBody');
                                           const template = document.getElementById('price-template-' + serviceId);

                                           if (template) {
                                               tbody.innerHTML = template.innerHTML;
                                           } else {
                                               tbody.innerHTML =
                                                       '<tr>' +
                                                       '<td colspan="3" class="text-center text-muted py-4">' +
                                                       '<i class="bi bi-inbox fs-4 d-block mb-2"></i>' +
                                                       'No pricing set for this service.' +
                                                       '</td>' +
                                                       '</tr>';
                                           }

                                           const modalEl = document.getElementById('priceModal');
                                           const modal = new bootstrap.Modal(modalEl);
                                           modal.show();
                                       }

                                       function goToEditFromModal() {
                                           const modalEl = document.getElementById('priceModal');
                                           const modalInstance = bootstrap.Modal.getInstance(modalEl);

                                           if (modalInstance) {
                                               modalInstance.hide();
                                           }

                                           setTimeout(function () {
                                               window.location.href = 'ServiceController?action=showEdit&id=' + currentModalServiceId;
                                           }, 180);
                                       }

                                       function dismissAlertElement(id) {
                                           const element = document.getElementById(id);

                                           if (element) {
                                               element.style.transition = "opacity 0.35s ease-out, transform 0.35s ease-out";
                                               element.style.opacity = "0";
                                               element.style.transform = "translateY(-6px)";

                                               setTimeout(function () {
                                                   element.style.setProperty("display", "none", "important");
                                               }, 350);
                                           }
                                       }

                                       document.addEventListener("DOMContentLoaded", function () {
                                           setTimeout(function () {
                                               const activeAlerts = document.querySelectorAll('.auto-dismiss-alert');

                                               activeAlerts.forEach(function (alert) {
                                                   dismissAlertElement(alert.id);
                                               });
                                           }, 4000);
                                       });
        </script>

    </body>
</html>