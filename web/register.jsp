<%@page import="dto.Account"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Register | Elite Auto</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
        <link href="css/style.css" rel="stylesheet">

        <style>
            .form-check-input:checked {
                background-color: #000000 !important;
                border-color: #000000 !important;
            }
            .form-check-input:focus {
                border-color: #000000;
                box-shadow: 0 0 0 0.25rem rgba(0, 0, 0, 0.125);
            }
            .cursor-pointer {
                cursor: pointer;
            }
            input[type="password"]::-ms-reveal,
            input[type="password"]::-ms-clear {
                display: none;
            }
            /* Animation mượt mà khi mở form doanh nghiệp */
            #businessFields {
                transition: max-height 0.4s ease-in-out, opacity 0.4s ease-in-out;
                overflow: hidden;
            }
        </style>
    </head>
    <body style="background-color: var(--bg-card); position: relative;">

        <a href="MainController?action=home" class="position-absolute top-0 start-0 m-3 m-md-4 text-dark text-decoration-none transition-hover d-flex align-items-center bg-white px-3 py-2 rounded-pill shadow-sm border border-light" style="z-index: 10;">
            <i class="bi bi-arrow-left me-2"></i><span class="small fw-medium">Back to Home</span>
        </a>

        <div class="container min-vh-100 d-flex flex-column justify-content-center align-items-center py-5 animate-fade-up">

            <div class="text-center mb-4 mt-4">
                <a class="text-dark text-decoration-none fw-bold fs-3 tracking-tight d-inline-block transition-hover">
                    <i class="bi bi-vinyl-fill me-2"></i>EliteAuto
                </a>
            </div>

            <div class="bg-white p-4 p-sm-5 rounded-4 shadow-sm border border-light transition-hover delay-1" style="max-width: 600px; width: 100%;">

                <div class="text-center mb-4 pb-2">
                    <span class="badge bg-light text-dark border px-3 py-1.5 rounded-pill small fw-medium mb-2">Member Portal</span>
                    <h3 class="fw-bold tracking-tight mb-2">Create Account</h3>
                    <p class="text-muted small mb-0">
                        Already have an account? <a href="MainController?action=home" class="text-dark fw-semibold text-decoration-none transition-hover">Log in</a>
                    </p>
                </div>

                <%
                    String error = (String) request.getAttribute("error");
                    if (error != null) {
                %>
                <div class="alert alert-danger border-0 bg-danger bg-opacity-10 text-danger rounded-3 p-3 small mb-4 d-flex align-items-center justify-content-between id-toast-error">
                    <div class="d-flex align-items-center">
                        <i class="bi bi-x-circle-fill me-2 fs-5"></i>
                        <div>
                            <span class="fw-bold d-block small">Notification</span>
                            <span class="small"><%= error%></span>
                        </div>
                    </div>
                    <button type="button" class="btn-close btn-close-dark shadow-none small toast-close-btn"></button>
                </div>
                <% } %>

                <%
                    String success = (String) request.getAttribute("success");
                    if (success != null) {
                %>
                <div id="successToast" class="alert alert-success border-0 bg-success bg-opacity-10 text-success rounded-3 p-3 small mb-4 d-flex align-items-center">
                    <i class="bi bi-check-circle-fill me-2 fs-5"></i>
                    <div>
                        <span class="fw-bold d-block small">Success</span>
                        <span class="small"><%= success%></span>
                    </div>
                </div>
                <% }%>

                <form action="MainController" method="post" class="needs-validation">
                    <input type="hidden" name="action" value="register">

                    <h6 class="text-uppercase fw-bold text-dark tracking-wider small mb-3">Personal Information</h6>

                    <div class="row g-3 mb-3">
                        <div class="col-sm-6">
                            <label class="small text-muted mb-2 fw-medium">First Name <span class="text-danger">*</span></label>
                            <input type="text" name="firstName" value="${param.firstName}" 
                                   class="form-control form-control-lg border-0 bg-light shadow-sm rounded-3 transition-hover" 
                                   placeholder="John" required pattern=".*[A-Za-zÀ-ỹ].*" title="Please enter a valid first name (cannot be empty spaces)">
                        </div>
                        <div class="col-sm-6">
                            <label class="small text-muted mb-2 fw-medium">Last Name <span class="text-danger">*</span></label>
                            <input type="text" name="lastName" value="${param.lastName}" pattern=".*[A-Za-zÀ-ỹ].*" title="Please enter a valid last name (cannot be empty spaces)" 
                                   class="form-control form-control-lg border-0 bg-light shadow-sm rounded-3 transition-hover" 
                                   placeholder="Doe" required>
                        </div>
                    </div>

                    <div class="mb-4">
                        <label class="small text-muted mb-2 fw-medium">Phone <span class="text-danger">*</span></label>
                        <input type="text" name="phone" value="${param.phone}" pattern="^(0|\+84)[0-9]{9}$" title="Phone number must be a valid format (e.g. 0901234567)" class="form-control form-control-lg border-0 bg-light shadow-sm rounded-3 transition-hover" placeholder="0901234567" required>
                    </div>

                    <h6 class="text-uppercase fw-bold text-dark tracking-wider small mb-3 border-top pt-4">Account Information</h6>

                    <div class="mb-3">
                        <label class="small text-muted mb-2 fw-medium">Email <span class="text-danger">*</span></label>
                        <input type="email" name="email" value="${param.email}" 
                               pattern="[a-zA-Z0-9._%+\-]+@[a-zA-Z0-9.\-]+\.[a-zA-Z]{2,}"
                               class="form-control form-control-lg border-0 bg-light shadow-sm rounded-3 transition-hover" 
                               placeholder="john@example.com" required>
                    </div>

                    <div class="mb-3">
                        <label class="small text-muted mb-2 fw-medium">Password <span class="text-danger">*</span></label>
                        <div class="position-relative">
                            <input type="password" id="password" name="password" 
                                   pattern="(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[^A-Za-z0-9]).{8,20}" class="form-control form-control-lg border-0 bg-light shadow-sm rounded-3 transition-hover pe-5" placeholder="Enter password" required>
                            <span class="position-absolute top-50 end-0 translate-middle-y me-3 text-muted cursor-pointer" onclick="togglePassword('password', this)">
                                <i class="bi bi-eye"></i>
                            </span>
                        </div>
                        <p class="text-muted" style="font-size: 0.75rem; line-height: 1.4; margin-top: 6px;">
                            8-20 characters, including uppercase, lowercase, numbers and special characters.
                        </p>
                    </div>

                    <div class="mb-4">
                        <label class="small text-muted mb-2 fw-medium">Verify Password <span class="text-danger">*</span></label>
                        <div class="position-relative">
                            <input type="password" id="confirmPassword" name="confirmPassword" class="form-control form-control-lg border-0 bg-light shadow-sm rounded-3 transition-hover pe-5" placeholder="Confirm password" required>
                            <span class="position-absolute top-50 end-0 translate-middle-y me-3 text-muted cursor-pointer" onclick="togglePassword('confirmPassword', this)">
                                <i class="bi bi-eye"></i>
                            </span>
                        </div>
                    </div>

                    <div class="form-check mb-4 text-start d-flex align-items-center">
                        <input class="form-check-input border-secondary-subtle me-2 cursor-pointer" type="checkbox" id="isBusiness" name="isBusiness" value="true" onchange="toggleBusinessForm()" ${param.isBusiness != null ? 'checked' : ''}>
                        <label class="form-check-label small text-muted cursor-pointer mb-0 pt-1" for="isBusiness">
                            Register as a Business?
                        </label>
                    </div>

                    <div id="businessFields" class="d-none">
                        <div class="p-4 bg-light rounded-4 mb-4 border">
                            <h6 class="text-uppercase fw-bold text-dark tracking-wider small mb-3">Business Information</h6>

                            <div class="mb-3">
                                <label class="small text-muted mb-2 fw-medium">Company Name <span class="text-danger">*</span></label>
                                <input type="text" id="companyName" name="companyName" 
                                       value="${param.companyName}"
                                       class="form-control form-control-lg border-0 shadow-sm rounded-3" 
                                       placeholder="Enter company name"
                                       pattern=".*\S.*" title="Company name cannot be only spaces">
                            </div>

                            <div class="row g-3 mb-3">
                                <div class="col-sm-6">
                                    <label class="small text-muted mb-2 fw-medium">Tax Code <span class="text-danger">*</span></label>
                                    <input type="text" id="taxCode" name="taxCode" 
                                           value="${param.taxCode}"
                                           class="form-control form-control-lg border-0 shadow-sm rounded-3" 
                                           placeholder="e.g. 0312345678"
                                           pattern="\d{10}|\d{10}-\d{3}">
                                </div>
                                <div class="col-sm-6">
                                    <label class="small text-muted mb-2 fw-medium">Company Address <span class="text-danger">*</span></label>
                                    <input type="text" id="companyAddress" 
                                           name="companyAddress" 
                                           value="${param.companyAddress}"
                                           class="form-control form-control-lg border-0 shadow-sm rounded-3" 
                                           placeholder="City, District..."
                                           pattern=".*\S.*" title="Address cannot be only spaces">
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="form-check mb-4 text-start d-flex align-items-center">
                        <input class="form-check-input border-secondary-subtle me-2 cursor-pointer" type="checkbox" name="agreeTerms" id="agreeTerms" required>
                        <label class="form-check-label small text-muted mb-0 pt-1" for="agreeTerms">
                            I agree to <a href="#" class="text-dark fw-semibold text-decoration-underline transition-hover" data-bs-toggle="modal" data-bs-target="#termsModal">Auto Wash System terms</a>.
                        </label>
                    </div>

                    <div class="btn-area">
                        <button type="submit" class="btn btn-black w-100 rounded-pill py-3 fw-bold tracking-wide transition-hover mb-3">
                            CREATE ACCOUNT
                        </button>
                    </div>
                </form>
            </div>
        </div>

        <div class="modal fade" id="termsModal" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered modal-dialog-scrollable modal-lg">
                <div class="modal-content border-0 rounded-4 shadow-lg overflow-hidden animate-fade-up">
                    <div class="modal-header border-bottom border-light px-4 py-3 bg-light">
                        <h5 class="modal-title fw-bold tracking-tight text-dark">Auto Wash System Terms & Conditions</h5>
                        <button type="button" class="btn-close shadow-none" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>

                    <div class="modal-body p-4 text-muted small" style="line-height: 1.6;">
                        <p class="fw-medium text-dark mb-4">Please read these mandatory terms carefully before creating your account. By registering and using Elite Auto services, you strictly agree to comply with the following conditions:</p>

                        <h6 class="fw-bold text-dark mt-4 mb-2"><i class="bi bi-person-badge me-2"></i>1. Account & Information Accuracy</h6>
                        <ul class="mb-3 ps-3">
                            <li class="mb-1">You must provide accurate and up-to-date personal and vehicle information (especially License Plate and Contact Number).</li>
                            <li class="mb-1"><strong>Business Accounts:</strong> Must provide a valid Company Name and Tax Code. Falsifying business details will result in immediate account suspension.</li>
                            <li>You are strictly responsible for maintaining the confidentiality of your account password.</li>
                        </ul>

                        <h6 class="fw-bold text-dark mt-4 mb-2"><i class="bi bi-calendar-x me-2"></i>2. Booking & Cancellation Policy</h6>
                        <ul class="mb-3 ps-3">
                            <li class="mb-1">Appointments must be modified or canceled at least <strong>2 hours</strong> prior to the scheduled time.</li>
                            <li class="mb-1 text-danger fw-medium">Repeated "No-shows" (failing to arrive for a confirmed booking without prior notice) will lead to temporary freezing of your account and loss of loyalty points.</li>
                            <li>We reserve the right to reschedule your booking in case of severe weather or technical system failures.</li>
                        </ul>

                        <h6 class="fw-bold text-dark mt-4 mb-2"><i class="bi bi-car-front me-2"></i>3. Service & Vehicle Liability</h6>
                        <ul class="mb-3 ps-3">
                            <li class="mb-1"><strong>Valuables:</strong> Please remove all valuable personal belongings from your vehicle before handing it over to our staff. Elite Auto is not responsible for any lost or damaged personal items.</li>
                            <li class="mb-1">Any pre-existing damage, scratches, or technical issues with the vehicle must be declared to our staff before the service begins.</li>
                            <li>We reserve the right to refuse service if the vehicle poses a safety or health hazard to our staff or equipment.</li>
                        </ul>

                        <h6 class="fw-bold text-dark mt-4 mb-2"><i class="bi bi-star me-2"></i>4. Promotions & Loyalty Tiers</h6>
                        <ul class="mb-0 ps-3">
                            <li class="mb-1">Loyalty points, tier benefits, and promotional vouchers are non-transferable and cannot be exchanged for cash.</li>
                            <li>Elite Auto reserves the right to modify or terminate promotional campaigns and tier rules at any time without prior notice.</li>
                        </ul>
                    </div>

                    <div class="modal-footer border-top border-light px-4 py-3 bg-light justify-content-between align-items-center">
                        <div class="small text-muted">
                            <i class="bi bi-info-circle me-1"></i> Scroll to read all terms
                        </div>
                        <button type="button" class="btn btn-black rounded-pill px-5 small transition-hover shadow-sm" data-bs-dismiss="modal" onclick="agreeTerms()">I Agree & Understand</button>
                    </div>
                </div>
            </div>
        </div>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script>
                            // YÊU CẦU 3: Giữ trạng thái hiển thị của form Business khi reload do lỗi submit
                            window.onload = function () {
                                if (document.getElementById("isBusiness").checked) {
                                    toggleBusinessForm();
                                }
                            };

                            // Logic bật/tắt form doanh nghiệp (Đã sửa để thêm/xóa required bằng JS)
                            function toggleBusinessForm() {
                                const isBusiness = document.getElementById("isBusiness").checked;
                                const businessFields = document.getElementById("businessFields");
                                const inputs = [document.getElementById("companyName"), document.getElementById("taxCode"), document.getElementById("companyAddress")];

                                if (isBusiness) {
                                    businessFields.classList.remove("d-none");
                                    // Bắt buộc nhập các trường này nếu là doanh nghiệp
                                    inputs.forEach(input => input.setAttribute("required", "true"));
                                } else {
                                    businessFields.classList.add("d-none");
                                    // Bỏ bắt buộc nhập nếu không phải doanh nghiệp
                                    inputs.forEach(input => {
                                        input.removeAttribute("required");
                                        // Tùy chọn: Xóa dữ liệu cũ nếu họ tắt đi, bỏ comment nếu bạn cần
                                        // input.value = ""; 
                                    });
                                }
                            }

                            // Logic cũ (giữ nguyên)
                            function agreeTerms() {
                                const checkbox = document.getElementById("agreeTerms");
                                if (checkbox)
                                    checkbox.checked = true;
                            }

                            var password = document.getElementById("password");
                            var confirmPassword = document.getElementById("confirmPassword");
                            function checkPasswordMatch() {
                                if (password.value !== confirmPassword.value)
                                    confirmPassword.setCustomValidity("Passwords do not match!");
                                else
                                    confirmPassword.setCustomValidity("");
                            }
                            password.addEventListener("change", checkPasswordMatch);
                            confirmPassword.addEventListener("keyup", checkPasswordMatch);

                            var toastCloseBtn = document.querySelector(".toast-close-btn");
                            var toastErrorAlert = document.querySelector(".id-toast-error");
                            if (toastErrorAlert) {
                                if (toastCloseBtn) {
                                    toastCloseBtn.onclick = function () {
                                        toastErrorAlert.style.setProperty("display", "none", "important");
                                    };
                                }
                                setTimeout(function () {
                                    toastErrorAlert.style.setProperty("display", "none", "important");
                                }, 3500);
                            }

                            var successToast = document.getElementById("successToast");
                            if (successToast) {
                                setTimeout(function () {
                                    window.location.href = "MainController?action=home";
                                }, 2000);
                            }

                            function togglePassword(inputId, element) {
                                const input = document.getElementById(inputId);
                                const icon = element.querySelector('i');
                                if (input.type === "password") {
                                    input.type = "text";
                                    icon.classList.remove('bi-eye');
                                    icon.classList.add('bi-eye-slash');
                                } else {
                                    input.type = "password";
                                    icon.classList.remove('bi-eye-slash');
                                    icon.classList.add('bi-eye');
                                }
                            }
        </script>
    </body>
</html>