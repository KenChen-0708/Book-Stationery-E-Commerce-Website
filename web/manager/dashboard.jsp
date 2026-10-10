<%@page contentType="text/html" pageEncoding="UTF-8"%>
<jsp:include page="../include/adminHeader.jsp" />

<%
    entity.Users user = (entity.Users) session.getAttribute("user");

    if (user == null || !user.getRole().equals("MANAGER")) {
        response.sendRedirect("../login.jsp");
        return;
    }
%>

<style>
    .card-link {
        text-decoration: none;
    }

    .card-hover {
        transition: transform 0.4s ease;
        cursor: pointer;
        overflow: hidden;
    }

    .card-hover:hover {
        transform: scale(1.05);
    }

    .card-desc {
        opacity: 0;
        max-height: 0;
        overflow: hidden;
        transition: opacity 0.5s ease, max-height 0.5s ease;
        margin-top: 10px;
    }

    .card-hover:hover .card-desc {
        opacity: 1;
        max-height: 100px;
    }
</style>

<!-- Dashboard Content -->
<div class="container my-5 w-50">
    <h2 class="mb-4 text-center">Manager Dashboard</h2>

    <!-- Manage Products -->
    <div class="row mb-4">
        <div class="col-12">
            <a href="/Assignment/ProductDataServlet" class="card-link">
                <div class="card text-white bg-primary card-hover">
                    <div class="card-body d-flex justify-content-center align-items-center flex-column text-center">
                        <h5 class="card-title">Manage Products</h5>
                        <p class="card-text card-desc">Add, update, or delete products.</p>
                    </div>
                </div>
            </a>
        </div>
    </div>

    <!-- Order -->
    <div class="row mb-4">
        <div class="col-12">
            <a href="manageOrders.jsp" class="card-link">
                <div class="card text-white bg-info card-hover">
                    <div class="card-body d-flex justify-content-center align-items-center flex-column text-center">
                        <h5 class="card-title">Manage Orders</h5>
                        <p class="card-text card-desc">View and manage feedback or order statuses.</p>
                    </div>
                </div>
            </a>
        </div>
    </div>

    <!--Review-->
    <div class="row mb-4">
        <div class="col-12">
            <a href="manageReview.jsp" class="card-link">
                <div class="card text-white bg-warning card-hover">
                    <div class="card-body d-flex justify-content-center align-items-center flex-column text-center">
                        <h5 class="card-title">Manage Review</h5>
                        <p class="card-text card-desc">View and manage reviews.</p>
                    </div>
                </div>
            </a>
        </div>
    </div>

    <!-- Manage User -->
    <div class="row mb-4">
        <div class="col-12">
            <a href="../UserDataServlet" class="card-link">
                <div class="card text-white bg-success card-hover">
                    <div class="card-body d-flex justify-content-center align-items-center flex-column text-center">
                        <h5 class="card-title">Manage User</h5>
                        <p class="card-text card-desc">View or manage customer/staff details.</p>
                    </div>
                </div>
            </a>
        </div>
    </div>

    <div class="row mb-4">
        <div class="col-12">
            <a href="../ReportServlet" class="card-link">
                <div class="card text-white bg-dark card-hover">
                    <div class="card-body d-flex justify-content-center align-items-center flex-column text-center">
                        <h5 class="card-title">Reports</h5>
                        <p class="card-text card-desc">View sales report and top product report.</p>
                    </div>
                </div>
            </a>
        </div>
    </div>

    <div class="row mb-4">
        <a href="/Assignment/manager/manageMessage.jsp" class="card-link">
            <div class="card text-white bg-danger card-hover overflow-hidden">
                <div class="card-body text-center">
                    <h5 class="card-title">Manage Inquiries</h5>
                    <p class="card-text card-desc">View and manage customer inquiries/messages.</p>
                </div>
            </div>
        </a>
    </div>
</div>



<jsp:include page="../include/adminFooter.jsp" />