<%@page import="dto.Business"%>
<%@page import="dto.Account"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    Account a = (Account) session.getAttribute("ACCOUNT");
    if (a == null) {
        response.sendRedirect("MainController?action=home");
        return;
    }
    String error = (String) request.getAttribute("error");
    String success = (String) request.getAttribute("success");

    // Tạo initials cho avatar
    String initials = (a.getFirstName() != null && !a.getFirstName().isEmpty() ? a.getFirstName().substring(0, 1) : "")
            + (a.getLastName() != null && !a.getLastName().isEmpty() ? a.getLastName().substring(0, 1) : "");

    Business bus = (Business) session.getAttribute("BUS");

    String dashboardURL;

    if (bus != null) {
        dashboardURL = "BusinessDashboardController";
    } else {
        dashboardURL = "CustomerDashBoardController";
    }
%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Edit Profile | Elite Auto</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
        <link href="css/style.css" rel="stylesheet">

        <style>
            input[type="password"]::-ms-reveal,
            input[type="password"]::-ms-clear {
                display: none !important;
            }

            input[type="password"]::-webkit-credentials-reveal {
                display: none !important;
            }
        </style>

    </head>
    <body style="background-color: var(--bg-card);">

        <div class="position-absolute top-0 start-0 p-4 z-3 animate-fade-up">
            <a href="<%=dashboardURL%>" class="d-inline-flex align-items-center bg-white rounded-pill shadow-sm px-4 py-2 text-dark fw-medium text-decoration-none transition-hover border border-light">
                <i class="bi bi-arrow-left me-2"></i> Back to Dashboard
            </a>
        </div>

        <div class="container py-5 min-vh-100 d-flex flex-column justify-content-center animate-fade-up delay-1">
            <div class="row justify-content-center w-100 mx-0">
                <div class="col-md-8 col-lg-6">

                    <div class="bg-white p-4 p-md-5 rounded-4 shadow-sm border border-light transition-hover">

                        <div class="text-center mb-5 border-bottom pb-4">
                            <div class="bg-dark text-white rounded-circle d-flex align-items-center justify-content-center mx-auto mb-3 shadow-sm float-anim" style="width: 80px; height: 80px; font-size: 1.8rem; font-weight: 700;">
                                <%= initials.toUpperCase()%>
                            </div>
                            <h3 class="fw-bold tracking-tight mb-1">Account Settings</h3>
                            <p class="text-muted small mb-0">Update your personal information and security details.</p>
                        </div>

                        <% if (error != null) {%>
                        <div class="alert alert-danger border-0 bg-danger bg-opacity-10 text-danger rounded-3 p-3 small mb-4 d-flex align-items-center alert-dismissible fade show" role="alert">
                            <i class="bi bi-exclamation-circle-fill me-2 fs-5"></i> <%= error%>
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                        <% } %>

                        <% if (success != null) {%>
                        <div class="alert alert-success border-0 bg-success bg-opacity-10 text-success rounded-3 p-3 small mb-4 d-flex align-items-center alert-dismissible fade show" role="alert">
                            <i class="bi bi-check-circle-fill me-2 fs-5"></i> <%= success%>
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                        <% }%>

                        <form action="MainController" method="post">
                            <input type="hidden" name="action" value="saveaccount">
                            <input type="hidden" name="accID" value="<%= a.getAccountID()%>">

                            <div class="d-flex align-items-center mb-3">
                                <i class="bi bi-person-badge-fill text-muted me-2"></i>
                                <h6 class="text-muted small text-uppercase fw-bold m-0 tracking-tight">Personal Details</h6>
                            </div>

                            <div class="row g-3 mb-3">
                                <div class="col-sm-6">
                                    <label class="small text-muted mb-2 fw-medium">First Name</label>
                                    <input type="text" name="firstName" 
                                           class="form-control form-control-lg border-0 bg-light shadow-sm rounded-3 transition-hover" 
                                           value="<%= a.getFirstName()%>" 
                                           pattern="[A-Za-zÀ-ỹ\s]+"
                                           required>
                                </div>
                                <div class="col-sm-6">
                                    <label class="small text-muted mb-2 fw-medium">Last Name</label>
                                    <input type="text" name="lastName" 
                                           class="form-control form-control-lg border-0 bg-light shadow-sm rounded-3 transition-hover"
                                           value="<%= a.getLastName()%>" 
                                           pattern="[A-Za-zÀ-ỹ\s]+"
                                           required>
                                </div>
                            </div>

                            <div class="mb-3">
                                <label class="small text-muted mb-2 fw-medium">Phone Number</label>
                                <input type="text" name="phone" 
                                       class="form-control form-control-lg border-0 bg-light shadow-sm rounded-3 transition-hover" 
                                       value="<%= a.getPhone()%>" 
                                       pattern="^[0-9]{10}$"
                                       required>
                            </div>

                            <div class="mb-4 pb-3 border-bottom border-light">
                                <label class="small text-muted mb-2 fw-medium">Email Address</label>
                                <input type="email" name="email" 
                                       class="form-control form-control-lg border-0 bg-light shadow-sm rounded-3 transition-hover" 
                                       value="<%= a.getEmail()%>" 
                                       pattern="[a-zA-Z0-9._%+\-]+@[a-zA-Z0-9.\-]+\.[a-zA-Z]{2,}"
                                       required>
                            </div>

                            <div class="d-flex align-items-center mb-3 pt-2">
                                <i class="bi bi-shield-lock-fill text-muted me-2"></i>
                                <h6 class="text-muted small text-uppercase fw-bold m-0 tracking-tight">Security Verification</h6>
                            </div>

                            <div class="mb-4">
                                <label class="small text-muted mb-2 fw-medium">Current Password <span class="text-danger">*</span></label>
                                <div class="password-container position-relative">
                                    <input type="password" id="currentPassword" name="currentPassword" 
                                           class="form-control form-control-lg border-0 bg-light shadow-sm rounded-3 transition-hover pe-5" 
                                           placeholder="Enter current password" required>
                                    <span class="position-absolute top-50 end-0 translate-middle-y me-3 text-muted cursor-pointer" onclick="togglePassword('currentPassword', this)">
                                        <i class="bi bi-eye"></i>
                                    </span>
                                </div>
                                <div class="form-text small text-muted mt-2">
                                    <i class="bi bi-info-circle me-1"></i>Confirm your current password to save changes.
                                </div>
                            </div>

                            <div class="form-check form-switch mb-4">
                                <input class="form-check-input cursor-pointer" type="checkbox" id="changePasswordToggle" name="changePasswordToggle" onchange="toggleNewPasswordFields()">
                                <label class="form-check-label small fw-medium text-dark cursor-pointer" for="changePasswordToggle">Want to change your password?</label>
                            </div>

                            <div id="newPasswordSection" class="d-none">
                                <div class="mb-3">
                                    <label class="small text-muted mb-2 fw-medium">New Password <span class="text-danger">*</span></label>
                                    <div class="position-relative">
                                        <input type="password" id="password" name="password" 
                                               pattern="(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[^A-Za-z0-9]).{8,20}"
                                               class="form-control form-control-lg border-0 bg-light shadow-sm rounded-3 transition-hover pe-5" 
                                               placeholder="Enter new password">
                                        <span class="position-absolute top-50 end-0 translate-middle-y me-3 text-muted cursor-pointer" onclick="togglePassword('password', this)">
                                            <i class="bi bi-eye"></i>
                                        </span>
                                    </div>
                                </div>

                                <div class="mb-4">
                                    <label class="small text-muted mb-2 fw-medium">Verify New Password <span class="text-danger">*</span></label>
                                    <div class="position-relative">
                                        <input type="password" id="confirmPassword" name="confirmPassword" 
                                               class="form-control form-control-lg border-0 bg-light shadow-sm rounded-3 transition-hover pe-5" 
                                               placeholder="Confirm new password">
                                        <span class="position-absolute top-50 end-0 translate-middle-y me-3 text-muted cursor-pointer" onclick="togglePassword('confirmPassword', this)">
                                            <i class="bi bi-eye"></i>
                                        </span>
                                    </div>
                                </div>
                            </div>

                            <button type="submit" class="btn btn-black w-100 rounded-pill py-3 fw-medium transition-hover">
                                Save Changes
                            </button>


                        </form>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script>
                                            // Hàm ẩn hiện mắt mật khẩu
                                            function togglePassword(inputId, button) {
                                                const input = document.getElementById(inputId);
                                                const icon = button.querySelector('i');
                                                if (input && input.type === "password") {
                                                    input.type = "text";
                                                    icon.classList.remove('bi-eye');
                                                    icon.classList.add('bi-eye-slash');
                                                } else if (input) {
                                                    input.type = "password";
                                                    icon.classList.remove('bi-eye-slash');
                                                    icon.classList.add('bi-eye');
                                                }
                                            }

                                            // Hàm ẩn hiện các ô mật khẩu mới và bật/tắt thuộc tính bắt buộc (required)
                                            function toggleNewPasswordFields() {
                                                const toggle = document.getElementById("changePasswordToggle");
                                                const section = document.getElementById("newPasswordSection");
                                                const newPass = document.getElementById("password");
                                                const confirmPass = document.getElementById("confirmPassword");

                                                if (toggle.checked) {
                                                    section.classList.remove("d-none");
                                                    newPass.setAttribute("required", "required");
                                                    confirmPass.setAttribute("required", "required");
                                                } else {
                                                    section.classList.add("d-none");
                                                    newPass.removeAttribute("required");
                                                    confirmPass.removeAttribute("required");
                                                    newPass.value = "";
                                                    confirmPass.value = "";
                                                    confirmPass.setCustomValidity(""); // Xóa thông báo lỗi cũ
                                                }
                                            }

                                            // Hàm kiểm tra trùng khớp mật khẩu mới
                                            function checkPasswordMatch() {
                                                const password = document.getElementById("password");
                                                const confirmPassword = document.getElementById("confirmPassword");

                                                if (password && confirmPassword) {
                                                    if (password.value !== confirmPassword.value) {
                                                        confirmPassword.setCustomValidity("Passwords do not match!");
                                                    } else {
                                                        confirmPassword.setCustomValidity("");
                                                    }
                                                }
                                            }

                                            // Đảm bảo bắt sự kiện an toàn sau khi trang web tải xong hoàn toàn
                                            document.addEventListener("DOMContentLoaded", function () {
                                                const passwordInput = document.getElementById("password");
                                                const confirmPasswordInput = document.getElementById("confirmPassword");

                                                if (passwordInput && confirmPasswordInput) {
                                                    passwordInput.addEventListener("change", checkPasswordMatch);
                                                    confirmPasswordInput.addEventListener("keyup", checkPasswordMatch);
                                                }
                                            });
        </script>
    </body>
</html>