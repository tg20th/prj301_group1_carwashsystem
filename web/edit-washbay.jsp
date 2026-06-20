<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="dto.WashBay"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>

<c:if test="${empty sessionScope.ACCOUNT}">
    <jsp:forward page="index.jsp"/>
</c:if>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Edit Wash Bay | Elite Auto</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
        <link href="css/admin.css?v=1.0" rel="stylesheet">
        <link href="css/washbay.css" rel="stylesheet">
    </head>

    <body class="admin-body">

        <jsp:include page="admin_sidebar.jsp"/>

        <main class="main-wrapper p-4 p-lg-5 animate-fade-up">

            <%
                WashBay wb = (WashBay) request.getAttribute("WB");
                boolean hasWb = (wb != null);
            %>

            <div class="d-flex justify-content-between align-items-end mb-4 pb-2">
                <div>
                    <div class="d-flex align-items-center gap-2 mb-1">
                        <a href="WashBayController?action=list" class="text-muted text-decoration-none small d-flex align-items-center">
                            <i class="bi bi-arrow-left me-1"></i> Back to Wash Bays
                        </a>
                    </div>

                    <h2 class="fw-bold tracking-tight mb-1 text-dark">Edit Wash Bay</h2>

                    <p class="text-muted small mb-0">
                        Update name, description and status
                        <% if (hasWb) { %>
                            for <strong class="text-dark">#<%= wb.getWashBayID() %> <%= wb.getBayName() != null ? wb.getBayName() : "" %></strong>
                        <% } %>
                    </p>
                </div>

                <% if (hasWb) { %>
                    <div>
                        <span class="badge bg-dark bg-opacity-10 text-dark border border-dark border-opacity-25 rounded-pill px-3 py-1 small fw-medium">
                            #<%= wb.getWashBayID() %>
                        </span>
                    </div>
                <% } %>
            </div>

            <%
                String error = (String) request.getAttribute("ERROR");
                if (error != null) {
            %>
                <div class="alert alert-danger border-0 bg-danger bg-opacity-10 text-danger rounded-4 p-3 small mb-4 d-flex align-items-center justify-content-between">
                    <div class="d-flex align-items-center">
                        <i class="bi bi-exclamation-circle-fill me-2"></i><%= error %>
                    </div>
                </div>
            <%
                }
            %>

            <%
                if (hasWb) {
            %>

            <form action="WashBayController" method="post">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="washBayID" value="<%= wb.getWashBayID() %>">

                <div class="bg-white p-4 rounded-4 shadow-sm border border-light mb-4">
                    <div class="mb-3">
                        <div class="section-title fw-bold text-dark mb-3 d-flex align-items-center">
                            <i class="bi bi-info-circle me-2"></i> Wash Bay Information
                        </div>
                    </div>

                    <div class="row g-4">
                        <div class="col-md-6">
                            <label class="small text-muted fw-semibold mb-2 ms-1">
                                Wash Bay ID
                            </label>
                            <input type="text"
                                   class="form-control form-control-custom shadow-none"
                                   value="#<%= wb.getWashBayID() %>"
                                   readonly>
                        </div>

                        <div class="col-md-6">
                            <label class="small text-muted fw-semibold mb-2 ms-1">Status</label>
                            <select name="status" class="form-select form-control-custom shadow-none" style="cursor: pointer;">
                                <option value="Available" <%= "Available".equalsIgnoreCase(wb.getStatus()) ? "selected" : "" %>>Available</option>
                                <option value="Unavailable" <%= "Unavailable".equalsIgnoreCase(wb.getStatus()) ? "selected" : "" %>>Unavailable</option>
                                <option value="Maintenance" <%= "Maintenance".equalsIgnoreCase(wb.getStatus()) ? "selected" : "" %>>Maintenance</option>
                            </select>
                        </div>

                        <div class="col-12">
                            <label class="small text-muted fw-semibold mb-2 ms-1">
                                Bay Name <span class="text-danger">*</span>
                            </label>
                            <input type="text"
                                   name="bayName"
                                   class="form-control form-control-custom shadow-none"
                                   value="<%= wb.getBayName() == null ? "" : wb.getBayName() %>"
                                   placeholder="e.g. Bay A - Exterior"
                                   required>
                        </div>

                        <div class="col-12">
                            <label class="small text-muted fw-semibold mb-2 ms-1">Description</label>
                            <textarea name="description"
                                      rows="4"
                                      required=""
                                      class="form-control form-control-custom shadow-none"
                                      placeholder="Optional notes about this wash bay (location, equipment, capacity...)"><%= wb.getDescription() == null ? "" : wb.getDescription() %></textarea>
                        </div>
                    </div>
                </div>

                <!-- ACTIONS -->
                <div class="d-flex gap-3">
                    <a href="WashBayController?action=list" class="btn btn-light rounded-pill px-4 py-2 fw-medium text-muted transition-hover">
                        Cancel
                    </a>

                    <button type="submit" class="btn btn-dark rounded-pill px-5 py-2 fw-medium shadow-sm transition-hover">
                        <i class="bi bi-check2-circle me-2"></i>
                        Save Changes
                    </button>

                    <div class="ms-auto small text-muted d-flex align-items-center gap-1">
                        <i class="bi bi-info-circle"></i>
                        <span><strong>Available</strong> = ready to book · <strong>Unavailable</strong> = admin offline · <strong>Maintenance</strong> = under repair. Booked bays show as Unavailable per time slot.</span>
                    </div>
                </div>
            </form>

            <%
                } else {
            %>

            <div class="bg-white p-4 rounded-4 shadow-sm border border-light">
                <div class="text-center text-muted py-5">
                    <i class="bi bi-inbox fs-1 d-block mb-3"></i>
                    <p class="mb-3">Wash bay not found or has been removed.</p>
                    <a href="WashBayController?action=list" class="btn btn-dark rounded-pill px-4 py-2 fw-medium text-decoration-none">
                        Back to Wash Bay List
                    </a>
                </div>
            </div>

            <%
                }
            %>
        </main>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>