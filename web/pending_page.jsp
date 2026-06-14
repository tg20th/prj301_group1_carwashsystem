<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Account Status | Elite Auto</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="css/style.css" rel="stylesheet">
</head>
<body style="background-color: var(--bg-card);">
    <div class="container min-vh-100 d-flex flex-column justify-content-center align-items-center animate-fade-up">
        <div class="bg-white p-5 rounded-4 shadow-sm border border-light text-center" style="max-width: 520px; width: 100%;">
            <div class="mb-4">
                <i class="bi bi-hourglass-split text-warning" style="font-size: 3rem;"></i>
            </div>
            <h3 class="fw-bold tracking-tight mb-3">Account Under Review</h3>
            <p class="text-muted mb-4">
                Your business registration is currently <strong>Pending</strong> or has been <strong>Rejected</strong>.<br>
                Please contact support or wait for admin approval.
            </p>
            <div class="d-flex flex-column flex-sm-row gap-3 justify-content-center">
                <a href="MainController?action=home" class="btn btn-outline-dark rounded-pill px-4 py-2 fw-medium transition-hover">
                    <i class="bi bi-house-door me-1"></i> Back to Home
                </a>
                <a href="mailto:support@eliteauto.vn" class="btn btn-black rounded-pill px-4 py-2 fw-medium transition-hover">
                    <i class="bi bi-envelope me-1"></i> Contact Support
                </a>
            </div>
        </div>
        <div class="text-center mt-4 text-muted small">
            &copy; 2026 Elite Auto Wash System
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
