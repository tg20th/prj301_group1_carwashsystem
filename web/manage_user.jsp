<%@page import="java.util.List"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<c:if test="${empty sessionScope.ACCOUNT}">
    <jsp:forward page="index.jsp"/>
</c:if>
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

            <!-- THÔNG BÁO TỪ BACKEND -->
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
                <h2 class="fw-bolder text-dark mb-1 fs-2 tracking-tight">User Directory</h2>
                <p class="text-secondary fw-medium mb-0">Overview and manage system access.</p>
            </div>

            <!-- VIBRANT KPI CARDS -->
            <div class="row g-4 mb-4">
                <div class="col-md-4">
                    <div class="glass-card p-4 rounded-4 shadow-sm h-100 d-flex align-items-center gap-4">
                        <div class="gradient-primary rounded-circle d-flex align-items-center justify-content-center shadow" style="width: 65px; height: 65px;">
                            <i class="bi bi-people-fill fs-3"></i>
                        </div>
                        <div>
                            <div class="text-muted fw-bold text-uppercase small mb-1" style="letter-spacing: 1px;">Total Users</div>
                            <h2 class="fw-bolder text-dark mb-0 tracking-tight" style="font-size: 2.2rem;">${totalUsers != null ? totalUsers : 0}</h2>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="glass-card p-4 rounded-4 shadow-sm h-100 d-flex align-items-center gap-4">
                        <div class="gradient-success rounded-circle d-flex align-items-center justify-content-center shadow" style="width: 65px; height: 65px;">
                            <i class="bi bi-check-circle-fill fs-3"></i>
                        </div>
                        <div>
                            <div class="text-muted fw-bold text-uppercase small mb-1" style="letter-spacing: 1px;">Active Accounts</div>
                            <h2 class="fw-bolder text-dark mb-0 tracking-tight" style="font-size: 2.2rem;">${activeUsers != null ? activeUsers : 0}</h2>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="glass-card p-4 rounded-4 shadow-sm h-100 d-flex align-items-center gap-4">
                        <div class="gradient-danger rounded-circle d-flex align-items-center justify-content-center shadow" style="width: 65px; height: 65px;">
                            <i class="bi bi-snow fs-3"></i>
                        </div>
                        <div>
                            <div class="text-muted fw-bold text-uppercase small mb-1" style="letter-spacing: 1px;">Frozen Accounts</div>
                            <h2 class="fw-bolder text-dark mb-0 tracking-tight" style="font-size: 2.2rem;">${frozenUsers != null ? frozenUsers : 0}</h2>
                        </div>
                    </div>
                </div>
            </div>

            <!-- MAIN TABLE CONTAINER -->
            <div class="glass-card rounded-4 shadow-sm overflow-hidden d-flex flex-column">

                <!-- TOOLBAR TÌM KIẾM -->
                <div class="p-4 border-bottom border-light">
                    <form id="filterForm" action="MainController?action=manage_user" method="POST" class="m-0 p-0 d-flex flex-column flex-md-row justify-content-between align-items-center gap-3">
                        
                        <input type="hidden" id="pageInput" name="page" value="${empty param.page ? 1 : param.page}">
                        
                        <div class="position-relative w-100" style="max-width: 400px;">
                            <i class="bi bi-search position-absolute text-muted" style="top: 50%; transform: translateY(-50%); left: 18px; font-size: 1rem;"></i>
                            <input type="text" name="search" value="${param.search}" class="form-control vibrant-input rounded-pill ps-5 w-100" placeholder="Search by name, email..." onkeypress="if(event.key === 'Enter') { document.getElementById('pageInput').value = 1; this.form.submit(); return false; }">
                        </div>

                        <div class="d-flex gap-2 w-100 justify-content-md-end">
                            <select name="userType" class="form-select vibrant-input rounded-pill cursor-pointer" style="width: auto; min-width: 150px;" onchange="document.getElementById('pageInput').value = 1; this.form.submit()">
                                <option value="ALL" ${param.userType == 'ALL' ? 'selected' : ''}>Role: All</option>
                                <option value="Customer" ${param.userType == 'Customer' ? 'selected' : ''}>Customer</option>
                                <option value="Business" ${param.userType == 'Business' ? 'selected' : ''}>Business</option>
                                <option value="Admin" ${param.userType == 'Admin' ? 'selected' : ''}>Admin</option>
                            </select>

                            <select name="status" class="form-select vibrant-input rounded-pill cursor-pointer" style="width: auto; min-width: 140px;" onchange="document.getElementById('pageInput').value = 1; this.form.submit()">
                                <option value="ALL" ${param.status == 'ALL' ? 'selected' : ''}>Status: All</option>
                                <option value="Active" ${param.status == 'Active' ? 'selected' : ''}>Active</option>
                                <option value="Frozen" ${param.status == 'Frozen' ? 'selected' : ''}>Frozen</option>
                            </select>
                        </div>
                    </form>
                </div>

                <!-- TABLE DỮ LIỆU -->
                <div class="table-responsive flex-grow-1" style="min-height: 400px;">
                    <table class="table table-borderless mb-0">
                        <thead class="bg-transparent">
                            <tr class="border-bottom" style="border-color: #eaedf1;">
                                <th class="text-muted text-uppercase fw-bold ps-4 py-3" style="font-size: 0.75rem; letter-spacing: 1px; width: 25%;">User Profile</th>
                                <th class="text-muted text-uppercase fw-bold py-3" style="font-size: 0.75rem; letter-spacing: 1px; width: 15%;">Role</th>
                                <th class="text-muted text-uppercase fw-bold py-3" style="font-size: 0.75rem; letter-spacing: 1px; width: 25%;">Contact Details</th>
                                <th class="text-muted text-uppercase fw-bold py-3" style="font-size: 0.75rem; letter-spacing: 1px; width: 15%;">Last Active</th>
                                <th class="text-muted text-uppercase fw-bold py-3" style="font-size: 0.75rem; letter-spacing: 1px; width: 10%;">Status</th>
                                <th class="text-muted text-uppercase fw-bold text-end pe-4 py-3" style="font-size: 0.75rem; letter-spacing: 1px; width: 10%;">Action</th>
                            </tr>
                        </thead>
                        <tbody>

                            <c:if test="${empty LISTOFUSER}">
                                <tr>
                                    <td colspan="6" class="text-center py-5">
                                        <div class="gradient-warning rounded-circle d-inline-flex align-items-center justify-content-center mb-3 shadow" style="width: 80px; height: 80px;">
                                            <i class="bi bi-people fs-1 text-white"></i>
                                        </div>
                                        <h4 class="fw-bold text-dark">No Accounts Found</h4>
                                        <p class="text-muted">No users match your query or database is empty.</p>
                                    </td>
                                </tr>
                            </c:if>

                            <c:forEach var="user" items="${LISTOFUSER}">
                                <tr class="user-row border-bottom ${user.status == 'Frozen' ? 'tr-frozen' : ''}" style="border-color: #f1f5f9;">
                                    
                                    <td class="ps-4 py-3">
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
                                                <div class="fw-bolder text-dark" style="font-size: 1rem;">${user.firstName} ${user.lastName}</div>
                                                <div class="text-muted fw-bold font-monospace mt-1" style="font-size: 0.75rem;">ID: #${user.accountID}</div>
                                            </div>
                                        </div>
                                    </td>

                                    <td class="py-3 align-middle">
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

                                    <td class="py-3 align-middle">
                                        <div class="text-dark fw-medium" style="font-size: 0.85rem;"><i class="bi bi-envelope text-primary me-2"></i>${user.email}</div>
                                        <div class="text-muted mt-1" style="font-size: 0.8rem;"><i class="bi bi-telephone text-secondary me-2"></i>${user.phone}</div>
                                    </td>

                                    <td class="py-3 align-middle">
                                        <div class="text-muted" style="font-size: 0.85rem;">
                                            ${empty user.lastLoginAt ? '<span class="text-danger fst-italic">Not recorded</span>' : user.lastLoginAt}
                                        </div>
                                    </td>

                                    <td class="py-3 align-middle">
                                        <c:choose>
                                            <c:when test="${user.status == 'Active'}">
                                                <div class="fw-bolder text-success small"><span class="status-dot bg-success shadow-sm"></span> ACTIVE</div>
                                            </c:when>
                                            <c:otherwise>
                                                <div class="fw-bolder text-danger small"><span class="status-dot bg-danger shadow-sm"></span> FROZEN</div>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>

                                    <td class="text-end pe-4 py-3 align-middle">
                                        <form action="MainController?action=process_user" method="POST" class="m-0 p-0"> 
                                            <input type="hidden" name="userId" value="${user.accountID}">
                                            
                                            <c:choose>
                                                <c:when test="${user.status == 'Active'}">
                                                    <input type="hidden" name="userAction" value="freeze">
                                                    <button type="submit" class="btn btn-sm btn-outline-danger rounded-pill px-4 fw-bold shadow-sm bg-white" onclick="return confirm('Freeze this account? User will be disconnected.');">
                                                        Freeze
                                                    </button>
                                                </c:when>
                                                <c:otherwise>
                                                    <input type="hidden" name="userAction" value="activate">
                                                    <button type="submit" class="btn btn-sm btn-dark-custom rounded-pill px-4 fw-bold shadow-sm" onclick="return confirm('Reactivate this account?');">
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

                <!-- PHÂN TRANG -->
                <c:set var="currentPage" value="${empty param.page ? 1 : param.page}" />
                <fmt:parseNumber var="totalPages" integerOnly="true" value="${(totalUsers + 9) / 10}" />
                
                <c:if test="${totalPages == 0}">
                    <c:set var="totalPages" value="1" />
                </c:if>
                
                <div class="bg-transparent p-4 border-top border-light d-flex flex-column flex-md-row justify-content-between align-items-center">
                    
                    <span class="text-muted fw-bold small">
                        Showing page <strong class="text-dark">${currentPage}</strong> of <strong class="text-dark">${totalPages}</strong>
                    </span>
                    
                    <div class="d-flex gap-2 mt-3 mt-md-0">
                        <!-- Nút Prev -->
                        <button type="button" onclick="goToPage(${currentPage - 1})"
                           class="btn btn-light rounded-circle fw-bold shadow-sm border ${currentPage <= 1 ? 'disabled opacity-50' : ''}" style="width: 40px; height: 40px; pointer-events: ${currentPage <= 1 ? 'none' : 'auto'}">
                           <i class="bi bi-chevron-left"></i>
                        </button>

                        <!-- Số trang -->
                        <c:forEach begin="1" end="${totalPages}" var="i">
                            <button type="button" onclick="goToPage(${i})"
                               class="btn rounded-circle fw-bold shadow-sm ${currentPage == i ? 'btn-dark-custom border-0' : 'btn-light border text-dark'}" style="width: 40px; height: 40px;">
                               ${i}
                            </button>
                        </c:forEach>

                        <!-- Nút Next -->
                        <button type="button" onclick="goToPage(${currentPage + 1})"
                           class="btn btn-light rounded-circle fw-bold shadow-sm border ${currentPage >= totalPages ? 'disabled opacity-50' : ''}" style="width: 40px; height: 40px; pointer-events: ${currentPage >= totalPages ? 'none' : 'auto'}">
                           <i class="bi bi-chevron-right"></i>
                        </button>
                    </div>
                </div>

            </div>
        </main>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            function goToPage(pageNumber) {
                document.getElementById('pageInput').value = pageNumber;
                document.getElementById('filterForm').submit();
            }

            document.addEventListener("DOMContentLoaded", function () {
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