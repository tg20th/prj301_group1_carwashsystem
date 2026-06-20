<%@page import="dto.Business"%>
<%@page import="dto.Customer"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<%
    // More robust check: ACCOUNT is set right after login.
    // CUSTOMER is only set after visiting dashboard. We accept either.
    if (session.getAttribute("ACCOUNT") == null && session.getAttribute("CUSTOMER") == null) {
        response.sendRedirect("index.jsp");
        return;
    }
    Business bus = (Business) session.getAttribute("BUS");

    String dashboardURL;

    if (bus != null) {
        dashboardURL = "BusinessDashboardController";
    } else {
        dashboardURL = "CustomerDashBoardController";
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
            <a href="<%=dashboardURL%>" class="d-inline-flex align-items-center bg-white rounded-pill shadow-sm px-4 py-2 text-dark fw-medium text-decoration-none transition-hover border border-light">
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

                        <%-- Success Message --%>
                        <% String success = (String) request.getAttribute("SUCCESS");
                            if (success != null) {%>
                        <div class="alert alert-success border-0 bg-success bg-opacity-10 text-success rounded-3 p-3 small mb-4 d-flex align-items-center alert-dismissible fade show" role="alert">
                            <i class="bi bi-check-circle-fill me-2 fs-5"></i> <%= success%>
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                        <% } %>

                        <%-- Error Message --%>
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

                        <!-- ==================== PHẦN QUÉT CAVET ==================== -->
                        <div class="mb-4 p-3 bg-light rounded-3 border">
                            <div class="d-flex align-items-center mb-2">
                                <i class="bi bi-camera-fill me-2"></i>
                                <span class="small fw-medium">Scan Cavet</span>
                            </div>

                            <div class="d-flex gap-2 mb-3">
                                <input type="file" accept="image/*" id="btnUploadInput" hidden>
                                <label for="btnUploadInput" class="btn btn-outline-dark flex-fill">
                                    <i class="bi bi-upload me-2"></i> Upload image
                                </label>
                                <button type="button" id="btnCamera" class="btn btn-outline-dark flex-fill">
                                    <i class="bi bi-camera-fill me-2"></i> Open camera
                                </button>
                            </div>

                            <input type="file" id="cavetFile" accept="image/*" class="d-none">

                            <!-- Webcam -->
                            <div id="webcamContainer" style="display:none;">
                                <div id="webcamStatus" class="alert alert-info small p-2 mb-2" style="display:none;"></div>
                                <video id="webcamVideo" class="w-100 rounded-3 border bg-dark"
                                       style="max-height:200px; object-fit:cover;" autoplay playsinline></video>
                                <div class="d-flex gap-2 mt-2">
                                    <button type="button" id="btnCapture" class="btn btn-dark btn-sm flex-fill">
                                        <i class="bi bi-camera-fill me-1"></i> Take photo
                                    </button>
                                    <button type="button" id="btnStopWebcam" class="btn btn-outline-secondary btn-sm">
                                        Stop camera
                                    </button>
                                </div>
                            </div>

                            <!-- Preview -->
                            <div id="cavetPreviewWrapper" class="mt-3 text-center" style="display: none;">
                                <img id="cavetPreview" class="img-thumbnail rounded-3 shadow-sm border" style="max-height: 160px;">
                                <div class="mt-2">
                                    <button type="button" id="btnRemoveCavet" class="btn btn-sm btn-outline-danger rounded-pill px-3">
                                        <i class="bi bi-trash me-1"></i> Remove image
                                    </button>
                                </div>
                                <div class="small text-muted mt-1" id="cavetStatus">
                                    Cavet photo is ready!
                                </div>
                            </div>

                            <!-- Nút quét FPT.AI -->
                            <button type="button" id="btnScanFpt" class="btn btn-primary w-100 mt-3" style="display:none;">
                                <i class="bi bi-magic me-2"></i> Scan &amp;
                            </button>
                        </div>
                        <!-- ==================== KẾT THÚC PHẦN OCR ==================== -->

                        <form action="MainController" method="post" enctype="multipart/form-data">
                            <input type="hidden" name="action" value="AddVehicle">

                            <!-- Biển số -->
                            <div class="mb-3">
                                <label class="small text-muted mb-2 fw-medium">License Plate <span class="text-danger">*</span></label>
                                <input type="text" id="licensePlate" name="licensePlate"
                                       class="form-control form-control-lg border-0 bg-light shadow-sm rounded-3 transition-hover text-uppercase"
                                       placeholder="e.g. 63A-12345"
                                       pattern="[0-9]{2}[A-Z]-[0-9]{5}"
                                       title="Format: 63A-12345 (2 digits, 1 letter, hyphen, 5 digits)"
                                       required>
                            </div>

                            <!-- Brand + Model -->
                            <div class="row g-3 mb-3">
                                <div class="col-sm-6">
                                    <label class="small text-muted mb-2 fw-medium">Brand <span class="text-danger">*</span></label>
                                    <select id="brandSelect" name="brandID"
                                            class="form-select form-select-lg border-0 bg-light shadow-sm rounded-3" required>
                                    </select>
                                </div>
                                <div class="col-sm-6">
                                    <label class="small text-muted mb-2 fw-medium">Model <span class="text-danger">*</span></label>
                                    <select id="modelSelect" name="modelID"
                                            class="form-select form-select-lg border-0 bg-light shadow-sm rounded-3" required disabled>
                                    </select>
                                </div>
                            </div>

                            <!-- Năm + Màu -->
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

                            <div class="mb-4">
                                <label class="small text-muted mb-2 fw-medium">
                                    License Plate Photo
                                </label>
                                <input type="file" 
                                       name="image" 
                                       accept="image/*"
                                       class="form-control form-control-lg border-0 bg-light shadow-sm rounded-3"
                                       required
                                       >
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
            // ==================== LOAD BRAND & MODEL ====================
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

                            brandSel.innerHTML = '<option value="">-- Choose brand --</option>';
                            allBrands.forEach(b => {
                                const opt = document.createElement('option');
                                opt.value = b.brandID;
                                opt.textContent = b.brandName;
                                brandSel.appendChild(opt);
                            });

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
                modelSel.innerHTML = '<option value="">Model loading...</option>';

                const filtered = allModels.filter(m => m.brandID == brandID);
                modelSel.innerHTML = '<option value="">-- Choose model --</option>';
                filtered.forEach(m => {
                    const opt = document.createElement('option');
                    opt.value = m.modelID;
                    opt.textContent = m.modelName;
                    modelSel.appendChild(opt);
                });
                modelSel.disabled = false;
            }

            // ==================== WEBCAM + UPLOAD ====================
            let currentStream = null;
            let currentCavetImage = null;

            document.addEventListener('DOMContentLoaded', function () {
                loadVehicleData();

                const previewWrapper = document.getElementById('cavetPreviewWrapper');
                const previewImg = document.getElementById('cavetPreview');
                const statusEl = document.getElementById('cavetStatus');
                const btnRemove = document.getElementById('btnRemoveCavet');
                const webcamContainer = document.getElementById('webcamContainer');
                const webcamVideo = document.getElementById('webcamVideo');
                const webcamStatus = document.getElementById('webcamStatus');
                const btnCamera = document.getElementById('btnCamera');
                const btnCapture = document.getElementById('btnCapture');
                const btnStopWebcam = document.getElementById('btnStopWebcam');
                const btnScanFpt = document.getElementById('btnScanFpt');
                const btnUploadInput = document.getElementById('btnUploadInput');

                // Camera logic
                async function startWebcam() {
                    if (!navigator.mediaDevices || !navigator.mediaDevices.getUserMedia) {
                        showWebcamStatus('Trình duyệt không hỗ trợ camera.', 'danger');
                        return;
                    }
                    webcamContainer.style.display = 'block';

                    try {
                        if (currentStream)
                            currentStream.getTracks().forEach(track => track.stop());

                        showWebcamStatus('Đang khởi động camera...', 'info');
                        currentStream = await navigator.mediaDevices.getUserMedia({
                            video: {facingMode: "environment", width: {ideal: 1280}, height: {ideal: 720}}
                        });
                        webcamVideo.srcObject = currentStream;
                        webcamStatus.style.display = 'none';
                    } catch (err) {
                        console.error(err);
                        showWebcamStatus('Không thể truy cập camera.', 'danger');
                    }
                }

                function stopWebcam() {
                    if (currentStream) {
                        currentStream.getTracks().forEach(track => track.stop());
                        currentStream = null;
                    }
                    webcamVideo.srcObject = null;
                    webcamContainer.style.display = 'none';
                    webcamStatus.style.display = 'none';
                }

                function showWebcamStatus(msg, type) {
                    webcamStatus.textContent = msg;
                    webcamStatus.className = `alert alert-${type} small p-2 mb-2`;
                    webcamStatus.style.display = 'block';
                }

                btnCamera.addEventListener('click', () => {
                    webcamContainer.style.display = 'block';
                    startWebcam();
                });
                btnStopWebcam.addEventListener('click', stopWebcam);

                btnCapture.addEventListener('click', function () {
                    if (!currentStream)
                        return;
                    const canvas = document.createElement('canvas');
                    canvas.width = webcamVideo.videoWidth;
                    canvas.height = webcamVideo.videoHeight;
                    const ctx = canvas.getContext('2d');
                    ctx.drawImage(webcamVideo, 0, 0, canvas.width, canvas.height);

                    const dataUrl = canvas.toDataURL('image/jpeg', 0.92);
                    previewImg.src = dataUrl;
                    previewWrapper.style.display = 'block';

                    canvas.toBlob(blob => {
                        if (blob) {
                            currentCavetImage = new File([blob], "capture.jpg", {type: "image/jpeg"});
                            statusEl.textContent = 'Cavet photo is ready';
                            btnScanFpt.style.display = 'block';
                        }
                    }, 'image/jpeg', 0.92);
                });

                btnUploadInput.addEventListener('change', function () {
                    if (this.files && this.files[0]) {
                        stopWebcam();
                        const reader = new FileReader();
                        reader.onload = function (e) {
                            previewImg.src = e.target.result;
                            previewWrapper.style.display = 'block';
                            currentCavetImage = this.files[0];
                            statusEl.textContent = 'Ảnh đã chọn từ máy.';
                            btnScanFpt.style.display = 'block';
                        }.bind(this);
                        reader.readAsDataURL(this.files[0]);
                    }
                });

                btnRemove.addEventListener('click', function () {
                    previewWrapper.style.display = 'none';
                    previewImg.src = '';
                    currentCavetImage = null;
                    btnUploadInput.value = '';
                    btnScanFpt.style.display = 'none';
                    statusEl.textContent = 'Ảnh đã xóa.';
                });

                btnScanFpt.addEventListener('click', function () {
                    if (currentCavetImage)
                        scanCavetWithFptAI(currentCavetImage);
                });
            });

            // ==================== FPT.AI OCR (ĐÃ CẬP NHẬT) ====================
            async function scanCavetWithFptAI(imageFile) {
                const btnScanFpt = document.getElementById('btnScanFpt');
                const originalContent = btnScanFpt.innerHTML;

                btnScanFpt.disabled = true;
                btnScanFpt.innerHTML = '<span class="spinner-border spinner-border-sm me-2"></span> Đang xử lý...';

                const formData = new FormData();
                formData.append("image", imageFile);

                try {
                    const response = await fetch("https://api.fpt.ai/reader/predict/6a223efa3a713b981ba29564?direct=true", {
                        method: "POST",
                        headers: {"api-key": "7S1NKmodAsU6o8HsVYpc46uS4jJmyz4Z"},
                        body: formData
                    });

                    if (!response.ok) {
                        throw new Error("HTTP error: " + response.status);
                    }

                    const json = await response.json();
                    console.log("FPT.AI Full Response:", json);

                    if (json.errorCode === 0 && json.data && json.data.length > 0) {
                        fillFormFromFptOcr(json);
                    } else {
                        alert("FPT.AI: " + (json.errorMessage || "Không nhận diện được thông tin từ ảnh."));
                    }
                } catch (error) {
                    console.error("FPT.AI Error:", error);
                    alert("Không thể kết nối hoặc xử lý với FPT.AI.");
                } finally {
                    btnScanFpt.disabled = false;
                    btnScanFpt.innerHTML = originalContent;
                }
            }

            function fillFormFromFptOcr(json) {
                console.log("Processing OCR Data...");

                let data = {};
                if (json.data && Array.isArray(json.data) && json.data.length > 0) {
                    data = json.data[0];
                } else if (json.info) {
                    data = json.info;
                } else if (json.fields) {
                    data = json.fields;
                } else {
                    data = json;
                }

                const getValue = (possibleKeys) => {
                    for (let key of possibleKeys) {
                        if (data[key] !== undefined && data[key] !== null && data[key] !== "N/A") {
                            return data[key];
                        }
                        for (let actualKey in data) {
                            if (actualKey.toLowerCase().includes(key.toLowerCase())) {
                                const val = data[actualKey];
                                if (val !== undefined && val !== null && val !== "N/A") {
                                    return val;
                                }
                            }
                        }
                    }
                    return null;
                };

                const plate = getValue(["plate_number", "license_plate"]);
                const brand = getValue(["make", "brand"]);
                const model = getValue(["model"]);
                const year = getValue(["year_manufacture", "year_of_manufacture"]);
                const color = getValue(["vehicle_color", "color"]);

                console.log("Extracted values:", {plate, brand, model, year, color});

                if (plate) {
                    document.getElementById('licensePlate').value =
                            String(plate).toUpperCase().replace(/[^A-Z0-9-]/g, '');
                }
                if (year && year !== "N/A") {
                    document.getElementById('manufactureYear').value = String(year).replace(/\D/g, '');
                }
                if (color && color !== "N/A") {
                    document.getElementById('color').value = String(color);
                }

                // Xử lý Brand + Model
                if (brand && allBrands.length > 0) {
                    const brandLower = String(brand).toLowerCase().trim();

                    const matchedBrand = allBrands.find(b =>
                        b.brandName.toLowerCase() === brandLower ||
                                b.brandName.toLowerCase().includes(brandLower) ||
                                brandLower.includes(b.brandName.toLowerCase())
                    );

                    if (matchedBrand) {
                        const brandSelect = document.getElementById('brandSelect');
                        brandSelect.value = matchedBrand.brandID;

                        filterModelsByBrand(matchedBrand.brandID, document.getElementById('modelSelect'));

                        if (model && model !== "N/A") {
                            setTimeout(() => {
                                const modelLower = String(model).toLowerCase().trim();
                                const modelSelect = document.getElementById('modelSelect');

                                const matchedModel = allModels.find(m =>
                                    m.brandID == matchedBrand.brandID &&
                                            (m.modelName.toLowerCase().includes(modelLower) ||
                                                    modelLower.includes(m.modelName.toLowerCase()))
                                );
                                if (matchedModel) {
                                    modelSelect.value = matchedModel.modelID;
                                }
                            }, 700);
                        }
                    } else {
                        console.log("Không tìm thấy hãng xe khớp:", brand);
                    }
                }

                document.getElementById('cavetStatus').innerHTML =
                        '<span class="text-success fw-bold">✅ Đã tự động điền thông tin từ Cavet!</span>';
            }
        </script>
    </body>
</html>