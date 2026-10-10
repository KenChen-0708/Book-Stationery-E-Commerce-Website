<%@page contentType="text/html" pageEncoding="UTF-8"%>
<jsp:include page="include/header.jsp" />
<style>
    .hover-zoom {
        transition: transform 0.3s ease;
    }

    .hover-zoom:hover {
        transform: scale(1.03);
    }

    /* Chat FAB Styles */
    .chat-fab {
        position: fixed;
        bottom: 30px;
        right: 70px;
        width: 60px;
        height: 60px;
        border-radius: 50%;
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        color: white;
        border: none;
        box-shadow: 0 4px 8px rgba(0,0,0,0.2);
        font-size: 24px;
        z-index: 1000;
        transition: all 0.3s;
        animation: pulse 2s infinite;
        display: flex;
        align-items: center;
        justify-content: center;
        cursor: pointer;
    }
    .chat-fab:hover {
        transform: scale(1.1);
        box-shadow: 0 6px 12px rgba(0,0,0,0.3);
    }
    @keyframes pulse {
        0% {
            box-shadow: 0 0 0 0 rgba(118, 75, 162, 0.7);
        }
        70% {
            box-shadow: 0 0 0 15px rgba(118, 75, 162, 0);
        }
        100% {
            box-shadow: 0 0 0 0 rgba(118, 75, 162, 0);
        }
    }
    /* Tooltip with right-side adjustment */
    .chat-fab .tooltip {
        visibility: hidden;
        width: 120px;
        background-color: #555;
        color: #fff;
        text-align: center;
        border-radius: 6px;
        padding: 5px;
        position: absolute;
        z-index: 1;
        bottom: 125%;
        right: 0;
        transform: translateX(25%);
        opacity: 0;
        transition: opacity 0.3s;
        font-size: 14px;
        font-weight: normal;
        white-space: nowrap;
    }
    .chat-fab .tooltip::after {
        content: "";
        position: absolute;
        top: 100%;
        left: 50%;
        margin-left: -5px;
        border-width: 5px;
        border-style: solid;
        border-color: #555 transparent transparent transparent;
    }
    .chat-fab:hover .tooltip {
        visibility: visible;
        opacity: 1;
    }
</style>

<section class="py-5" style="background: linear-gradient(to right, #248650, #258550);">
    <div class="container">
        <div class="row align-items-center py-5">
            <div class="col-md-8 text-white">
                <h1>About Us</h1>
                <p><b>
                        Welcome to Chapter & Craft
                        At Chapter & Craft, we believe that words on paper and creative tools have the power to transform lives. Founded in 2018, our store has grown from a small corner shop to a beloved destination for book lovers and stationery enthusiasts alike.</b>
                    <br><br>
                <h2>Our Story </h2>
                <b>Chapter & Craft began with a simple vision: to create a space where the love of literature meets the joy of creativity. Our founders, avid readers and journaling enthusiasts, noticed a gap in their community for a store that could serve as both a thoughtfully curated bookshop and a high-quality stationery haven.</b>
                </p>
            </div>
            <div class="col-md-4">
                <img src="assets/img/about2.png" alt="About" style="width: 500px; height: 600px;">
            </div>
        </div>
    </div>
</section>

<!-- Close Banner -->

<!-- Start Section -->
<section class="container py-5">
    <div class="row text-center pt-5 pb-3">
        <div class="col-lg-6 m-auto">
            <h1 class="h1 fw-bolder">Our Services</h1>
            <p>
                At Chapter & Craft, we bring books and stationery together to inspire creativity and productivity.
            </p>
        </div>
    </div>
    <div class="row">

        <div class="col-md-6 col-lg-3 pb-5">
            <div class="h-100 py-5 services-icon-wap shadow hover-zoom">
                <div class="h1 text-success text-center"><i class="fa fa-truck fa-lg"></i></div>
                <h2 class="h5 mt-4 text-center">Delivery Services</h2>
            </div>
        </div>

        <div class="col-md-6 col-lg-3 pb-5">
            <div class="h-100 py-5 services-icon-wap shadow hover-zoom">
                <div class="h1 text-success text-center"><i class="fas fa-exchange-alt"></i></div>
                <h2 class="h5 mt-4 text-center">Shipping & Return</h2>
            </div>
        </div>

        <div class="col-md-6 col-lg-3 pb-5">
            <div class="h-100 py-5 services-icon-wap shadow hover-zoom">
                <div class="h1 text-success text-center"><i class="fa fa-percent"></i></div>
                <h2 class="h5 mt-4 text-center">Promotion</h2>
            </div>
        </div>

        <div class="col-md-6 col-lg-3 pb-5">
            <div class="h-100 py-5 services-icon-wap shadow hover-zoom">
                <div class="h1 text-success text-center"><i class="fa fa-user"></i></div>
                <h2 class="h5 mt-4 text-center">24 Hours Service</h2>
            </div>
        </div>
    </div>
</section>
<!-- End Section -->

<!-- Start Brands -->
<section class="bg-light py-5 mt-5">
    <div class="container text-center pb-5">
        <h2 class="fw-bold mb-4">Our Brands</h2>
        <p class="text-muted mb-5">We collaborate with top brands to bring you high-quality books and stationery.</p>
        <div id="brandCarousel" class="carousel slide" data-bs-ride="carousel">
            <div class="carousel-inner">
                <div class="carousel-item active">
                    <div class="d-flex justify-content-around align-items-center">
                        <img src="assets/img/brand_01.png" class="img-fluid" style="max-height: 80px;" alt="Brand 1">
                        <img src="assets/img/brand_02.png" class="img-fluid" style="max-height: 80px;" alt="Brand 2">
                        <img src="assets/img/brand_03.png" class="img-fluid" style="max-height: 80px;" alt="Brand 3">
                    </div>
                </div>
                <div class="carousel-item">
                    <div class="d-flex justify-content-around align-items-center">
                        <img src="assets/img/brand_04.png" class="img-fluid" style="max-height: 80px;" alt="Brand 4">
                        <img src="assets/img/brand_05.png" class="img-fluid" style="max-height: 80px;" alt="Brand 5">
                        <img src="assets/img/brand_06.png" class="img-fluid" style="max-height: 80px;" alt="Brand 6">
                    </div>
                </div>
            </div>
            <button class="carousel-control-prev" type="button" data-bs-target="#brandCarousel" data-bs-slide="prev">
                <span class="carousel-control-prev-icon"></span>
            </button>
            <button class="carousel-control-next" type="button" data-bs-target="#brandCarousel" data-bs-slide="next">
                <span class="carousel-control-next-icon"></span>
            </button>
        </div>
    </div>
</section>
<!--End Brands-->

<!-- Chat Button -->
<a href="inbox.jsp">
    <button class="chat-fab" id="chatFab">
    <i class="fas fa-comment-dots"></i>
    <span class="tooltip">Chat with Seller</span>
    </button>
</a>

<jsp:include page="include/footer.jsp" />