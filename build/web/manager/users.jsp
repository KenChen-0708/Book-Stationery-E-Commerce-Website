<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="da.GenericDA" %>
<%@ page import="entity.Users" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<jsp:include page="../include/adminHeader.jsp" />

<%

    entity.Users user = (entity.Users) session.getAttribute("user");

    if (user == null || !user.getRole().equals("MANAGER")) {
        response.sendRedirect("../login.jsp");
        return;
    }

    if (request.getAttribute("userList") == null) {
        response.sendRedirect(request.getContextPath() + "/UserDataServlet");
        return;
    }
%>

<div class="container my-5">
    <h2 class="text-center mb-4">User Management</h2>
    <div class="row mb-3">
        <div class="col text-start">
            <button class="btn btn-warning" id="clearUserTableState">Reset Table</button>
        </div>
        <div class="col text-end">
            <button class="btn btn-primary" onclick="loadAddForm()">Add User</button>
        </div>
    </div>

    <table id="userTable" class="table table-striped table-bordered">
        <thead class="table-dark">

            <tr>
                <th>ID</th>
                <th>Username</th>
                <th>Password</th>
                <th>Email</th>
                <th>Phone</th>
                <th>Role</th>
                <th>Action</th>
            </tr>
            <tr class="filter-row">
                <th><input type="text" class="form-control form-control-sm" placeholder="Search ID"></th>
                <th><input type="text" class="form-control form-control-sm" placeholder="Search Username"></th>
                <th><input type="text" class="form-control form-control-sm" placeholder="Search Password"></th>
                <th><input type="text" class="form-control form-control-sm" placeholder="Search Email"></th>
                <th><input type="text" class="form-control form-control-sm" placeholder="Search Phone"></th>
                <th>
                    <select class="form-select form-select-sm" id="roleFilter">
                        <option value="">All Roles</option>
                        <c:forEach var="role" items="${roleList}">
                            <option value="${role}">${role}</option>
                        </c:forEach>
                    </select>
                </th>
                <th></th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="user" items="${userList}">
                <tr>
                    <td class="fw-bolder">${user.userId}</td>
                    <td>${user.username}</td>
                    <td>
                        <div class="d-flex justify-content-between align-items-center">
                            <span class="password-mask" data-password="${user.password}">••••••••</span>
                            <button class="btn btn-sm btn-light toggle-password ms-2" type="button">
                                <i class="fa-regular fa-eye-slash"></i>
                            </button>
                        </div>
                    </td>

                    <td>${user.email}</td>
                    <td>${user.phone}</td>
                    <td>${user.role}</td>
                    <td>
                        <!-- Edit Button -->
                        <button class="btn btn-sm btn-success me-1"
                                data-bs-toggle="tooltip" data-bs-placement="top" title="Edit"
                                onclick="loadEditForm(${user.userId}, '${user.username}', '${user.email}', '${user.phone}', '${user.role}', '${user.password}')">
                            <i class="fas fa-edit"></i>
                        </button>

                        <!-- Delete Button -->
                        <button class="btn btn-sm btn-danger"
                                data-bs-toggle="tooltip" data-bs-placement="top" title="Delete"
                                onclick="confirmDelete(${user.userId})">
                            <i class="fas fa-trash-alt"></i>
                        </button>

                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
</div>

<!-- Modal for Add/Edit -->
<div class="modal fade" id="formModal" tabindex="-1" aria-labelledby="formModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <form id="userForm" class="modal-content" action="UserDataServlet" method="post">
            <div class="modal-header">
                <h5 class="modal-title" id="formModalLabel">User Form</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <input type="hidden" name="userId" id="userId">
                <input type="hidden" name="action" id="action" value="add">

                <div class="form-floating mb-3">
                    <input type="text" class="form-control" id="username" name="username" placeholder="Username" required>
                    <label for="username">Username</label>
                </div>

                <div class="form-floating mb-3">
                    <input type="email" class="form-control" id="email" name="email" placeholder="Email" required>
                    <label for="email">Email</label>
                </div>

                <div class="form-floating mb-3">
                    <input type="text" class="form-control" id="phone" name="phone" placeholder="Phone">
                    <label for="phone">Phone</label>
                </div>

                <div class="form-floating mb-3">
                    <select class="form-select" id="role" name="role" required>
                        <option value="CUSTOMER">Customer</option>
                        <option value="STAFF">Staff</option>
                        <option value="MANAGER">Manager</option>
                    </select>
                    <label for="role">Role</label>
                </div>

                <div class="mb-3 form-floating flex-fill mb-0 text-muted position-relative">
                    <input type="password" id="password" name="password" class="form-control" placeholder="password" required/>
                    <label class="form-label" for="password" id="password">Password</label>
                    <button class="btn btn-default reveal position-absolute" type="button" style="top: 50%; right: 0; transform: translateY(-50%);">
                        <i class="fa-regular fa-eye-slash"></i>
                    </button>
                </div>

                <div class="modal-footer pb-0">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-success">Save</button>
                </div>
            </div>
        </form>
    </div>
</div>

<!-- Delete Confirmation Modal -->
<div class="modal fade" id="deleteConfirmModal" tabindex="-1" aria-labelledby="deleteConfirmLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <form action="UserDataServlet" method="post" class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="deleteConfirmLabel">Confirm Deletion</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                Are you sure you want to delete this user?
                <input type="hidden" name="userId" id="deleteUserId">
                <input type="hidden" name="action" value="delete">
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                <button type="submit" class="btn btn-danger">Delete</button>
            </div>
        </form>
    </div>
</div>


<!--Modal-->
<script>

    function loadAddForm() {
        $('#userForm')[0].reset();
        $('#action').val('add');
        $('#formModal').modal('show');
    }

    function loadEditForm(id, username, email, phone, role, password) {

        $('#userId').val(id);
        $('#username').val(username);
        $('#password').val(password);
        $('#email').val(email);
        $('#phone').val(phone);
        $('#role').val(role);
        $('#action').val('edit');
        $('#formModal').modal('show');
    }

    function confirmDelete(userId) {
        $('#deleteUserId').val(userId);
        $('#deleteConfirmModal').modal('show');
    }

</script>

<!--DataTable-->
<script>
    $(document).ready(function () {
        let table = $('#userTable').DataTable({
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
            fixedHeader: true,
            responsive: true,
            keys: true,
            order: [[0, 'asc']],
            columnDefs: [
                {
                    targets: 2,
                    type: 'password-mask' // use our custom search type
                },

                {targets: 0, width: '10%'}, // User ID
                {targets: 1, width: '15%'}, // Username
                {targets: 2, width: '15%', type: 'password-mask'}, // Password
                {targets: 3, width: '20%'}, // Email
                {targets: 4, width: '15%'}, // Phone
                {targets: 5, width: '15%'}, // Role
                {targets: 6, width: '7%'}   // Actions
            ]
        });

        // Apply column filters
        $('#userTable thead tr.filter-row th').each(function (i) {
            $('input', this).on('keyup change', function () {
                if (table.column(i).search() !== this.value) {
                    table.column(i).search(this.value).draw();
                }
            });
        });

        // Disable column sorting when clicking in the filter inputs
        $('#userTable thead input, #userTable thead select').on('click', function (e) {
            e.stopImmediatePropagation();
        });

    });

</script>

<!--password-->
<script>
    $(".reveal").on('click', function () {
        var $pwd = $("#password");
        var $icon = $(this).find('i');

        if ($pwd.attr('type') === 'password') {
            $pwd.attr('type', 'text');
            $icon.removeClass('fa-eye-slash').addClass('fa-eye');
        } else {
            $pwd.attr('type', 'password');
            $icon.removeClass('fa-eye').addClass('fa-eye-slash');
        }
    });


    // Toggle password visibility in table rows
    $(document).on('click', '.toggle-password', function () {
        const $icon = $(this).find('i');
        const $mask = $(this).siblings('.password-mask');

        if ($mask.text().includes('•')) {
            $mask.text($mask.data('password')); // Show actual password
            $icon.removeClass('fa-eye-slash').addClass('fa-eye');
        } else {
            $mask.text('••••••••'); // Hide it again
            $icon.removeClass('fa-eye').addClass('fa-eye-slash');
        }
    });

    $.fn.dataTable.ext.type.search['password-mask'] = function (data) {
        // Use data-password attribute if available
        const el = document.createElement('div');
        el.innerHTML = data;
        const span = el.querySelector('.password-mask');
        return span ? span.getAttribute('data-password') || '' : data;
    };


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

<!--dropdown-->
<script>
    // Role dropdown filter
    $('#roleFilter').on('change', function () {
        const val = $(this).val();
        $('#userTable').DataTable().column(5).search(val).draw();
    });

</script>

<!--reset button-->
<script>
    $('#clearUserTableState').on('click', function (e) {
        e.preventDefault();

        const table = $('#userTable').DataTable();

        // Clear DataTables saved state
        table.state.clear();

        // Clear input filters
        $('#userTable thead tr.filter-row input').each(function () {
            $(this).val('');
            const colIndex = $(this).closest('th').index();
            table.column(colIndex).search('').draw();
        });

        // Reset role dropdown
        $('#roleFilter').val('');
        table.column(5).search('').draw();

        // Reset column order and sort by ID ascending
        table.order([0, 'asc']).draw();

        // Reload the page (optional, based on server filter logic)
        window.location.href = 'UserDataServlet';
    });
</script>

<jsp:include page="../include/adminFooter.jsp" />