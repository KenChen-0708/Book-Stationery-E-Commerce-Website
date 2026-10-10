<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="entity.Orders" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<jsp:include page="../include/adminHeader.jsp" />

<%
    entity.Users user = (entity.Users) session.getAttribute("user");
    if (user == null || !(user.getRole().equals("MANAGER") || user.getRole().equals("STAFF"))) {
        response.sendRedirect("../login.jsp");
        return;
    }

    if (request.getAttribute("ordersList") == null) {
        response.sendRedirect(request.getContextPath() + "/OrderServlet?action=list");
        return;
    }
%>

<div class="container my-5">
    <h2 class="text-center mb-4">Order Management</h2>

    <div class="row mb-3">
        <div class="col text-start">
            <button class="btn btn-warning" id="clearTableState">Reset Table</button>
        </div>
        <div class="col text-end">
            <button class="btn btn-primary" onclick="loadAddForm()">Add Order</button>
        </div>
    </div>

    <table id="orderTable" class="table table-striped table-bordered">
        <thead class="table-dark">
            <tr>
                <th>Order ID</th>
                <th>User</th>
                <th>Order Date</th>
                <th>Status</th>
                <th>Total Price</th>
                <th>Shipping Address</th>
                <th>Payment Method</th>
                <th>Shipping Fee</th>
                <th>Discount</th>
                <th>Transaction #</th>
                <th>Action</th>
            </tr>
            <tr class="filter-row">
                <th><input type="number" class="form-control form-control-sm" placeholder="Search ID"></th>
                <th><input type="text" class="form-control form-control-sm" placeholder="Search User"></th>
                <th><input type="text" class="form-control form-control-sm" placeholder="Search Date"></th>
                <th><input type="text" class="form-control form-control-sm" placeholder="Search Status"></th>
                <th><input type="number" class="form-control form-control-sm" placeholder="Search Price"></th>
                <th><input type="text" class="form-control form-control-sm" placeholder="Search Address"></th>
                <th><input type="text" class="form-control form-control-sm" placeholder="Search Payment"></th>
                <th><input type="number" class="form-control form-control-sm" placeholder="Search Fee"></th>
                <th><input type="number" class="form-control form-control-sm" placeholder="Search Discount"></th>
                <th><input type="text" class="form-control form-control-sm" placeholder="Search Trans #"></th>
                <th></th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="o" items="${ordersList}">
                <tr>
                    <td>${o.orderId}</td>
                    <td>${o.userId.username}</td>
                    <td>${o.orderDate}</td>
                    <td>${o.status}</td>
                    <td>${o.totalPrice}</td>
                    <td>${o.shippingAddress}</td>
                    <td>${o.paymentMethod}</td>
                    <td>${o.shippingFee}</td>
                    <td>${o.discount}</td>
                    <td>${o.transactionNumber}</td>
                    <td>
                        <button class="btn btn-sm btn-success me-1" data-bs-toggle="tooltip" title="Edit"
                                onclick="loadEditForm('${o.orderId}', '${o.orderDate}', '${o.status}', '${o.totalPrice}', '${o.shippingAddress}', '${o.paymentMethod}', '${o.shippingFee}', '${o.discount}', '${o.transactionNumber}')">
                            <i class="fas fa-edit"></i>
                        </button>
                        <button class="btn btn-sm btn-danger" data-bs-toggle="tooltip" title="Delete"
                                onclick="confirmDelete(${o.orderId})">
                            <i class="fas fa-trash-alt"></i>
                        </button>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
</div>

<!-- Order Form Modal -->
<div class="modal fade" id="orderModal" tabindex="-1" aria-labelledby="orderModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <form class="modal-content" method="post" action="OrderServlet">
            <div class="modal-header">
                <h5 class="modal-title" id="orderModalLabel">Order Form</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <input type="hidden" name="orderId" id="orderId">
                <input type="hidden" name="action" id="formAction" value="add">

                <input type="hidden" class="form-control" id="orderDate" name="orderDate" required>

                <div class="form-floating mb-3">
                    <div class="form-floating mb-3">
                        <select class="form-select" id="status" name="status" required>
                            <option value="PAID">PAID</option>
                            <option value="SHIPPED">SHIPPED</option>
                            <option value="DELIVERED">DELIVERED</option>
                        </select>
                        <label for="status">Status</label>
                    </div>
                </div>

                <div class="form-floating mb-3">
                    <input type="number" step="0.01" class="form-control" id="totalPrice" name="totalPrice" required>
                    <label for="totalPrice">Total Price</label>
                </div>

                <div class="form-floating mb-3">
                    <input type="text" class="form-control" id="shippingAddress" name="shippingAddress" required>
                    <label for="shippingAddress">Shipping Address</label>
                </div>

                <div class="form-floating mb-3">
                    <select class="form-select" id="paymentMethod" name="paymentMethod" required>
                        <option value="CREDIT">CREDIT</option>
                        <option value="DEBIT">DEBIT</option>
                        <option value="E-WALLET">E-WALLET</option>
                    </select>
                    <label for="paymentMethod">Payment Method</label>
                </div>

                <div class="form-floating mb-3">
                    <input type="number" step="0.01" class="form-control" id="shippingFee" name="shippingFee" required>
                    <label for="shippingFee">Shipping Fee</label>
                </div>

                <div class="form-floating mb-3">
                    <input type="number" step="0.01" class="form-control" id="discount" name="discount" required>
                    <label for="discount">Discount</label>
                </div>

                <div class="form-floating mb-3" id="transactionContainer" style="display: none;">
                    <input type="text" class="form-control" id="transactionNumber" name="transactionNumber">
                    <label for="transactionNumber">Transaction Number</label>
                </div>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                <button type="submit" class="btn btn-success">Save</button>
            </div>
        </form>
    </div>
</div>

<!-- Delete Confirmation Modal -->
<div class="modal fade" id="deleteModal" tabindex="-1" aria-labelledby="deleteModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <form method="post" action="OrderServlet" class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="deleteModalLabel">Confirm Deletion</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                Are you sure you want to delete this order?
                <input type="hidden" name="action" value="delete">
                <input type="hidden" name="id" id="deleteOrderId">
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                <button type="submit" class="btn btn-danger">Yes, Delete</button>
            </div>
        </form>
    </div>
</div>

<script>
    $(document).ready(function () {
        const table = $('#orderTable').DataTable({
            dom: '<"row mb-3"<"col-md-4"l><"col-md-4 text-center"B><"col-md-4"f>>' +
                    '<"row"<"col-12"tr>>' +
                    '<"row mt-3"<"col-md-6"i><"col-md-6"p>>',
            buttons: ['copy', 'csv', 'excel', 'pdf', 'print'],
            colReorder: {realtime: false, fixedColumnsLeft: 1},
            paging: true,
            lengthMenu: [5, 10, 25, 50],
            pageLength: 5,
            ordering: true,
            searching: true,
            info: true,
            stateSave: true,
            responsive: true,
            keys: true,
            order: [[0, 'asc']],
            autoWidth: true

//            columnDefs: [
//                { targets: 0, width: '5%' },  // Order ID
//                { targets: 1, width: '10%' },
//                { targets: 2, width: '10%' },
//                { targets: 3, width: '10%' },
//                { targets: 4, width: '10%' },
//                { targets: 5, width: '12%' },
//                { targets: 6, width: '10%' },
//                { targets: 7, width: '8%' },
//                { targets: 8, width: '8%' },
//                { targets: 9, width: '10%' },
//                { targets: 10, width: '7%' }
//            ]
        });

        $('#orderTable thead tr.filter-row th').each(function (i) {
            $('input', this).on('keyup change', function () {
                if (table.column(i).search() !== this.value) {
                    table.column(i).search(this.value).draw();
                }
            });
        });

        $('#orderTable thead input').on('click', function (e) {
            e.stopImmediatePropagation();
        });

        // Tooltips
        document.querySelectorAll('[data-bs-toggle="tooltip"]').forEach(el => new bootstrap.Tooltip(el));
    });

    function loadAddForm() {
        $('#orderId, #status, #totalPrice, #shippingAddress, #paymentMethod, #shippingFee, #discount').val('');

        const now = new Date();
        const currentDate = now.toString();
        $('#orderDate').val(currentDate);


        const hex = Math.floor(Math.random() * 0xFFFFFFFF).toString(16).toUpperCase().padStart(8, '0');
        const txnNumber = 'TXN-' + hex;
        $('#transactionNumber').val(txnNumber);
        $('#transactionContainer').hide();

        $('#formAction').val('add');
        $('#orderModalLabel').text('Add Order');
        $('#orderModal').modal('show');
    }

    function loadEditForm(orderId, orderDate, status, totalPrice, shippingAddress, paymentMethod, shippingFee, discount, transactionNumber) {
        $('#orderId').val(orderId);
        $('#orderDate').val(orderDate);
        $('#status').val(status);
        $('#totalPrice').val(totalPrice);
        $('#shippingAddress').val(shippingAddress);
        $('#paymentMethod').val(paymentMethod);
        $('#shippingFee').val(shippingFee);
        $('#discount').val(discount);
        $('#transactionNumber').val(transactionNumber);

        $('#formAction').val('edit');
        $('#orderModalLabel').text('Edit Order');

        $('#transactionContainer').show(); // show transaction number for editing

        $('#orderModal').modal('show');
    }



    function confirmDelete(orderId) {
        $('#deleteOrderId').val(orderId);
        $('#deleteModal').modal('show');
    }

    $('#clearTableState').on('click', function () {
        const table = $('#orderTable').DataTable();
        table.state.clear();
        $('#orderTable thead tr.filter-row input').each(function () {
            $(this).val('');
            const colIndex = $(this).closest('th').index();
            table.column(colIndex).search('').draw();
        });
        table.order([0, 'asc']).draw();
        window.location.href = 'OrderServlet';
    });
</script>
<jsp:include page="../include/adminFooter.jsp" />