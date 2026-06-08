<%@page import="dto.Customer"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<%
    Customer cus = (Customer) session.getAttribute("CUSTOMER");
    if (cus == null) {
        response.sendRedirect("index.jsp");
        return;
    }
%>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Add Vehicle | Elite Auto</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
        <link href="css/style.css" rel="stylesheet">
    </head>
    <body style="background-color: var(--bg-card);">

        <div class="position-absolute top-0 start-0 p-4 z-3 animate-fade-up">
            <a href="MainController?action=dashboard" class="d-inline-flex align-items-center bg-white rounded-pill shadow-sm px-4 py-2 text-dark fw-medium text-decoration-none transition-hover border border-light">
                <i class="bi bi-arrow-left me-2"></i> Back to Dashboard
            </a>
        </div>

        <div class="container py-5 min-vh-100 d-flex flex-column justify-content-center animate-fade-up">

            <div class="row justify-content-center w-100 mx-0">
                <div class="col-md-8 col-lg-5">

                    <div class="bg-white p-4 p-sm-5 rounded-4 shadow-sm border border-light transition-hover delay-1">

                        <div class="text-center mb-4 pb-2">
                            <div class="bg-light rounded-circle d-flex align-items-center justify-content-center mx-auto mb-3 float-anim" style="width: 60px; height: 60px;">
                                <i class="bi bi-car-front-fill text-dark fs-3"></i>
                            </div>
                            <h3 class="fw-bold tracking-tight mb-2">Add New Vehicle</h3>
                            <p class="text-muted small mb-0">Register a new vehicle to your fleet.</p>
                        </div>

                        <%                            String success = (String) request.getAttribute("SUCCESS");
                            if (success != null) {
                        %>
                        <div class="alert alert-success border-0 bg-success bg-opacity-10 text-success rounded-3 p-3 small mb-4 d-flex align-items-center alert-dismissible fade show" role="alert">
                            <i class="bi bi-check-circle-fill me-2 fs-5"></i> <%= success%>
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                        <% } %>

                        <%
                            String errorMsg = (String) request.getAttribute("ERROR");
                            if (errorMsg == null) {
                                errorMsg = (String) request.getAttribute("error");
                            }
                            if (errorMsg != null) {
                        %>
                        <div class="alert alert-danger border-0 bg-danger bg-opacity-10 text-danger rounded-3 p-3 small mb-4 d-flex align-items-center alert-dismissible fade show" role="alert">
                            <i class="bi bi-exclamation-circle-fill me-2 fs-5"></i> <%= errorMsg%>
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                        <% }%>

                        <!-- ==================== PHẦN QUÉT CAVET OCR (UI trước, kết nối FPT.AI sau) ==================== -->
                        <div class="mb-4 p-3 bg-light rounded-3 border">
                            <div class="d-flex align-items-center mb-2">
                                <i class="bi bi-camera-fill me-2"></i>
                                <span class="small fw-medium">Quét thông tin từ Cavet xe</span>
                            </div>
                            <p class="text-muted small mb-2">Chọn ảnh Cavet để tự động điền biển số, hãng, mẫu, năm sản xuất...</p>

                            <button type="button" id="btnScanCavet"
                                    class="btn btn-outline-dark btn-sm w-100 rounded-pill py-2 fw-medium">
                                <i class="bi bi-camera me-1"></i> Quét Cavet bằng OCR (FPT.AI)
                            </button>

                            <!-- Input file ẩn -->
                            <input type="file" id="cavetFile" accept="image/*" class="d-none">

                            <!-- Khu vực xem trước ảnh Cavet -->
                            <div id="cavetPreviewWrapper" class="mt-3 text-center" style="display: none;">
                                <img id="cavetPreview" class="img-thumbnail rounded-3 shadow-sm" style="max-height: 160px;">
                                <div class="small text-muted mt-1" id="cavetStatus">
                                    Ảnh đã chọn. (Chức năng quét sẽ kết nối sau)
                                </div>
                            </div>
                        </div>
                        <!-- ==================== KẾT THÚC PHẦN OCR ==================== -->

                        <form action="MainController" method="post">
                            <input type="hidden" name="action" value="AddVehicle">

                            <!-- Biển số -->
                            <div class="mb-3">
                                <label class="small text-muted mb-2 fw-medium">License Plate <span class="text-danger">*</span></label>
                                <input type="text" id="licensePlate" name="licensePlate"
                                       class="form-control form-control-lg border-0 bg-light shadow-sm rounded-3 transition-hover text-uppercase"
                                       placeholder="e.g. 63A-12345" required>
                            </div>

                            <!-- Brand + Model (SELECT từ database, không cho nhập tay) -->
                            <div class="row g-3 mb-3">
                                <div class="col-sm-6">
                                    <label class="small text-muted mb-2 fw-medium">Brand <span class="text-danger">*</span></label>
                                    <select id="brandSelect" name="brandID"
                                            class="form-select form-select-lg border-0 bg-light shadow-sm rounded-3" required>
                                        <option value="">-- Đang tải hãng xe --</option>
                                    </select>
                                </div>

                                <div class="col-sm-6">
                                    <label class="small text-muted mb-2 fw-medium">Model <span class="text-danger">*</span></label>
                                    <select id="modelSelect" name="modelID"
                                            class="form-select form-select-lg border-0 bg-light shadow-sm rounded-3" required disabled>
                                        <option value="">-- Chọn hãng xe trước --</option>
                                    </select>
                                </div>
                            </div>

                            <!-- Năm sản xuất + Màu -->
                            <div class="row g-3 mb-4">
                                <div class="col-sm-6">
                                    <label class="small text-muted mb-2 fw-medium">Manufacture Year</label>
                                    <input type="number" id="manufactureYear" name="manufactureYear"
                                           class="form-control form-control-lg border-0 bg-light shadow-sm rounded-3"
                                           placeholder="2023" min="1950" max="2035">
                                </div>
                                <div class="col-sm-6">
                                    <label class="small text-muted mb-2 fw-medium">Color <span class="text-danger">*</span></label>
                                    <input type="text" id="color" name="color"
                                           class="form-control form-control-lg border-0 bg-light shadow-sm rounded-3 transition-hover"
                                           list="colorList" placeholder="White / Black / Silver..." required>
                                    <datalist id="colorList">
                                        <option value="White"><option value="Black"><option value="Silver">
                                        <option value="Red"><option value="Blue"><option value="Gray">
                                        <option value="Green"><option value="Yellow"><option value="Brown">
                                    </datalist>
                                </div>
                            </div>

                            <button type="submit" class="btn btn-black w-100 rounded-pill py-3 fw-medium transition-hover">
                                <i class="bi bi-plus-lg me-1"></i> Save Vehicle
                            </button>
                        </form>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

        <script>
            // ==================== LOAD BRAND + MODEL QUA AJAX (KHÔNG LẤY TỪ REQUEST) ====================
            let allBrands = [];
            let allModels = [];

            function loadVehicleData() {
                const brandSel = document.getElementById('brandSelect');
                const modelSel = document.getElementById('modelSelect');

                fetch('MainController?action=getVehicleData')
                    .then(res => res.json())
                    .then(data => {
                        allBrands = data.brands || [];
                        allModels = data.models || [];

                        // Đổ Brand vào select
                        brandSel.innerHTML = '<option value="">-- Chọn hãng xe --</option>';
                        allBrands.forEach(b => {
                            const opt = document.createElement('option');
                            opt.value = b.brandID;
                            opt.textContent = b.brandName;
                            brandSel.appendChild(opt);
                        });

                        // Khi chọn Brand thì lọc Model từ dữ liệu JS đã có (không cần request hay AJAX thêm)
                        brandSel.addEventListener('change', function () {
                            filterModelsByBrand(this.value, modelSel);
                        });
                    })
                    .catch(err => {
                        console.error(err);
                        brandSel.innerHTML = '<option value="">Lỗi tải dữ liệu hãng xe</option>';
                    });
            }

            function filterModelsByBrand(brandID, modelSel) {
                modelSel.disabled = true;
                modelSel.innerHTML = '<option value="">Đang tải mẫu xe...</option>';

                const filtered = allModels.filter(m => m.brandID == brandID);

                modelSel.innerHTML = '<option value="">-- Chọn mẫu xe --</option>';
                filtered.forEach(m => {
                    const opt = document.createElement('option');
                    opt.value = m.modelID;
                    opt.textContent = m.modelName;
                    modelSel.appendChild(opt);
                });
                modelSel.disabled = false;
            }

            // ==================== XỬ LÝ NÚT QUÉT CAVET + PREVIEW ẢNH ====================
            document.addEventListener('DOMContentLoaded', function () {
                loadVehicleData();   // Tự động load brand + model khi trang sẵn sàng

                const btnScan = document.getElementById('btnScanCavet');
                const cavetFile = document.getElementById('cavetFile');
                const previewWrapper = document.getElementById('cavetPreviewWrapper');
                const previewImg = document.getElementById('cavetPreview');
                const statusEl = document.getElementById('cavetStatus');

                if (btnScan && cavetFile) {
                    btnScan.addEventListener('click', () => cavetFile.click());

                    cavetFile.addEventListener('change', function () {
                        if (this.files && this.files[0]) {
                            const reader = new FileReader();
                            reader.onload = function (e) {
                                previewImg.src = e.target.result;
                                previewWrapper.style.display = 'block';
                                if (statusEl) {
                                    statusEl.textContent = 'Ảnh Cavet đã chọn. (Kết nối FPT.AI OCR sau để tự động điền form)';
                                }
                            };
                            reader.readAsDataURL(this.files[0]);

                            // TODO: Sau này gọi FPT.AI tại đây, ví dụ:
                            // scanCavetWithFptAI(this.files[0]);
                        }
                    });
                }
            });
        </script>
    </body>
</html>