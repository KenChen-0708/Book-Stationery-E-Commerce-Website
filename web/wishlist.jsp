<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="entity.WishlistItem"%>
<%@page import="java.util.List"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="include/header.jsp" />

<style>
    .zoom-hover {
        transition: transform 0.3s ease;
    }

    .zoom-hover:hover {
        transform: scale(1.10);
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

<script src="https://unpkg.com/@lottiefiles/lottie-player@latest/dist/lottie-player.js"></script>

<section style="background-color: #eee;" class="pb-5">
    <div class="container py-5">
        <div class="row">
            <div class="col">
                <!-- Account page navigation -->
                <nav class="nav nav-borders">
                    <a class="nav-link ms-0" href="profile.jsp">User Profile</a>
                    <a class="nav-link active" href="WishlistServlet">Wishlist</a>
                    <a class="nav-link" href="OrderStatus.jsp">My Order</a>
                    <a class="nav-link" href="billing.jsp">Billing & Card</a>
                </nav>
                <hr class="mt-0 mb-4">
            </div>
        </div>

        <!-- Wishlist Content -->
        <div class="row">
            <div class="col-lg-12">
                <c:choose>
                    <c:when test="${empty wishlistItemMap}">
                        <div class="d-flex flex-column align-items-center justify-content-center my-5 pb-5">
                            <lottie-player src="https://assets2.lottiefiles.com/packages/lf20_kq5rGs.json"
                                           background="transparent" speed="1"
                                           style="width: 200px; height: 200px;" loop autoplay>
                            </lottie-player>
                            <h4 class="mt-3">Your wishlist is empty</h4>
                            <a href="shop.jsp" class="btn btn-outline-primary mt-2">Go to Add</a>
                        </div>
                    </c:when>

                    <c:otherwise>
                        <div class="container">
                            <h3 class="mb-4">Your Wishlist</h3>
                            <div class="table-responsive">
                                <table class="table align-middle text-center table-hover">
                                    <thead class="table-dark">
                                        <tr>
                                            <th class="h5">Product</th>
                                            <th>Category</th>
                                            <th>Price</th>
                                            <th>Action</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="entry" items="${wishlistItemMap}">
                                            <c:set var="item" value="${entry.key}" />
                                            <c:set var="product" value="${entry.value}" />

                                            <tr>
                                                <td class="text-start">
                                                    <div class="d-flex align-items-center">
                                                        <a href="ProductServlet?action=single&id=${product.productId}">
                                                            <img src="${pageContext.request.contextPath}/${product.imageUrl}" 
                                                                 class="img-fluid rounded border zoom-hover hover-dark"
                                                                 data-product-id="${product.productId}"
                                                                 style="width: 100px; height: auto;" 
                                                                 alt="${product.name}">

                                                        </a>
                                                        <div class="ms-3">
                                                            <a href="ProductServlet?action=single&id=${product.productId}" class="text-dark text-decoration-none">
                                                                <h5 class="mb-1 fw-bold">${product.name}</h5>
                                                            </a>
                                                            <p class="mb-0 text-muted small">${product.description}</p>
                                                        </div>
                                                    </div>
                                                </td>

                                                <td>
                                                    <span class="badge bg-secondary">${product.categoryMain}</span><br/>
                                                    <small class="text-muted">${product.categorySub}</small>
                                                </td>

                                                <td>
                                                    RM <fmt:formatNumber value="${product.price}" type="number" minFractionDigits="2" />
                                                </td>

                                                <td>
                                                    <!-- Trigger Modal -->
                                                    <button type="button" class="btn btn-sm btn-danger"
                                                            data-bs-toggle="modal"
                                                            data-bs-target="#confirmRemoveModal"
                                                            data-item-id="${item.wishlistItemId}">
                                                        <i class="fas fa-trash-alt"></i> Remove
                                                    </button>


                                                    <!-- Add to cart -->
                                                    <form action="CartServlet" method="post" class="d-inline add-to-cart-form">
                                                        <input type="hidden" name="productId" value="${product.productId}" />
                                                        <input type="hidden" name="quantity" value="1" />
                                                        <input type="hidden" name="redirect" value="WishlistServlet" />
                                                        <c:choose>
                                                            <c:when test="${product.stock <= 0}">
                                                                <button type="submit" class="btn btn-sm btn-success ms-2" disabled>
                                                                    <i class="fas fa-cart-plus"></i> Out of Stock
                                                                </button>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <button type="submit" class="btn btn-sm btn-success ms-2">
                                                                    <i class="fas fa-cart-plus"></i> Add to Cart
                                                                </button>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </form>


                                                </td>
                                            </tr>
                                        </c:forEach>

                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </c:otherwise>
                </c:choose>

                <!-- Remove Confirmation Modal -->
                <div class="modal fade" id="confirmRemoveModal" tabindex="-1" aria-labelledby="confirmRemoveLabel" aria-hidden="true">
                    <div class="modal-dialog modal-dialog-centered">
                        <form method="post" action="WishlistServlet" class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title" id="confirmRemoveLabel">Remove Item</h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                            </div>
                            <div class="modal-body">
                                Are you sure you want to remove this item from your wishlist?
                                <input type="hidden" name="wishlistItemId" id="removeWishlistItemId" />
                                <input type="hidden" name="action" value="remove" />
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                                <button type="submit" class="btn btn-danger">Yes, Remove</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>
<script>
    document.querySelectorAll('.add-to-cart-form').forEach(form => {
        form.addEventListener('submit', function (e) {
            const productId = form.querySelector('input[name="productId"]').value;
            const img = form.closest('tr').querySelector("img[data-product-id='" + productId + "']");
            const cartIcon = document.getElementById('cart-icon');
            console.log('productId:', productId);
            console.log('img:', img);
            console.log('cartIcon:', cartIcon);

            if (img && cartIcon) {
                const imgClone = img.cloneNode(true);
                const imgRect = img.getBoundingClientRect();
                const cartRect = cartIcon.getBoundingClientRect();

                imgClone.style.position = 'fixed';
                imgClone.style.left = imgRect.left + 'px';
                imgClone.style.top = imgRect.top + 'px';
                imgClone.style.width = imgRect.width + 'px';
                imgClone.style.height = imgRect.height + 'px';
                imgClone.style.zIndex = '10000';
                imgClone.style.transition = 'all 1s ease-in-out';
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
                    e.target.submit();
                }, 1000);

                e.preventDefault();
            }
        });
    });
</script>

<script>
    const removeModal = document.getElementById('confirmRemoveModal');
    removeModal.addEventListener('show.bs.modal', function (event) {
        const button = event.relatedTarget;
        const itemId = button.getAttribute('data-item-id');
        document.getElementById('removeWishlistItemId').value = itemId;
    });
</script>



<jsp:include page="include/footer.jsp" />