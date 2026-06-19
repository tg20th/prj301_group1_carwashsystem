<%@page import="java.util.List"%>
<%@page import="dto.Vehicle"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>


<!DOCTYPE html>
<c:if test="account == null">
    <jsp:forward page="MainController?action=home"/>
</c:if>

<%
    List<Vehicle> vehicleList = (List<Vehicle>) request.getAttribute("LIST");
%>

<% if (vehicleList != null && !vehicleList.isEmpty()) { %>

<% for (Vehicle v : vehicleList) {%>

<div class="border rounded-4 p-2 mb-2">

    <div class="row align-items-center">

        <!-- IMAGE -->
        <div class="col-lg-2">
            <img src="<%= v.getImageURL()%>"
                 class="img-fluid rounded shadow-sm"
                 style="width:70px;height:50px;object-fit:cover;">
        </div>

        <!-- INFO -->
        <div class="col-lg-6">

            <h6 class="fw-bold mb-1">
                <%= v.getLicensePlate()%>
            </h6>
            <div class="mb-1">
                <span class="badge bg-dark">
                    <%= v.getBrandName()%>
                </span>
                <span class="badge bg-secondary">
                    <%= v.getModelName()%>
                </span>
            </div>
            <small class="text-muted">
                Color:
                <strong><%= v.getColor()%></strong>
                Year:
                <strong><%= v.getManufactureYear()%></strong>
            </small>
        </div>
        <!-- ACTION -->
        <div class="col-lg-4">
            <div class="d-flex justify-content-end gap-2">
                <form action="ApproveVehicleController"
                      method="post" onsubmit="submitVehicleAction(event, this)">
                    <input type="hidden"
                           name="customerID"
                           value="<%= v.getCustomerID()%>">
                    <input type="hidden"
                           name="vehicleID"
                           value="<%= v.getVehicleID()%>">
                    <button type="submit"
                            class="btn btn-success btn-sm">
                        <i class="bi bi-check-lg"></i>
                        Approve
                    </button>
                </form>
                <form action="RejectVehicleController"
                      method="post" onsubmit="submitVehicleAction(event, this)">
                    <input type="hidden"
                           name="customerID"
                           value="<%= v.getCustomerID()%>">
                    <input type="hidden"
                           name="vehicleID"
                           value="<%= v.getVehicleID()%>">
                    <button type="submit"
                            class="btn btn-outline-danger btn-sm">
                        <i class="bi bi-x-lg"></i>
                        Reject
                    </button>
                </form>
            </div>
        </div>
    </div>
</div>
<% } %>
<% } else { %>

<div class="text-center py-5">
    <i class="bi bi-car-front display-3 text-muted"></i>
    <h5 class="mt-3 text-muted">
        No Pending Vehicles
    </h5>
</div>

<% }%>