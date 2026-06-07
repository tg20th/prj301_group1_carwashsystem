<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Oops! Something went wrong | Elite Auto</title>
    
    <!-- Bootstrap 5 & Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    
    <!-- CSS dùng chung -->
    <link href="css/style.css" rel="stylesheet">
</head>
<body style="background-color: var(--bg-card);">

    <div class="container min-vh-100 d-flex flex-column justify-content-center align-items-center animate-fade-up">
        
        <!-- Logo -->
        <div class="text-center mb-4">
            <a class="text-dark text-decoration-none fw-bold fs-3 tracking-tight d-inline-block transition-hover">
                <i class="bi bi-vinyl-fill me-2"></i>EliteAuto
            </a>
        </div>

        <!-- Error Card -->
        <div class="bg-white p-4 p-md-5 rounded-4 shadow-sm border border-light text-center transition-hover delay-1" style="max-width: 540px; w-100">
            
            <!-- Animated Icon -->
            <div class="bg-light rounded-circle d-flex align-items-center justify-content-center mx-auto mb-4 float-anim" style="width: 100px; height: 100px;">
                <i class="bi bi-exclamation-triangle-fill text-warning" style="font-size: 3rem;"></i>
            </div>
            
            <%-- Lấy mã lỗi từ server (nếu có) --%>
            <% 
                Integer statusCode = (Integer) request.getAttribute("javax.servlet.error.status_code");
                String errorMessage = "We can't seem to find the page you're looking for.";
                
                if (statusCode != null) {
                    if (statusCode == 500) {
                        errorMessage = "Internal Server Error. Our team is working on fixing it.";
                    } else if (statusCode == 403) {
                        errorMessage = "Access Denied. You do not have permission to view this page.";
                    }
                } else {
                    statusCode = 404; // Mặc định là 404 nếu không có mã lỗi
                }
            %>

            <!-- Error Details -->
            <h1 class="display-3 fw-bold tracking-tight text-dark mb-2"><%= statusCode %></h1>
            <h4 class="fw-bold tracking-tight mb-3">Oops! Something went wrong.</h4>
            <p class="text-muted small mb-5 lh-lg px-md-3">
                <%= errorMessage %>
            </p>
            
            <!-- Action Buttons -->
            <div class="d-flex flex-column flex-sm-row gap-3 justify-content-center">
                <button onclick="history.back()" class="btn btn-outline-dark rounded-pill px-4 py-2 fw-medium transition-hover">
                    <i class="bi bi-arrow-left me-1"></i> Go Back
                </button>
                <a href="MainController?action=home" class="btn btn-black rounded-pill px-4 py-2 fw-medium transition-hover">
                    <i class="bi bi-house-door-fill me-1"></i> Home Page
                </a>
            </div>

        </div>
        
        <div class="text-center mt-5 text-muted small delay-2">
            &copy; 2026 Elite Auto Wash System. All rights reserved.
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>