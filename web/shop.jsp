<%@page import="java.util.List"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="entity.Product" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<jsp:include page="include/header.jsp" />

<%
    if (request.getAttribute("productList") == null) {
        response.sendRedirect(request.getContextPath() + "/ProductServlet?action=list");
        return;
    }

    String selectedSort = request.getParameter("sort");
    String selectedCategory = request.getParameter("category");
    String selectedSubcategory = request.getParameter("subcategory");

    String searchQuery = (String) request.getAttribute("searchQuery");
    List<Product> productList = (List<Product>) request.getAttribute("productList");

    if (searchQuery != null) {%>
<div class="text-center mt-5 px-2 px-md-0">
    <h4 class="fw-bold mb-3">
        Search results for: 
        <span class="text-primary">"<%= searchQuery%>"</span>
    </h4>
    <a href="ProductServlet?action=list" class="btn btn-outline-secondary btn-sm">
        <i class="fas fa-times me-1"></i> Clear Search
    </a>
</div>

<% } %>

<style>
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
        -webkit-line-clamp: 2; /* Limit to 2 lines */
        -webkit-box-orient: vertical;
        overflow: hidden;
        text-overflow: ellipsis;
    }

    .rating-stars i {
        color: #ffc107;
        margin-right: 2px; /* Added spacing between stars */
    }
    .rating-stars .text-muted {
        color: #6c757d !important;
        margin-left: 5px; /* Added spacing after stars */
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






<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<!-- Added just for star icons -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<!-- Start Content -->
<div class="container py-5">
    <% if (productList != null && !productList.isEmpty()) {%>
    <div class="row">
        <!-- Sidebar -->
        <div class="col-lg-3">
            <div class="card shadow-sm mb-4">
                <div class="card-body">
                    <h5 class="card-title fw-bold mb-4">Filter by Category</h5>
                    <div class="accordion" id="categoryAccordion">

                        <!-- Books -->
                        <div class="accordion-item">
                            <h2 class="accordion-header" id="booksHeading">
                                <button class="accordion-button <%= "Books".equals(selectedCategory) ? "" : "collapsed"%>"
                                        type="button"
                                        data-bs-toggle="collapse"
                                        data-bs-target="#booksCollapse"
                                        aria-expanded="<%= "Books".equals(selectedCategory) ? "true" : "false"%>"
                                        aria-controls="booksCollapse">
                                    📚 Books
                                </button>
                            </h2>
                            <div id="booksCollapse"
                                 class="accordion-collapse collapse <%= "Books".equals(selectedCategory) ? "show" : ""%>">
                                <div class="accordion-body ps-3">
                                    <a class="d-block mb-2 text-decoration-none <%= "Fiction".equals(selectedSubcategory) ? "fw-bold" : ""%>"
                                       href="ProductServlet?action=list&category=Books&subcategory=Fiction">Fiction</a>
                                    <a class="d-block mb-2 text-decoration-none <%= "Non-Fiction".equals(selectedSubcategory) ? "fw-bold" : ""%>"
                                       href="ProductServlet?action=list&category=Books&subcategory=Non-Fiction">Non-Fiction</a>
                                </div>
                            </div>
                        </div>

                        <!-- Stationery -->
                        <div class="accordion-item">
                            <h2 class="accordion-header" id="stationeryHeading">
                                <button class="accordion-button <%= "Stationery".equals(selectedCategory) ? "" : "collapsed"%>"
                                        type="button"
                                        data-bs-toggle="collapse"
                                        data-bs-target="#stationeryCollapse"
                                        aria-expanded="<%= "Stationery".equals(selectedCategory) ? "true" : "false"%>"
                                        aria-controls="stationeryCollapse">
                                    ✏️ Stationery
                                </button>
                            </h2>
                            <div id="stationeryCollapse"
                                 class="accordion-collapse collapse <%= "Stationery".equals(selectedCategory) ? "show" : ""%>">
                                <div class="accordion-body ps-3">
                                    <a class="d-block mb-2 text-decoration-none <%= "Notebooks".equals(selectedSubcategory) ? "fw-bold" : ""%>"
                                       href="ProductServlet?action=list&category=Stationery&subcategory=Notebooks">Notebooks</a>
                                    <a class="d-block mb-2 text-decoration-none <%= "Pens".equals(selectedSubcategory) ? "fw-bold" : ""%>"
                                       href="ProductServlet?action=list&category=Stationery&subcategory=Pens">Pens</a>
                                    <a class="d-block mb-2 text-decoration-none <%= "Highlighters".equals(selectedSubcategory) ? "fw-bold" : ""%>"
                                       href="ProductServlet?action=list&category=Stationery&subcategory=Highlighters">Highlighters</a>
                                </div>
                            </div>
                        </div>

                    </div>
                </div>
            </div>
        </div>

        <!-- Product Grid -->
        <div class="col-lg-9">
            <!-- Top filter bar -->
            <div class="row mb-4">
                <div class="col-md-6">
                    <ul class="nav nav-pills">
                        <li class="nav-item">
                            <a class="nav-link <%= (selectedCategory == null) ? "active btn-success text-white" : "text-dark"%>" 
                               href="ProductServlet?action=list">All</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link <%= "Books".equals(selectedCategory) ? "active btn-success text-white" : "text-dark"%>" 
                               href="ProductServlet?action=list&category=Books">Books</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link <%= "Stationery".equals(selectedCategory) ? "active btn-success text-white" : "text-dark"%>" 
                               href="ProductServlet?action=list&category=Stationery">Stationery</a>
                        </li>
                    </ul>

                </div>
                <div class="col-md-6">
                    <select class="form-control" id="sortOptions" onchange="sortProducts()">
                        <option value="newArrivals" <%= "newArrivals".equals(selectedSort) ? "selected" : ""%>>New Arrivals</option>
                        <option value="aToZ" <%= "aToZ".equals(selectedSort) ? "selected" : ""%>>A to Z</option>
                        <option value="priceLowToHigh" <%= "priceLowToHigh".equals(selectedSort) ? "selected" : ""%>>Price Low to High</option>
                        <option value="priceHighToLow" <%= "priceHighToLow".equals(selectedSort) ? "selected" : ""%>>Price High to Low</option>
                    </select>
                </div>
            </div>

            <!-- Products -->
            <div class="row">
                <c:forEach var="p" items="${productList}">

                    <div class="col-md-4">
                        <a href="ProductServlet?action=single&id=${p.productId}" class="text-decoration-none">
                            <div class="card mb-4 product-wap rounded-0 product-card shadow-sm border-0 product-card" style="height: 630px;">
                                <div class="card rounded-0 shadow-sm border-0">
                                    <!-- Product Image -->
                                    <img class="card-img rounded-0 img-fluid" 
                                         src="${pageContext.request.contextPath}/${p.imageUrl}" 
                                         alt="${p.name}" 
                                         style="width: 100%; height: 400px; object-fit: cover;">
                                    <div class="card-img-overlay rounded-0 product-overlay d-flex align-items-center justify-content-center">

                                    </div>
                                </div>
                                <div class="card-body">
                                    <!-- Product Name (Font size 15px, Bold) -->
                                    <p class="h3 text-decoration-none fw-bold" style="font-size: 15px;">${p.name}</p>

                                    <!-- Product Description (Font size 10px) -->
                                    <p class="description card-text text-muted small" style="min-height: 50px; max-height: 50px; overflow: hidden;">
                                        ${p.description}
                                    </p>


                                    <ul class="w-100 list-unstyled d-flex justify-content-between mb-0">
                                        <li class="pt-2">
                                            <!-- Product Color Dots -->
                                            <span class="product-color-dot color-dot-red float-left rounded-circle ml-1"></span>
                                            <span class="product-color-dot color-dot-blue float-left rounded-circle ml-1"></span>
                                            <span class="product-color-dot color-dot-black float-left rounded-circle ml-1"></span>
                                            <span class="product-color-dot color-dot-light float-left rounded-circle ml-1"></span>
                                            <span class="product-color-dot color-dot-green float-left rounded-circle ml-1"></span>
                                        </li>
                                    </ul>

                                    <!-- Line break before rating -->
                                    <br>

                                    <!-- Updated Rating Stars (only this section changed) -->
                                    <div class="rating-stars d-flex justify-content-center mb-1">
                                        <c:forEach begin="1" end="5" var="i">
                                            <i class="fa fa-star ${i <= p.averageRating ? 'text-warning' : 'text-muted'}"></i>
                                        </c:forEach>
                                        <c:if test="${p.reviewCount > 0}">
                                            <span class="ms-2 text-muted">(${p.reviewCount})</span>
                                        </c:if>
                                    </div>

                                    <!-- Product Price -->
                                    <p class="card-text text-center fw-bold text-primary" style="font-size: 1.2rem;">
                                        RM ${p.price}
                                    </p>
                                </div>
                            </div>
                        </a>
                    </div>

                </c:forEach>
            </div>
        </div>
    </div>
    <% } else {%>
    <div class="text-center py-5">
        <img src="https://cdn-icons-png.flaticon.com/512/6134/6134065.png" alt="No results" style="max-height: 180px;" class="mb-4">
        <h5 class="text-muted">No products found!</h5>
    </div>
    <% }%>
</div>
<!-- End Content -->

<!-- Chat Button -->
<a href="inbox.jsp">
    <button class="chat-fab" id="chatFab">
        <i class="fas fa-comment-dots"></i>
        <span class="tooltip">Chat with Seller</span>
    </button>
</a>

<script>
    function sortProducts() {
        const sortOption = document.getElementById('sortOptions').value;
        const urlParams = new URLSearchParams(window.location.search);
        const category = urlParams.get("category");
        const subcategory = urlParams.get("subcategory");

        let newUrl = "ProductServlet?action=list&sort=" + sortOption;
        if (category)
            newUrl += "&category=" + encodeURIComponent(category);
        if (subcategory)
            newUrl += "&subcategory=" + encodeURIComponent(subcategory);

        window.location.href = newUrl;
    }
</script>

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
<!-- End Brands -->

<jsp:include page="include/footer.jsp" />