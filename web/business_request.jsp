<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<c:if test="account == null">
    <jsp:forward page="index.jsp"/>
</c:if>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Business Account Requests | Elite Auto</title>
    
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
        
        <div class="mb-4">
            <h2 class="section-header mb-1 text-dark fw-bold tracking-tight">Business Account Requests</h2>
            <p class="text-muted small mb-0">Review and approve new business registrations</p>
        </div>

        <c:if test="${not empty error}">
            <div id="globalErrorAlert" class="alert alert-danger border-0 bg-danger bg-opacity-10 text-danger rounded-4 p-3 small mb-4 d-flex align-items-center justify-content-between auto-dismiss-alert">
                <div class="d-flex align-items-center"><i class="bi bi-exclamation-circle-fill me-2"></i>${error}</div>
                <button type="button" class="btn-close shadow-none small" onclick="dismissAlertElement('globalErrorAlert')"></button>
            </div>
        </c:if>
        <c:if test="${not empty success}">
            <div id="globalSuccessAlert" class="alert alert-success border-0 bg-success bg-opacity-10 text-success rounded-4 p-3 small mb-4 d-flex align-items-center justify-content-between auto-dismiss-alert">
                <div class="d-flex align-items-center"><i class="bi bi-check-circle-fill me-2"></i>${success}</div>
                <button type="button" class="btn-close shadow-none small" onclick="dismissAlertElement('globalSuccessAlert')"></button>
            </div>
        </c:if>

        <div class="bg-white rounded-4 shadow-sm border border-light p-4">
            <c:if test="${empty LIST_BUSINESS_REQUESTS}">
                <div class="text-center text-muted py-5">
                    <i class="bi bi-inbox fs-1 d-block mb-3"></i>
                    <p class="mb-0">No business requests found.</p>
                </div>
            </c:if>
            
            <c:if test="${not empty LIST_BUSINESS_REQUESTS}">
                <div class="table-responsive">
                    <table class="table table-custom table-borderless table-hover align-middle mb-0" id="requestTable">
                        <thead class="table-light">
                            <tr>
                                <th class="text-muted small fw-bold text-uppercase border-0 rounded-start ps-4">ID</th>
                                <th class="text-muted small fw-bold text-uppercase border-0">Company Name</th>
                                <th class="text-muted small fw-bold text-uppercase border-0">Contact Person</th>
                                <th class="text-muted small fw-bold text-uppercase border-0">Email / Phone</th>
                                <th class="text-muted small fw-bold text-uppercase border-0 text-center">Tax Code</th>
                                <th class="text-muted small fw-bold text-uppercase border-0 text-center">Status</th>
                                <th class="text-muted small fw-bold text-uppercase border-0 rounded-end text-end pe-4">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="req" items="${LIST_BUSINESS_REQUESTS}">
                                <tr class="border-bottom border-light">
                                    <td class="text-muted small fw-medium ps-4">#B-${req.accountId}</td>
                                    <td class="fw-bold text-dark">${req.businessName}</td>
                                    <td class="text-muted fw-medium">${req.contractName}</td>
                                    <td>
                                        <div class="text-dark small">${req.email}</div>
                                        <div class="text-muted small" style="font-size: 0.8rem;">${req.phone}</div>
                                    </td>
                                    <td class="text-center">
                                        <span class="badge bg-primary bg-opacity-10 text-primary border-0 px-3 py-1 font-monospace" style="font-size: 0.85rem; letter-spacing: 0.5px;">${req.taxCode}</span>
                                    </td>
                                    <td class="text-center">
                                        <c:choose>
                                            <c:when test="${req.status eq 'Pending'}">
                                                <span class="badge" style="background-color: #fef3c7; color: #b45309; padding: 0.4rem 0.75rem; font-size: 0.75rem; border-radius: 2rem;">
                                                    <i class="bi bi-clock me-1"></i> Pending
                                                </span>
                                            </c:when>
                                            <c:when test="${req.status eq 'Rejected'}">
                                                <span class="badge badge-soft-danger border border-danger border-opacity-25 px-3 py-1" style="font-size: 0.75rem; border-radius: 2rem;">Rejected</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge badge-soft-success border border-success border-opacity-25 px-3 py-1" style="font-size: 0.75rem; border-radius: 2rem;">${req.status}</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="text-end pe-4">
                                        <div class="d-flex justify-content-end gap-2">
                                            
                                            <button onclick="viewDetail(this)" 
                                                    data-id="${req.accountId}"
                                                    data-company="${req.businessName}"
                                                    data-contact="${req.contractName}"
                                                    data-email="${req.email}"
                                                    data-phone="${req.phone}"
                                                    data-tax="${req.taxCode}"
                                                    data-address="${empty req.companyAddress ? 'Not provided' : req.companyAddress}"
                                                    data-status="${req.status}"
                                                    class="btn btn-sm btn-outline-secondary px-3 py-1 rounded-pill fw-medium d-flex align-items-center gap-1 transition-hover" style="font-size: 0.8rem;">
                                                <i class="bi bi-eye"></i> View
                                            </button>
                                            
                                            <c:if test="${req.status eq 'Pending'}">
                                                <button onclick="triggerApproveModal('${req.accountId}')" 
                                                        class="btn btn-sm text-white px-3 py-1 rounded-pill fw-medium d-flex align-items-center gap-1 transition-hover shadow-sm" style="font-size: 0.8rem; background-color: #059669; border-color: #059669;">
                                                    <i class="bi bi-check-lg"></i> Approve
                                                </button>
                                                
                                                <button onclick="triggerRejectModal('${req.accountId}')" 
                                                        class="btn btn-sm btn-outline-danger px-3 py-1 rounded-pill fw-medium d-flex align-items-center gap-1 transition-hover" style="font-size: 0.8rem;">
                                                    <i class="bi bi-x-lg"></i> Reject
                                                </button>
                                            </c:if>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:if>
        </div>
    </main>

    <div class="modal fade" id="detailModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered modal-lg">
            <div class="modal-content border-0 shadow" style="border-radius: 1.5rem;" id="modalContentShell">
                </div>
        </div>
    </div>

    <div class="modal fade" id="approveModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered modal-sm">
            <div class="modal-content border-0 shadow" style="border-radius: 1.5rem;">
                <div class="modal-body p-4 text-center">
                    <div class="mb-3 mt-2">
                        <i class="bi bi-check-circle-fill text-success" style="font-size: 3.5rem;"></i>
                    </div>
                    <h5 class="fw-bold text-dark mb-2">Confirm Approval?</h5>
                    <p class="text-muted small mb-4">Are you sure you want to approve the business account for <span id="approveIdText" class="fw-bold text-dark"></span>?</p>
                    <div class="d-flex gap-2 justify-content-center">
                        <button type="button" class="btn btn-light rounded-pill px-4 fw-medium transition-hover" data-bs-dismiss="modal">Cancel</button>
                        <button type="button" class="btn btn-success rounded-pill px-4 fw-medium shadow-sm transition-hover" onclick="submitApprove()" style="background-color: #059669; border-color: #059669;">Approve Now</button>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="rejectModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered modal-md"> 
            <div class="modal-content border-0 shadow" style="border-radius: 1.5rem;">
                <div class="modal-body p-4 text-center">
                    <div class="mb-3 mt-2">
                        <i class="bi bi-x-circle-fill text-danger" style="font-size: 3.5rem;"></i>
                    </div>
                    <h5 class="fw-bold text-dark mb-2">Confirm Rejection?</h5>
                    <p class="text-muted small mb-3">Are you sure you want to reject the registration request for <span id="rejectIdText" class="fw-bold text-dark"></span>?</p>
                    
                    <div class="text-start mb-3">
                        <label class="small text-muted fw-semibold mb-2 ms-1">Rejection Reason <span class="text-danger">*</span></label>
                        <textarea id="rejectReasonInput" class="form-control border-0 bg-light py-2 px-3 shadow-none small text-dark" 
                                  style="border-radius: 0.75rem; resize: none; font-size: 0.85rem;" rows="3" 
                                  placeholder="Please write down the reason for rejection..."></textarea>
                        
                        <div id="rejectErrorMsg" class="text-danger small mt-2 fw-medium d-none" style="font-size: 0.8rem;">
                            <i class="bi bi-exclamation-circle-fill me-1"></i> Please provide a reason before submitting.
                        </div>
                    </div>

                    <div class="d-flex gap-2 justify-content-end border-top pt-3 mt-2">
                        <button type="button" class="btn btn-light rounded-pill px-4 fw-medium transition-hover" data-bs-dismiss="modal">Cancel</button>
                        <button type="button" class="btn btn-danger rounded-pill px-4 fw-medium shadow-sm transition-hover" onclick="submitReject()">Reject Account</button>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // ==================== AUTO DISMISS ALERTS ====================
        function dismissAlertElement(id) {
            const element = document.getElementById(id);
            if (element) {
                element.style.transition = "opacity 0.4s ease-out, transform 0.4s ease-out";
                element.style.opacity = "0";
                element.style.transform = "translateY(-8px)";
                setTimeout(() => { element.style.setProperty("display", "none", "important"); }, 400);
            }
        }

        window.onload = function () {
            setTimeout(function() {
                const activeAlerts = document.querySelectorAll('.auto-dismiss-alert');
                activeAlerts.forEach(alert => { dismissAlertElement(alert.id); });
            }, 4000);
        };

        // ==================== MODAL LOGIC ====================
        let currentActionId = null;

        function viewDetail(btnElement) {
            const id = btnElement.getAttribute('data-id');
            const company = btnElement.getAttribute('data-company');
            const contact = btnElement.getAttribute('data-contact');
            const email = btnElement.getAttribute('data-email');
            const phone = btnElement.getAttribute('data-phone');
            const taxCode = btnElement.getAttribute('data-tax');
            const address = btnElement.getAttribute('data-address');
            const rawStatus = btnElement.getAttribute('data-status');

            let badgeHtml = '';
            let footerHtml = ''; 

            if (rawStatus === 'Pending') {
                badgeHtml = `<span class="badge ms-3" style="background-color: #fef3c7; color: #b45309; padding: 0.4rem 0.8rem; font-size: 0.8rem; border-radius: 2rem; font-weight: 600;"><i class="bi bi-clock me-1"></i> Pending</span>`;
                footerHtml = `
                    <div class="px-4">
                        <hr class="border-light mb-3 mt-0">
                    </div>
                    <div class="modal-footer border-0 px-4 pb-4 pt-0 gap-2 justify-content-end">
                        <button onclick="triggerRejectModal('\${id}')" class="btn btn-outline-danger rounded-pill px-4 fw-medium d-flex align-items-center gap-2 transition-hover">
                            <i class="bi bi-x-lg"></i> Reject
                        </button>
                        <button onclick="triggerApproveModal('\${id}')" class="btn btn-success rounded-pill px-4 fw-medium d-flex align-items-center gap-2 transition-hover shadow-sm" style="background-color: #059669; border-color: #059669;">
                            <i class="bi bi-check-lg"></i> Approve Account
                        </button>
                    </div>
                `;
            } else if (rawStatus === 'Rejected') {
                badgeHtml = `<span class="badge badge-soft-danger border border-danger border-opacity-25 px-3 py-1 ms-3" style="font-size: 0.8rem; border-radius: 2rem;">Rejected</span>`;
            } else {
                badgeHtml = `<span class="badge badge-soft-success border border-success border-opacity-25 px-3 py-1 ms-3" style="font-size: 0.8rem; border-radius: 2rem;">\${rawStatus}</span>`;
            }

            const modalContent = document.getElementById("modalContentShell");
            
            modalContent.innerHTML = `
                <div class="modal-header border-0 px-4 pt-4 pb-2 align-items-start">
                    <div>
                        <div class="d-flex align-items-center mb-1">
                            <h4 class="fw-bold mb-0 text-dark">\${company}</h4>
                            \${badgeHtml}
                        </div>
                        <p class="text-muted small mb-0 mt-1">Registration Request • #B-\${id}</p>
                    </div>
                    <button type="button" class="btn-close shadow-none p-2 bg-light rounded-circle mt-1" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                
                <div class="modal-body px-4 py-4">
                    <div class="row g-5">
                        <div class="col-md-6">
                            <h6 class="text-muted small fw-bold text-uppercase mb-4" style="letter-spacing: 0.5px;">Contact Information</h6>
                            <div class="mb-4">
                                <label class="text-muted small mb-1">Full Name</label>
                                <div class="fw-medium text-dark fs-6">\${contact}</div>
                            </div>
                            <div class="row">
                                <div class="col-7">
                                    <label class="text-muted small mb-1">Email</label>
                                    <div class="fw-medium text-dark text-break">\${email}</div>
                                </div>
                                <div class="col-5">
                                    <label class="text-muted small mb-1">Phone Number</label>
                                    <div class="fw-medium text-dark">\${phone}</div>
                                </div>
                            </div>
                        </div>
                        
                        <div class="col-md-6">
                            <h6 class="text-muted small fw-bold text-uppercase mb-4" style="letter-spacing: 0.5px;">Business Information</h6>
                            <div class="mb-4">
                                <label class="text-muted small mb-1">Company Name</label>
                                <div class="fw-medium text-dark fs-6">\${company}</div>
                            </div>
                            <div class="mb-4">
                                <label class="text-muted small mb-1">Tax Code</label>
                                <div class="fw-medium text-dark">\${taxCode}</div>
                            </div>
                            <div class="mb-3">
                                <label class="text-muted small mb-1">Company Address</label>
                                <div class="fw-medium text-dark">\${address}</div>
                            </div>
                        </div>
                    </div>
                </div>
                \${footerHtml}
            `;
            new bootstrap.Modal(document.getElementById('detailModal')).show();
        }

        function triggerApproveModal(id) {
            currentActionId = id;
            document.getElementById('approveIdText').innerText = '#B-' + id;
            const detailModalInstance = bootstrap.Modal.getInstance(document.getElementById('detailModal'));
            if (detailModalInstance) detailModalInstance.hide();
            new bootstrap.Modal(document.getElementById('approveModal')).show();
        }

        function submitApprove() {
            if (currentActionId) {
                window.location.href = 'ApproveBusinessController?action=approve&id=' + currentActionId;
            }
        }

        function triggerRejectModal(id) {
            currentActionId = id;
            document.getElementById('rejectIdText').innerText = '#B-' + id;
            
            document.getElementById('rejectReasonInput').value = '';
            document.getElementById('rejectErrorMsg').classList.add('d-none');
            
            const detailModalInstance = bootstrap.Modal.getInstance(document.getElementById('detailModal'));
            if (detailModalInstance) detailModalInstance.hide();
            
            new bootstrap.Modal(document.getElementById('rejectModal')).show();
        }

        function submitReject() {
            const reason = document.getElementById('rejectReasonInput').value;
            
            if (!reason || reason.trim() === "") {
                document.getElementById('rejectErrorMsg').classList.remove('d-none');
                return;
            }
            
            if (currentActionId) {
                window.location.href = 'RejectBusinessController?action=reject&id=' + currentActionId + '&reason=' + encodeURIComponent(reason.trim());
            }
        }
    </script>
</body>
</html>