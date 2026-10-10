<%@page import="entity.Users"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.text.SimpleDateFormat, java.util.Date"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="include/header.jsp" />
<jsp:useBean id="order" class="entity.Orders" scope="request" />

<%
    Users user = (Users) session.getAttribute("user");

    if (user == null || !"CUSTOMER".equals(user.getRole())) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    if (order.getOrderId() == null){
        response.sendRedirect("index.jsp");
        return;
    }
%>

 
<style>

    .card-success {
        border: none;
        border-radius: 20px;
        background: #fff;
        transition: all 0.3s ease-in-out;
        padding: 40px 30px;
    }

    .card-success:hover {
        box-shadow: 0 8px 30px rgba(0, 0, 0, 0.1);
    }

    .icon-circle {
        background: #d1fae5;
        border-radius: 50%;
        width: 80px;
        height: 80px;
        display: flex;
        align-items: center;
        justify-content: center;
        margin: 0 auto 20px;
        animation: pop 0.4s ease-out;
    }

    .icon-circle i {
        font-size: 32px;
    }

    @keyframes pop {
        0% { transform: scale(0.5); opacity: 0; }
        100% { transform: scale(1); opacity: 1; }
    }

    .btn-outline-success {
        transition: 0.3s;
    }

    .btn-outline-success:hover {
        background: #198754;
        color: #fff;
        transform: scale(1.03);
    }

    .order-list .list-group-item {
        background-color: #f8f9fa;
        border: none;
        padding: 15px 20px;
    }

    .order-list .fw-bold {
        font-size: 1.1rem;
    }
</style>

<div class="container my-5">
    <div class="row justify-content-center text-center">
        <div class="col-lg-6">
            <div class="card card-success shadow-lg">
                <div class="icon-circle text-success">
                    <i class="fas fa-check"></i>
                </div>
                <h2 class="fw-bold text-success mb-3">Payment Successful!</h2>
                <p class="text-muted mb-4">Thank you for your purchase. Your order has been confirmed and is now being processed.</p>

                <div class="order-list bg-white rounded p-4 text-start shadow-sm">
                    <h5 class="mb-4 fw-semibold text-success border-bottom pb-2">Order Summary</h5>
                    <ul class="list-group list-group-flush mb-3">
                        <li class="list-group-item d-flex justify-content-between">
                            <span>Order Date</span>
                            <span><jsp:getProperty name="order" property="orderDate" /></span>
                        </li>
                        <li class="list-group-item d-flex justify-content-between">
                            <span>Order ID</span>
                            <span><jsp:getProperty name="order" property="orderId" /></span>
                        </li>
                        <li class="list-group-item d-flex justify-content-between fw-bold">
                            <span>Total Paid</span>
                            <span class="text-success">RM <jsp:getProperty name="order" property="totalPrice" /></span>
                        </li>
                    </ul>
                </div>

                <a href="shop.jsp" class="btn btn-outline-success mt-4 px-4 py-2">
                    <i class="fas fa-shopping-bag me-2"></i> Continue Shopping
                </a>
            </div>
        </div>
    </div>
</div>

<jsp:include page="include/footer.jsp" />
