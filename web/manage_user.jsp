<%@page import="java.util.List"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>User Management | Elite Auto</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
        <link href="css/admin.css?v=1.1" rel="stylesheet">
        
        <link href="css/manage_users.css" rel="stylesheet">
    </head>
    <body class="admin-body bg-light">

        <jsp:include page="admin_sidebar.jsp"/>

        <main class="main-wrapper p-4 p-lg-5 animate-fade-up">

            <c:if test="${not empty error}">
                <div class="alert alert-danger border-0 bg-danger bg-opacity-10 text-danger rounded-4 p-3 mb-4 shadow-sm d-flex align-items-center">
                    <i class="bi bi-exclamation-circle-fill me-2 fs-5"></i>
                    <div class="small fw-bold">${error}</div>
                    <button type="button" class="btn-close ms-auto shadow-none small" data-bs-dismiss="alert"></button>
                </div>
            </c:if>
            <c:if test="${not empty success}">
                <div class="alert alert-success border-0 bg-success bg-opacity-10 text-success rounded-4 p-3 mb-4 shadow-sm d-flex align-items-center">
                    <i class="bi bi-check-circle-fill me-2 fs-5"></i>
                    <div class="small fw-bold">${success}</div>
                    <button type="button" class="btn-close ms-auto shadow-none small" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <div class="mb-4 pb-2">
                <h2 class="fw-bold text-dark mb-1 fs-3 tracking-tight">User Directory</h2>
                <p class="text-muted fw-medium small mb-0">Overview and manage system access.</p>
            </div>

            <div class="row g-4 mb-4">
                <div class="col-md-4">
                    <div class="bg-white p-4 rounded-4 shadow-sm border border-light h-100 d-flex align-items-center gap-4">
                        <div class="bg-light text-secondary rounded-circle d-flex align-items-center justify-content-center" style="width: 56px; height: 56px;">
                            <i class="bi bi-people-fill fs-4"></i>
                        </div>
                        <div>
                            <div class="text-muted fw-semibold text-uppercase small mb-1" style="font-size: 0.7rem; letter-spacing: 0.5px;">Total Users</div>
                            <h2 class="fw-bold text-dark mb-0 tracking-tight">${totalUsers != null ? totalUsers : 0}</h2>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="bg-white p-4 rounded-4 shadow-sm border border-light h-100 d-flex align-items-center gap-4">
                        <div class="bg-success bg-opacity-10 text-success rounded-circle d-flex align-items-center justify-content-center" style="width: 56px; height: 56px;">
                            <i class="bi bi-check-circle-fill fs-4"></i>
                        </div>
                        <div>
                            <div class="text-muted fw-semibold text-uppercase small mb-1" style="font-size: 0.7rem; letter-spacing: 0.5px;">Active Accounts</div>
                            <h2 class="fw-bold text-dark mb-0 tracking-tight">${activeUsers != null ? activeUsers : 0}</h2>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="bg-white p-4 rounded-4 shadow-sm border border-light h-100 d-flex align-items-center gap-4">
                        <div class="bg-danger bg-opacity-10 text-danger rounded-circle d-flex align-items-center justify-content-center" style="width: 56px; height: 56px;">
                            <i class="bi bi-snow fs-4"></i>
                        </div>
                        <div>
                            <div class="text-muted fw-semibold text-uppercase small mb-1" style="font-size: 0.7rem; letter-spacing: 0.5px;">Frozen Accounts</div>
                            <h2 class="fw-bold text-dark mb-0 tracking-tight">${frozenUsers != null ? frozenUsers : 0}</h2>
                        </div>
                    </div>
                </div>
            </div>

            <div class="bg-white rounded-4 shadow-sm border border-light overflow-hidden d-flex flex-column">

                <div class="p-4 border-bottom border-light">
                    <form id="filterForm" action="ManageUserController" method="POST" class="m-0 p-0 d-flex flex-column flex-md-row justify-content-between align-items-center gap-3">
                        
                        <input type="hidden" id="pageInput" name="page" value="${empty param.page ? 1 : param.page}">
                        
                        <div class="position-relative w-100" style="max-width: 350px;">
                            <i class="bi bi-search position-absolute text-muted" style="top: 50%; transform: translateY(-50%); left: 16px; font-size: 0.9rem;"></i>
                            <input type="text" name="search" value="${param.search}" class="form-control filter-input rounded-pill ps-5 py-2 w-100 shadow-none" placeholder="Search by name, email..." onkeypress="if(event.key === 'Enter') { submitFilter(); return false; }">
                        </div>

                        <div class="d-flex gap-2 w-100 justify-content-md-end">
                            <select name="userType" class="form-select filter-input rounded-pill py-2 ps-3 pe-5 shadow-none fw-medium cursor-pointer" style="width: auto; min-width: 130px;" onchange="submitFilter()">
                                <option value="ALL" ${param.userType == 'ALL' ? 'selected' : ''}>All Roles</option>
                                <option value="Customer" ${param.userType == 'Customer' ? 'selected' : ''}>Customer</option>
                                <option value="Business" ${param.userType == 'Business' ? 'selected' : ''}>Business</option>
                                <option value="Admin" ${param.userType == 'Admin' ? 'selected' : ''}>Admin</option>
                            </select>

                            <select name="status" class="form-select filter-input rounded-pill py-2 ps-3 pe-5 shadow-none fw-medium cursor-pointer" style="width: auto; min-width: 130px;" onchange="submitFilter()">
                                <option value="ALL" ${param.status == 'ALL' ? 'selected' : ''}>All Status</option>
                                <option value="Active" ${param.status == 'Active' ? 'selected' : ''}>Active</option>
                                <option value="Frozen" ${param.status == 'Frozen' ? 'selected' : ''}>Frozen</option>
                            </select>
                        </div>
                    </form>
                </div>

                <div class="table-responsive flex-grow-1" style="min-height: 400px;">
                    <table class="table table-custom table-borderless mb-0">
                        <thead class="bg-transparent">
                            <tr>
                                <th class="text-muted text-uppercase ps-4 pt-4 pb-3" style="width: 25%;">User Profile</th>
                                <th class="text-muted text-uppercase pt-4 pb-3" style="width: 15%;">Role</th>
                                <th class="text-muted text-uppercase pt-4 pb-3" style="width: 25%;">Contact Details</th>
                                <th class="text-muted text-uppercase pt-4 pb-3" style="width: 15%;">Last Active</th>
                                <th class="text-muted text-uppercase pt-4 pb-3" style="width: 10%;">Status</th>
                                <th class="text-muted text-uppercase text-end pe-4 pt-4 pb-3" style="width: 10%;">Action</th>
                            </tr>
                        </thead>
                        <tbody>

                            <c:if test="${empty LISTOFUSER}">
                                <tr>
                                    <td colspan="6" class="text-center py-5">
                                        <i class="bi bi-inbox fs-1 text-muted d-block mb-3" style="opacity: 0.2;"></i>
                                        <h5 class="fw-bold text-dark mb-1">No accounts found</h5>
                                        <p class="text-muted small">No users match your query or database is empty.</p>
                                    </td>
                                </tr>
                            </c:if>

                            <c:forEach var="user" items="${LISTOFUSER}">
                                <tr class="user-row ${user.status == 'Frozen' ? 'tr-frozen' : ''}">
                                    
                                    <td class="ps-4">
                                        <div class="d-flex align-items-center gap-3">
                                            <c:choose>
                                                <c:when test="${user.typeUser == 'Admin'}">
                                                    <div class="avatar-img avatar-admin">${fn:substring(user.firstName, 0, 1)}</div>
                                                </c:when>
                                                <c:when test="${user.typeUser == 'Business'}">
                                                    <div class="avatar-img avatar-business">${fn:substring(user.firstName, 0, 1)}</div>
                                                </c:when>
                                                <c:otherwise>
                                                    <div class="avatar-img avatar-customer">${fn:substring(user.firstName, 0, 1)}</div>
                                                </c:otherwise>
                                            </c:choose>
                                            
                                            <div>
                                                <div class="fw-bold text-dark" style="font-size: 0.95rem;">${user.firstName} ${user.lastName}</div>
                                                <div class="text-muted mt-1" style="font-size: 0.75rem;">ID: #${user.accountID}</div>
                                            </div>
                                        </div>
                                    </td>

                                    <td>
                                        <c:choose>
                                            <c:when test="${user.typeUser == 'Admin'}">
                                                <span class="badge-role role-admin">ADMIN</span>
                                            </c:when>
                                            <c:when test="${user.typeUser == 'Business'}">
                                                <span class="badge-role role-business">BUSINESS</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge-role role-customer">CUSTOMER</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>

                                    <td>
                                        <div class="text-dark fw-medium" style="font-size: 0.85rem;">${user.email}</div>
                                        <div class="text-muted mt-1" style="font-size: 0.8rem;">${user.phone}</div>
                                    </td>

                                    <td>
                                        <div class="text-muted" style="font-size: 0.85rem;">
                                            ${empty user.lastLoginAt ? '<span class="fst-italic opacity-50">Not recorded</span>' : user.lastLoginAt}
                                        </div>
                                    </td>

                                    <td>
                                        <c:choose>
                                            <c:when test="${user.status == 'Active'}">
                                                <div class="badge-status status-active">
                                                    <span class="status-dot"></span> ACTIVE
                                                </div>
                                            </c:when>
                                            <c:otherwise>
                                                <div class="badge-status status-frozen">
                                                    <span class="status-dot"></span> FROZEN
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>

                                    <td class="text-end pe-4">
                                        <form action="UserProcessController" method="POST" class="m-0 p-0">
                                            <input type="hidden" name="userId" value="${user.accountID}">
                                            <c:choose>
                                                <c:when test="${user.status == 'Active'}">
                                                    <input type="hidden" name="action" value="freeze">
                                                    <button type="submit" class="btn btn-sm btn-outline-danger rounded-pill px-4 fw-medium transition-hover" onclick="return confirm('Freeze this account? User will be disconnected.');">
                                                        Freeze
                                                    </button>
                                                </c:when>
                                                <c:otherwise>
                                                    <input type="hidden" name="action" value="activate">
                                                    <button type="submit" class="btn btn-sm btn-dark rounded-pill px-4 fw-medium transition-hover" onclick="return confirm('Reactivate this account?');">
                                                        Activate
                                                    </button>
                                                </c:otherwise>
                                            </c:choose>
                                        </form>
                                    </td>

                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>

                <c:set var="currentPage" value="${empty param.page ? 1 : param.page}" />
                <fmt:parseNumber var="totalPages" integerOnly="true" value="${(totalUsers + 9) / 10}" />
                
                <c:if test="${totalPages == 0}">
                    <c:set var="totalPages" value="1" />
                </c:if>
                
                <div class="bg-transparent p-4 border-top border-light d-flex flex-column flex-md-row justify-content-between align-items-center">
                    
                    <span class="text-muted fw-medium small">
                        Showing page <strong class="text-dark">${currentPage}</strong> of <strong class="text-dark">${totalPages}</strong>
                    </span>
                    
                    <div class="d-flex gap-1 mt-3 mt-md-0">
                        <button type="button" onclick="goToPage(${currentPage - 1})"
                           class="btn btn-sm btn-white border bg-white fw-bold ${currentPage <= 1 ? 'disabled opacity-50' : ''}" style="pointer-events: ${currentPage <= 1 ? 'none' : 'auto'}">
                           <i class="bi bi-chevron-left"></i>
                        </button>

                        <c:forEach begin="1" end="${totalPages}" var="i">
                            <button type="button" onclick="goToPage(${i})"
                               class="btn btn-sm fw-medium px-3 py-1 ${currentPage == i ? 'btn-dark text-white' : 'btn-white border bg-white text-dark'}">
                               ${i}
                            </button>
                        </c:forEach>

                        <button type="button" onclick="goToPage(${currentPage + 1})"
                           class="btn btn-sm btn-white border bg-white fw-bold ${currentPage >= totalPages ? 'disabled opacity-50' : ''}" style="pointer-events: ${currentPage >= totalPages ? 'none' : 'auto'}">
                           <i class="bi bi-chevron-right"></i>
                        </button>
                    </div>
                </div>

            </div>
        </main>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            // Hàm xử lý tìm kiếm/lọc: Ép quay lại trang 1 và gửi bằng POST
            function submitFilter() {
                document.getElementById('pageInput').value = 1;
                document.getElementById('filterForm').submit();
            }

            // Hàm xử lý chuyển trang: Truyền số trang vào input ẩn và gửi bằng POST
            function goToPage(pageNumber) {
                document.getElementById('pageInput').value = pageNumber;
                document.getElementById('filterForm').submit();
            }

            document.addEventListener("DOMContentLoaded", function () {
                // Tắt thông báo alert tự động
                setTimeout(function () {
                    let alerts = document.querySelectorAll('.alert');
                    alerts.forEach(function (alert) {
                        alert.style.transition = "opacity 0.5s ease-out, transform 0.5s ease-out";
                        alert.style.opacity = "0";
                        alert.style.transform = "translateY(-10px)";
                        setTimeout(() => { if (alert.parentNode) alert.parentNode.removeChild(alert); }, 500);
                    });
                }, 4000);
            });
        </script>
    </body>
</html>