<%@page import="entity.Product"%>
<%@page import="java.util.List"%>
<jsp:include page="include/header.jsp" />

<% String company = getServletContext().getInitParameter("companyName");%>

<%
    List<Product> bestProducts = (List<Product>) request.getAttribute("bestProducts");

    if (bestProducts == null || bestProducts.isEmpty()) {
        response.sendRedirect("ProductServlet?action=best");
        return;
    }
%>

<style>
    .hover-zoom {
        transition: transform 0.3s ease;
    }

    .hover-zoom:hover {
        transform: scale(1.1);
    }

    .product-card:hover {
        transform: translateY(-10px);
        transition: all 0.3s ease-in-out;
    }

    .product-card .card-img-top {
        transition: transform 0.3s ease-in-out;
    }

    .product-card:hover .card-img-top {
        transform: scale(1.05);
    }

    .description {
        font-size: 14px;
        color: #666;
        display: -webkit-box;
        -webkit-line-clamp: 2;
        -webkit-box-orient: vertical;
        overflow: hidden;
        text-overflow: ellipsis;
    }

    .rating-stars i {
        color: #ffc107;
        margin-right: 2px;
    }

    .rating-stars .text-muted {
        color: #6c757d !important;
        margin-left: 5px;
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

<!-- Start Banner Hero -->
<div id="template-mo-zay-hero-carousel" class="carousel slide" data-bs-ride="carousel">
    <ol class="carousel-indicators">
        <li data-bs-target="#template-mo-zay-hero-carousel" data-bs-slide-to="0" class="active"></li>
        <li data-bs-target="#template-mo-zay-hero-carousel" data-bs-slide-to="1"></li>
        <li data-bs-target="#template-mo-zay-hero-carousel" data-bs-slide-to="2"></li>
    </ol>
    <div class="carousel-inner">
        <div class="carousel-item active">
            <div class="container">
                <div class="row p-5">
                    <div class="mx-auto col-md-8 col-lg-6 order-lg-first">
                        <img class="img-fluid animate__animated animate__zoomIn" src="./assets/img/logo1.png" alt="" style="width: 400px; height: 500px;">
                    </div>
                    <div class="col-lg-6 mb-0 d-flex align-items-center">
                        <div class="text-align-left">
                            <h1 class="h1"><b><%= company%></b></h1>
                            <p>
                                Your go-to destination for carefully curated books, premium stationery, and inspiring tools to fuel your creativity, learning, and everyday productivity
                            </p>
                        </div>
                    </div>
                </div>
            </div>
        </div>


        <div class="carousel-item">
            <div class="container">
                <div class="row p-5">
                    <div class="mx-auto col-md-8 col-lg-6 order-lg-first">
                        <img class="img-fluid animate__animated animate__fadeInLeft" src="./assets/img/home10.png" alt="" style="width: 600px; height: 500px;">
                    </div>
                    <div class="col-lg-6 mb-0 d-flex align-items-center">
                        <div class="text-align-left">
                            <h1 class="h1"><b>Unlock Your Potential with the Perfect Combo</b></h1>
                            <p>
                                Books & Stationery! !<br>
                                Explore our curated bestsellers and premium stationery ? perfect pairings to inspire your reading and writing journey.
                            </p>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="carousel-item">
            <div class="container">
                <div class="row p-5">
                    <div class="mx-auto col-md-8 col-lg-6 order-lg-first">
                        <img class="img-fluid animate__animated animate__fadeInRight" src="./assets/img/home11.png" alt="" style="width: 500px; height: 500px;">
                    </div>
                    <div class="col-lg-6 mb-0 d-flex align-items-center">
                        <div class="text-align-left">
                            <h1 class="h1"><b>Lucky Dip Stationery Surprise</b></h1>                          
                            <p>
                                Tired of ordinary stationery? <br>Dive into the thrill of our Limited Edition Stationery Blind Box ? where every unboxing is an adventure! Each carefully curated box is packed with 5-7 premium items
                            </p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <a class="carousel-control-prev text-decoration-none w-auto ps-3" href="#template-mo-zay-hero-carousel" role="button" data-bs-slide="prev">
        <i class="fas fa-chevron-left"></i>
    </a>
    <a class="carousel-control-next text-decoration-none w-auto pe-3" href="#template-mo-zay-hero-carousel" role="button" data-bs-slide="next">
        <i class="fas fa-chevron-right"></i>
    </a>
</div>
<!-- End Banner Hero -->


<!-- Start Categories of The Month -->
<section class="container py-5">
    <div class="row text-center pt-3">
        <div class="col-lg-6 m-auto">
            <h1 class="h1 fw-bolder">Our Products</h1>
            <p>
                Find your next chapter here.
            </p>
        </div>
    </div>
    <div class="row justify-content-center">
        <!-- Books -->
        <div class="col-md-4 text-center mb-4 hover-zoom">
            <a href="ProductServlet?action=list&category=Books">
                <img src="./assets/img/books.jpg" class="rounded-circle border " style="width: 250px; height: 250px; object-fit: cover;">
            </a>
            <h4 class="mt-3">Books</h4>
            <a href="ProductServlet?action=list&category=Books" class="btn btn-success">Go Shop</a>
        </div>

        <!-- Shoes -->
        <div class="col-md-4 text-center mb-4 hover-zoom">
            <a href="ProductServlet?action=list&category=Stationery">
                <img src="./assets/img/stationaries.jpg" class="rounded-circle border " style="width: 250px; height: 250px; object-fit: cover;">
            </a>
            <h4 class="mt-3">Stationaries</h4>
            <a href="ProductServlet?action=list&category=Stationery" class="btn btn-success">Go Shop</a>
        </div>
    </div>
</section>
<!-- End Categories of The Month -->


<!-- Start Featured Product -->
<section class="bg-light">
    <div class="container py-5">
        <div class="row text-center py-3">
            <div class="col-lg-6 m-auto">
                <h1 class="h1 fw-bolder">Our Best Products</h1>
                <p>See what the customers say.</p>
            </div>
        </div>
        <div class="row">
            <%
                if (bestProducts != null) {
                    for (Product product : bestProducts) {
            %>
            <div class="col-md-4">
                <a href="ProductServlet?action=single&id=<%=product.getProductId()%>" class="text-decoration-none">
                    <div class="card mb-4 product-wap rounded-0 product-card shadow-sm border-0" style="height: 630px;">
                        <div class="card rounded-0 shadow-sm border-0">
                            <!-- Product Image -->
                            <img class="card-img rounded-0 img-fluid"
                                 src="<%=request.getContextPath()%>/<%=product.getImageUrl()%>"
                                 alt="<%=product.getName()%>"
                                 style="width: 100%; height: 400px; object-fit: cover;">
                        </div>
                        <div class="card-body">
                            <!-- Product Name -->
                            <p class="h3 text-decoration-none fw-bold" style="font-size: 15px;">
                                <%=product.getName()%>
                            </p>

                            <!-- Description Placeholder -->
                            <p class="description card-text text-muted small" style="min-height: 50px; max-height: 50px; overflow: hidden;">
                                <%=product.getDescription() != null ? product.getDescription() : "No description available."%>
                            </p>

                            <!-- Rating Stars -->
                            <div class="rating-stars d-flex justify-content-center mb-1">
                                <%
                                    int fullStars = (int) Math.floor(product.getAverageRating());
                                    for (int i = 1; i <= 5; i++) {
                                %>
                                <i class="fa fa-star <%= i <= fullStars ? "text-warning" : "text-muted"%>"></i>
                                <% } %>
                                <% if (product.getReviewCount() > 0) {%>
                                <span class="ms-2 text-muted">(<%=product.getReviewCount()%>)</span>
                                <% }%>
                            </div>

                            <!-- Product Price -->
                            <p class="card-text text-center fw-bold text-primary" style="font-size: 1.2rem;">
                                RM <%=product.getPrice()%>
                            </p>
                        </div>
                    </div>
                </a>
            </div>
            <%
                    }
                }
            %>
        </div>
    </div>
</section>

<!-- End Featured Product -->

<!-- Chat Button -->
<a href="inbox.jsp">
    <button class="chat-fab" id="chatFab">
    <i class="fas fa-comment-dots"></i>
    <span class="tooltip">Chat with Seller</span>
    </button>
</a>

<style>
    /* Set fixed height for carousel items */
    .carousel-item {
        height: 600px; /* Adjust this value as needed */
    }

    /* Ensure content stays vertically centered */
    .carousel-content-wrapper {
        height: 100%;
        display: flex;
        align-items: center;
    }

    /* Make images consistent in size */
    .carousel-img {
        max-height: 500px;
        width: auto;
        object-fit: contain;
    }
</style>

<jsp:include page="include/footer.jsp" />