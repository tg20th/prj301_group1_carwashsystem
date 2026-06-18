
<%@ page pageEncoding="UTF-8" %>

<div class="bg-white rounded-4 shadow-sm border border-light p-3 mb-4">

    <div class="d-flex justify-content-end">

        <div class="btn-group">

            <a href="VehicleRequestController"
               id="vehicleRequestBtn"
               class="btn btn-outline-dark">

                <i class="bi bi-car-front-fill me-2"></i>
                Customer Vehicle Requests

            </a>

            <a href="VehicleRequestBusController"
               id="businessVehicleBtn"
               class="btn btn-outline-dark">

                <i class="bi bi-building-fill me-2"></i>
                Business Vehicle Requests

            </a>

        </div>

    </div>

</div>

<script>

    document.addEventListener("DOMContentLoaded", function () {

        const url = window.location.href;

        if (url.includes("VehicleRequestController")) {

            document.getElementById("vehicleRequestBtn")
                    .classList.remove("btn-outline-dark");

            document.getElementById("vehicleRequestBtn")
                    .classList.add("btn-dark");
        }

        if (url.includes("BusinessVehicleRequestController")) {

            document.getElementById("businessVehicleBtn")
                    .classList.remove("btn-outline-dark");

            document.getElementById("businessVehicleBtn")
                    .classList.add("btn-dark");
        }

    });

</script>
