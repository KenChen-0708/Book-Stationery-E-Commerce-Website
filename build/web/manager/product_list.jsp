<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="entity.Product" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<jsp:include page="../include/adminHeader.jsp" />

<%
    entity.Users user = (entity.Users) session.getAttribute("user");

    if (user == null || !(user.getRole().equals("MANAGER") || user.getRole().equals("STAFF"))) {
        response.sendRedirect("../login.jsp");
        return;
    }
%>

<%
    if (request.getAttribute("productList") == null) {
        response.sendRedirect(request.getContextPath() + "/ProductDataServlet?action=list");
        return;
    }
%>

<div class="container my-5">
    <h2 class="text-center mb-4">Product Management</h2>
    <div class="row mb-3">
        <div class="col text-start">
            <button class="btn btn-warning" id="clearTableState">Reset Table</button>
        </div>
        <div class="col text-end">
            <button class="btn btn-primary" onclick="loadAddForm()">Add Product</button>
        </div>
    </div>


    <form method="post" action="ProductDataServlet">
        <table id="productTable" class="table table-striped table-bordered">
            <thead class="table-dark">
                <tr>
                    <th>ID</th>
                    <th>Name</th>
                    <th>Image</th>
                    <th>Price</th>
                    <th>Stock</th>
                    <th>Main Category</th>
                    <th>Sub Category</th>
                    <th>Action</th>
                </tr>

                <tr class="filter-row">
                    <th><input type="number" min="1" class="form-control form-control-sm" name="id" value="${id}" placeholder="Search ID"></th>
                    <th><input type="text" class="form-control form-control-sm" name="name" value="${name}" placeholder="Search Name"></th>
                    <th></th>
                    <th><input type="number" min="0" class="form-control form-control-sm" name="price" value="${price}" placeholder="Search Price"></th>
                    <th><input type="number" min="0" class="form-control form-control-sm" name="stock" value="${stock}" placeholder="Search Stock"></th>
                    <th>
                        <select class="form-select form-select-sm" name="mainCategory" onchange="this.form.submit()">
                            <option value="">All Main Categories</option>
                            <c:forEach var="cat" items="${mainCategoryList}">
                                <option value="${cat}" <c:if test="${cat == selectedMainCategory}">selected</c:if>>${cat}</option>
                            </c:forEach>
                        </select>
                    </th>
                    <th>
                        <input type="hidden" name="mainCategory" value="${selectedMainCategory}" />
                        <select class="form-select form-select-sm" name="subCategory" onchange="this.form.submit()">
                            <option value="">All Sub Categories</option>
                            <c:forEach var="cat" items="${subCategoryList}">
                                <option value="${cat}" <c:if test="${cat == selectedSubCategory}">selected</c:if>>${cat}</option>
                            </c:forEach>
                        </select>
                    </th>
                    <th></th>
                </tr>
            </thead>

            <tbody>
                <c:forEach var="p" items="${productList}">
                    <tr>
                        <td class="fw-bolder">${p.productId}</td>
                        <td>${p.name}</td>
                        <td><img src="${pageContext.request.contextPath}/${p.imageUrl}" width="60"></td>
                        <td>${p.price}</td>
                        <td>${p.stock}</td>
                        <td>${p.categoryMain}</td>
                        <td>${p.categorySub}</td>
                        <td>
                            <!-- Edit Button -->
                            <button type="button" class="btn btn-sm btn-success me-1"
                                    data-bs-toggle="tooltip" data-bs-placement="top" title="Edit"
                                    onclick="loadEditForm('${p.productId}', '${p.name}', '${p.price}', '${p.stock}', '${p.categoryMain}', '${p.categorySub}', '${p.description}', '${p.imageUrl}')">
                                <i class="fas fa-edit"></i>
                            </button>

                            <!-- Delete Button -->
                            <button type="button" class="btn btn-sm btn-danger"
                                    data-bs-toggle="tooltip" data-bs-placement="top" title="Delete"
                                    onclick="confirmDelete(${user.userId})">
                                <i class="fas fa-trash-alt"></i>
                            </button>

                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </form>
</div>

<!-- Modal -->
<div class="modal fade" id="productModal" tabindex="-1" aria-labelledby="productModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <form class="modal-content" method="post" action="ProductDataServlet" enctype="multipart/form-data">
            <div class="modal-header">
                <h5 class="modal-title" id="productModalLabel">Product Form</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <input type="hidden" name="id" id="id">
                <input type="hidden" name="action" id="formAction" value="add">
                <input type="hidden" name="existingImage" id="existingImage">

                <div class="form-floating mb-3">
                    <input type="text" class="form-control" id="name" name="name" placeholder="Name" required>
                    <label for="name">Name</label>
                </div>

                <div class="form-floating mb-3">
                    <input type="number" step="0.01" class="form-control" id="price" name="price" placeholder="Price" required>
                    <label for="price">Price</label>
                </div>

                <div class="form-floating mb-3">
                    <input type="number" class="form-control" id="stock" name="stock" placeholder="Stock" required>
                    <label for="stock">Stock</label>
                </div>

                <div class="form-floating mb-3">
                    <input type="text" class="form-control" id="categoryMain" name="categoryMain" placeholder="Main Category" required>
                    <label for="categoryMain">Main Category</label>
                </div>

                <div class="form-floating mb-3">
                    <input type="text" class="form-control" id="categorySub" name="categorySub" placeholder="Sub Category" required>
                    <label for="categorySub">Sub Category</label>
                </div>

                <div class="form-floating mb-3">
                    <textarea class="form-control" id="description" name="description" placeholder="Description"
                              style="height: 100px"></textarea>
                    <label for="description">Description</label>
                </div>

                <div class="mb-3">
                    <label for="image" class="form-label">Product Image</label>
                    <input type="file" class="form-control" id="image" name="image" accept=".jpg,.jpeg,.png">
                    <img id="previewImage" src="" class="img-thumbnail mt-2" style="width: 100px; display: none"/>
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
        <form method="post" action="ProductDataServlet" class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="deleteModalLabel">Confirm Deletion</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                Are you sure you want to delete this product?
                <input type="hidden" name="action" value="delete">
                <input type="hidden" name="id" id="deleteProductId">
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
        const table = $('#productTable').DataTable({
            dom: '<"row mb-3"' +
                    '<"col-md-4"l>' +
                    '<"col-md-4 text-center"B>' +
                    '<"col-md-4"f>' +
                    '>' +
                    '<"row"<"col-12"tr>>' +
                    '<"row mt-3"<"col-md-6"i><"col-md-6"p>>',
            buttons: ['copy', 'csv', 'excel', 'pdf', 'print'],
            colReorder: {
                realtime: false,
                fixedColumnsLeft: 1
            },
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
            columnDefs: [
                {targets: 0, width: '10%'}, // ID
                {targets: 1, width: '20%'}, // Name
                {targets: 2, width: '6%'}, // Image
                {targets: 3, width: '13%'}, // Price
                {targets: 4, width: '13%'}, // Stock
                {targets: 5, width: '15%'}, // Main Category
                {targets: 6, width: '15%'}, // Sub Category
                {targets: 7, width: '7%'}   // Actions
            ]
        });

        // Column filtering
        $('#productTable thead tr.filter-row th').each(function (i) {
            $('input', this).on('keyup change', function () {
                if (table.column(i).search() !== this.value) {
                    table.column(i).search(this.value).draw();
                }
            });
        });

        // Prevent filter inputs from triggering sort
        $('#productTable thead input').on('click', function (e) {
            e.stopImmediatePropagation();
        });

        // Override column search to match exact value
        function exactMatch(columnIndex, value) {
            // Escape special regex characters in value
            const escapedValue = '^' + $.fn.dataTable.util.escapeRegex(value) + '$';
            $('#productTable').DataTable().column(columnIndex).search(value ? escapedValue : '', true, false).draw();
        }

        // Exact match for Main Category
        $('#mainCatFilter').on('change', function () {
            exactMatch(5, this.value); // Column 5 = Main Category
        });

        // Exact match for Sub Category
        $('#subCatFilter').on('change', function () {
            exactMatch(6, this.value); // Column 6 = Sub Category
        });

        // Prevent dropdown clicks from sorting
        $('#productTable thead select').on('click', function (e) {
            e.stopImmediatePropagation();
        });

    });


    function loadAddForm() {
        $('#id').val('');
        $('#name').val('');
        $('#price').val('');
        $('#stock').val('');
        $('#categoryMain').val('');
        $('#categorySub').val('');
        $('#description').val('');
        $('#existingImage').val('');
        $('#previewImage').hide();
        $('#formAction').val('add');
        $('#image').replaceWith($('#image').clone().val(''));
        $('#productModal').modal('show');
    }

    function loadEditForm(id, name, price, stock, categoryMain, categorySub, description, imageUrl) {
        $('#id').val(id);
        $('#name').val(name);
        $('#price').val(price);
        $('#stock').val(stock);
        $('#categoryMain').val(categoryMain);
        $('#categorySub').val(categorySub);
        $('#description').val(description);
        $('#existingImage').val(imageUrl);
        $('#previewImage').attr("src", "${pageContext.request.contextPath}/" + imageUrl).show();
        $('#formAction').val('edit');
        $('#image').replaceWith($('#image').clone().val(''));
        $('#productModal').modal('show');
    }


    function confirmDelete(productId) {
        $('#deleteProductId').val(productId);
        $('#deleteModal').modal('show');
    }


    $('#image').on('change', function () {
        const [file] = this.files;
        if (file) {
            const reader = new FileReader();
            reader.onload = function (e) {
                $('#previewImage').attr('src', e.target.result).show();
            };
            reader.readAsDataURL(file);
        }
    });
</script>

<!--Clear DataTable state, category filters, and reload the page-->
<script>
    $('#clearTableState').on('click', clearTableState);

    function clearTableState(e) {
        if (e)
            e.preventDefault(); // Prevent the form from submitting immediately

        const table = $('#productTable').DataTable();

        // Clear DataTables saved state
        table.state.clear();

        // Clear input filters
        $('#productTable thead tr.filter-row input').each(function () {
            $(this).val('');
            const colIndex = $(this).closest('th').index();
            table.column(colIndex).search('').draw();
        });

        // Reset dropdowns
        $('select[name="mainCategory"]').val('');
        $('#subCatFilter').val('');

        table.order([0, 'asc']).draw();

        // Redirect manually
        window.location.href = 'ProductDataServlet';

        return false; // prevent default form submission
    }


</script>

<!--tooltips-->
<script>
    document.addEventListener('DOMContentLoaded', function () {
        var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
        var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
            return new bootstrap.Tooltip(tooltipTriggerEl);
        });
    });
</script>

<jsp:include page="../include/adminFooter.jsp" />