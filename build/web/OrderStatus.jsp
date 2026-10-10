<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<jsp:include page="include/header.jsp" />
<%
    List orderDetails = (List) request.getAttribute("orderDetails");
    if (orderDetails == null) {
        response.sendRedirect("OrderStatusServlet");
        return;
    }
%>
<style>
    :root {
        --primary: #5e72e4;
        --primary-light: #8a9ef5;
        --secondary: #825ee4;
        --success: #2dce89;
        --warning: #fb6340;
        --info: #11cdef;
        --dark: #32325d;
        --light: #f8f9fe;
        --gray: #adb5bd;
        --border: #e9ecef;
    }

    body {
        font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
        color: #525f7f;
    }

    .order-card {
        border: none;
        border-radius: 14px;
        box-shadow: 0 4px 24px rgba(0, 0, 0, 0.06);
        overflow: hidden;
        background: white;
        transition: transform 0.3s ease, box-shadow 0.3s ease;
    }

    .order-card:hover {
        transform: translateY(-2px);
        box-shadow: 0 8px 28px rgba(0, 0, 0, 0.1);
    }

    .card-header {
        background: linear-gradient(135deg, var(--primary), var(--secondary));
        color: white;
        padding: 1.25rem 1.5rem;
        border-bottom: none;
    }

    .card-header h4 {
        font-weight: 700;
        letter-spacing: -0.5px;
    }

    .product-img {
        width: 72px;
        height: 72px;
        object-fit: contain;
        border-radius: 10px;
        border: 1px solid var(--border);
        background: white;
        padding: 6px;
        transition: transform 0.3s ease;
    }

    .product-img:hover {
        transform: scale(1.05);
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
    }

    .status-badge {
        font-size: 0.7rem;
        font-weight: 700;
        letter-spacing: 0.5px;
        padding: 0.4rem 0.8rem;
        border-radius: 12px;
        text-transform: uppercase;
        cursor: pointer;
        transition: all 0.2s ease;
    }

    .status-badge:hover {
        transform: translateY(-1px);
        box-shadow: 0 2px 5px rgba(0,0,0,0.1);
    }

    .status-PAID {
        background-color: rgba(94, 114, 228, 0.12) !important;
        color: var(--primary);
    }

    .status-SHIPPED {
        background-color: rgba(17, 205, 239, 0.12);
        color: var(--info);
    }

    .status-DELIVERED {
        background-color: rgba(45, 206, 137, 0.12);
        color: var(--success);
    }

    .review-btn {
        border-radius: 12px;
        font-size: 0.75rem;
        font-weight: 600;
        padding: 0.45rem 0.9rem;
        transition: all 0.3s ease;
        letter-spacing: 0.3px;
        border-width: 1.5px;
    }

    .review-btn:hover {
        transform: translateY(-1px);
        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
    }

    .table {
        margin-bottom: 0;
    }

    .table th {
        font-weight: 700;
        color: var(--dark);
        background-color: var(--light);
        text-transform: uppercase;
        font-size: 0.7rem;
        letter-spacing: 0.5px;
        padding: 1rem 1.5rem;
        border-top: none;
        border-bottom: 1px solid var(--border);
    }

    .table td {
        padding: 1.25rem 1.5rem;
        vertical-align: middle;
        border-top: 1px solid var(--border);
    }

    .table-hover tbody tr:hover {
        background-color: rgba(248, 249, 254, 0.6);
    }

    .product-name {
        font-weight: 600;
        color: var(--dark);
        margin-bottom: 0.15rem;
        font-size: 0.95rem;
    }

    .product-desc {
        font-size: 0.8rem;
        color: var(--gray);
        line-height: 1.4;
    }

    .price {
        font-weight: 700;
        color: var(--primary);
        font-size: 0.95rem;
    }

    .delivery-date {
        font-weight: 600;
        color: var(--dark);
        font-size: 0.85rem;
    }

    .review-action {
        padding: 0.75rem; /* Match other cells */
        vertical-align: middle;
    }

    .review-action .btn {
        margin-bottom: 0.25rem; /* Adjust if needed */
    }

    .review-status {
        font-size: 0.85rem;
        color: #6c757d;
    }

    /* Status Modal */
    .status-modal .modal-content {
        border: none;
        border-radius: 14px;
        overflow: hidden;
        box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
    }

    .status-modal .modal-header {
        background: linear-gradient(135deg, var(--primary), var(--secondary));
        color: white;
        border-bottom: none;
        padding: 1.25rem 1.5rem;
    }

    .status-modal .modal-title {
        font-weight: 700;
        letter-spacing: -0.5px;
    }

    .btn-close-white {
        filter: invert(1) brightness(100%);
    }

    /* Rating Stars */
    .rating {
        display: flex;
        justify-content: center;
        margin: 1rem 0;
    }

    .rating i {
        color: #e0e0e0;
        font-size: 1.5rem;
        margin: 0 0.2rem;
        cursor: pointer;
        transition: color 0.2s;
    }

    .rating i.active {
        color: #ffc107;
    }

    /* Status Timeline */
    .timeline {
        position: relative;
        padding-left: 2rem;
        margin: 1.5rem 0;
    }

    .timeline-step {
        position: relative;
        padding-bottom: 1.5rem;
    }

    .timeline-step:last-child {
        padding-bottom: 0;
    }

    .timeline-step:not(:last-child):before {
        content: '';
        position: absolute;
        left: 0.6rem;
        top: 1.8rem;
        height: calc(100% - 1.8rem);
        width: 2px;
        background: #e9ecef;
        z-index: 1;
    }

    .timeline-icon {
        position: absolute;
        left: 0;
        width: 1.4rem;
        height: 1.4rem;
        border-radius: 50%;
        background: #e9ecef;
        display: flex;
        align-items: center;
        justify-content: center;
        z-index: 2;
        font-size: 0.7rem;
        color: white;
    }

    .timeline-step.completed .timeline-icon {
        background: var(--primary);
    }

    .timeline-step.active .timeline-icon {
        background: var(--primary);
        box-shadow: 0 0 0 4px rgba(94, 114, 228, 0.2);
    }

    .timeline-step.current .timeline-icon {
        background: var(--success);
        box-shadow: 0 0 0 4px rgba(45, 206, 137, 0.2);
    }

    .timeline-content {
        margin-left: 2rem;
    }

    .timeline-title {
        font-weight: 600;
        margin-bottom: 0.2rem;
    }

    .timeline-desc {
        font-size: 0.85rem;
        color: var(--gray);
        margin-bottom: 0.3rem;
    }

    .timeline-date {
        font-size: 0.75rem;
        color: var(--primary);
        font-weight: 500;
    }

    .nav-borders .nav-link.active {
        color: #0061f2;
        border-bottom-color: #0061f2;
    }
    .nav-borders .nav-link {
        color: #69707a;
        border-bottom-width: 0.125rem;
        border-bottom-style: solid;
        border-bottom-color: transparent;
        padding-top: 0.5rem;
        padding-bottom: 0.5rem;
        padding-left: 0;
        padding-right: 0;
        margin-left: 1rem;
        margin-right: 1rem;
    }
</style>

<section style="background-color: #eee;">
    <div class="container py-5">
        <div class="row">
            <div class="col">
                <nav class="nav nav-borders">
                    <a class="nav-link ms-0" href="profile.jsp">User Profile</a>
                    <a class="nav-link" href="WishlistServlet">Wishlist</a>
                    <a class="nav-link active" href="OrderStatus.jsp">My Order</a>
                    <a class="nav-link" href="billing.jsp">Billing & Card</a>
                </nav>
                <hr class="mt-0 mb-4">
            </div>
        </div>

        <div class="container pt-4">
            <div class="card order-card mb-5">
                <div class="card-header">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h4 class="mb-1">My Order</h4>
                        </div>
                    </div>
                </div>

                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover">
                            <thead>
                                <tr>
                                    <th>Product</th>
                                    <th>Details</th>
                                    <th>Amount</th>
                                    <th>Status</th>
                                    <th>Delivery Date</th>
                                    <th>Review</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="orderItem" items="${orderDetails}">
                                    <tr>
                                        <td>
                                            <a href="ProductServlet?action=single&id=${orderItem.productId.productId}">
                                                <img src="${orderItem.productId.imageUrl}" class="product-img" alt="${orderItem.productId.name}">
                                            </a>
                                        </td>
                                        <td>
                                            <a href="ProductServlet?action=single&id=${orderItem.productId.productId}" class="text-decoration-none text-dark fw-bold">
                                                ${orderItem.productId.name} <small class="fw-normal">x${orderItem.quantity}</small>
                                            </a>
                                            <div class="product-desc">${orderItem.productId.description}</div>
                                        </td>
                                        <td class="price">RM${orderItem.price}</td>
                                        <td>
                                            <button type="button"
                                                    class="btn status-badge status-${orderItem.orderId.status}" 
                                                    data-bs-toggle="modal" 
                                                    data-bs-target="#statusModal" 
                                                    data-status="${orderItem.orderId.status}" 
                                                    data-item="${orderItem.productId.name}">
                                                ${orderItem.orderId.status}
                                            </button>
                                        </td>
                                        <td class="delivery-date">
                                            <c:choose>
                                                <c:when test="${not empty orderItem.orderId.orderDate}">
                                                    ${orderItem.orderId.orderDate}
                                                </c:when>
                                                <c:otherwise>-</c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="review-action">
                                            <c:choose>
                                                <c:when test="${orderItem.orderId.status == 'DELIVERED'}">
                                                    <c:set var="review" value="${reviewMap[orderItem.productId.productId]}" />
                                                    <c:choose>
                                                        <c:when test="${not empty review}">
                                                            <button class="btn btn-sm btn-outline-success review-btn"
                                                                    data-bs-toggle="modal" data-bs-target="#viewReviewModal"
                                                                    data-product-name="${orderItem.productId.name}"
                                                                    data-rating="${review.rating}"
                                                                    data-comment="${review.comment}"
                                                                    data-review-id="${review.reviewId}"
                                                                    data-product-id="${orderItem.productId.productId}"
                                                                    data-reply="${not empty review.reviewReplyCollection ? review.reviewReplyCollection.iterator().next().replyText : ''}">
                                                                <i class="fas fa-eye me-1"></i> View Review
                                                            </button>
                                                            <div class="review-status">Submitted on ${review.reviewDate}</div>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <button class="btn btn-sm btn-primary review-btn"
                                                                    data-bs-toggle="modal" data-bs-target="#reviewModal"
                                                                    data-product-id="${orderItem.productId.productId}"
                                                                    data-product-name="${orderItem.productId.name}">
                                                                <i class="far fa-edit me-1"></i> Review
                                                            </button>
                                                            <div class="review-status">Ready for feedback</div>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </c:when>
                                                <c:when test="${orderItem.orderId.status == 'SHIPPED'}">
                                                    <button class="btn btn-sm btn-outline-info review-btn" disabled>
                                                        <i class="fas fa-truck me-1"></i> In Transit
                                                    </button>
                                                </c:when>
                                                <c:otherwise>
                                                    <button class="btn btn-sm btn-outline-secondary review-btn" disabled>
                                                        <i class="far fa-clock me-1"></i> Pending
                                                    </button>
                                                    <div class="review-status">Awaiting shipment</div>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>

        <!-- Status Detail Modal -->
        <div class="modal fade status-modal" id="statusModal" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="statusModalTitle">Order Status Details</h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body" id="statusModalBody">
                        <!-- Dynamic content will be inserted here -->
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-primary" data-bs-dismiss="modal">Close</button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Review Modal -->
        <div class="modal fade" id="reviewModal" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                    <form action="OrderStatusServlet" method="POST">
                        <input type="hidden" name="action" value="review">
                        <input type="hidden" id="productIdInput" name="productId" value="">
                        <div class="modal-header">
                            <h5 class="modal-title" id="reviewModalTitle">Review</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">
                            <div class="mb-4">
                                <label class="form-label d-block text-center mb-2">How would you rate this product?</label>
                                <div class="rating">
                                    <i class="fas fa-star text-warning" data-rating="1"></i>
                                    <i class="fas fa-star text-warning" data-rating="2"></i>
                                    <i class="fas fa-star text-warning" data-rating="3"></i>
                                    <i class="fas fa-star text-warning" data-rating="4"></i>
                                    <i class="fas fa-star text-warning" data-rating="5"></i>
                                </div>
                                <input type="hidden" id="productRating" name="rating" value="5">
                            </div>
                            <div class="mb-3">
                                <label for="reviewText" class="form-label">Your Review</label>
                                <textarea name="reviewText" class="form-control" id="reviewText" rows="4" placeholder="Share your experience with this product..."></textarea>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                            <button type="submit" class="btn btn-primary">Submit Review</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <!-- View Review Modal -->
        <div class="modal fade" id="viewReviewModal" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-lg modal-dialog-centered modal-dialog-scrollable">
                <div class="modal-content">
                    <div class="modal-header bg-light">
                        <h5 class="modal-title fw-bold" id="viewReviewModalTitle">Review Details</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <div class="card shadow-sm mb-4">
                            <div class="card-body">
                                <div class="d-flex justify-content-between align-items-start">
                                    <div>
                                        <h6 class="fw-bold mb-1" id="reviewerUsername">You</h6>
                                        <div id="viewReviewStars" class="rating-stars mb-2"></div>
                                    </div>
                                    <small class="text-muted" id="viewReviewDate"></small>
                                </div>
                                <p class="mb-0" id="viewReviewComment"></p>
                            </div>
                        </div>
                        <div id="viewReviewReplyContainer"></div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-outline-danger me-auto" id="deleteReviewBtn">Delete Review</button>
                        <button class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    document.querySelectorAll('.rating i').forEach(star => {
        star.addEventListener('click', function () {
            const rating = parseInt(this.getAttribute('data-rating'));
            document.getElementById('productRating').value = rating;

            // Update star display
            const stars = this.parentElement.querySelectorAll('i');
            stars.forEach((star, index) => {
                if (index < rating) {
                    star.classList.remove('far');
                    star.classList.add('fas');
                } else {
                    star.classList.remove('fas');
                    star.classList.add('far');
                }
            });
        });
    });

    // Status modal content update based on product and status
    const statusModal = document.getElementById('statusModal');
    if (statusModal) {
        statusModal.addEventListener('show.bs.modal', function (event) {
            const button = event.relatedTarget;
            const product = button.getAttribute('data-item');
            const status = button.getAttribute('data-status');
            const modalTitle = document.getElementById('statusModalTitle');
            const modalBody = document.getElementById('statusModalBody');

            modalTitle.textContent = `Status Details - ${product}`;

            let timelineHTML = '';

            if (status === 'PAID') {
                timelineHTML = `
                    <div class="timeline">
                        <div class="timeline-step completed">
                            <div class="timeline-icon">
                                <i class="fas fa-shopping-cart"></i>
                            </div>
                            <div class="timeline-content">
                                <div class="timeline-title">Order Placed</div>
                                <div class="timeline-desc">Your order has been received</div>
                            </div>
                        </div>
                        <div class="timeline-step completed">
                            <div class="timeline-icon">
                                <i class="fas fa-credit-card"></i>
                            </div>
                            <div class="timeline-content">
                                <div class="timeline-title">Payment Processed</div>
                                <div class="timeline-desc">Your payment has been confirmed</div>
                            </div>
                        </div>
                        <div class="timeline-step current">
                            <div class="timeline-icon">
                                <i class="fas fa-check-circle"></i>
                            </div>
                            <div class="timeline-content">
                                <div class="timeline-title">Order Confirmed</div>
                                <div class="timeline-desc">We're preparing your item for shipment</div>
                            </div>
                        </div>
                        <div class="timeline-step">
                            <div class="timeline-icon">
                                <i class="fas fa-box"></i>
                            </div>
                            <div class="timeline-content">
                                <div class="timeline-title">Processing</div>
                                <div class="timeline-desc">Item being prepared for shipping</div>
                            </div>
                        </div>
                        <div class="timeline-step">
                            <div class="timeline-icon">
                                <i class="fas fa-shipping-fast"></i>
                            </div>
                            <div class="timeline-content">
                                <div class="timeline-title">Shipped</div>
                                <div class="timeline-desc">Will be handed to carrier</div>
                            </div>
                        </div>
                        <div class="timeline-step">
                            <div class="timeline-icon">
                                <i class="fas fa-home"></i>
                            </div>
                            <div class="timeline-content">
                                <div class="timeline-title">Delivered</div>
                                <div class="timeline-desc">On its way to your address</div>
                            </div>
                        </div>
                    </div>
                `;
            } else if (status === 'SHIPPED') {
                timelineHTML = `
                    <div class="timeline">
                        <div class="timeline-step completed">
                            <div class="timeline-icon">
                                <i class="fas fa-shopping-cart"></i>
                            </div>
                            <div class="timeline-content">
                                <div class="timeline-title">Order Placed</div>
                                <div class="timeline-desc">Your order has been received</div>
                            </div>
                        </div>
                        <div class="timeline-step completed">
                            <div class="timeline-icon">
                                <i class="fas fa-credit-card"></i>
                            </div>
                            <div class="timeline-content">
                                <div class="timeline-title">Payment Processed</div>
                                <div class="timeline-desc">Your payment has been confirmed</div>
                            </div>
                        </div>
                        <div class="timeline-step completed">
                            <div class="timeline-icon">
                                <i class="fas fa-box"></i>
                            </div>
                            <div class="timeline-content">
                                <div class="timeline-title">Processing</div>
                                <div class="timeline-desc">Item prepared for shipping</div>
                            </div>
                        </div>
                        <div class="timeline-step current">
                            <div class="timeline-icon">
                                <i class="fas fa-shipping-fast"></i>
                            </div>
                            <div class="timeline-content">
                                <div class="timeline-title">Shipped</div>
                                <div class="timeline-desc">Carrier picked up your package</div>
                            </div>
                        </div>
                        <div class="timeline-step">
                            <div class="timeline-icon">
                                <i class="fas fa-truck"></i>
                            </div>
                            <div class="timeline-content">
                                <div class="timeline-title">In Transit</div>
                                <div class="timeline-desc">On its way to your location</div>
                            </div>
                        </div>
                        <div class="timeline-step">
                            <div class="timeline-icon">
                                <i class="fas fa-home"></i>
                            </div>
                            <div class="timeline-content">
                                <div class="timeline-title">Delivered</div>
                                <div class="timeline-desc">Estimated delivery June 25</div>
                            </div>
                        </div>
                    </div>
                `;
            } else if (status === 'DELIVERED') {
                timelineHTML = `
                    <div class="timeline">
                        <div class="timeline-step completed">
                            <div class="timeline-icon">
                                <i class="fas fa-shopping-cart"></i>
                            </div>
                            <div class="timeline-content">
                                <div class="timeline-title">Order Placed</div>
                                <div class="timeline-desc">Your order has been received</div>
                            </div>
                        </div>
                        <div class="timeline-step completed">
                            <div class="timeline-icon">
                                <i class="fas fa-credit-card"></i>
                            </div>
                            <div class="timeline-content">
                                <div class="timeline-title">Payment Processed</div>
                                <div class="timeline-desc">Your payment has been confirmed</div>
                            </div>
                        </div>
                        <div class="timeline-step completed">
                            <div class="timeline-icon">
                                <i class="fas fa-box"></i>
                            </div>
                            <div class="timeline-content">
                                <div class="timeline-title">Processing</div>
                                <div class="timeline-desc">Item prepared for shipping</div>
                            </div>
                        </div>
                        <div class="timeline-step completed">
                            <div class="timeline-icon">
                                <i class="fas fa-shipping-fast"></i>
                            </div>
                            <div class="timeline-content">
                                <div class="timeline-title">Shipped</div>
                                <div class="timeline-desc">Carrier picked up your package</div>
                            </div>
                        </div>
                        <div class="timeline-step completed">
                            <div class="timeline-icon">
                                <i class="fas fa-truck"></i>
                            </div>
                            <div class="timeline-content">
                                <div class="timeline-title">In Transit</div>
                                <div class="timeline-desc">Package was on its way</div>
                            </div>
                        </div>
                        <div class="timeline-step current">
                            <div class="timeline-icon">
                                <i class="fas fa-home"></i>
                            </div>
                            <div class="timeline-content">
                                <div class="timeline-title">Delivered</div>
                                <div class="timeline-desc">Package was delivered to your address</div>
                            </div>
                        </div>
                    </div>
                `;
            }

            modalBody.innerHTML = timelineHTML;
        });
    }

    // View Review Modal setup
    const viewReviewModal = document.getElementById('viewReviewModal');
    if (viewReviewModal) {
        viewReviewModal.addEventListener('show.bs.modal', function (event) {
            const button = event.relatedTarget;
            const productName = button.getAttribute('data-product-name');
            const rating = parseInt(button.getAttribute('data-rating'));
            const comment = button.getAttribute('data-comment');
            const reviewId = button.getAttribute('data-review-id');
            const productId = button.getAttribute('data-product-id');
            const reply = button.getAttribute('data-reply');

            // Set global variables
            currentReviewId = reviewId;
            currentProductId = productId;

            // Set modal content
            document.getElementById('viewReviewModalTitle').textContent = "Review - " + productName;
            document.getElementById('viewReviewComment').textContent = comment;

            // Set stars
            const starsContainer = document.getElementById('viewReviewStars');
            starsContainer.innerHTML = '';
            for (let i = 1; i <= 5; i++) {
                const star = document.createElement('i');
                star.className = 'fas fa-star ' + (i <= rating ? 'text-warning' : 'text-muted');
                starsContainer.appendChild(star);
            }

            // Set reply if exists
            const replyContainer = document.getElementById('viewReviewReplyContainer');
            replyContainer.innerHTML = '';
            if (reply && reply.trim() !== '') {
                replyContainer.innerHTML =
                        '<div class="card reply-card shadow-sm">' +
                        '<div class="card-body py-2">' +
                        '<div class="d-flex justify-content-between">' +
                        '<h6 class="fw-bold mb-0"><i class="fas fa-reply me-1"></i> Seller</h6>' +
                        '</div>' +
                        '<p class="mb-0">' + reply + '</p>' +
                        '</div>' +
                        '</div>';

            }
        });
    }

    // Delete Review Button handler
    document.getElementById('deleteReviewBtn')?.addEventListener('click', function () {
        if (confirm('Are you sure you want to delete this review? This action cannot be undone.')) {
            const form = document.createElement('form');
            form.method = 'POST';
            form.action = 'OrderStatusServlet';

            const actionInput = document.createElement('input');
            actionInput.type = 'hidden';
            actionInput.name = 'action';
            actionInput.value = 'deleteReview';
            form.appendChild(actionInput);

            const reviewIdInput = document.createElement('input');
            reviewIdInput.type = 'hidden';
            reviewIdInput.name = 'reviewId';
            reviewIdInput.value = currentReviewId;
            form.appendChild(reviewIdInput);

            document.body.appendChild(form);
            form.submit();
        }
    });

    // Review modal setup
    const reviewModal = document.getElementById('reviewModal');
    if (reviewModal) {
        reviewModal.addEventListener('show.bs.modal', function (event) {
            const button = event.relatedTarget;
            const productName = button.getAttribute('data-product-name');
            const productId = button.getAttribute('data-product-id');

            document.getElementById('reviewModalTitle').textContent = "Review - " + productName;
            document.getElementById('productIdInput').value = productId;
        });
    }
</script>

<jsp:include page="include/footer.jsp" />