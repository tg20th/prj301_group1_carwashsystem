<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:if test="${empty sessionScope.ACCOUNT}">
    <jsp:forward page="index.jsp"/>
</c:if>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Tier Management | Elite Auto</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">

        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">

        <link href="css/admin.css?v=1.1" rel="stylesheet">

        <style>
            /* Tổng quan nền */
            body {
                background-color: #f4f7fe;
                font-family: 'Inter', sans-serif;
                color: #334155;
            }


        </style>
    </head>
    <body class="admin-body">

        <jsp:include page="admin_sidebar.jsp"/>

        <main class="main-wrapper p-4 p-lg-5 animate-fade-up flex-grow-1" style="min-width: 0;">

            <!-- LOGIC BÁO LỖI -->
            <c:set var="isEdit" value="${not empty isEditMode and isEditMode}" />
            <c:set var="isAdd" value="${not empty tierName and not isEdit}" />
            <c:set var="isGlobalError" value="${not empty error and not isEdit and not isAdd}" />

            <!-- MESSAGES -->
            <c:if test="${not empty success}">
                <div id="globalSuccessAlert" class="alert alert-success border-0 bg-success bg-opacity-10 text-success rounded-4 p-3 mb-4 shadow-sm d-flex align-items-center justify-content-between auto-dismiss-alert">
                    <div class="d-flex align-items-center fw-bold"><i class="bi bi-check-circle-fill me-2 fs-5"></i>${success}</div>
                    <button type="button" class="btn-close shadow-none" onclick="dismissAlertElement('globalSuccessAlert')"></button>
                </div>
            </c:if>
            <c:if test="${isGlobalError}">
                <div id="globalErrorAlert" class="alert alert-danger border-0 bg-danger bg-opacity-10 text-danger rounded-4 p-3 mb-4 shadow-sm d-flex align-items-center justify-content-between auto-dismiss-alert">
                    <div class="d-flex align-items-center fw-bold"><i class="bi bi-exclamation-circle-fill me-2 fs-5"></i>${error}</div>
                    <button type="button" class="btn-close shadow-none" onclick="dismissAlertElement('globalErrorAlert')"></button>
                </div>
            </c:if>

            <!-- HEADER -->
            <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center mb-4 pb-2">
                <div>
                    <h2 class="fw-bolder tracking-tight mb-1 text-dark fs-2">Loyalty Tiers</h2>
                    <p class="text-secondary fw-medium mb-0">Manage loyalty levels, required spends, and point rates.</p>
                </div>
                <div class="mt-3 mt-md-0">
                    <button class="btn btn-dark-custom rounded-pill px-4 py-2 fw-bold d-flex align-items-center gap-2 shadow-sm" data-bs-toggle="modal" data-bs-target="#addTierModal">
                        <i class="bi bi-plus-circle-fill fs-5"></i> Create Tier
                    </button>
                </div>
            </div>

            <!-- VIBRANT KPI CARDS -->
            <div class="row g-4 mb-4">
                <div class="col-md-4">
                    <div class="glass-card p-4 rounded-4 shadow-sm h-100 d-flex align-items-center gap-4 hover-scale border-light">
                        <div class="gradient-primary rounded-circle d-flex align-items-center justify-content-center shadow" style="width: 65px; height: 65px;">
                            <i class="bi bi-layers-fill fs-3"></i>
                        </div>
                        <div>
                            <div class="text-muted fw-bold text-uppercase small mb-1" style="letter-spacing: 1px;">Total Tiers</div>
                            <h2 class="fw-bolder text-dark mb-0 tracking-tight" style="font-size: 2.2rem;">${empty LISTOFTIER ? 0 : fn:length(LISTOFTIER)}</h2>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="glass-card p-4 rounded-4 shadow-sm h-100 d-flex align-items-center gap-4 hover-scale border-light">
                        <div class="gradient-warning rounded-circle d-flex align-items-center justify-content-center shadow" style="width: 65px; height: 65px;">
                            <i class="bi bi-star-fill fs-3"></i>
                        </div>
                        <div>
                            <div class="text-muted fw-bold text-uppercase small mb-1" style="letter-spacing: 1px;">Highest Rate</div>
                            <c:set var="maxRate" value="0.0" />
                            <c:forEach var="t" items="${LISTOFTIER}">
                                <c:if test="${t.pointRate > maxRate}"><c:set var="maxRate" value="${t.pointRate}" /></c:if>
                            </c:forEach>
                            <h2 class="fw-bolder text-dark mb-0 tracking-tight" style="font-size: 2.2rem;">${maxRate}x</h2>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="glass-card p-4 rounded-4 shadow-sm h-100 d-flex align-items-center gap-4 hover-scale border-light">
                        <div class="gradient-success rounded-circle d-flex align-items-center justify-content-center shadow" style="width: 65px; height: 65px;">
                            <i class="bi bi-cash-stack fs-3"></i>
                        </div>
                        <div>
                            <div class="text-muted fw-bold text-uppercase small mb-1" style="letter-spacing: 1px;">Entry Rate</div>
                            <c:set var="minRate" value="99.0" />
                            <c:forEach var="t" items="${LISTOFTIER}">
                                <c:if test="${t.pointRate < minRate}"><c:set var="minRate" value="${t.pointRate}" /></c:if>
                            </c:forEach>
                            <h2 class="fw-bolder text-dark mb-0 tracking-tight" style="font-size: 2.2rem;">${minRate == 99.0 ? '0.0' : minRate}x</h2>
                        </div>
                    </div>
                </div>
            </div>

            <!-- TABLE CONTAINER -->
            <div class="glass-card rounded-4 shadow-sm overflow-hidden d-flex flex-column p-0 border-light">

                <c:choose>
                    <c:when test="${empty LISTOFTIER}">
                        <div class="text-center py-5 my-4">
                            <div class="gradient-warning rounded-circle d-inline-flex align-items-center justify-content-center mb-3 shadow" style="width: 80px; height: 80px;">
                                <i class="bi bi-inbox fs-1 text-white"></i>
                            </div>
                            <h4 class="fw-bold text-dark">No Tiers Found</h4>
                            <p class="text-muted">Create a new loyalty tier to get started!</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="table-responsive" style="min-height: 400px;">
                            <table class="table table-borderless align-middle mb-0">
                                <thead>
                                    <tr class="border-bottom" style="border-color: #eaedf1;">
                                        <th class="text-muted text-uppercase fw-bold ps-4 py-4" style="font-size: 0.75rem; letter-spacing: 1px; width: 10%;">ID</th>
                                        <th class="text-muted text-uppercase fw-bold py-4" style="font-size: 0.75rem; letter-spacing: 1px; width: 20%;">Tier Name</th>
                                        <th class="text-muted text-uppercase fw-bold py-4" style="font-size: 0.75rem; letter-spacing: 1px; width: 25%;">Description</th>
                                        <th class="text-muted text-uppercase fw-bold py-4" style="font-size: 0.75rem; letter-spacing: 1px; width: 15%;">Min Spend</th>
                                        <th class="text-muted text-uppercase fw-bold py-4" style="font-size: 0.75rem; letter-spacing: 1px; width: 10%;">Rate</th>
                                        <th class="text-muted text-uppercase fw-bold py-4 text-center" style="font-size: 0.75rem; letter-spacing: 1px; width: 10%;">Status</th>
                                        <th class="text-muted text-uppercase text-end fw-bold pe-4 py-4" style="font-size: 0.75rem; letter-spacing: 1px; width: 10%;">Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="t" items="${LISTOFTIER}">
                                        <c:set var="tierNameLower" value="${fn:toLowerCase(fn:trim(t.tierName))}" />
                                        <c:set var="tierColor" value="text-primary" />
                                        <c:set var="tierIcon" value="bi-award-fill" />

                                        <c:choose>
                                            <c:when test="${tierNameLower == 'member'}"><c:set var="tierColor" value="text-dark" /><c:set var="tierIcon" value="bi-person-badge-fill" /></c:when>
                                            <c:when test="${tierNameLower == 'silver'}"><c:set var="tierColor" value="text-secondary" /></c:when>
                                            <c:when test="${tierNameLower == 'gold'}"><c:set var="tierColor" value="text-warning" /></c:when>
                                            <c:when test="${tierNameLower == 'platinum' || tierNameLower == 'diamond'}"><c:set var="tierColor" value="text-info" /><c:set var="tierIcon" value="bi-gem" /></c:when>
                                            <c:when test="${tierNameLower == 'vip'}"><c:set var="tierColor" value="text-danger" /><c:set var="tierIcon" value="bi-stars" /></c:when>
                                        </c:choose>

                                        <tr class="tier-row border-bottom" style="border-color: #f1f5f9;">
                                            <td class="text-muted fw-bold font-monospace small ps-4 py-4">#${t.tierID}</td>
                                            <td class="fw-bolder ${tierColor} py-4" style="font-size: 1.05rem;">
                                                <i class="bi ${tierIcon} me-2"></i>${t.tierName}
                                            </td>
                                            <td class="text-muted fw-medium small py-4" style="max-width: 200px;">
                                                <div class="text-truncate" title="${t.desciption}">
                                                    ${empty t.desciption ? '<span class="fst-italic opacity-50">No description</span>' : t.desciption}
                                                </div>
                                            </td>
                                            <td class="text-dark fw-bolder py-4">
                                                <fmt:formatNumber value="${t.minSpend}" pattern="#,###" /> VNĐ
                                            </td>
                                            <td class="text-dark fw-bolder py-4">
                                                <span class="bg-light border rounded px-2 py-1">${t.pointRate}x</span>
                                            </td>
                                            <td class="text-center py-4">
                                                <c:choose>
                                                    <c:when test="${t.status}">
                                                        <span class="badge bg-success bg-opacity-10 text-success border border-success border-opacity-25 px-2 py-1 shadow-sm" style="font-size: 0.7rem; letter-spacing: 0.5px;">ACTIVE</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-danger bg-opacity-10 text-danger border border-danger border-opacity-25 px-2 py-1 shadow-sm" style="font-size: 0.7rem; letter-spacing: 0.5px;">INACTIVE</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="text-end pe-4 py-4">
                                                <div class="d-flex justify-content-end gap-2">
                                                    <!-- Nút Edit gọi JS. Xử lý escape chuỗi JS an toàn -->
                                                    <c:set var="singleQuote" value="'" />
                                                    <c:set var="escapedSingleQuote" value="\\'" />
                                                    <c:set var="doubleQuote" value='"' />
                                                    <c:set var="escapedDoubleQuote" value="&quot;" />

                                                    <c:set var="descStep1" value="${fn:replace(t.desciption, singleQuote, escapedSingleQuote)}" />
                                                    <c:set var="escapedDesc" value="${fn:replace(descStep1, doubleQuote, escapedDoubleQuote)}" />

                                                    <button type="button" class="btn btn-light rounded-pill px-3 fw-bold text-dark border shadow-sm"
                                                            onclick="openEditModal(${t.tierID}, '${t.tierName}', ${t.minSpend}, ${t.pointRate}, ${t.status}, '${escapedDesc}')" title="Edit Tier">
                                                        <i class="bi bi-pencil-square"></i>
                                                    </button>

                                                    <form action="MainController" method="post" class="m-0 p-0">
                                                        <input type="hidden" name="action" value="update_status_tier">
                                                        <input type="hidden" name="tierID" value="${t.tierID}">
                                                        <c:choose>
                                                            <c:when test="${t.status}">
                                                                <button type="submit" class="btn btn-outline-danger rounded-pill px-3 fw-bold bg-white" title="Deactivate" onclick="return confirm('Deactivate this tier?');">
                                                                    <i class="bi bi-pause-circle-fill"></i>
                                                                </button>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <button type="submit" class="btn btn-dark-custom rounded-pill px-3 fw-bold shadow-sm" title="Activate" onclick="return confirm('Activate this tier?');">
                                                                    <i class="bi bi-play-circle-fill"></i>
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
                    </c:otherwise>
                </c:choose>
            </div>
        </main>

        <!-- ==============================================
             MODAL ADD TIER
        ================================================ -->
        <div class="modal fade" id="addTierModal" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-lg modal-dialog-centered">
                <div class="modal-content modal-content-custom shadow-lg">
                    <div class="modal-header modal-header-custom px-4 py-4">
                        <h5 class="modal-title fw-bolder text-dark"><i class="bi bi-plus-circle-fill text-dark me-2"></i>Create New Tier</h5>
                        <button type="button" class="btn-close shadow-none" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <form action="MainController" method="post" class="needs-validation">
                        <input type="hidden" name="action" value="add_tier">
                        <div class="modal-body px-4 py-4" style="background-color: #f8fafc;">

                            <c:if test="${not empty error and isAdd}">
                                <div id="addModalAlert" class="alert alert-danger border-0 bg-danger bg-opacity-10 text-danger rounded-4 py-3 px-3 mb-4 d-flex align-items-center justify-content-between auto-dismiss-alert">
                                    <div class="d-flex align-items-center fw-bold"><i class="bi bi-exclamation-circle-fill me-2"></i>${error}</div>
                                    <button type="button" class="btn-close shadow-none" onclick="dismissAlertElement('addModalAlert')"></button>
                                </div>
                            </c:if>

                            <div class="row g-4">
                                <div class="col-12">
                                    <label class="fw-bold text-dark mb-2 small text-uppercase">Tier Name <span class="text-danger">*</span></label>
                                    <input type="text" name="tierName" class="form-control vibrant-input" placeholder="e.g. Diamond, Titanium, VIP..." required pattern=".*\S.*" value="${tierName}">
                                </div>
                                <div class="col-12">
                                    <label class="fw-bold text-dark mb-2 small text-uppercase">Description / Benefits</label>
                                    <textarea name="description" class="form-control vibrant-input" rows="3" placeholder="Describe the exclusive perks or benefits of this tier...">${description}</textarea>
                                </div>
                                <div class="col-md-6">
                                    <label class="fw-bold text-dark mb-2 small text-uppercase">Min Spend (VNĐ) <span class="text-danger">*</span></label>
                                    <input type="number" name="minSpend" class="form-control vibrant-input" min="0" value="${not empty minSpend ? minSpend : 0}" required>
                                </div>
                                <div class="col-md-6">
                                    <label class="fw-bold text-dark mb-2 small text-uppercase">Point Rate <span class="text-danger">*</span></label>
                                    <div class="input-group">
                                        <input type="number" name="pointRate" class="form-control vibrant-input" step="0.01" min="1.0" value="${not empty pointRate ? pointRate : 1.00}" required>
                                        <span class="input-group-text fw-bolder bg-light text-dark border-0">x Multiplier</span>
                                    </div>
                                </div>
                                <div class="col-12">
                                    <label class="fw-bold text-dark mb-2 small text-uppercase">Status</label>
                                    <select name="status" class="form-select vibrant-input cursor-pointer">
                                        <option value="true" ${empty status or status ? 'selected' : ''}>Active</option>
                                        <option value="false" ${not empty status and not status ? 'selected' : ''}>Inactive</option>
                                    </select>
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer px-4 py-3 border-0 bg-white">
                            <button type="button" class="btn btn-light rounded-pill px-4 fw-bold" data-bs-dismiss="modal">Cancel</button>
                            <button type="submit" class="btn btn-dark-custom rounded-pill px-5 fw-bold shadow-sm">Create Tier</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <!-- ==============================================
             MODAL EDIT TIER
        ================================================ -->
        <div class="modal fade" id="editTierModal" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-lg modal-dialog-centered">
                <div class="modal-content modal-content-custom shadow-lg">
                    <div class="modal-header modal-header-custom px-4 py-4">
                        <h5 class="modal-title fw-bolder text-dark"><i class="bi bi-pencil-square text-dark me-2"></i>Edit Tier Details</h5>
                        <button type="button" class="btn-close shadow-none" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <form action="MainController" method="post">
                        <input type="hidden" name="action" value="update_tier">
                        <input type="hidden" id="editTierID" name="tierID">

                        <div class="modal-body px-4 py-4" style="background-color: #f8fafc;">

                            <c:if test="${not empty error and isEdit}">
                                <div id="editModalAlert" class="alert alert-danger border-0 bg-danger bg-opacity-10 text-danger rounded-4 py-3 px-3 mb-4 d-flex align-items-center justify-content-between auto-dismiss-alert">
                                    <div class="d-flex align-items-center fw-bold"><i class="bi bi-exclamation-circle-fill me-2"></i>${error}</div>
                                    <button type="button" class="btn-close shadow-none" onclick="dismissAlertElement('editModalAlert')"></button>
                                </div>
                            </c:if>

                            <div class="row g-4">
                                <div class="col-12">
                                    <label class="fw-bold text-dark mb-2 small text-uppercase">Tier Name <span class="text-danger">*</span></label>
                                    <input type="text" id="editTierName" name="tierName" class="form-control vibrant-input" required pattern=".*\S.*">
                                </div>
                                <div class="col-12">
                                    <label class="fw-bold text-dark mb-2 small text-uppercase">Description / Benefits</label>
                                    <textarea id="editDescription" name="description" class="form-control vibrant-input" rows="3"></textarea>
                                </div>
                                <div class="col-md-6">
                                    <label class="fw-bold text-dark mb-2 small text-uppercase">Min Spend (VNĐ) <span class="text-danger">*</span></label>
                                    <input type="number" id="editMinSpend" name="minSpend" class="form-control vibrant-input" min="0" required>
                                </div>
                                <div class="col-md-6">
                                    <label class="fw-bold text-dark mb-2 small text-uppercase">Point Rate <span class="text-danger">*</span></label>
                                    <div class="input-group">
                                        <input type="number" id="editPointRate" name="pointRate" class="form-control vibrant-input" step="0.01" min="1.0" required>
                                        <span class="input-group-text fw-bolder bg-light text-dark border-0">x Multiplier</span>
                                    </div>
                                </div>
                                <div class="col-12">
                                    <label class="fw-bold text-dark mb-2 small text-uppercase">Status</label>
                                    <select id="editStatus" name="status" class="form-select vibrant-input cursor-pointer">
                                        <option value="true">Active</option>
                                        <option value="false">Inactive</option>
                                    </select>
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer px-4 py-3 border-0 bg-white">
                            <button type="button" class="btn btn-light rounded-pill px-4 fw-bold" data-bs-dismiss="modal">Cancel</button>
                            <button type="submit" class="btn btn-dark-custom rounded-pill px-5 fw-bold shadow-sm">Save Changes</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script>
                                        // Ẩn mượt mà các alert báo lỗi / thành công
                                        function dismissAlertElement(id) {
                                            const element = document.getElementById(id);
                                            if (element) {
                                                element.style.transition = "opacity 0.4s ease-out, transform 0.4s ease-out";
                                                element.style.opacity = "0";
                                                element.style.transform = "translateY(-8px)";
                                                setTimeout(() => {
                                                    element.style.setProperty("display", "none", "important");
                                                }, 400);
                                            }
                                        }

                                        window.onload = function () {
                                            // Tự ẩn alert sau 4s
                                            setTimeout(function () {
                                                const activeAlerts = document.querySelectorAll('.auto-dismiss-alert');
                                                activeAlerts.forEach(alert => {
                                                    dismissAlertElement(alert.id);
                                                });
                                            }, 4000);

                                            // Load lại modal nếu có validation error từ backend (Đã fix truyền biến EL an toàn)
                                            const errorMsg = '${fn:escapeXml(error)}';
                                            const isEditFlag = ${isEdit};
                                            const isAddFlag = ${isAdd};

                                            if (errorMsg !== "") {
                                                if (isEditFlag) {
                                                    const id = '${empty editTierID ? 0 : editTierID}';
                                                    const name = '${fn:escapeXml(tierName)}';
                                                    const spend = '${empty minSpend ? 0 : minSpend}';
                                                    const rate = '${empty pointRate ? 1.0 : pointRate}';
                                                    const statusVal = '${empty status ? true : status}';
                                                    const desc = '${fn:escapeXml(description)}';

                                                    openEditModal(id, name, spend, rate, statusVal === 'true', desc);
                                                } else if (isAddFlag) {
                                                    new bootstrap.Modal(document.getElementById('addTierModal')).show();
                                                }
                                            }
                                        };

                                        // Hàm mở Modal và đổ Data
                                        function openEditModal(id, name, spend, rate, status, description) {
                                            document.getElementById('editTierID').value = id;
                                            document.getElementById('editTierName').value = name;
                                            document.getElementById('editMinSpend').value = spend;
                                            document.getElementById('editPointRate').value = rate;
                                            document.getElementById('editStatus').value = status ? "true" : "false";
                                            document.getElementById('editDescription').value = description || '';

                                            new bootstrap.Modal(document.getElementById('editTierModal')).show();
                                        }
        </script>
    </body>
</html>