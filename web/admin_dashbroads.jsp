<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard | Elite Auto</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    
    <link href="css/style.css" rel="stylesheet">

    <style>
        /* Custom CSS cho layout Admin Sidebar */
        body {
            background-color: var(--bg-card);
            overflow-x: hidden;
        }
        .sidebar {
            width: 260px;
            height: 100vh;
            position: fixed;
            top: 0;
            left: 0;
            z-index: 1000;
            background-color: #ffffff;
            border-right: 1px solid #eaeaea;
        }
        .main-wrapper {
            margin-left: 260px;
            min-height: 100vh;
        }
        
        /* Hiệu ứng chuyển đổi mượt mà cho Menu */
        .nav-link {
            color: #6c757d;
            font-weight: 500;
            padding: 0.8rem 1rem;
            border-radius: 0.5rem;
            transition: all 0.3s ease;
        }
        .nav-link:hover:not(.active) {
            background-color: #f8f9fa;
            color: #000000;
            transform: translateX(5px); /* Hiệu ứng rê chuột đẩy nhẹ sang phải */
        }
        .nav-link.active {
            background-color: #000000;
            color: #ffffff !important;
            border-radius: 0.5rem;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
        }

        .table-custom th {
            font-size: 0.75rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            color: #6c757d;
            border-bottom: 2px solid #eaeaea;
            padding-bottom: 1rem;
        }
        .table-custom td {
            vertical-align: middle;
            padding: 0.8rem 0.5rem; /* Thu nhỏ padding một chút để hiển thị 10 dòng gọn hơn */
            border-bottom: 1px solid #f1f1f1;
        }

        /* Style cho badge trạng thái */
        .badge-soft-warning { background-color: rgba(255, 193, 7, 0.1); color: #d39e00; }
        .badge-soft-success { background-color: rgba(25, 135, 84, 0.1); color: #198754; }
        .badge-soft-danger { background-color: rgba(220, 53, 69, 0.1); color: #dc3545; }
        .badge-soft-info { background-color: rgba(13, 202, 240, 0.1); color: #087990; }
        
        /* Chuyển đổi mượt mà cho nút Pill lọc dữ liệu */
        .nav-pills .nav-link {
            transition: all 0.3s ease;
        }
    </style>
</head>
<body>

    <aside class="sidebar d-flex flex-column p-4">
        <a href="#" class="text-dark text-decoration-none fw-bold fs-4 tracking-tight mb-5 d-flex align-items-center transition-hover">
            <i class="bi bi-vinyl-fill me-2 fs-3"></i>EliteAuto<span class="text-muted ms-1 fs-6 fw-normal">Admin</span>
        </a>

        <p class="text-muted small fw-bold text-uppercase tracking-wider mb-2" style="font-size: 0.7rem;">Main Menu</p>
        <ul class="nav flex-column gap-2 mb-4" id="sidebarMenu">
            <li class="nav-item">
                <a class="nav-link active d-flex align-items-center" href="#"><i class="bi bi-grid-1x2-fill me-3"></i> Action Center</a>
            </li>
            <li class="nav-item">
                <a class="nav-link d-flex align-items-center" href="#"><i class="bi bi-building me-3"></i> Businesses <span class="badge bg-danger rounded-pill ms-auto">5</span></a>
            </li>
            <li class="nav-item">
                <a class="nav-link d-flex align-items-center" href="#"><i class="bi bi-car-front me-3"></i> Vehicles <span class="badge bg-danger rounded-pill ms-auto">12</span></a>
            </li>
            <li class="nav-item">
                <a class="nav-link d-flex align-items-center" href="#"><i class="bi bi-people me-3"></i> Customers</a>
            </li>
        </ul>

        <p class="text-muted small fw-bold text-uppercase tracking-wider mb-2 mt-auto" style="font-size: 0.7rem;">System</p>
        <ul class="nav flex-column gap-2">
            <li class="nav-item">
                <a class="nav-link d-flex align-items-center" href="#"><i class="bi bi-gear me-3"></i> Settings</a>
            </li>
            <li class="nav-item mt-2">
                <a href="MainController?action=logout" class="nav-link d-flex align-items-center text-danger"><i class="bi bi-box-arrow-right me-3"></i> Logout</a>
            </li>
        </ul>
    </aside>

    <main class="main-wrapper p-4 p-lg-5 animate-fade-up">
        
        <div class="d-flex justify-content-between align-items-center mb-5">
            <div class="position-relative" style="width: 300px;">
                <i class="bi bi-search position-absolute top-50 start-0 translate-middle-y ms-3 text-muted"></i>
                <input type="text" class="form-control form-control-lg border-0 shadow-sm rounded-pill bg-white ps-5 small transition-hover" placeholder="Search requests, users...">
            </div>
            
            <div class="d-flex align-items-center gap-3">
                <button class="btn btn-white border-0 shadow-sm rounded-circle d-flex align-items-center justify-content-center position-relative transition-hover" style="width: 45px; height: 45px;">
                    <i class="bi bi-bell fs-5 text-dark"></i>
                    <span class="position-absolute top-0 start-100 translate-middle p-1 bg-danger border border-light rounded-circle"></span>
                </button>
                <div class="d-flex align-items-center gap-2 bg-white p-1 pe-3 rounded-pill shadow-sm border border-light cursor-pointer transition-hover">
                    <img src="https://ui-avatars.com/api/?name=Admin&background=000&color=fff" alt="Admin" class="rounded-circle" width="35" height="35">
                    <span class="small fw-bold text-dark">Super Admin</span>
                </div>
            </div>
        </div>

        <div class="d-flex justify-content-between align-items-end mb-4">
            <div>
                <h2 class="fw-bold tracking-tight mb-1">Action Center</h2>
                <p class="text-muted small mb-0">Manage and approve user requests across the system.</p>
            </div>
            <div class="d-flex gap-2">
                <button class="btn btn-outline-dark rounded-pill px-4 fw-medium small transition-hover"><i class="bi bi-download me-2"></i>Export</button>
            </div>
        </div>

        <div class="row g-4 mb-5">
            <div class="col-md-3 delay-1">
                <div class="bg-white p-4 rounded-4 shadow-sm border border-light h-100 transition-hover">
                    <p class="text-muted small fw-bold text-uppercase tracking-tight mb-2">Pending Businesses</p>
                    <div class="d-flex justify-content-between align-items-end">
                        <h2 class="fw-bold mb-0">05</h2>
                        <span class="badge bg-danger bg-opacity-10 text-danger rounded-pill px-2 py-1"><i class="bi bi-clock-history me-1"></i>Action Req</span>
                    </div>
                </div>
            </div>
            <div class="col-md-3 delay-2">
                <div class="bg-white p-4 rounded-4 shadow-sm border border-light h-100 transition-hover">
                    <p class="text-muted small fw-bold text-uppercase tracking-tight mb-2">Pending Vehicles</p>
                    <div class="d-flex justify-content-between align-items-end">
                        <h2 class="fw-bold mb-0">12</h2>
                        <span class="badge bg-warning bg-opacity-10 text-warning rounded-pill px-2 py-1"><i class="bi bi-clock-history me-1"></i>Action Req</span>
                    </div>
                </div>
            </div>
            <div class="col-md-3 delay-3">
                <div class="bg-white p-4 rounded-4 shadow-sm border border-light h-100 transition-hover">
                    <p class="text-muted small fw-bold text-uppercase tracking-tight mb-2">Service Requests</p>
                    <div class="d-flex justify-content-between align-items-end">
                        <h2 class="fw-bold mb-0">34</h2>
                        <span class="badge bg-info bg-opacity-10 text-info rounded-pill px-2 py-1"><i class="bi bi-arrow-up-right me-1"></i>+12%</span>
                    </div>
                </div>
            </div>
            <div class="col-md-3 delay-4">
                <div class="bg-white p-4 rounded-4 shadow-sm border border-light h-100 transition-hover">
                    <p class="text-muted small fw-bold text-uppercase tracking-tight mb-2">System Users</p>
                    <div class="d-flex justify-content-between align-items-end">
                        <h2 class="fw-bold mb-0">1,204</h2>
                        <span class="badge bg-success bg-opacity-10 text-success rounded-pill px-2 py-1"><i class="bi bi-people me-1"></i>Total</span>
                    </div>
                </div>
            </div>
        </div>

        <div class="bg-white rounded-4 shadow-sm border border-light p-4 transition-hover delay-5">
            
            <div class="d-flex justify-content-between align-items-center mb-4">
                <ul class="nav nav-pills gap-2" id="tableFilter">
                    <li class="nav-item"><a class="nav-link active bg-dark text-white rounded-pill px-4 py-1 small fw-medium" href="#">All Requests</a></li>
                    <li class="nav-item"><a class="nav-link text-dark bg-light rounded-pill px-4 py-1 small fw-medium" href="#">Business</a></li>
                    <li class="nav-item"><a class="nav-link text-dark bg-light rounded-pill px-4 py-1 small fw-medium" href="#">Vehicles</a></li>
                </ul>
                <button class="btn btn-light rounded-pill px-3 py-1 small fw-medium text-dark border transition-hover"><i class="bi bi-filter me-1"></i> Filter</button>
            </div>

            <div class="table-responsive">
                <table class="table table-custom table-borderless table-hover mb-0">
                    <thead>
                        <tr>
                            <th style="width: 50px;">
                                <input class="form-check-input bg-light border-secondary" type="checkbox">
                            </th>
                            <th>Request Detail</th>
                            <th>Requester / User</th>
                            <th>Date Submitted</th>
                            <th>Type</th>
                            <th>Status</th>
                            <th class="text-end">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td><input class="form-check-input border-secondary" type="checkbox"></td>
                            <td>
                                <div class="fw-bold text-dark">TechCorp Solutions Ltd.</div>
                                <div class="small text-muted">Tax: 0312456789</div>
                            </td>
                            <td>
                                <div class="d-flex align-items-center gap-2">
                                    <div class="bg-dark text-white rounded-circle d-flex justify-content-center align-items-center small" style="width: 28px; height: 28px;">JD</div>
                                    <span class="small fw-medium text-dark">John Doe</span>
                                </div>
                            </td>
                            <td class="small text-muted">Oct 24, 2026</td>
                            <td><span class="badge bg-light text-dark border"><i class="bi bi-building me-1"></i> Business</span></td>
                            <td><span class="badge badge-soft-warning rounded-pill px-3 py-2 fw-medium">Pending Review</span></td>
                            <td class="text-end">
                                <button class="btn btn-sm btn-light text-success border rounded-3 me-1 transition-hover" title="Approve"><i class="bi bi-check-lg"></i></button>
                                <button class="btn btn-sm btn-light text-danger border rounded-3 transition-hover" title="Reject"><i class="bi bi-x-lg"></i></button>
                            </td>
                        </tr>

                        <tr>
                            <td><input class="form-check-input border-secondary" type="checkbox"></td>
                            <td>
                                <div class="fw-bold text-dark">Ford Everest (Black)</div>
                                <div class="small text-muted font-monospace">51G-12345</div>
                            </td>
                            <td>
                                <div class="d-flex align-items-center gap-2">
                                    <div class="bg-secondary text-white rounded-circle d-flex justify-content-center align-items-center small" style="width: 28px; height: 28px;">AS</div>
                                    <span class="small fw-medium text-dark">Anna Smith</span>
                                </div>
                            </td>
                            <td class="small text-muted">Oct 24, 2026</td>
                            <td><span class="badge bg-light text-dark border"><i class="bi bi-car-front me-1"></i> Vehicle</span></td>
                            <td><span class="badge badge-soft-warning rounded-pill px-3 py-2 fw-medium">Pending Review</span></td>
                            <td class="text-end">
                                <button class="btn btn-sm btn-light text-success border rounded-3 me-1 transition-hover" title="Approve"><i class="bi bi-check-lg"></i></button>
                                <button class="btn btn-sm btn-light text-danger border rounded-3 transition-hover" title="Reject"><i class="bi bi-x-lg"></i></button>
                            </td>
                        </tr>

                        <tr>
                            <td><input class="form-check-input border-secondary" type="checkbox"></td>
                            <td>
                                <div class="fw-bold text-dark">Honda Civic (White)</div>
                                <div class="small text-muted font-monospace">29A-98765</div>
                            </td>
                            <td>
                                <div class="d-flex align-items-center gap-2">
                                    <div class="bg-info text-white rounded-circle d-flex justify-content-center align-items-center small" style="width: 28px; height: 28px;">MP</div>
                                    <span class="small fw-medium text-dark">Mike Pen</span>
                                </div>
                            </td>
                            <td class="small text-muted">Oct 23, 2026</td>
                            <td><span class="badge bg-light text-dark border"><i class="bi bi-car-front me-1"></i> Vehicle</span></td>
                            <td><span class="badge badge-soft-success rounded-pill px-3 py-2 fw-medium">Approved</span></td>
                            <td class="text-end">
                                <button class="btn btn-sm btn-light text-dark border rounded-3 transition-hover" title="View Details"><i class="bi bi-eye"></i></button>
                            </td>
                        </tr>

                        <tr>
                            <td><input class="form-check-input border-secondary" type="checkbox"></td>
                            <td>
                                <div class="fw-bold text-dark">Elite Motors Auto</div>
                                <div class="small text-muted">Tax: 0102938475</div>
                            </td>
                            <td>
                                <div class="d-flex align-items-center gap-2">
                                    <div class="bg-primary text-white rounded-circle d-flex justify-content-center align-items-center small" style="width: 28px; height: 28px;">DN</div>
                                    <span class="small fw-medium text-dark">David Nguyen</span>
                                </div>
                            </td>
                            <td class="small text-muted">Oct 22, 2026</td>
                            <td><span class="badge bg-light text-dark border"><i class="bi bi-building me-1"></i> Business</span></td>
                            <td><span class="badge badge-soft-success rounded-pill px-3 py-2 fw-medium">Approved</span></td>
                            <td class="text-end">
                                <button class="btn btn-sm btn-light text-dark border rounded-3 transition-hover" title="View Details"><i class="bi bi-eye"></i></button>
                            </td>
                        </tr>

                        <tr>
                            <td><input class="form-check-input border-secondary" type="checkbox"></td>
                            <td>
                                <div class="fw-bold text-dark">VinFast VF8 (Blue)</div>
                                <div class="small text-muted font-monospace">30G-55555</div>
                            </td>
                            <td>
                                <div class="d-flex align-items-center gap-2">
                                    <div class="bg-danger text-white rounded-circle d-flex justify-content-center align-items-center small" style="width: 28px; height: 28px;">TL</div>
                                    <span class="small fw-medium text-dark">Tran Le</span>
                                </div>
                            </td>
                            <td class="small text-muted">Oct 22, 2026</td>
                            <td><span class="badge bg-light text-dark border"><i class="bi bi-car-front me-1"></i> Vehicle</span></td>
                            <td><span class="badge badge-soft-warning rounded-pill px-3 py-2 fw-medium">Pending Review</span></td>
                            <td class="text-end">
                                <button class="btn btn-sm btn-light text-success border rounded-3 me-1 transition-hover" title="Approve"><i class="bi bi-check-lg"></i></button>
                                <button class="btn btn-sm btn-light text-danger border rounded-3 transition-hover" title="Reject"><i class="bi bi-x-lg"></i></button>
                            </td>
                        </tr>

                        <tr>
                            <td><input class="form-check-input border-secondary" type="checkbox"></td>
                            <td>
                                <div class="fw-bold text-dark">CleanWash Inc.</div>
                                <div class="small text-muted">Tax: 0432123456</div>
                            </td>
                            <td>
                                <div class="d-flex align-items-center gap-2">
                                    <div class="bg-dark text-white rounded-circle d-flex justify-content-center align-items-center small" style="width: 28px; height: 28px;">SJ</div>
                                    <span class="small fw-medium text-dark">Sarah Jones</span>
                                </div>
                            </td>
                            <td class="small text-muted">Oct 21, 2026</td>
                            <td><span class="badge bg-light text-dark border"><i class="bi bi-building me-1"></i> Business</span></td>
                            <td><span class="badge badge-soft-danger rounded-pill px-3 py-2 fw-medium">Rejected</span></td>
                            <td class="text-end">
                                <button class="btn btn-sm btn-light text-dark border rounded-3 transition-hover" title="View Details"><i class="bi bi-eye"></i></button>
                            </td>
                        </tr>

                        <tr>
                            <td><input class="form-check-input border-secondary" type="checkbox"></td>
                            <td>
                                <div class="fw-bold text-dark">BMW 320i (Silver)</div>
                                <div class="small text-muted font-monospace">60A-11223</div>
                            </td>
                            <td>
                                <div class="d-flex align-items-center gap-2">
                                    <div class="bg-success text-white rounded-circle d-flex justify-content-center align-items-center small" style="width: 28px; height: 28px;">MK</div>
                                    <span class="small fw-medium text-dark">Minh Khoa</span>
                                </div>
                            </td>
                            <td class="small text-muted">Oct 21, 2026</td>
                            <td><span class="badge bg-light text-dark border"><i class="bi bi-car-front me-1"></i> Vehicle</span></td>
                            <td><span class="badge badge-soft-success rounded-pill px-3 py-2 fw-medium">Approved</span></td>
                            <td class="text-end">
                                <button class="btn btn-sm btn-light text-dark border rounded-3 transition-hover" title="View Details"><i class="bi bi-eye"></i></button>
                            </td>
                        </tr>

                        <tr>
                            <td><input class="form-check-input border-secondary" type="checkbox"></td>
                            <td>
                                <div class="fw-bold text-dark">AutoCare Group</div>
                                <div class="small text-muted">Tax: 0109876543</div>
                            </td>
                            <td>
                                <div class="d-flex align-items-center gap-2">
                                    <div class="bg-warning text-dark rounded-circle d-flex justify-content-center align-items-center small" style="width: 28px; height: 28px;">LT</div>
                                    <span class="small fw-medium text-dark">Le Tuan</span>
                                </div>
                            </td>
                            <td class="small text-muted">Oct 20, 2026</td>
                            <td><span class="badge bg-light text-dark border"><i class="bi bi-building me-1"></i> Business</span></td>
                            <td><span class="badge badge-soft-warning rounded-pill px-3 py-2 fw-medium">Pending Review</span></td>
                            <td class="text-end">
                                <button class="btn btn-sm btn-light text-success border rounded-3 me-1 transition-hover" title="Approve"><i class="bi bi-check-lg"></i></button>
                                <button class="btn btn-sm btn-light text-danger border rounded-3 transition-hover" title="Reject"><i class="bi bi-x-lg"></i></button>
                            </td>
                        </tr>

                        <tr>
                            <td><input class="form-check-input border-secondary" type="checkbox"></td>
                            <td>
                                <div class="fw-bold text-dark">Toyota Camry (Red)</div>
                                <div class="small text-muted font-monospace">43A-67890</div>
                            </td>
                            <td>
                                <div class="d-flex align-items-center gap-2">
                                    <div class="bg-dark text-white rounded-circle d-flex justify-content-center align-items-center small" style="width: 28px; height: 28px;">HQ</div>
                                    <span class="small fw-medium text-dark">Hoang Quan</span>
                                </div>
                            </td>
                            <td class="small text-muted">Oct 20, 2026</td>
                            <td><span class="badge bg-light text-dark border"><i class="bi bi-car-front me-1"></i> Vehicle</span></td>
                            <td><span class="badge badge-soft-warning rounded-pill px-3 py-2 fw-medium">Pending Review</span></td>
                            <td class="text-end">
                                <button class="btn btn-sm btn-light text-success border rounded-3 me-1 transition-hover" title="Approve"><i class="bi bi-check-lg"></i></button>
                                <button class="btn btn-sm btn-light text-danger border rounded-3 transition-hover" title="Reject"><i class="bi bi-x-lg"></i></button>
                            </td>
                        </tr>

                        <tr>
                            <td><input class="form-check-input border-secondary" type="checkbox"></td>
                            <td>
                                <div class="fw-bold text-dark">Mazda CX-5 (White)</div>
                                <div class="small text-muted font-monospace">61A-22334</div>
                            </td>
                            <td>
                                <div class="d-flex align-items-center gap-2">
                                    <div class="bg-secondary text-white rounded-circle d-flex justify-content-center align-items-center small" style="width: 28px; height: 28px;">NB</div>
                                    <span class="small fw-medium text-dark">Ngoc Bich</span>
                                </div>
                            </td>
                            <td class="small text-muted">Oct 19, 2026</td>
                            <td><span class="badge bg-light text-dark border"><i class="bi bi-car-front me-1"></i> Vehicle</span></td>
                            <td><span class="badge badge-soft-success rounded-pill px-3 py-2 fw-medium">Approved</span></td>
                            <td class="text-end">
                                <button class="btn btn-sm btn-light text-dark border rounded-3 transition-hover" title="View Details"><i class="bi bi-eye"></i></button>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
            
            <div class="d-flex justify-content-between align-items-center mt-4 pt-3 border-top">
                <span class="text-muted small">Showing 1 to 10 of 42 entries</span>
                <nav>
                    <ul class="pagination pagination-sm mb-0">
                        <li class="page-item disabled"><a class="page-link text-dark border-0 bg-light rounded-start-pill px-3" href="#">Prev</a></li>
                        <li class="page-item active"><a class="page-link bg-dark border-dark text-white" href="#">1</a></li>
                        <li class="page-item"><a class="page-link text-dark border-0" href="#">2</a></li>
                        <li class="page-item"><a class="page-link text-dark border-0" href="#">3</a></li>
                        <li class="page-item"><a class="page-link text-dark border-0" href="#">...</a></li>
                        <li class="page-item"><a class="page-link text-dark border-0 bg-light rounded-end-pill px-3" href="#">Next</a></li>
                    </ul>
                </nav>
            </div>

        </div>
    </main>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        document.addEventListener("DOMContentLoaded", function() {
            
            // Xử lý hiệu ứng khi click vào Menu bên trái (Sidebar)
            const sidebarLinks = document.querySelectorAll('#sidebarMenu .nav-link');
            sidebarLinks.forEach(link => {
                link.addEventListener('click', function(e) {
                    if(this.getAttribute('href') === '#') e.preventDefault(); // Ngăn trình duyệt load lại trang nếu link là #
                    
                    // Xóa class 'active' khỏi tất cả các menu
                    sidebarLinks.forEach(l => l.classList.remove('active'));
                    
                    // Thêm class 'active' vào menu vừa click
                    this.classList.add('active');
                });
            });

            // Xử lý hiệu ứng khi click vào các nút lọc bảng (All Requests / Business / Vehicles)
            const filterPills = document.querySelectorAll('#tableFilter .nav-link');
            filterPills.forEach(pill => {
                pill.addEventListener('click', function(e) {
                    if(this.getAttribute('href') === '#') e.preventDefault();
                    
                    // Xóa màu đen khỏi tất cả các nút và trả về màu xám nhạt
                    filterPills.forEach(p => {
                        p.classList.remove('active', 'bg-dark', 'text-white');
                        p.classList.add('bg-light', 'text-dark');
                    });
                    
                    // Áp màu đen cho nút vừa click
                    this.classList.remove('bg-light', 'text-dark');
                    this.classList.add('active', 'bg-dark', 'text-white');
                });
            });

        });
    </script>
</body>
</html>