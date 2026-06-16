<%@page import="dto.Tier"%>
<%@page import="java.util.List"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<%
    // Lấy danh sách Tier từ Servlet truyền sang
    List<Tier> listTier = (List<Tier>) request.getAttribute("LISTOFTIER");
    String error = (String) request.getAttribute("error");
    String success = (String) request.getAttribute("success");
    Boolean isEditMode = (Boolean) request.getAttribute("isEditMode");
    
    // LOGIC NHẬN DIỆN CHÍNH XÁC NGUỒN GỐC LỖI
    boolean isEdit = (isEditMode != null && isEditMode);
    // Nếu có tierName trả về nhưng không phải isEdit, chứng tỏ là đang ở form Add
    boolean isAdd = (request.getAttribute("tierName") != null && !isEdit);
    // Nếu có lỗi, mà không phải của Edit và Add -> Chắc chắn là lỗi chung (VD: của nút Toggle Status)
    boolean isGlobalError = (error != null && !isEdit && !isAdd);
%>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Tier Management | Elite Auto</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
        <link href="css/admin.css?v=1.1" rel="stylesheet">
    </head>
    <body class="admin-body">

        <jsp:include page="admin_sidebar.jsp"/>

        <main class="main-wrapper p-4 p-lg-5 animate-fade-up">
            <div class="d-flex justify-content-between align-items-end mb-4 pb-2">
                <div>
                    <h2 class="fw-bold tracking-tight mb-1 text-dark">Tier Rules & Rates</h2>
                    <p class="text-muted small mb-0">Manage loyalty levels, benefits description, required spends, and point rates</p>
                </div>
                <button class="btn btn-dark rounded-pill px-4 py-2 d-flex align-items-center gap-2 fw-medium transition-hover" 
                        data-bs-toggle="modal" data-bs-target="#addTierModal">
                    <i class="bi bi-plus-lg"></i> Add New Tier
                </button>
            </div>

            <% if (success != null) { %>
                <div id="globalSuccessAlert" class="alert alert-success border-0 bg-success bg-opacity-10 text-success rounded-4 p-3 small mb-4 d-flex align-items-center justify-content-between auto-dismiss-alert">
                    <div class="d-flex align-items-center"><i class="bi bi-check-circle-fill me-2"></i><%= success %></div>
                    <button type="button" class="btn-close shadow-none small" onclick="dismissAlertElement('globalSuccessAlert')"></button>
                </div>
            <% } %>
            
            <% if (isGlobalError) { %>
                <div id="globalErrorAlert" class="alert alert-danger border-0 bg-danger bg-opacity-10 text-danger rounded-4 p-3 small mb-4 d-flex align-items-center justify-content-between auto-dismiss-alert">
                    <div class="d-flex align-items-center"><i class="bi bi-exclamation-circle-fill me-2"></i><%= error %></div>
                    <button type="button" class="btn-close shadow-none small" onclick="dismissAlertElement('globalErrorAlert')"></button>
                </div>
            <% } %>

            <div class="bg-white p-4 rounded-4 shadow-sm border border-light">
                <% if (listTier == null || listTier.isEmpty()) { %>
                <div class="text-center text-muted py-5">
                    <i class="bi bi-inbox fs-1 d-block mb-3"></i>
                    <p class="mb-0">No tiers found. Create one to get started!</p>
                </div>
                <% } else { %>
                <div class="table-responsive">
                    <table class="table table-custom table-borderless table-hover mb-0 align-middle">
                        <thead class="table-light">
                            <tr>
                                <th class="text-muted small fw-bold text-uppercase border-0 rounded-start ps-3">ID</th>
                                <th class="text-muted small fw-bold text-uppercase border-0">Tier Name</th>
                                <th class="text-muted small fw-bold text-uppercase border-0">Description / Benefits</th>
                                <th class="text-muted small fw-bold text-uppercase border-0">Min Spend</th>
                                <th class="text-muted small fw-bold text-uppercase border-0">Point Rate</th>
                                <th class="text-muted small fw-bold text-uppercase border-0 text-center">Status</th>
                                <th class="text-muted small fw-bold text-uppercase border-0 rounded-end text-end pe-3">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                for (Tier t : listTier) {
                                    String tierColor = "text-primary";
                                    String tierIcon = "bi-award-fill";
                                    String name = (t.getTierName() != null) ? t.getTierName().trim() : "";
                                    if ("Member".equalsIgnoreCase(name)) {
                                        tierColor = "text-dark"; tierIcon = "bi-person-badge-fill";
                                    } else if ("Silver".equalsIgnoreCase(name)) {
                                        tierColor = "text-secondary"; tierIcon = "bi-award-fill";
                                    } else if ("Gold".equalsIgnoreCase(name)) {
                                        tierColor = "text-warning"; tierIcon = "bi-award-fill";
                                    } else if ("Platinum".equalsIgnoreCase(name) || "Diamond".equalsIgnoreCase(name)) {
                                        tierColor = "text-info"; tierIcon = "bi-gem";
                                    } else if ("VIP".equalsIgnoreCase(name)) {
                                        tierColor = "text-danger"; tierIcon = "bi-stars";
                                    }
                                    String statusBadge = t.isStatus() ? "bg-success bg-opacity-10 text-success border-success" : "bg-danger bg-opacity-10 text-danger border-danger";
                                    String statusText = t.isStatus() ? "Active" : "Inactive";
                                    
                                    String rawDesc = (t.getDesciption() != null) ? t.getDesciption() : "";
                                    String jsEscapedDesc = rawDesc.replace("'", "\\'").replace("\"", "&quot;").replace("\n", " ").replace("\r", "");
                            %>
                            <tr class="border-bottom border-light">
                                <td class="text-muted small fw-medium ps-3">#<%= t.getTierID()%></td>
                                <td class="fw-bold <%= tierColor%>">
                                    <i class="bi <%= tierIcon%> me-2"></i><%= t.getTierName()%>
                                </td>
                                <td class="text-muted small text-truncate" style="max-width: 220px;" title="<%= rawDesc%>">
                                    <%= rawDesc.isEmpty() ? "<span class='text-light-emphasis italic'>No description</span>" : rawDesc%>
                                </td>
                                <td class="text-dark fw-medium">
                                    <%= String.format("%,d", (long) t.getMinSpend())%> VNĐ
                                </td>
                                <td class="text-dark fw-medium"><%= t.getPointRate()%><span class="text-muted small fw-normal">x</span></td>
                                <td class="text-center">
                                    <span class="badge <%= statusBadge%> border border-opacity-25 px-2 py-1" style="font-size: 0.7rem;"><%= statusText%></span>
                                </td>
                                <td class="text-end pe-3">
                                    <button type="button" class="btn btn-sm bg-primary bg-opacity-10 text-primary border-0 rounded-circle transition-hover me-2"
                                            style="width: 32px; height: 32px;"
                                            onclick="openEditModal(<%= t.getTierID()%>, '<%= t.getTierName()%>', <%= (long) t.getMinSpend()%>, <%= t.getPointRate()%>, <%= t.isStatus()%>, '<%= jsEscapedDesc %>')"
                                            title="Edit Tier">
                                        <i class="bi bi-pencil-fill" style="font-size: 0.8rem;"></i>
                                    </button>

                                    <form action="RemoveTierController" method="post" class="d-inline">
                                        <input type="hidden" name="action" value="toggleStatus">
                                        <input type="hidden" name="tierID" value="<%= t.getTierID()%>">
                                        <button type="submit" class="btn btn-sm <%= t.isStatus() ? "bg-danger bg-opacity-10 text-danger" : "bg-success bg-opacity-10 text-success"%> border-0 rounded-circle transition-hover"
                                                style="width: 32px; height: 32px;"
                                                title="<%= t.isStatus() ? "Deactivate" : "Activate"%>"
                                                onclick="return confirm('Are you sure you want to change the status of this tier?');">
                                            <i class="bi <%= t.isStatus() ? "bi-eye-slash-fill" : "bi-eye-fill"%>" style="font-size: 0.8rem;"></i>
                                        </button>
                                    </form>
                                </td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
                <% }%>
            </div>
        </main>

        <div class="modal fade" id="addTierModal" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content border-0 shadow" style="border-radius: 1.5rem;">
                    <div class="modal-header border-0 px-4 pt-4 pb-0">
                        <h5 class="modal-title fw-bold text-dark fs-4">Add New Tier</h5>
                        <button type="button" class="btn-close bg-light rounded-circle p-2 shadow-none" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <form action="AddTierController" method="post">
                        <div class="modal-body p-4">

                            <% if (error != null && isAdd) { %>
                            <div id="addModalAlert" class="alert alert-danger border-0 bg-danger bg-opacity-10 text-danger rounded-3 py-2 px-3 small mb-3 d-flex align-items-center justify-content-between auto-dismiss-alert">
                                <div class="d-flex align-items-center">
                                    <i class="bi bi-exclamation-circle-fill me-2"></i>
                                    <span><%= error %></span>
                                </div>
                                <button type="button" class="btn-close shadow-none" onclick="dismissAlertElement('addModalAlert')" style="font-size: 0.65rem;"></button>
                            </div>
                            <% } %>

                            <div class="mb-4">
                                <label class="small text-muted fw-semibold mb-2 ms-1">Tier Name <span class="text-danger">*</span></label>
                                <input type="text" name="tierName" class="form-control border-0 bg-light py-2 px-3 shadow-none" 
                                       style="border-radius: 0.75rem;" placeholder="e.g. Diamond, Titanium, VIP..." required pattern=".*\S.*"
                                       value="${tierName}">
                            </div>
                            <div class="mb-4">
                                <label class="small text-muted fw-semibold mb-2 ms-1">Description / Benefits</label>
                                <textarea name="description" class="form-control border-0 bg-light py-2 px-3 shadow-none" 
                                          style="border-radius: 0.75rem; resize: none;" rows="3" placeholder="Describe the exclusive perks or benefits of this tier...">${description}</textarea>
                            </div>
                            <div class="row g-3 mb-4">
                                <div class="col-sm-6">
                                    <label class="small text-muted fw-semibold mb-2 ms-1">Min Spend (VNĐ) <span class="text-danger">*</span></label>
                                    <input type="number" name="minSpend" class="form-control border-0 bg-light py-2 px-3 shadow-none" 
                                           style="border-radius: 0.75rem;" min="0" value="${minSpend != null ? minSpend : 0}" required>
                                </div>
                                <div class="col-sm-6">
                                    <label class="small text-muted fw-semibold mb-2 ms-1">Point Rate <span class="text-danger">*</span></label>
                                    <input type="number" name="pointRate" class="form-control border-0 bg-light py-2 px-3 shadow-none" 
                                           style="border-radius: 0.75rem;" step="0.01" min="1.0" value="${pointRate != null ? pointRate : 1.00}" required>
                                </div>
                            </div>
                            <div class="mb-2">
                                <label class="small text-muted fw-semibold mb-2 ms-1">Status</label>
                                <select name="status" class="form-select border-0 bg-light py-2 px-3 shadow-none" style="border-radius: 0.75rem; cursor: pointer;">
                                    <option value="true" ${status == null || status == true ? 'selected' : ''}>Active</option>
                                    <option value="false" ${status != null && status == false ? 'selected' : ''}>Inactive</option>
                                </select>
                            </div>
                        </div>
                        <div class="modal-footer border-0 px-4 pb-4 pt-0 gap-2">
                            <button type="button" class="btn btn-light rounded-pill px-4 py-2 small fw-medium text-muted transition-hover" data-bs-dismiss="modal">Cancel</button>
                            <button type="submit" class="btn btn-dark rounded-pill px-4 py-2 small fw-medium shadow-sm transition-hover">Create Tier</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <div class="modal fade" id="editTierModal" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content border-0 shadow" style="border-radius: 1.5rem;">
                    <div class="modal-header border-0 px-4 pt-4 pb-0">
                        <h5 class="modal-title fw-bold text-dark fs-4">Edit Tier Details</h5>
                        <button type="button" class="btn-close bg-light rounded-circle p-2 shadow-none" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <form action="UpdateTierController" method="post">
                        <input type="hidden" name="action" value="update">
                        <input type="hidden" id="editTierID" name="tierID">
                        <div class="modal-body p-4">

                            <% if (error != null && isEdit) { %>
                            <div id="editModalAlert" class="alert alert-danger border-0 bg-danger bg-opacity-10 text-danger rounded-3 py-2 px-3 small mb-3 d-flex align-items-center justify-content-between auto-dismiss-alert">
                                <div class="d-flex align-items-center">
                                    <i class="bi bi-exclamation-circle-fill me-2"></i>
                                    <span><%= error %></span>
                                </div>
                                <button type="button" class="btn-close shadow-none" onclick="dismissAlertElement('editModalAlert')" style="font-size: 0.65rem;"></button>
                            </div>
                            <% } %>

                            <div class="mb-4">
                                <label class="small text-muted fw-semibold mb-2 ms-1">Tier Name <span class="text-danger">*</span></label>
                                <input type="text" id="editTierName" name="tierName" class="form-control border-0 bg-light py-2 px-3 shadow-none" 
                                       style="border-radius: 0.75rem;" required pattern=".*\S.*">
                            </div>
                            <div class="mb-4">
                                <label class="small text-muted fw-semibold mb-2 ms-1">Description / Benefits</label>
                                <textarea id="editDescription" name="description" class="form-control border-0 bg-light py-2 px-3 shadow-none" 
                                          style="border-radius: 0.75rem; resize: none;" rows="3"></textarea>
                            </div>
                            <div class="row g-3 mb-4">
                                <div class="col-sm-6">
                                    <label class="small text-muted fw-semibold mb-2 ms-1">Min Spend (VNĐ) <span class="text-danger">*</span></label>
                                    <input type="number" id="editMinSpend" name="minSpend" class="form-control border-0 bg-light py-2 px-3 shadow-none" 
                                           style="border-radius: 0.75rem;" min="0" required>
                                </div>
                                <div class="col-sm-6">
                                    <label class="small text-muted fw-semibold mb-2 ms-1">Point Rate <span class="text-danger">*</span></label>
                                    <input type="number" id="editPointRate" name="pointRate" class="form-control border-0 bg-light py-2 px-3 shadow-none" 
                                           style="border-radius: 0.75rem;" step="0.01" min="1.0" required>
                                </div>
                            </div>
                            <div class="mb-2">
                                <label class="small text-muted fw-semibold mb-2 ms-1">Status</label>
                                <select id="editStatus" name="status" class="form-select border-0 bg-light py-2 px-3 shadow-none" style="border-radius: 0.75rem; cursor: pointer;">
                                    <option value="true">Active</option>
                                    <option value="false">Inactive</option>
                                </select>
                            </div>
                        </div>
                        <div class="modal-footer border-0 px-4 pb-4 pt-0 gap-2">
                            <button type="button" class="btn btn-light rounded-pill px-4 py-2 small fw-medium text-muted transition-hover" data-bs-dismiss="modal">Cancel</button>
                            <button type="submit" class="btn btn-dark rounded-pill px-4 py-2 small fw-medium shadow-sm transition-hover">Save Changes</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            // FUNCTION HIỆU ỨNG BIẾN MẤT MƯỢT MÀ
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

            // XỬ LÝ LÔ-GÍC BUNG MODAL VÀ TẮT THÔNG BÁO TỰ ĐỘNG
            window.onload = function () {
                // Đếm ngược 4000ms (4 giây) để tự ẩn TẤT CẢ các thông báo cảnh báo/thành công
                setTimeout(function() {
                    const activeAlerts = document.querySelectorAll('.auto-dismiss-alert');
                    activeAlerts.forEach(alert => {
                        dismissAlertElement(alert.id);
                    });
                }, 4000);

                const errorMsg = '<%= error != null ? error.replace("'", "\\'").replace("\n", " ").replace("\r", "") : "" %>';
                const isEditFlag = <%= isEdit %>;
                const isAddFlag = <%= isAdd %>;

                if (errorMsg !== "") {
                    // Nếu là lỗi sửa dữ liệu
                    if (isEditFlag) {
                        const id = '<%= request.getAttribute("editTierID") != null ? request.getAttribute("editTierID") : 0 %>';
                        const name = '<%= request.getAttribute("tierName") != null ? request.getAttribute("tierName") : "" %>';
                        const spend = '<%= request.getAttribute("minSpend") != null ? request.getAttribute("minSpend") : 0 %>';
                        const rate = '<%= request.getAttribute("pointRate") != null ? request.getAttribute("pointRate") : 1.0 %>';
                        const statusVal = '<%= request.getAttribute("status") != null ? request.getAttribute("status") : true %>';
                        const desc = '<%= request.getAttribute("description") != null ? ((String) request.getAttribute("description")).replace("\'", "\\\'").replace("\n", "\\n").replace("\r", "") : "" %>';

                        openEditModal(id, name, spend, rate, statusVal === "true", desc);
                    } 
                    // Nếu là lỗi tạo mới
                    else if (isAddFlag) {
                        var addModal = new bootstrap.Modal(document.getElementById('addTierModal'));
                        addModal.show();
                    }
                    // Trường hợp còn lại (isGlobalError = true) -> không bung Modal nào cả, sẽ tự hiện cái Global Error ở ngoài!
                }
            };

            function openEditModal(id, name, spend, rate, status, description) {
                document.getElementById('editTierID').value = id;
                document.getElementById('editTierName').value = name;
                document.getElementById('editMinSpend').value = spend;
                document.getElementById('editPointRate').value = rate;
                document.getElementById('editStatus').value = status ? "true" : "false";
                document.getElementById('editDescription').value = description || '';
                
                var editModal = new bootstrap.Modal(document.getElementById('editTierModal'));
                editModal.show();
            }
        </script>
    </body>
</html>