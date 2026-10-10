<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<jsp:include page="include/header.jsp" />

<%
    if (request.getAttribute("cardList") == null) {
        response.sendRedirect("CardServlet?action=list");
        return;
    }
%>


<style>
    .img-account-profile {
        height: 10rem;
    }
    .rounded-circle {
        border-radius: 50% !important;
    }
    .card {
        box-shadow: 0 0.15rem 1.75rem 0 rgb(33 40 50 / 15%);
    }
    .card .card-header {
        font-weight: 500;
    }
    .card-header:first-child {
        border-radius: 0.35rem 0.35rem 0 0;
    }
    .card-header {
        padding: 1rem 1.35rem;
        margin-bottom: 0;
        background-color: rgba(33, 40, 50, 0.03);
        border-bottom: 1px solid rgba(33, 40, 50, 0.125);
    }
    .form-control, .dataTable-input {
        display: block;
        width: 100%;
        padding: 0.875rem 1.125rem;
        font-size: 0.875rem;
        font-weight: 400;
        line-height: 1;
        color: #69707a;
        background-color: #fff;
        background-clip: padding-box;
        border: 1px solid #c5ccd6;
        -webkit-appearance: none;
        -moz-appearance: none;
        appearance: none;
        border-radius: 0.35rem;
        transition: border-color 0.15s ease-in-out, box-shadow 0.15s ease-in-out;
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
    .fa-2x {
        font-size: 2em;
    }

    .table-billing-history th, .table-billing-history td {
        padding-top: 0.75rem;
        padding-bottom: 0.75rem;
        padding-left: 1.375rem;
        padding-right: 1.375rem;
    }
    .table > :not(caption) > * > *, .dataTable-table > :not(caption) > * > * {
        padding: 0.75rem 0.75rem;
        background-color: var(--bs-table-bg);
        border-bottom-width: 1px;
        box-shadow: inset 0 0 0 9999px var(--bs-table-accent-bg);
    }

    .border-start-primary {
        border-left-color: #0061f2 !important;
    }
    .border-start-secondary {
        border-left-color: #6900c7 !important;
    }
    .border-start-success {
        border-left-color: #00ac69 !important;
    }
    .border-start-lg {
        border-left-width: 0.25rem !important;
    }
    .h-100 {
        height: 100% !important;
    }
</style>

<section style="background-color: #eee;">
    <div class="container py-5">
        <nav class="nav nav-borders">
            <a class="nav-link ms-0" href="profile.jsp">User Profile</a>
            <a class="nav-link" href="WishlistServlet">Wishlist</a>
            <a class="nav-link" href="OrderStatus.jsp">My Order</a>
            <a class="nav-link ${'billing'.equals(activeTab) ? 'active' : ''}" href="CardServlet?action=list">Billing & Card</a>
        </nav>
        <hr class="mt-0 mb-4">

        <!-- Payment methods card-->
        <div class="card card-header-actions mb-4">
            <div class="card-header">
                Payment Methods
                <button class="btn btn-sm btn-primary" data-bs-toggle="modal" data-bs-target="#addCardModal">Add Payment Method</button>
            </div>
            <div class="card-body px-0">
                <c:forEach var="card" items="${cardList}">
                    <div class="d-flex align-items-center justify-content-between px-4">
                        <div class="d-flex align-items-center">
                            <c:choose>
                                <c:when test="${card.paymentMethod == 'CREDIT'}">
                                    <i class="fab fa-cc-mastercard fa-2x text-dark"></i>
                                </c:when>
                                <c:otherwise>
                                    <i class="fab fa-cc-visa fa-2x text-dark"></i>
                                </c:otherwise>
                            </c:choose>
                            <div class="ms-4">
                                <div class="small">
                                    ${card.cardholderName} ending in ${fn:substring(card.cardNumber, fn:length(card.cardNumber)-4, fn:length(card.cardNumber))}
                                </div>
                                <div class="text-xs text-muted">
                                    Expires ${card.expiryMonth}/${card.expiryYear}
                                </div>
                            </div>
                        </div>
                        <div class="ms-4 small">
                            <c:if test="${card.isDefault}">
                                <div class="badge bg-light text-dark me-3">Default</div>
                            </c:if>
                            <a href="#editCardModal${card.cardId}" data-bs-toggle="modal">Edit</a>
                            &nbsp;|
                            <a href="#" class="text-danger" data-bs-toggle="modal" data-bs-target="#deleteCardModal${card.cardId}">Delete</a>
                        </div>
                    </div>
                    <hr>

                    <!-- Delete Confirmation Modal -->
                    <div class="modal fade" id="deleteCardModal${card.cardId}" tabindex="-1" aria-labelledby="deleteCardModalLabel${card.cardId}" aria-hidden="true">
                        <div class="modal-dialog">
                            <div class="modal-content">
                                <form action="CardServlet" method="get">
                                    <input type="hidden" name="action" value="delete">
                                    <input type="hidden" name="id" value="${card.cardId}">
                                    <div class="modal-header">
                                        <h5 class="modal-title" id="deleteCardModalLabel${card.cardId}">Confirm Delete</h5>
                                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                    </div>
                                    <div class="modal-body">
                                        Are you sure you want to delete this card?<br>
                                        <strong>${card.cardholderName}</strong> ending in <strong>${fn:substring(card.cardNumber, fn:length(card.cardNumber)-4, fn:length(card.cardNumber))}</strong>
                                    </div>
                                    <div class="modal-footer">
                                        <button type="submit" class="btn btn-danger">Yes</button>
                                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>

                    <!-- Edit Modal for each card -->
                    <div class="modal fade" id="editCardModal${card.cardId}" tabindex="-1">
                        <div class="modal-dialog">
                            <div class="modal-content">
                                <form action="CardServlet?action=update" method="post">
                                    <div class="modal-header">
                                        <h5 class="modal-title">Edit Card</h5>
                                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                    </div>
                                    <div class="modal-body">
                                        <input type="hidden" name="cardId" value="${card.cardId}" />
                                        <div class="mb-3">
                                            <label class="form-label">Cardholder Name</label>
                                            <input type="text" class="form-control" name="cardholderName" value="${card.cardholderName}" required minlength="2" maxlength="100" />
                                        </div>
                                        <div class="mb-3">
                                            <label class="form-label">Card Number</label>
                                            <input type="text" class="form-control" name="cardNumber" value="${card.cardNumber}" required pattern="\d{16}" maxlength="16" title="Card number must be 16 digits" />
                                        </div>
                                        <div class="row">
                                            <div class="col">
                                                <label class="form-label">Expiry Month</label>
                                                <input type="number" class="form-control" name="expiryMonth" value="${card.expiryMonth}" min="1" max="12" required />
                                            </div>
                                            <div class="col">
                                                <label class="form-label">Expiry Year</label>
                                                <input type="number" class="form-control" name="expiryYear" value="${card.expiryYear}" min="2024" required />
                                            </div>
                                        </div>
                                        <div class="mb-3 mt-3">
                                            <label class="form-label">Billing Address</label>
                                            <textarea class="form-control" name="billingAddress" rows="2" maxlength="255">${card.billingAddress}</textarea>
                                        </div>
                                        <div class="mb-3">
                                            <label class="form-label">Payment Method</label><br>
                                            <div class="form-check form-check-inline">
                                                <input class="form-check-input" type="radio" name="paymentMethod" id="editDebitOption${card.cardId}" value="DEBIT" ${card.paymentMethod == 'DEBIT' ? 'checked' : ''}>
                                                <label class="form-check-label" for="editDebitOption${card.cardId}">
                                                    <i class="fab fa-cc-visa me-1"></i> Debit
                                                </label>
                                            </div>
                                            <div class="form-check form-check-inline">
                                                <input class="form-check-input" type="radio" name="paymentMethod" id="editCreditOption${card.cardId}" value="CREDIT" ${card.paymentMethod == 'CREDIT' ? 'checked' : ''}>
                                                <label class="form-check-label" for="editCreditOption${card.cardId}">
                                                    <i class="fab fa-cc-mastercard me-1"></i> Credit
                                                </label>
                                            </div>
                                        </div>
                                        <div class="form-check">
                                            <input class="form-check-input" type="checkbox" name="isDefault" ${card.isDefault ? 'checked' : ''} />
                                            <label class="form-check-label">Set as default</label>
                                        </div>
                                    </div>
                                    <div class="modal-footer">
                                        <button type="submit" class="btn btn-primary">Update Card</button>
                                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>

        <!-- Billing history card -->
        <div class="card mb-4">
            <div class="card-header">Billing History</div>
            <div class="card-body p-0">
                <div class="table-responsive table-billing-history">
                    <table class="table mb-0">
                        <thead>
                            <tr>
                                <th>Transaction ID</th>
                                <th>Date</th>
                                <th>Amount</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${empty orderList}">
                                    <tr>
                                        <td colspan="3" class="text-center text-muted py-3">You haven't purchased the product yet</td>
                                    </tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="order" items="${orderList}">
                                        <tr>
                                            <td>${order.transactionNumber}</td>
                                            <td>${order.orderDate}</td>
                                            <td>$${order.totalPrice}</td>
                                        </tr>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
</section>

<!-- Add Card Modal -->
<div class="modal fade" id="addCardModal" tabindex="-1" aria-labelledby="addCardModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <form action="CardServlet?action=add" method="post">
                <div class="modal-header">
                    <h5 class="modal-title" id="addCardModalLabel">Add Payment Method</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger">${error}</div>
                    </c:if>
                    <div class="mb-3">
                        <label class="form-label">Cardholder Name</label>
                        <input type="text" class="form-control" name="cardholderName" required minlength="2" maxlength="100" />
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Card Number</label>
                        <input type="text" class="form-control" name="cardNumber" required pattern="\d{16}" maxlength="16" title="Card number must be 16 digits" />
                    </div>
                    <div class="row">
                        <div class="col">
                            <label class="form-label">Expiry Month</label>
                            <input type="number" class="form-control" name="expiryMonth" min="1" max="12" required />
                        </div>
                        <div class="col">
                            <label class="form-label">Expiry Year</label>
                            <input type="number" class="form-control" name="expiryYear" min="2024" required />
                        </div>
                    </div>
                    <div class="mb-3 mt-3">
                        <label class="form-label">Billing Address</label>
                        <textarea class="form-control" name="billingAddress" rows="2" maxlength="255"></textarea>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Payment Method</label><br>
                        <div class="form-check form-check-inline">
                            <input class="form-check-input" type="radio" name="paymentMethod" id="debitOption" value="DEBIT" checked>
                            <label class="form-check-label" for="debitOption">
                                <i class="fab fa-cc-visa fa-lg"></i> Debit
                            </label>
                        </div>
                        <div class="form-check form-check-inline">
                            <input class="form-check-input" type="radio" name="paymentMethod" id="creditOption" value="CREDIT">
                            <label class="form-check-label" for="creditOption">
                                <i class="fab fa-cc-mastercard fa-lg"></i> Credit
                            </label>
                        </div>
                    </div>
                    <div class="form-check">
                        <input class="form-check-input" type="checkbox" name="isDefault" />
                        <label class="form-check-label">Set as default</label>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="submit" class="btn btn-primary">Save Card</button>
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                </div>
            </form>
        </div>
    </div>
</div>

<jsp:include page="include/footer.jsp" />