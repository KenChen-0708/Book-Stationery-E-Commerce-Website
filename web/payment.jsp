<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="entity.Users, entity.CartItem"%>
<%@page import="java.util.List"%>
<%@page import="java.math.BigDecimal"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="include/header.jsp" />

<%
    Users user = (Users) session.getAttribute("user");
    if (user == null || !"CUSTOMER".equals(user.getRole())) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<div class="container my-5">
    <div class="row g-5">
        <!-- CART SUMMARY -->
        <div class="col-md-5 col-lg-4 order-md-last">
            <h4 class="d-flex justify-content-between align-items-center mb-3">
                <span class="text-success">Your cart</span>
                <span class="badge bg-success rounded-pill">${cartItems.size()}</span>
            </h4>
            <c:if test="${isBuyNow}">
                <div class="alert alert-info">
                    You are checking out a single item via <strong>Buy Now</strong>.
                </div>
            </c:if>

            <ul class="list-group mb-3">
                <c:forEach var="item" items="${cartItems}">
                    <li class="list-group-item d-flex justify-content-between lh-sm">
                        <div>
                            <h6 class="my-0">${item.productId.name}</h6>
                            <small class="text-body-secondary">${item.quantity} × RM<fmt:formatNumber value="${item.productId.price}" minFractionDigits="2"/></small>
                        </div>
                        <span class="text-body-secondary">RM<fmt:formatNumber value="${item.subtotal}" minFractionDigits="2"/></span>
                    </li>
                </c:forEach>

                <li class="list-group-item d-flex justify-content-between">
                    <span>Subtotal</span>
                    <strong>RM<fmt:formatNumber value="${cartTotal}" minFractionDigits="2"/></strong>
                </li>

                <li class="list-group-item d-flex justify-content-between">
                    <span>Shipping</span>
                    <strong>RM<fmt:formatNumber value="${deliveryFee}" minFractionDigits="2"/></strong>
                </li>

                <li class="list-group-item d-flex justify-content-between">
                    <span>Total</span>
                    <strong id="grandTotalDisplay">RM<fmt:formatNumber value="${grandTotal}" minFractionDigits="2"/></strong>
                    <input type="hidden" id="originalTotal" value="${grandTotal}" />
                    <input type="hidden" name="discount" id="discount" value="0" />
                </li>
            </ul>
            <!-- Promo Code Form -->
            <form onsubmit="applyPromo(event)" class="card p-2 mt-2">
                <div class="input-group">
                    <input type="text" class="form-control" id="promoCode" name="promoCode" placeholder="Promo code" />
                    <button type="submit" class="btn btn-outline-success">Redeem</button>
                </div>
                <div id="promoMessage" class="small mt-1"></div>
            </form>

        </div>

        <!-- BILLING + PAYMENT -->
        <div class="col-md-7 col-lg-8">
            <h4 class="mb-3">Billing address</h4>
            <form class="needs-validation" action="${pageContext.request.contextPath}/PaymentServlet" method="post">
                <input type="hidden" name="promoCode" id="hiddenPromoCode" value="" />
                <input type="hidden" name="discount" id="hiddenDiscount" value="0" />
                <input type="hidden" name="action" value="${isBuyNow ? 'buyNow' : 'checkout'}" />

                <c:if test="${isBuyNow}">
                    <input type="hidden" name="productId" value="${productId}" />
                    <input type="hidden" name="quantity" value="${quantity}" />
                </c:if>


                <div class="row g-3">
                    <div class="col-12">
                        <label class="form-label">Name</label>
                        <input type="text" class="form-control" value="${user.username}" readonly>
                    </div>

                    <div class="col-12">
                        <label for="email" class="form-label">Email</label>
                        <input type="email" class="form-control" id="email" name="email" value="${user.email}" required>
                    </div>

                    <div class="col-12">
                        <label for="address" class="form-label">Address</label>
                        <input type="text" class="form-control" id="address" name="address" value="${savedAddress.addressLine}" required>
                    </div>

                    <div class="col-md-5">
                        <label for="country" class="form-label">Country</label>
                        <select class="form-select" id="country" name="country" required>
                            <option value="Malaysia" <c:if test="${savedAddress.country eq 'Malaysia'}">selected</c:if>>Malaysia</option>
                            </select>
                        </div>

                        <div class="col-md-4">
                            <label for="state" class="form-label">State</label>
                            <select class="form-select" id="state" name="state" required>
                                <option value="">Choose...</option>
                                <option <c:if test="${savedAddress.state eq 'Selangor'}">selected</c:if>>Selangor</option>
                            <option <c:if test="${savedAddress.state eq 'Kuala Lumpur'}">selected</c:if>>Kuala Lumpur</option>
                            <option <c:if test="${savedAddress.state eq 'Penang'}">selected</c:if>>Penang</option>
                            </select>
                        </div>

                        <div class="col-md-3">
                            <label for="zip" class="form-label">Postcode</label>
                            <input type="text" class="form-control" id="zip" name="zip" value="${savedAddress.postalCode}" required>
                    </div>
                </div>

                <hr class="my-4">

                <h4 class="mb-3">Payment</h4>
                <div class="my-3">
                    <div class="form-check">
                        <input id="credit" name="paymentMethod" type="radio" class="form-check-input" value="CREDIT" checked required>
                        <label class="form-check-label" for="credit">
                            <i class="fab fa-cc-mastercard pe-1"></i> Credit card
                        </label>
                    </div>
                    <div class="form-check">
                        <input id="debit" name="paymentMethod" type="radio" class="form-check-input" value="DEBIT" required>
                        <label class="form-check-label" for="debit">
                            <i class="fab fa-cc-visa pe-1"></i> Debit card
                        </label>
                    </div>
                    <div class="form-check">
                        <input id="ewallet" name="paymentMethod" type="radio" class="form-check-input" value="E-WALLET" required>
                        <label class="form-check-label" for="ewallet">
                            <i class="fas fa-qrcode pe-1"></i> E-Wallet
                        </label>
                    </div>
                </div>

                <div class="row gy-3">
                    <div class="col-md-6">
                        <label for="cc-name" class="form-label">Name on card</label>
                        <input type="text" class="form-control" id="cc-name" name="ccName" value="${savedCard.cardholderName}" required minlength="2" maxlength="100">
                    </div>
                    <div class="col-md-6">
                        <label for="cc-number" class="form-label">Card number</label>
                        <input type="text" class="form-control" id="cc-number" name="ccNumber" value="${savedCard.cardNumber}" required pattern="\d{16}" maxlength="16" title="Card number must be 16 digits">
                    </div>
                    <div class="col-md-3">
                        <label class="form-label">Expiry Month</label>
                        <input type="number" class="form-control" name="expiryMonth" value="${savedCard.expiryMonth}" min="1" max="12" required />
                    </div>
                    <div class="col-md-3">
                        <label class="form-label">Expiry Year</label>
                        <input type="number" class="form-control" name="expiryYear" value="${savedCard.expiryYear}" min="2024" required />
                    </div>
                    <div class="col-md-3">
                        <label for="cc-cvv" class="form-label">CVV</label>
                        <input type="text" class="form-control" id="cc-cvv" name="ccCVV" required pattern="\d{3,4}" maxlength="4">
                    </div>
                </div>

                <!-- Check Save Information -->
                <hr class="my-4">
                <div class="form-check mb-2">
                    <input class="form-check-input" type="checkbox" id="saveAddress" name="saveAddress" <c:if test="${isFirstTime}">checked</c:if>>
                        <label class="form-check-label" for="saveAddress">
                            Save this address for future checkout
                        </label>
                    </div>
                    <div class="form-check mb-4">
                        <input class="form-check-input" type="checkbox" id="saveCard" name="saveCard" <c:if test="${isFirstTime}">checked</c:if>>
                        <label class="form-check-label" for="saveCard">
                            Save this card for future checkout
                        </label>
                    </div>

                    <div class="alert alert-info">
                        <small>
                            ✔️ If checked, your address and card info will be saved for next time.<br>
                            ⚠️ If you change the info and keep it checked, your saved data will be updated.
                        </small>
                    </div>

                    <!-- Checkout Button -->
<button id="checkoutButton" class="w-100 btn btn-success btn-lg" type="submit">
    <i class="fas fa-lock me-2"></i>Checkout & Pay <span id="checkoutAmount">RM<fmt:formatNumber value="${grandTotal}" minFractionDigits="2"/></span>
</button>
            </form>
        </div>
    </div>
</div>

<!-- QR Checkout Modal -->
<div class="modal fade" id="qrModal" tabindex="-1" aria-labelledby="qrModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-success">
            <div class="modal-header">
                <h5 class="modal-title" id="qrModalLabel">E-Wallet QR Payment</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body text-center">
                <p>Please scan the QR code below using your preferred e-wallet:</p>
                <img src="assets/img/qr.jpg" alt="QR Code" width="180" class="mb-3" />
                <p class="text-muted small">Supported: Touch 'n Go</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-success w-100" onclick="submitCheckoutForm()">I've Paid, Proceed</button>
            </div>
        </div>
    </div>
</div>

<script>
    document.addEventListener("DOMContentLoaded", function () {
        const radios = document.querySelectorAll('input[name="paymentMethod"]');
        const modalTrigger = document.createElement('button');
        modalTrigger.type = 'button';
        modalTrigger.style.display = 'none';
        modalTrigger.setAttribute('data-bs-toggle', 'modal');
        modalTrigger.setAttribute('data-bs-target', '#qrModal');
        document.body.appendChild(modalTrigger);

        const saveCardCheckbox = document.getElementById('saveCard');
        const cardFields = document.querySelectorAll('#cc-name, #cc-number, input[name="expiryMonth"], input[name="expiryYear"], #cc-cvv');

        function hideCardFields() {
            cardFields.forEach(f => {
                f.readOnly = true;
                f.closest('.col-md-3, .col-md-6')?.classList.add('d-none');
            });
        }

        function showCardFields() {
            cardFields.forEach(f => {
                f.readOnly = false;
                f.closest('.col-md-3, .col-md-6')?.classList.remove('d-none');
            });
        }

        function toggleCardFields() {
            const selected = document.querySelector('input[name="paymentMethod"]:checked');
            if (selected?.value === "E-WALLET") {
                saveCardCheckbox.checked = false;
                hideCardFields();
                modalTrigger.click();
            } else {
                showCardFields();
            }
        }

        radios.forEach(r => r.addEventListener("change", toggleCardFields));
        toggleCardFields();
    });

    function submitCheckoutForm() {
        document.querySelector('form.needs-validation').submit();
    }

function applyPromo(event) {
    event.preventDefault();
    const promoInput = document.getElementById("promoCode");
    const promoCode = promoInput.value.trim();
    const totalDisplay = document.getElementById("grandTotalDisplay");
    const originalTotal = parseFloat(document.getElementById("originalTotal").value);
    const promoMessage = document.getElementById("promoMessage");

    const discountInput = document.getElementById("hiddenDiscount");
    const hiddenPromoCode = document.getElementById("hiddenPromoCode");

    
    const checkoutAmount = document.getElementById("checkoutAmount");

    if (promoCode === "HelloWorld") {
        const newTotal = (originalTotal - 5).toFixed(2);
        totalDisplay.innerText = "RM" + newTotal;
        checkoutAmount.innerText = "RM" + newTotal;  
        discountInput.value = "5";
        hiddenPromoCode.value = promoCode;

        promoMessage.innerText = "✅ RM5 discount applied.";
        promoMessage.classList.remove("text-danger");
        promoMessage.classList.add("text-success");
    } else {
        totalDisplay.innerText = "RM" + originalTotal.toFixed(2);
        checkoutAmount.innerText = "RM" + originalTotal.toFixed(2);  
        discountInput.value = "0";
        hiddenPromoCode.value = "";

        promoMessage.innerText = "❌ Invalid promo code.";
        promoMessage.classList.remove("text-success");
        promoMessage.classList.add("text-danger");
    }
}


</script>

</div>
</div>


<jsp:include page="include/footer.jsp" />