<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="dto.WashBay"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Wash Bay Management | Elite Auto</title>

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

            <div class="d-flex justify-content-between align-items-end mb-4 pb-2">
                <div>
                    <h2 class="fw-bold tracking-tight mb-1 text-dark">Wash Bay Management</h2>
                    <p class="text-muted small mb-0">
                        View and manage all wash bays, names, descriptions and  status
                    </p>
                </div>
            </div>

            <%
                String error = (String) request.getAttribute("ERROR");
                if (error != null) {
            %>
            <div class="alert alert-danger border-0 bg-danger bg-opacity-10 text-danger rounded-4 p-3 small mb-4 d-flex align-items-center justify-content-between auto-dismiss-alert">
                <div class="d-flex align-items-center">
                    <i class="bi bi-exclamation-circle-fill me-2"></i><%= error%>
                </div>
                <button type="button" class="btn-close shadow-none small" onclick="dismissAlertElement(this)"></button>
            </div>
            <%
                }
            %>

            <div class="bg-white p-4 rounded-4 shadow-sm border border-light">
                <div class="d-flex justify-content-between align-items-center mb-3 px-1">
                    <h6 class="fw-bold m-0 text-dark">All Wash Bays</h6>

                    <%
                        List<WashBay> wbList = (List<WashBay>) request.getAttribute("WB_LIST");
                        int count = (wbList != null) ? wbList.size() : 0;
                    %>
                    <span class="badge bg-primary bg-opacity-10 text-primary border border-primary border-opacity-25 rounded-pill px-3 py-1 small">
                        <%= count%> wash bays
                    </span>
                </div>

                <div class="table-responsive">
                    <table class="table table-custom table-borderless table-hover mb-0 align-middle">
                        <thead>
                            <tr class="border-bottom border-light">
                                <th class="text-muted small fw-bold text-uppercase ps-3" style="width: 60px;">ID</th>
                                <th class="text-muted small fw-bold text-uppercase">Bay Name</th>
                                <th class="text-muted small fw-bold text-uppercase">Description</th>
                                <th class="text-muted small fw-bold text-uppercase text-center" style="width: 110px;">Status</th>
                                <th class="text-muted small fw-bold text-uppercase text-end rounded-end pe-3" style="width: 100px;">Action</th>
                            </tr>
                        </thead>

                        <tbody>
                            <%
                                if (wbList != null && !wbList.isEmpty()) {
                                    for (WashBay wb : wbList) {
                            %>
                            <tr class="border-bottom border-light">
                                <td class="text-muted small fw-medium ps-3">
                                    #<%= wb.getWashBayID()%>
                                </td>

                                <td class="fw-bold text-dark">
                                    <i class="bi bi-droplet me-2 text-primary"></i><%= wb.getBayName() != null ? wb.getBayName() : ""%>
                                </td>

                                <td class="text-muted small text-truncate" style="max-width: 520px;" title="<%= wb.getDescription() != null ? wb.getDescription() : ""%>">
                                    <%= (wb.getDescription() == null || wb.getDescription().isEmpty()) ? "No description" : wb.getDescription()%>
                                </td>

                                <td class="text-center">
                                    <%

                                        if (wb.isUnavailable()) {
                                    %>
                                    <span class="badge bg-danger bg-opacity-10 text-danger border-danger border border-opacity-25 px-3 py-1"
                                          style="font-size: 0.7rem;">
                                        Unavailable
                                    </span>
                                    <%
                                    } else if (wb.isAvailable()) {
                                    %>
                                    <span class="badge bg-success bg-opacity-10 text-success border-success border border-opacity-25 px-3 py-1"
                                          style="font-size: 0.7rem;">
                                        Available
                                    </span>
                                    <%
                                    } else if (wb.isMaintenance()) {
                                    %>
                                    <span class="badge bg-warning bg-opacity-10 text-warning border-warning border border-opacity-75 px-3 py-1"
                                          style="font-size: 0.7rem;">
                                        Maintenance
                                    </span>
                                    <%
                                        }
                                    %>
                                </td>

                                <td class="text-end pe-3">
                                    <a href="WashBayController?action=showEditDashboard&washBayID=<%= wb.getWashBayID()%>"
                                       class="btn btn-sm bg-warning bg-opacity-10 text-warning border-0 rounded-circle transition-hover"
                                       style="width: 34px; height: 34px; display: inline-flex; align-items: center; justify-content: center;"
                                       title="Edit wash bay">
                                        <i class="bi bi-pencil-fill" style="font-size: 0.85rem;"></i>
                                    </a>
                                </td>
                            </tr>
                            <%
                                }
                            } else {
                            %>
                            <tr>
                                <td colspan="5" class="text-center text-muted py-5">
                                    <i class="bi bi-inbox fs-4 d-block mb-2"></i>
                                    No wash bays found.
                                </td>
                            </tr>
                            <%
                                }
                            %>
                        </tbody>
                    </table>
                </div>

                <div class="mt-3 px-1">
                    <small class="text-muted">
                        Use the edit action to update bay name, description .
                    </small>
                </div>
            </div>
        </main>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script>
                        function dismissAlertElement(el) {
                            if (!el)
                                return;
                            const alert = el.closest('.auto-dismiss-alert') || el.parentElement;
                            if (!alert)
                                return;
                            alert.style.transition = "opacity 0.35s ease-out, transform 0.35s ease-out";
                            alert.style.opacity = "0";
                            alert.style.transform = "translateY(-6px)";
                            setTimeout(function () {
                                alert.style.display = "none";
                            }, 350);
                        }

                        document.addEventListener("DOMContentLoaded", function () {
                            setTimeout(function () {
                                document.querySelectorAll('.auto-dismiss-alert').forEach(function (alert) {
                                    const btn = alert.querySelector('.btn-close');
                                    if (btn)
                                        btn.click();
                                });
                            }, 4500);
                        });
        </script>
    </body>
</html>