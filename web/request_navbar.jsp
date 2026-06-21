<%@ page pageEncoding="UTF-8" %>

<style>
    /* Thiết kế thanh Tab dạng Pill Toggle (Giống iOS/SaaS) */
    .request-tabs {
        background-color: #ffffff;
        border-radius: 50rem;
        padding: 4px; /* Khoảng cách nhỏ bên trong */
        border: 1px solid #e2e8f0;
        display: inline-flex;
    }
    .request-tab-btn {
        border-radius: 50rem !important; /* Ép bo tròn hoàn toàn */
        padding: 0.5rem 1.25rem;
        font-weight: 600;
        font-size: 0.9rem;
        color: #64748b; /* Màu chữ xám khi chưa chọn */
        border: none;
        transition: all 0.3s ease;
    }
    .request-tab-btn:hover {
        color: #0f172a;
        background-color: #f8fafc;
    }
    
    /* Trạng thái khi được chọn (Active) */
    .request-tab-btn.active-tab {
        background-color: #0f172a; /* Nền đen */
        color: #ffffff !important; /* Chữ trắng */
        box-shadow: 0 4px 6px -1px rgba(15, 23, 42, 0.2);
    }
</style>

<!-- Đã gỡ bỏ thẻ div trắng bự chảng bọc bên ngoài -->
<div class="d-flex justify-content-md-end">
    <div class="request-tabs shadow-sm">
        
        <a href="MainController?action=vehicle_request" id="vehicleRequestBtn" class="btn request-tab-btn">
            <i class="bi bi-car-front-fill me-2"></i>Customer Vehicle Requests
        </a>
        
        <a href="MainController?action=vehicle_bus_request" id="businessVehicleBtn" class="btn request-tab-btn">
            <i class="bi bi-building-fill me-2"></i>Business Vehicle Requests
        </a>
        
    </div>
</div>

<script>
    document.addEventListener("DOMContentLoaded", function () {
        const url = window.location.href;
        
        const cusBtn = document.getElementById("vehicleRequestBtn");
        const busBtn = document.getElementById("businessVehicleBtn");

        // Đã sửa lỗi: Javascript cũ check sai tên Controller
        if (url.includes("VehicleRequestBusController")) {
            // Nếu URL chứa BusController -> Kích hoạt nút Business
            busBtn.classList.add("active-tab");
        } else if (url.includes("VehicleRequestController")) {
            // Nếu URL chứa Controller thường -> Kích hoạt nút Customer
            cusBtn.classList.add("active-tab");
        }
    });
</script>