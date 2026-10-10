<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="entity.CartItem"%>
<%@page import="java.util.List"%>
<%@page import="java.math.BigDecimal"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="include/header.jsp" />
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<script src="https://unpkg.com/@lottiefiles/lottie-player@latest/dist/lottie-player.js"></script>
<style>
    .zoom-hover {
        transition: transform 0.3s ease;
    }

    .zoom-hover:hover {
        transform: scale(1.10);
    }

    /* Remove spinner buttons from number input (Chrome, Safari, Edge) */
    input.no-spinner::-webkit-inner-spin-button,
    input.no-spinner::-webkit-outer-spin-button {
        -webkit-appearance: none;
        margin: 0;
    }

    /* Remove spinner for Firefox */
    input.no-spinner[type=number] {
        -moz-appearance: textfield;
    }
</style>

<c:choose>
    <c:when test="${empty cartItems}">
        <div class="d-flex flex-column align-items-center justify-content-center my-5 pb-5">
            <lottie-player src="https://assets1.lottiefiles.com/packages/lf20_UJNc2t.json"
                           background="transparent" speed="1"
                           style="width: 200px; height: 200px;" loop autoplay>
            </lottie-player>
            <h4 class="mt-3">Your cart is empty</h4>
            <a href="shop.jsp" class="btn btn-outline-primary mt-2">Go to Shop</a>
        </div>

    </c:when>

    <c:otherwise>
        <section class="h-100 h-custom">
            <div class="container h-100 py-5">
                <div class="row d-flex justify-content-between align-items-start h-100">
                    <div class="col-lg-8">
                        <div class="table-responsive py-4">
                            <table class="table table-hover align-middle">
                                <thead class="table-dark text-center">
                                    <tr>
                                        <th class="h5">Shopping Bag</th>
                                        <th>Category</th>
                                        <th>Quantity</th>
                                        <th>Subtotal</th>
                                        <th>Action</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="item" items="${cartItems}">
                                        <tr>
                                            <!-- Product Info -->
                                            <td>
                                                <div class="d-flex align-items-center">
                                                    <a href="ProductServlet?action=single&id=${item.productId.productId}">
                                                        <img src="${pageContext.request.contextPath}/${item.productId.imageUrl}" 
                                                             class="img-fluid rounded zoom-hover" style="width: 100px; height: auto;" alt="${item.productId.name}">
                                                    </a>

                                                    <div class="ms-3">
                                                        <a href="ProductServlet?action=single&id=${item.productId.productId}" class="text-decoration-none text-dark fw-bold">
                                                            ${item.productId.name}
                                                        </a>
                                                        <p class="mb-0 text-muted small">Price: RM${item.productId.price}</p>
                                                    </div>
                                                </div>
                                            </td>

                                            <!-- Format Info -->
                                            <td class="text-center">
                                                <span class="badge bg-secondary">${item.productId.categoryMain}</span><br/>
                                                <small class="text-muted">${item.productId.categorySub}</small>
                                            </td>

                                            <!-- Quantity Controls -->
                                            <td class="text-center">
                                                <form action="CartServlet" method="post" class="d-inline-flex align-items-center justify-content-center" onsubmit="setUpdateAction(this)">
                                                    <input type="hidden" name="cartItemId" value="${item.cartItemId}" />
                                                    <input type="hidden" name="action" value="update" />

                                                    <button type="button" class="btn btn-sm btn-outline-secondary" onclick="changeQuantity(this, -1, ${item.productId.stock})">
                                                        <i class="fas fa-minus"></i>
                                                    </button>

                                                    <input type="number" name="quantity" value="${item.quantity}" min="1" max="${item.productId.stock}"
                                                           class="form-control form-control-sm mx-1 text-center no-spinner"
                                                           style="width: 60px;" onchange="this.form.submit()" />

                                                    <button type="button" class="btn btn-sm btn-outline-secondary" onclick="changeQuantity(this, 1, ${item.productId.stock})">
                                                        <i class="fas fa-plus"></i>
                                                    </button>

                                                </form>

                                            </td>

                                            <!-- Subtotal -->
                                            <td class="text-center">
                                                <strong>RM${item.subtotal}</strong>
                                            </td>

                                            <!-- Remove Button -->
                                            <td class="text-center">
                                                <button type="button" class="btn btn-sm btn-danger" 
                                                        data-bs-toggle="modal" 
                                                        data-bs-target="#confirmRemoveModal"
                                                        data-item-id="${item.cartItemId}">
                                                    <i class="fas fa-trash-alt"></i>
                                                </button>
                                            </td>


                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <div class="col-lg-4">
                        <div class="card mt-3 mb-lg-0 border-0 shadow">
                            <div class="card-body p-4">
                                <h5 class="text-center mb-4 fw-bold">Order Summary</h5>

                                <!-- Subtotal -->
                                <div class="d-flex justify-content-between mb-2">
                                    <span class="text-muted">Subtotal</span>
                                    <span>RM${cartTotal}</span>
                                </div>

                                <!-- Shipping -->
                                <div class="d-flex justify-content-between mb-2">
                                    <span class="text-muted">
                                        Shipping 
                                        <small class="text-muted fst-italic">(Free over RM100)</small>
                                    </span>
                                    <span>
                                        <c:choose>
                                            <c:when test="${deliveryFee == 0}">
                                                <span class="text-success fw-semibold">Free</span>
                                            </c:when>
                                            <c:otherwise>
                                                RM${deliveryFee}
                                            </c:otherwise>
                                        </c:choose>
                                    </span>
                                </div>

                                <!-- Divider -->
                                <hr class="my-3">

                                <!-- Total -->
                                <div class="d-flex justify-content-between mb-4 fs-5 fw-semibold">
                                    <span>Total</span>
                                    <span>RM${grandTotal}</span>
                                </div>

                                <!-- Checkout Button -->
                                <form action="PaymentServlet" method="post">
                                    <input type="hidden" name="action" value="display" />
                                    <button type="submit" class="btn btn-success w-100 py-2">
                                        <i class="fas fa-lock me-2"></i> Proceed to Checkout
                                    </button>
                                </form>
                            </div>
                        </div>
                    </div>

                </div>
            </div>
        </section>
    </c:otherwise>
</c:choose>

<!-- Remove Confirmation Modal -->
<div class="modal fade" id="confirmRemoveModal" tabindex="-1" aria-labelledby="confirmRemoveLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <form method="post" action="CartServlet" class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="confirmRemoveLabel">Remove Item</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                Are you sure you want to remove this item from your cart?
                <input type="hidden" name="cartItemId" id="removeCartItemId" />
                <input type="hidden" name="action" value="delete" />
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                <button type="submit" class="btn btn-danger">Yes, Remove</button>
            </div>
        </form>
    </div>
</div>

<script>
    const removeModal = document.getElementById('confirmRemoveModal');
    removeModal.addEventListener('show.bs.modal', function (event) {
        const button = event.relatedTarget;
        const itemId = button.getAttribute('data-item-id');
        document.getElementById('removeCartItemId').value = itemId;
    });
</script>

<script>
    function changeQuantity(button, change, maxStock) {
        const form = button.form;
        const input = form.querySelector('input[name="quantity"]');
        let current = input.valueAsNumber || 1;

        let newQty = current + change;

        if (newQty < 1)
            newQty = 1;
        if (newQty > maxStock)
            newQty = maxStock;

        input.value = newQty;
        form.submit();
    }
</script>




<jsp:include page="include/footer.jsp" />
