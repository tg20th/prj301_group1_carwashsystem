<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Elite Auto | Smart Car Wash System</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
        <link href="css/style.css" rel="stylesheet">
    </head>
    <body>

        <!-- Navbar -->
        <nav class="navbar navbar-expand-lg py-4 bg-white sticky-top shadow-sm animate-fade-up">
            <div class="container">
                <a class="navbar-brand fw-bold fs-4" href="#">
                    <i class="bi bi-vinyl-fill me-2"></i>EliteAuto
                </a>
                <button class="navbar-toggler border-0" type="button" data-bs-toggle="collapse" data-bs-target="#mainNav">
                    <i class="bi bi-list fs-2"></i>
                </button>
                <div class="collapse navbar-collapse justify-content-center" id="mainNav">
                    <ul class="navbar-nav mb-2 mb-lg-0 gap-3">
                        <li class="nav-item"><a class="nav-link text-dark transition-hover" href="#">Home</a></li>
                        <li class="nav-item"><a class="nav-link text-dark transition-hover" href="#advantages">Advantages</a></li>
                        <li class="nav-item"><a class="nav-link text-dark transition-hover" href="#process">Process</a></li>
                        <li class="nav-item"><a class="nav-link text-dark transition-hover" href="#functions">Functions</a></li>
                        <li class="nav-item"><a class="nav-link text-dark transition-hover" href="#bays">Offers</a></li>
                    </ul>
                </div>
                <div class="d-none d-lg-flex align-items-center gap-4">
                    <a href="javascript:void(0)" onclick="document.getElementById('login-section').scrollIntoView({behavior: 'smooth'});" class="text-dark fw-medium text-decoration-none small transition-hover">Sign In</a>
                    <a href="MainController?action=register_page" class="btn btn-black rounded-pill px-4 py-2 fw-medium small">Sign Up</a>
                </div>
            </div>
        </nav>

        <!-- Hero Section -->
        <section id="login-section" class="hero-section py-5">
            <div class="hero-bg-image"></div>
            <div class="container hero-content py-4">
                <div class="row align-items-center justify-content-between">

                    <div class="col-lg-6 mb-5 mb-lg-0 pe-lg-5 animate-fade-up delay-1 text-white">
                        <div class="d-inline-flex align-items-center gap-2 px-3 py-2 rounded-pill mb-4 border border-secondary" style="background-color: rgba(255,255,255,0.1); backdrop-filter: blur(10px);">
                            <span class="badge bg-light text-dark rounded-pill float-anim">Smart</span>
                            <span class="small fw-medium">Next-Gen Booking System</span>
                        </div>
                        <h1 class="display-4 fw-bold lh-sm mb-4 tracking-tight text-white">
                            Wash Intelligently,<br>Drive Proudly
                        </h1>
                        <p class="fs-5 mb-4 opacity-75" style="line-height: 1.6; max-width: 90%;">
                            Manage your vehicle's care from your phone. Book automated wash slots, claim exclusive membership offers, and track your wash history seamlessly.
                        </p>
                    </div>

                    <div class="col-lg-5 animate-fade-up delay-2 z-3">
                        <div class="mockup-card p-4 p-md-5 transition-hover shadow-lg bg-white border-0">
                            <div class="floating-stat-card position-absolute bg-white rounded-pill px-3 py-2 shadow float-anim d-none d-sm-flex align-items-center gap-2" style="top: 20px; right: 20px;">
                                <div class="bg-success rounded-circle" style="width: 8px; height: 8px;"></div>
                                <span class="small fw-bold text-dark">System Online</span>
                            </div>

                            <div class="mb-4">
                                <h4 class="fw-bold mb-1">Member Login</h4>
                                <p class="text-muted small">Sign in to book a bay and view active offers.</p>
                            </div>

                            <% String error = (String) request.getAttribute("error");
                            if (error != null) {%>
                            <div class="alert alert-danger rounded-3 p-2 small"><%= error%></div>
                            <% }%>

                            <form action="MainController" method="post">
                                <input type="hidden" name="action" value="login">
                                <div class="mb-3">
                                    <label class="small text-muted mb-2 fw-medium">Email Address</label>
                                    <input type="email" name="email" class="form-control form-control-lg border-0 bg-light shadow-sm rounded-4 transition-hover" placeholder="name@example.com" value="<%= request.getAttribute("email") != null ? request.getAttribute("email") : ""%>" required>
                                </div>
                                <div class="mb-4">
                                    <label class="small text-muted mb-2 fw-medium">Password</label>
                                    <input type="password" name="password" class="form-control form-control-lg border-0 bg-light shadow-sm rounded-4 transition-hover" placeholder="••••••••" required>
                                </div>

                                <button type="submit" class="btn btn-black w-100 rounded-pill py-3 fw-medium mb-4 fs-6">Sign In</button>

                                <div class="text-center">
                                    <span class="text-muted small">Don't have an account? </span>
                                    <a href="MainController?action=register_page" class="text-dark fw-bold text-decoration-none small transition-hover">Sign up now</a>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- Advantages Section -->
        <section id="advantages" class="py-5 mt-4 bg-white">
            <div class="container">
                <div class="text-center mb-5 max-w-75 mx-auto animate-fade-up">
                    <h2 class="display-6 fw-bold mb-3 tracking-tight">Why Choose Automated Care?</h2>
                    <p class="text-muted">We eliminate human error and mechanical friction, delivering perfect results every single time.</p>
                </div>

                <div class="row g-4 mt-2">
                    <div class="col-md-3 animate-fade-up delay-1">
                        <div class="mockup-card p-4 h-100 transition-hover">
                            <i class="bi bi-shield-check fs-2 text-dark mb-3 d-block"></i>
                            <h6 class="fw-bold mb-2">100% Touchless</h6>
                            <p class="text-muted small mb-0">No brushes mean zero micro-scratches or swirl marks on your clear coat.</p>
                        </div>
                    </div>
                    <div class="col-md-3 animate-fade-up delay-2">
                        <div class="mockup-card p-4 h-100 transition-hover">
                            <i class="bi bi-clock-history fs-2 text-dark mb-3 d-block"></i>
                            <h6 class="fw-bold mb-2">Ultra-Fast Cycles</h6>
                            <p class="text-muted small mb-0">Complete premium wash cycles in under 3 minutes. No more waiting in lines.</p>
                        </div>
                    </div>
                    <div class="col-md-3 animate-fade-up delay-3">
                        <div class="mockup-card p-4 h-100 transition-hover">
                            <i class="bi bi-droplet fs-2 text-dark mb-3 d-block"></i>
                            <h6 class="fw-bold mb-2">Eco-Friendly</h6>
                            <p class="text-muted small mb-0">Integrated filtration systems capture toxic oils and recycle up to 85% of water.</p>
                        </div>
                    </div>
                    <div class="col-md-3 animate-fade-up delay-4">
                        <div class="mockup-card p-4 h-100 transition-hover">
                            <i class="bi bi-phone-vibrate fs-2 text-dark mb-3 d-block"></i>
                            <h6 class="fw-bold mb-2">Smart Booking</h6>
                            <p class="text-muted small mb-0">Reserve a bay instantly from your phone and skip the payment kiosk entirely.</p>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- Section (Wash Process) -->
        <section id="process" class="py-5 bg-light">
            <div class="container py-4">
                <div class="text-center mb-5 animate-fade-up">
                    <h2 class="display-6 fw-bold mb-3 tracking-tight">The 4-Stage Wash Process</h2>
                    <p class="text-muted">A mathematically calibrated sequence for maximum cleanliness.</p>
                </div>

                <div class="row g-4">
                    <div class="col-md-6 col-lg-3 animate-fade-up delay-1">
                        <div class="bg-white p-4 rounded-4 shadow-sm h-100 border border-light transition-hover text-center text-md-start">
                            <h1 class="display-4 fw-bold text-muted opacity-25 mb-3">01</h1>
                            <h6 class="fw-bold mb-2">Underchassis Blast</h6>
                            <p class="small text-muted mb-0">150 bar high-pressure jets remove magnetic soil from frame and wheels.</p>
                        </div>
                    </div>
                    <div class="col-md-6 col-lg-3 animate-fade-up delay-2">
                        <div class="bg-white p-4 rounded-4 shadow-sm h-100 border border-light transition-hover text-center text-md-start">
                            <h1 class="display-4 fw-bold text-muted opacity-25 mb-3">02</h1>
                            <h6 class="fw-bold mb-2">Active Snow Foam</h6>
                            <p class="small text-muted mb-0">Alkaline emulsion completely covers body, chemically stripping grimy carbon dust.</p>
                        </div>
                    </div>
                    <div class="col-md-6 col-lg-3 animate-fade-up delay-3">
                        <div class="bg-white p-4 rounded-4 shadow-sm h-100 border border-light transition-hover text-center text-md-start">
                            <h1 class="display-4 fw-bold text-muted opacity-25 mb-3">03</h1>
                            <h6 class="fw-bold mb-2">3D Contour Rinse</h6>
                            <p class="small text-muted mb-0">Intelligent laser tracking guides robotic spray columns around the vehicle silhouette.</p>
                        </div>
                    </div>
                    <div class="col-md-6 col-lg-3 animate-fade-up delay-4">
                        <div class="bg-white p-4 rounded-4 shadow-sm h-100 border border-light transition-hover text-center text-md-start">
                            <h1 class="display-4 fw-bold text-muted opacity-25 mb-3">04</h1>
                            <h6 class="fw-bold mb-2">Polymer Wax & Dry</h6>
                            <p class="small text-muted mb-0">Applies a micro-thin wax shield followed by 4-motor aerodynamic turbine drying.</p>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- (Advanced Functions) -->
        <section id="functions" class="py-5 bg-white my-4">
            <div class="container py-4">
                <div class="row align-items-center justify-content-between">
                    <div class="col-lg-5 mb-5 mb-lg-0 animate-fade-up delay-1">
                        <h2 class="display-6 fw-bold mb-4 tracking-tight">Advanced Washing<br>Functions</h2>
                        <p class="text-muted mb-4" style="line-height: 1.7;">
                            Our automated bays execute a highly calibrated sequence. Every function is designed to protect your vehicle while delivering absolute cleanliness without physical contact.
                        </p>
                        <a href="MainController?action=register_page" class="btn btn-outline-dark rounded-pill px-4 py-3 mt-2 fw-medium transition-hover">Create Account to Book</a>
                    </div>

                    <div class="col-lg-6 animate-fade-up delay-2">
                        <div class="mockup-card p-4 p-md-5 shadow-sm bg-light">
                            <div class="mb-4 pb-4 border-bottom border-secondary border-opacity-10">
                                <h5 class="fw-bold fs-6 mb-2"><i class="bi bi-crosshair text-dark me-2"></i> Laser Precision Calibration</h5>
                                <p class="text-muted small mb-0 lh-lg">The bay automatically detects if you drive a Sedan, SUV, or Truck, adjusting the robotic arm distance for optimal pressure.</p>
                            </div>

                            <div class="mb-4 pb-4 border-bottom border-secondary border-opacity-10">
                                <h5 class="fw-bold fs-6 mb-2"><i class="bi bi-stars text-dark me-2"></i> Chemical Breakdown Technology</h5>
                                <p class="text-muted small mb-0 lh-lg">We don't use friction to scrub dirt. Our specialized active foam dissolves mud and grease on a molecular level.</p>
                            </div>

                            <div>
                                <h5 class="fw-bold fs-6 mb-2"><i class="bi bi-wind text-dark me-2"></i> Aerodynamic Drying</h5>
                                <p class="text-muted small mb-0 lh-lg">Four high-speed turbines shear off 98% of standing water in seconds, completely preventing hard water spots on glass and paint.</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- Bays & Offers Section -->
        <section id="bays" class="py-5 bg-light border-top">
            <div class="container py-4">
                <div class="text-center mb-5 animate-fade-up">
                    <span class="badge bg-dark rounded-pill px-3 py-2 mb-3">Membership Offers</span>
                    <h2 class="display-6 fw-bold mb-3 tracking-tight">Choose Your Wash Bay</h2>
                    <p class="text-muted">Flexible pricing tiers tailored to your vehicle's needs.</p>
                </div>

                <div class="row g-4 justify-content-center">
                    <div class="col-lg-4 col-md-6 animate-fade-up delay-1">
                        <div class="bay-card p-5 h-100">
                            <h5 class="fw-bold mb-1">Standard Bay</h5>
                            <p class="text-muted small mb-4">Quick & Essential Wash</p>
                            <h2 class="fw-bold mb-4">$8.00 <span class="fs-6 text-muted fw-normal">/ wash</span></h2>

                            <ul class="list-unstyled mb-5 small">
                                <li class="mb-3 d-flex"><i class="bi bi-check-circle-fill text-dark me-3"></i> <span>High-Pressure Rinse</span></li>
                                <li class="mb-3 d-flex"><i class="bi bi-check-circle-fill text-dark me-3"></i> <span>Active Snow Foam</span></li>
                                <li class="mb-3 d-flex"><i class="bi bi-check-circle-fill text-dark me-3"></i> <span>Turbine Air Dry</span></li>
                                <li class="mb-3 d-flex text-muted opacity-50"><i class="bi bi-x-circle me-3"></i> <span>Underchassis Blast</span></li>
                                <li class="mb-3 d-flex text-muted opacity-50"><i class="bi bi-x-circle me-3"></i> <span>Nano Wax Shield</span></li>
                            </ul>
                            <button class="btn btn-outline-dark w-100 rounded-pill py-2 fw-medium">Book Standard</button>
                        </div>
                    </div>

                    <div class="col-lg-4 col-md-6 animate-fade-up delay-2">
                        <div class="bay-card premium p-5 h-100 position-relative shadow-lg">
                            <div class="position-absolute bg-danger text-white small fw-bold px-3 py-1 rounded-pill" style="top: -15px; right: 20px;">
                                MOST POPULAR
                            </div>
                            <h5 class="fw-bold mb-1">Elite Premium Bay</h5>
                            <p class="text-muted small mb-4">The Complete Treatment</p>
                            <h2 class="fw-bold mb-4">$15.00 <span class="fs-6 text-muted fw-normal">/ wash</span></h2>

                            <ul class="list-unstyled mb-5 small">
                                <li class="mb-3 d-flex"><i class="bi bi-check-circle-fill text-white me-3"></i> <span>High-Pressure Rinse</span></li>
                                <li class="mb-3 d-flex"><i class="bi bi-check-circle-fill text-white me-3"></i> <span>Double Active Snow Foam</span></li>
                                <li class="mb-3 d-flex"><i class="bi bi-check-circle-fill text-white me-3"></i> <span>Extended Turbine Air Dry</span></li>
                                <li class="mb-3 d-flex"><i class="bi bi-check-circle-fill text-white me-3"></i> <span>Underchassis Blast</span></li>
                                <li class="mb-3 d-flex"><i class="bi bi-check-circle-fill text-white me-3"></i> <span>Nano Wax Shield</span></li>
                            </ul>
                            <button class="btn btn-light w-100 rounded-pill py-2 fw-bold text-dark transition-hover">Book Premium</button>
                        </div>
                    </div>

                    <div class="col-lg-4 col-md-6 animate-fade-up delay-3">
                        <div class="bay-card p-5 h-100">
                            <h5 class="fw-bold mb-1">Unlimited Pass</h5>
                            <p class="text-muted small mb-4">Monthly Subscription</p>
                            <h2 class="fw-bold mb-4">$39.00 <span class="fs-6 text-muted fw-normal">/ month</span></h2>

                            <ul class="list-unstyled mb-5 small">
                                <li class="mb-3 d-flex"><i class="bi bi-check-circle-fill text-dark me-3"></i> <span>Unlimited Premium Washes</span></li>
                                <li class="mb-3 d-flex"><i class="bi bi-check-circle-fill text-dark me-3"></i> <span>Priority Bay Booking</span></li>
                                <li class="mb-3 d-flex"><i class="bi bi-check-circle-fill text-dark me-3"></i> <span>Skip The Queue Access</span></li>
                                <li class="mb-3 d-flex"><i class="bi bi-check-circle-fill text-dark me-3"></i> <span>Cancel Anytime</span></li>
                                <li class="mb-3 d-flex"><i class="bi bi-check-circle-fill text-dark me-3"></i> <span>20% Off Interior Detailing</span></li>
                            </ul>
                            <button class="btn btn-black w-100 rounded-pill py-2 fw-medium">Get Pass</button>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- Footer -->
        <footer class="py-5 bg-white border-top animate-fade-up">
            <div class="container pt-4">
                <div class="row mb-5 pb-4 border-bottom">

                    <div class="col-lg-4 mb-4 mb-lg-0">
                        <a class="navbar-brand fw-bold fs-4 tracking-tight text-dark d-block mb-4" href="#">
                            <i class="bi bi-vinyl-fill me-2"></i>EliteAuto
                        </a>
                        <p class="text-muted mb-4 pe-lg-4">
                            Next-generation automated car wash system, utilizing high-precision IoT sensors and eco-friendly technology.
                        </p>
                        <a href="MainController?action=register_page" class="btn btn-black rounded-pill px-4 py-2 fw-medium transition-hover">Create Account Now</a>
                    </div>

                    <div class="col-lg-2 offset-lg-1 col-md-6 mb-4 mb-md-0">
                        <h6 class="fw-bold mb-4">Navigation</h6>
                        <ul class="list-unstyled">
                            <li class="mb-3"><a href="#" class="text-decoration-none text-muted transition-hover">Home</a></li>
                            <li class="mb-3"><a href="#advantages" class="text-decoration-none text-muted transition-hover">Advantages</a></li>
                            <li class="mb-3"><a href="#process" class="text-decoration-none text-muted transition-hover">Process</a></li>
                            <li class="mb-3"><a href="#bays" class="text-decoration-none text-muted transition-hover">Pricing & Offers</a></li>
                        </ul>
                    </div>

                    <div class="col-lg-4 offset-lg-1 col-md-6">
                        <h6 class="fw-bold mb-4">Contact Information</h6>
                        <ul class="list-unstyled text-muted small">
                            <li class="mb-3 d-flex align-items-start">
                                <i class="bi bi-geo-alt fs-5 me-3 text-dark"></i>
                                <span class="mt-1">Care Bay 9, 123 Automation Blvd,<br>District 1, Ho Chi Minh City, VN</span>
                            </li>
                            <li class="mb-3 d-flex align-items-center">
                                <i class="bi bi-telephone fs-5 me-3 text-dark"></i>
                                <span>(+84) 1800 567 854</span>
                            </li>
                            <li class="mb-3 d-flex align-items-center">
                                <i class="bi bi-envelope fs-5 me-3 text-dark"></i>
                                <span>support@eliteauto.vn</span>
                            </li>
                            <li class="mb-3 d-flex align-items-center">
                                <i class="bi bi-clock fs-5 me-3 text-dark"></i>
                                <span>Mon - Sun: 6:00 AM - 10:00 PM</span>
                            </li>
                        </ul>
                    </div>
                </div>

                <div class="d-flex flex-column flex-md-row justify-content-between align-items-center text-muted small">
                    <p class="mb-2 mb-md-0">© 2026 EliteAuto System. All rights reserved.</p>
                    <div class="d-flex gap-3">
                        <a href="#" class="text-muted text-decoration-none transition-hover">Privacy Policy</a>
                        <a href="#" class="text-muted text-decoration-none transition-hover">Terms of Service</a>
                    </div>
                </div>
            </div>
        </footer>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>