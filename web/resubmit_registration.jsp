<%@page import="dto.Account"%>
<%@page import="dto.Business"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<%
    Account account = (Account) request.getSession().getAttribute("ACCOUNT");
    if (account == null) {
        response.sendRedirect("MainController?action=home");
        return;
    }

    Business b = (Business)request.getAttribute("business");
%>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Update Registration | Elite Auto</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    
    <style>
        body {
            font-family: 'Inter', sans-serif;
            background-color: #f9fafb;
            color: #111827;
        }
        .form-control {
            border-radius: 0.75rem;
            padding: 0.6rem 1rem;
            font-size: 0.95rem;
            border: 1px solid transparent;
        }
        .form-control:focus {
            background-color: #ffffff !important;
            border-color: #0a0a0a;
            box-shadow: 0 0 0 4px rgba(10, 10, 10, 0.1);
        }
        .badge-soft-danger {
            background-color: rgba(220, 53, 69, 0.1);
            color: #b02a37;
        }
        /* Hiệu ứng load của nút lúc redirect */
        .redirecting {
            opacity: 0.7;
            pointer-events: none;
        }
    </style>
</head>
<body>

    <nav class="navbar navbar-light bg-white border-bottom shadow-sm px-4 py-3">
        <a class="navbar-brand fw-bold fs-4 d-flex align-items-center" href="#">
            <i class="bi bi-vinyl-fill me-2 fs-3 text-dark"></i>EliteAuto
        </a>
        <a href="MainController?action=logout" class="btn btn-light rounded-pill px-4 fw-medium btn-sm transition-hover">
            Logout
        </a>
    </nav>

    <div class="container py-5">
        <div class="row justify-content-center">
            <div class="col-lg-8 col-xl-7">
                
                <div class="text-center mb-4 pb-2">
                    <h2 class="fw-bold tracking-tight mb-2">Update Your Information</h2>
                    <p class="text-muted small">Please review the feedback and update your registration details.</p>
                </div>

                <c:if test="${not empty error}">
                    <div id="globalErrorAlert" class="alert alert-danger border-0 bg-danger bg-opacity-10 text-danger rounded-4 p-3 small mb-4 d-flex align-items-center justify-content-between auto-dismiss-alert shadow-sm">
                        <div class="d-flex align-items-center"><i class="bi bi-exclamation-circle-fill me-2 fs-5"></i>${error}</div>
                        <button type="button" class="btn-close shadow-none small" onclick="dismissAlertElement('globalErrorAlert')"></button>
                    </div>
                </c:if>
                <c:if test="${not empty success}">
                    <div id="globalSuccessAlert" class="alert alert-success border-0 bg-success bg-opacity-10 text-success rounded-4 p-3 small mb-4 d-flex align-items-center justify-content-between auto-dismiss-alert shadow-sm">
                        <div class="d-flex align-items-center"><i class="bi bi-check-circle-fill me-2 fs-5"></i>${success} - Redirecting to login page...</div>
                        <button type="button" class="btn-close shadow-none small" onclick="dismissAlertElement('globalSuccessAlert')"></button>
                    </div>
                </c:if>
                <div class="alert badge-soft-danger border border-danger border-opacity-25 rounded-4 p-4 mb-4 shadow-sm">
                    <div class="d-flex align-items-start">
                        <i class="bi bi-exclamation-octagon-fill fs-4 me-3 mt-1"></i>
                        <div>
                            <h6 class="fw-bold mb-1 text-uppercase" style="letter-spacing: 0.5px; font-size: 0.85rem;">Action Required</h6>
                            <p class="mb-0 small fw-medium" style="line-height: 1.5;">
                                ${rejectReason != null ? rejectReason : 'Your previous application was missing some valid information. Please double-check your inputs below.'}
                            </p>
                        </div>
                    </div>
                </div>

                <div class="card border-0 shadow-sm rounded-4" id="mainFormCard">
                    <div class="card-body p-4 p-md-5">
                        
                        <form action="MainController" method="POST" id="updateForm">
                            <input type="hidden" name="action" value="resubmit_registration">
                            <input type="hidden" name="accountId" value="<%= account.getAccountID()%>">
                            
                            <h5 class="fw-bold mb-4 fs-6 text-uppercase text-muted border-bottom pb-2">Contact Details</h5>
                            
                            <div class="row g-3 mb-4">
                                <div class="col-md-6">
                                    <label class="form-label small fw-semibold text-muted ms-1 mb-1">Contact Person <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control bg-light shadow-none" name="contactName" value="<%= b.getContractName()%>" required placeholder="e.g. John Doe">
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label small fw-semibold text-muted ms-1 mb-1">Phone Number <span class="text-danger">*</span></label>
                                    <input type="tel" class="form-control bg-light shadow-none" name="phone" value="<%= b.getPhone()%>" required placeholder="e.g. 0901234567">
                                </div>
                            </div>
                            
                            <div class="mb-5">
                                <label class="form-label small fw-semibold text-muted ms-1 mb-1">Email Address <span class="text-danger">*</span></label>
                                <input type="email" class="form-control bg-light shadow-none" name="email" value="<%= b.getEmail()%>" required placeholder="name@company.com" readonly>
                                <div class="form-text small ms-1 mt-1 text-muted"><i class="bi bi-info-circle"></i> Email cannot be changed.</div>
                            </div>

                            <h5 class="fw-bold mb-4 fs-6 text-uppercase text-muted border-bottom pb-2">Business Information</h5>

                            <div class="row g-3 mb-4">
                                <div class="col-md-7">
                                    <label class="form-label small fw-semibold text-muted ms-1 mb-1">Company Name <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control bg-light shadow-none" name="businessName" value="<%= b.getBusinessName()%>" required placeholder="Full registered company name" pattern=".*\S.*">
                                </div>
                                <div class="col-md-5">
                                    <label class="form-label small fw-semibold text-muted ms-1 mb-1">Tax Code <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control bg-light shadow-none font-monospace" name="taxCode" value="<%= b.getTaxCode()%>" required placeholder="Tax identification number" pattern=".*\S.*">
                                </div>
                            </div>

                            <div class="mb-4 pb-2">
                                <label class="form-label small fw-semibold text-muted ms-1 mb-1">Company Address <span class="text-danger">*</span></label>
                                <textarea class="form-control bg-light shadow-none" name="companyAddress" rows="3" required style="resize: none;" placeholder="Full operating address" pattern=".*\S.*"><%= b.getCompanyAddress()%></textarea>
                            </div>

                            <div class="d-grid gap-2">
                                <button type="submit" class="btn btn-dark rounded-pill py-3 fw-bold fs-6 shadow-sm transition-hover" id="submitBtn">
                                    <i class="bi bi-send-fill me-2"></i> Resubmit Application
                                </button>
                            </div>

                        </form>

                    </div>
                </div>
                
                <div class="text-center mt-4">
                    <p class="text-muted small">Need help? Contact our support at <a href="mailto:support@eliteauto.com" class="text-dark fw-medium text-decoration-none">support@eliteauto.com</a></p>
                </div>

            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Hàm ẩn cảnh báo mượt mà
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
            // 1. Tự động ẩn tất cả thông báo lỗi/thành công sau 3.5 giây
            setTimeout(function() {
                const activeAlerts = document.querySelectorAll('.auto-dismiss-alert');
                activeAlerts.forEach(alert => { dismissAlertElement(alert.id); });
            }, 3500);

            // 2. Logic tự động Redirect nếu có biến success
            const isSuccess = "${not empty success}";
            if (isSuccess === "true") {
                // Khóa form lại để người dùng không bấm lung tung khi đang chờ chuyển trang
                document.getElementById('mainFormCard').classList.add('redirecting');
                const btn = document.getElementById('submitBtn');
                btn.innerHTML = '<span class="spinner-border spinner-border-sm me-2" role="status" aria-hidden="true"></span> Redirecting...';
                
                setTimeout(function() {
                    window.location.href = "MainController?action=home"; 
                }, 4000);
            }
        };
    </script>
</body>
</html>