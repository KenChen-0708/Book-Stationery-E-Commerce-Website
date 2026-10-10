<%@page import="entity.WishlistItem"%>
<%@page import="java.util.Collection"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="entity.Product, entity.Review, entity.ReviewReply, java.util.List, java.util.Map" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<jsp:include page="include/header.jsp" />
<%
    Product product = (Product) request.getAttribute("product");
    if (product == null) {
        response.sendRedirect(request.getContextPath() + "/ProductServlet?action=list");
        return;
    }
    
    List<Review> reviews = (List<Review>) request.getAttribute("reviews");
    double averageRating = (double) request.getAttribute("averageRating");
    int reviewCount = (int) request.getAttribute("reviewCount");
    Map<Integer, Long> ratingCounts = (Map<Integer, Long>) request.getAttribute("ratingCounts");
    int stock = product.getStock();
    
    boolean isInWishlist = request.getAttribute("isInWishlist") != null && (boolean) request.getAttribute("isInWishlist");
    %>
<!-- Font Awesome for icons -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
<style>
    .rating-stars i {
    color: #ffc107;
    }
    .product-img {
    width: 100%;
    height: 400px;
    object-fit: contain;
    border-radius: 8px;
    }
    .review-card, .reply-card {
    border-left: 4px solid #0d6efd;
    border-radius: 8px;
    }
    .reply-card {
    background-color: #f8f9fa;
    border-color: #6c757d;
    }
    .progress {
    height: 8px;
    }
    .quantity-input {
    width: 60px;
    text-align: center;
    }
    .btn-lg {
    padding: 0.75rem 1.25rem;
    font-size: 1.1rem;
    }
    .like-btn {
    position: relative;
    padding: 0;
    border: none;
    background: transparent;
    cursor: pointer;
    overflow: hidden;
    transition: all 0.3s ease;
    width: 44px;  /* Increased from 36px */
    height: 44px; /* Increased from 36px */
    display: inline-flex;
    align-items: center;
    justify-content: center;
    vertical-align: middle;
    margin-left: 12px;
    }
    .heart-icon {
    width: 34px;
    height: 34px;
    fill: #ccc;
    transition: all 0.3s ease;
    transform-origin: center;
    }
    .like-btn:hover .heart-icon {
    transform: scale(1.20);
    fill: #ff325d;
    }
    .like-btn.liked .heart-icon {
    fill: #ff325d;
    animation: heartBounce 0.5s ease;
    }
    @keyframes heartBounce {
    0% {
    transform: scale(1);
    }
    30% {
    transform: scale(1.2);
    }
    50% {
    transform: scale(0.9);
    }
    70% {
    transform: scale(1.1);
    }
    100% {
    transform: scale(1);
    }
    }
    .ripple {
    position: absolute;
    border-radius: 50%;
    background: rgba(255, 50, 93, 0.3);
    transform: scale(0);
    animation: ripple 0.6s linear;
    }
    @keyframes ripple {
    to {
    transform: scale(2);
    opacity: 0;
    }
    }
    .like-btn::before {
    content: '';
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background: rgba(255, 50, 93, 0.1);
    border-radius: 50%;
    opacity: 0;
    transition: all 0.3s ease;
    }
    .like-btn.liked::before {
    animation: circlePulse 0.6s ease;
    }
    @keyframes circlePulse {
    0% {
    transform: scale(0);
    opacity: 1;
    }
    100% {
    transform: scale(1.5);
    opacity: 0;
    }
    }
    /* Product title container */
    .product-title-container {
    display: flex;
    align-items: center;
    gap: 10px;
    margin-bottom: 1rem;
    }
    .product-title {
    margin: 0;
    flex-grow: 1;
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
    /* Chat Modal Styles */
    .chat-modal {
    position: fixed;
    bottom: 100px;
    right: 30px;
    width: 350px;
    height: 500px;
    background: white;
    border-radius: 15px;
    box-shadow: 0 5px 15px rgba(0,0,0,0.2);
    z-index: 1050;
    display: none;
    flex-direction: column;
    overflow: hidden;
    }
    .chat-header {
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    color: white;
    padding: 15px;
    display: flex;
    justify-content: space-between;
    align-items: center;
    }
    .chat-body {
    flex: 1;
    padding: 15px;
    overflow-y: auto;
    background: #f8f9fa;
    }
    .chat-footer {
    padding: 15px;
    background: white;
    border-top: 1px solid #eee;
    }
    .message {
    margin-bottom: 10px;
    max-width: 80%;
    }
    .received {
    align-self: flex-start;
    background: white;
    padding: 10px 15px;
    border-radius: 15px 15px 15px 0;
    box-shadow: 0 1px 1px rgba(0,0,0,0.1);
    }
    .sent {
    align-self: flex-end;
    background: #667eea;
    color: white;
    padding: 10px 15px;
    border-radius: 15px 15px 0 15px;
    }
    .chat-input {
    width: 100%;
    padding: 10px;
    border: 1px solid #ddd;
    border-radius: 20px;
    outline: none;
    }
    .chat-close {
    background: none;
    border: none;
    color: white;
    font-size: 1.2rem;
    cursor: pointer;
    }
    /* Responsive adjustment for smaller screens */
    @media (max-width: 768px) {
    .chat-fab {
    right: 20px;
    bottom: 20px;
    }
    .chat-fab .tooltip {
    right: -10px;
    transform: none;
    }
    .chat-modal {
    width: 100%;
    height: 70vh;
    bottom: 0;
    right: 0;
    border-radius: 15px 15px 0 0;
    }
    }
    /* Hide number input spinners for all browsers */
    input[type=number]::-webkit-inner-spin-button,
    input[type=number]::-webkit-outer-spin-button {
    -webkit-appearance: none;
    margin: 0;
    }
    input[type=number] {
    -moz-appearance: textfield; /* Firefox */
    }
</style>
<!-- Product Details -->
<section class="py-5">
    <div class="container">
        <div class="row align-items-start">
            <!-- Product Image -->
            <div class="col-lg-5 mb-4">
                <img id="productImage" src="${pageContext.request.contextPath}/<%= product.getImageUrl()%>" alt="<%= product.getName()%>" class="product-img">
            </div>
            <!-- Product Info -->
            <div class="col-lg-7">
                <div class="product-title-container">
                    <h2 class="product-title fw-bold"><%= product.getName()%></h2>
                    <form action="${pageContext.request.contextPath}/WishlistServlet" method="post" class="d-inline">
                        <input type="hidden" name="productId" value="<%= product.getProductId()%>">
                        <button type="submit" class="like-btn <%= isInWishlist ? "liked" : ""%>" aria-label="Toggle wishlist">
                            <svg class="heart-icon" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">
                                <path d="M12 21.35l-1.45-1.32C5.4 15.36 2 12.28 2 8.5
                                    2 5.42 4.42 3 7.5 3c1.74 0 3.41.81 4.5 2.09
                                    C13.09 3.81 14.76 3 16.5 3 19.58 3 22 5.42 22 8.5
                                    c0 3.78-3.4 6.86-8.55 11.54L12 21.35z"/>
                            </svg>
                            <span class="ripple"></span>
                        </button>
                    </form>
                </div>
                <!-- Rating & Reviews -->
                <div class="d-flex align-items-center mb-3">
                    <div class="rating-stars">
                        <% for (int i = 1; i <= 5; i++) {%>
                        <i class="fa fa-star <%= i <= averageRating ? "text-warning" : "text-muted"%>"></i>
                        <% }%>
                    </div>
                    <span class="ms-2 text-muted">(<%= reviewCount%> reviews)</span>
                    <button class="btn btn-sm btn-outline-secondary ms-3" data-bs-toggle="modal" data-bs-target="#reviewsModal">
                    View All Reviews
                    </button>
                </div>
                <!-- Price -->
                <h3 class="text-primary fw-bold mb-4">RM <%= product.getPrice()%></h3>
                <!-- Description -->
                <p><strong class="me-2">Description:</strong><span class="text-muted"><%= product.getDescription()%></span></p>
                <!-- Availability -->
                <p>
                    <strong>Availability:</strong>
                    <span class="text-<%= product.getStock() > 0 ? "success" : "danger"%>">
                    <%= product.getStock() > 0 ? "In Stock (" + product.getStock() + ")" : "Out of Stock"%>
                    </span>
                </p>
                <!-- Add to Cart and Buy Now Buttons -->
                <div class="d-flex flex-column align-items-start gap-3 mt-4">
                    <!-- Quantity Selector -->
                    <div class="input-group" style="width: 130px;">
                        <button class="btn btn-outline-secondary" type="button" id="decreaseBtn">-</button>
                        <input type="number" class="form-control quantity-input" id="quantityInput" 
                            value="1" min="1">
                        <button class="btn btn-outline-secondary" type="button" id="increaseBtn">+</button>
                    </div>
                    <!-- Action Buttons -->
                    <div class="action-buttons w-100">
                        <div class="d-flex gap-3 w-100">
                            <!-- Add to Cart Form -->
                            <form id="addToCartForm" action="${pageContext.request.contextPath}/CartServlet" method="post" style="width: 50%;">
                                <input type="hidden" name="productId" value="<%= product.getProductId()%>">
                                <input type="hidden" name="quantity" id="addToCartQuantity" value="1">
                                <input type="hidden" name="action" value="add">
                                <input type="hidden" name="redirect" value="<%= request.getContextPath()%>/ProductServlet?action=single&id=<%= product.getProductId()%>">
                                <button type="submit" class="btn btn-success btn-lg w-100" <%= product.getStock() <= 0 ? "disabled" : ""%>>
                                <i class="fas fa-cart-plus"></i> Add to Cart
                                </button>
                            </form>
                            <!-- Buy Now Form -->
                            <form id="buyNowForm" action="${pageContext.request.contextPath}/CartServlet" method="post" style="width: 50%;">
                                <input type="hidden" name="productId" value="<%= product.getProductId()%>">
                                <input type="hidden" name="quantity" id="buyNowQuantity" value="1">
                                <input type="hidden" name="action" value="buyNow">
                                <button type="submit" class="btn btn-primary btn-lg w-100" <%= product.getStock() <= 0 ? "disabled" : ""%>>
                                <i class="fas fa-shopping-cart"></i> Buy Now
                                </button>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>
                                
<!-- Review Modal -->
<div class="modal fade" id="reviewsModal" tabindex="-1" aria-labelledby="reviewsModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg modal-dialog-centered modal-dialog-scrollable">
        <div class="modal-content">
            <div class="modal-header bg-light">
                <h5 class="modal-title fw-bold">Customer Reviews</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <!-- Rating Summary -->
                <div class="row mb-4">
                    <div class="col-md-4 text-center border-end">
                        <h1 class="display-4 fw-bold text-primary"><%= String.format("%.1f", averageRating)%></h1>
                        <div class="rating-stars mb-2">
                            <% for (int i = 1; i <= 5; i++) {%>
                            <i class="fa fa-star <%= i <= averageRating ? "text-warning" : "text-muted"%>"></i>
                            <% }%>
                        </div>
                        <p class="text-muted"><%= reviewCount%> reviews</p>
                    </div>
                    <div class="col-md-8">
                        <h6 class="fw-bold mb-3">Rating</h6>
                        <% for (int i = 5; i >= 1; i--) {%>
                        <div class="d-flex align-items-center mb-2">
                            <div class="col-2"><%= i%> <i class="fas fa-star text-warning"></i></div>
                            <div class="col-8">
                                <div class="progress">
                                    <div class="progress-bar bg-warning" style="width: <%= reviewCount > 0 ? (ratingCounts.getOrDefault(i, 0L) * 100 / reviewCount) : 0%>%"></div>
                                </div>
                            </div>
                            <div class="col-2 text-end text-muted"><%= ratingCounts.getOrDefault(i, 0L)%></div>
                        </div>
                        <% } %>
                    </div>
                </div>
                <!-- Review List -->
                <div>
                    <h6 class="fw-bold mb-3">All Reviews</h6>
                    <% if (reviews.isEmpty()) { %>
                    <div class="alert alert-info">No reviews yet for this product.</div>
                    <% } else {
                        for (Review review : reviews) {%>
                    <div class="card mb-3 review-card shadow-sm">
                        <div class="card-body">
                            <div class="d-flex justify-content-between mb-2">
                                <div>
                                    <h6 class="fw-bold mb-0"><%= review.getUserId().getUsername()%></h6>
                                    <div class="rating-stars">
                                        <% for (int i = 1; i <= 5; i++) {%>
                                        <i class="fa fa-star <%= i <= review.getRating() ? "text-warning" : "text-muted"%>"></i>
                                        <% }%>
                                    </div>
                                </div>
                                <small class="text-muted"><%= new java.text.SimpleDateFormat("dd MMM yyyy").format(review.getReviewDate())%></small>
                            </div>
                            <p class="mb-0"><%= review.getComment()%></p>
                            <!-- Replies -->
                            <% if (review.getReviewReplyCollection() != null && !review.getReviewReplyCollection().isEmpty()) { %>
                            <div class="mt-3">
                                <% for (ReviewReply reply : review.getReviewReplyCollection()) {%>
                                <div class="card reply-card mb-2 shadow-sm">
                                    <div class="card-body py-2">
                                        <div class="d-flex justify-content-between">
                                            <h6 class="fw-bold mb-0"><i class="fas fa-reply me-1"></i> <%= reply.getUserId().getUsername()%></h6>
                                            <small class="text-muted"><%= new java.text.SimpleDateFormat("dd MMM yyyy").format(reply.getReplyDate())%></small>
                                        </div>
                                        <p class="mb-0"><%= reply.getReplyText()%></p>
                                    </div>
                                </div>
                                <% } %>
                            </div>
                            <% } %>
                        </div>
                    </div>
                    <% }
                        }%>
                </div>
            </div>
            <div class="modal-footer">
                <button class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
            </div>
        </div>
    </div>
</div>
<!-- Chat Button -->
<a href="inbox.jsp">
    <button class="chat-fab" id="chatFab">
    <i class="fas fa-comment-dots"></i>
    <span class="tooltip">Chat with Seller</span>
    </button>
</a>
<!-- Chat Modal -->
<!--<div class="chat-modal" id="chatModal">
    <div class="chat-header">
        <div>
            <h6 class="mb-0 fw-bold">Chat with Seller</h6>
            <small>About: <%= product.getName()%></small>
        </div>
        <button class="chat-close" id="closeChat">&times;</button>
    </div>
    <div class="chat-body" id="chatMessages">
         Messages will appear here 
        <div class="d-flex flex-column">
            <div class="message received">
                <p>Hello! How can I help you with <%= product.getName()%>?</p>
                <small class="text-muted">Seller - Just now</small>
            </div>
        </div>
    </div>
    <div class="chat-footer">
        <div class="input-group">
            <input type="text" class="form-control chat-input" id="chatInput" placeholder="Type your message...">
            <button class="btn btn-primary" id="sendMessage"><i class="fas fa-paper-plane"></i></button>
        </div>
    </div>
</div>-->
<!-- Stock Validation Script -->
<script>
    // Quantity control for both forms
    const quantityInput = document.getElementById('quantityInput');
    const addToCartQuantity = document.getElementById('addToCartQuantity');
    const buyNowQuantity = document.getElementById('buyNowQuantity');
    const maxStock = <%= stock%>;
    
    document.getElementById('decreaseBtn').addEventListener('click', function () {
        let value = parseInt(quantityInput.value);
        if (value > 1) {
            quantityInput.value = value - 1;
            addToCartQuantity.value = value - 1;
            buyNowQuantity.value = value - 1;
        }
    });
    
    document.getElementById('increaseBtn').addEventListener('click', function () {
        let value = parseInt(quantityInput.value);
        if (value < maxStock) {
            quantityInput.value = value + 1;
            addToCartQuantity.value = value + 1;
            buyNowQuantity.value = value + 1;
        } else {
            quantityInput.value = maxStock;
        }
    });
    
    // Manual typing handler
    quantityInput.addEventListener('input', function () {
        let value = parseInt(quantityInput.value);
        if (isNaN(value) || value < 1) {
            value = 1;
        } else if (value > maxStock) {
            value = maxStock;
        }
        quantityInput.value = value;
        addToCartQuantity.value = value;
        buyNowQuantity.value = value;
    });
    
    // Chat functionality
    const chatFab = document.getElementById('chatFab');
    const chatModal = document.getElementById('chatModal');
    const closeChat = document.getElementById('closeChat');
    const chatMessages = document.getElementById('chatMessages');
    const chatInput = document.getElementById('chatInput');
    const sendMessage = document.getElementById('sendMessage');
    
    // Toggle chat modal
    chatFab.addEventListener('click', function () {
        chatModal.style.display = chatModal.style.display === 'flex' ? 'none' : 'flex';
    });
    
    closeChat.addEventListener('click', function () {
        chatModal.style.display = 'none';
    });
    
    // Send message functionality
    sendMessage.addEventListener('click', sendChatMessage);
    chatInput.addEventListener('keypress', function (e) {
        if (e.key === 'Enter') {
            sendChatMessage();
        }
    });
    
    function sendChatMessage() {
        const message = chatInput.value.trim();
        if (message) {
            // Add user message
            addMessage(message, 'sent', 'You - Just now');
    
            // Simulate reply after 1 second
            setTimeout(() => {
                addMessage("Thanks for your message about <%= product.getName()%>. We'll get back to you soon!", 'received', 'Seller - Just now');
            }, 1000);
    
            chatInput.value = '';
            scrollToBottom();
        }
    }
    
    function addMessage(text, type, sender) {
        const messageDiv = document.createElement('div');
        messageDiv.className = `message ${type}`;
        messageDiv.innerHTML = `
            <p>${text}</p>
            <small class="text-muted">${sender}</small>
        `;
        chatMessages.querySelector('.d-flex').appendChild(messageDiv);
        scrollToBottom();
    }
    
    function scrollToBottom() {
        chatMessages.scrollTop = chatMessages.scrollHeight;
    }
</script>
<script>
    document.getElementById('addToCartForm').addEventListener('submit', function (e) {
        const img = document.getElementById('productImage');
        const cart = document.getElementById('cart-icon');
    
        if (img && cart) {
            const imgClone = img.cloneNode(true);
            const imgRect = img.getBoundingClientRect();
            const cartRect = cart.getBoundingClientRect();
    
            imgClone.style.position = 'fixed';
            imgClone.style.left = imgRect.left + 'px';
            imgClone.style.top = imgRect.top + 'px';
            imgClone.style.width = imgRect.width + 'px';
            imgClone.style.height = imgRect.height + 'px';
            imgClone.style.zIndex = '10000';
            imgClone.style.transition = 'all 0.5s ease-in-out';
            imgClone.style.borderRadius = '50%';
    
            document.body.appendChild(imgClone);
    
            setTimeout(() => {
                imgClone.style.left = cartRect.left + 'px';
                imgClone.style.top = cartRect.top + 'px';
                imgClone.style.width = '20px';
                imgClone.style.height = '20px';
                imgClone.style.opacity = '0.5';
    
            }, 10);
    
            setTimeout(() => {
                imgClone.remove();
    
                // Let the form submit AFTER animation
                e.target.submit();
            }, 500);
    
            // Prevent default submission now
            e.preventDefault();
        }
    });
    
    // Wishlist button functionality
    document.querySelector('.like-btn').addEventListener('click', function (e) {
        this.classList.toggle('liked');
    
        // Create ripple effect
        const ripple = document.createElement('span');
        ripple.className = 'ripple';
        const rect = this.getBoundingClientRect();
        ripple.style.left = (e.clientX - rect.left - 5) + 'px';
        ripple.style.top = (e.clientY - rect.top - 5) + 'px';
        this.appendChild(ripple);
    
        // Remove ripple element after animation
        setTimeout(() => {
            ripple.remove();
        }, 600);
    
        // Add your wishlist logic here
        if (this.classList.contains('liked')) {
            console.log('Added to wishlist');
        } else {
            console.log('Removed from wishlist');
        }
    });
</script>
<jsp:include page="include/footer.jsp" />