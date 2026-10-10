<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="entity.Review" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<jsp:include page="../include/adminHeader.jsp" />

<%
    entity.Users user = (entity.Users) session.getAttribute("user");
    if (user == null || !(user.getRole().equals("MANAGER") || user.getRole().equals("STAFF"))) {
        response.sendRedirect("../login.jsp");
        return;
    }

    if (request.getAttribute("reviewList") == null) {
        response.sendRedirect(request.getContextPath() + "/ReviewServlet");
        return;
    }
%>

<div class="container my-5">
    <h2 class="text-center mb-4">Review Management</h2>

    <div class="row mb-3">
        <div class="col text-start">
            <button class="btn btn-warning" id="clearTableState">Reset Table</button>
        </div>

    </div>

    <table id="reviewTable" class="table table-striped table-bordered" style="width:100%">
        <thead class="table-dark">
            <tr>
                <th>Review ID</th>
                <th>Username</th>
                <th>Product Name</th>
                <th>Rating</th>
                <th>Comment</th>
                <th>Reply</th>
                <th>Date</th>
                <th>Action</th>
            </tr>
            <tr class="filter-row">
                <th><input type="number" class="form-control form-control-sm" placeholder="Search ID"></th>
                <th><input type="text" class="form-control form-control-sm" placeholder="Search User"></th>
                <th><input type="text" class="form-control form-control-sm" placeholder="Search Product"></th>
                <th><input type="number" class="form-control form-control-sm" placeholder="Search Rating"></th>
                <th><input type="text" class="form-control form-control-sm" placeholder="Search Comment"></th>
                <th><input type="text" class="form-control form-control-sm" placeholder="Search Reply"></th>
                <th><input type="text" class="form-control form-control-sm" placeholder="Search Date"></th>
                <th></th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="r" items="${reviewList}" varStatus="reviewStatus">
                <tr>
                    <td>${r.reviewId}</td>
                    <td>${r.userId.username}</td>
                    <td>${r.productId.name}</td>
                    <td>${r.rating}</td>
                    <td>${r.comment}</td>
                    <td>
                        <div style="max-height: 150px; overflow-y: auto;">
                            <c:choose>
                                <c:when test="${not empty r.reviewReplyCollection}">
                                    <c:forEach var="reply" items="${r.reviewReplyCollection}" varStatus="replyStatus">
                                        <div class="mb-2 p-2 ">
                                            <div class="d-flex align-items-center mb-1">
                                                <i class="fas fa-reply me-2 text-success"></i>
                                                <div class="">${reply.replyText}</div>
                                            </div>
                                            <div class="text-end">
                                                <button class="btn btn-sm btn-outline-primary"
                                                        data-bs-toggle="modal"
                                                        data-bs-target="#replyDetailsModal${reviewStatus.index}_${replyStatus.index}">
                                                    Details
                                                </button>
                                            </div>
                                        </div>

                                        <!-- Modal for Reply Details -->
                                        <div class="modal fade" id="replyDetailsModal${reviewStatus.index}_${replyStatus.index}" tabindex="-1"
                                             aria-labelledby="replyDetailsModalLabel${reviewStatus.index}_${replyStatus.index}" aria-hidden="true">
                                            <div class="modal-dialog modal-dialog-centered">
                                                <div class="modal-content">
                                                    <div class="modal-header">
                                                        <h5 class="modal-title" id="replyDetailsModalLabel${reviewStatus.index}_${replyStatus.index}">Reply Details</h5>
                                                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                                    </div>
                                                    <div class="modal-body">
                                                        <p><strong>Reply ID:</strong> ${reply.replyId}</p>
                                                        <p><strong>User:</strong> ${reply.userId.username}</p>
                                                        <p><strong>Date:</strong> ${reply.replyDate}</p>
                                                        <p><strong>Reply Text:</strong><br/> ${reply.replyText}</p>
                                                    </div>

                                                    <div class="modal-footer d-flex justify-content-between">
                                                        <button type="button" class="btn btn-danger" onclick="openDeleteConfirmModal(${reply.replyId})">
                                                            Delete Reply
                                                        </button>
                                                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                                                            Close
                                                        </button>
                                                    </div>

                                                </div>
                                            </div>
                                        </div>
                                    </c:forEach>

                                </c:when>
                                <c:otherwise>
                                    <span class="text-muted fst-italic">No replies yet.</span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </td>




                    <td>${r.reviewDate}</td>
                    <td>
                        <c:choose>
                            <c:when test="${not empty r.reviewReplyCollection}">
                                <button class="btn btn-success btn-sm me-1" disabled>
                                    Replied
                                </button>
                            </c:when>
                            <c:otherwise>
                                <button class="btn btn-success btn-sm me-1"
                                        onclick="showReplyModal('${r.reviewId}')">
                                    Reply
                                </button>
                            </c:otherwise>
                        </c:choose>
                    </td>

                </tr>
            </c:forEach>
        </tbody>
    </table>
</div>

<!-- Reply Modal -->
<div class="modal fade" id="replyModal" tabindex="-1" aria-labelledby="replyModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <form class="modal-content" method="post" action="ReviewServlet">
            <input type="hidden" name="action" value="addReply">
            <div class="modal-header">
                <h5 class="modal-title" id="replyModalLabel">Reply to Review</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <input type="hidden" id="replyReviewId" name="reviewId">
                <div class="form-floating mb-3">
                    <textarea class="form-control" id="replyText" name="replyText" placeholder="Write your reply here..." style="height: 120px" required></textarea>
                    <label for="replyText">Reply</label>
                </div>
            </div>
            <div class="modal-footer">
                <button type="submit" class="btn btn-success">Send Reply</button>
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
            </div>
        </form>
    </div>
</div>


<!-- Delete Confirmation Modal -->
<div class="modal fade" id="deleteConfirmModal" tabindex="-1" aria-labelledby="deleteConfirmModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <form method="post" action="ReviewServlet" class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="deleteConfirmModalLabel">Confirm Delete</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                Are you sure you want to delete this reply?
                <input type="hidden" name="action" value="deleteReply">
                <input type="hidden" id="deleteReplyId" name="replyId">
            </div>
            <div class="modal-footer">
                <button type="submit" class="btn btn-danger">Yes, Delete</button>
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
            </div>
        </form>
    </div>
</div>



<script>
    $(document).ready(function () {
        const table = $('#reviewTable').DataTable({
            dom: '<"row mb-3"<"col-md-4"l><"col-md-4 text-center"B><"col-md-4"f>>' +
                    '<"row"<"col-12 table-responsive"tr>>' +
                    '<"row mt-3"<"col-md-6"i><"col-md-6"p>>',
            buttons: ['copy', 'csv', 'excel', 'pdf', 'print'],
            colReorder: {realtime: false, fixedColumnsLeft: 1},
            paging: true,
            lengthMenu: [5, 10, 25, 50],
            pageLength: 5,
            ordering: true,
            searching: true,
            info: true,
            stateSave: false,
            responsive: true,
            keys: true,
            order: [[0, 'asc']],
            columnDefs: [
                {targets: 0, width: '6%'}, // Review ID
                {targets: 1, width: '13%'}, // Username
                {targets: 2, width: '18%'}, // Product Name
                {targets: 3, width: '6%'}, // Rating
                {targets: 4, width: '22%'}, // Comment
                {targets: 5, width: '20%'}, // Replies
                {targets: 6, width: '10%'}, // Date
                {targets: 7, width: '5%'}    // Action
            ]

        });

        $('#reviewTable thead tr.filter-row th').each(function (i) {
            $('input', this).on('keyup change', function () {
                if (table.column(i).search() !== this.value) {
                    table.column(i).search(this.value).draw();
                }
            });
        });

        $('#reviewTable thead input').on('click', function (e) {
            e.stopImmediatePropagation();
        });

        // Tooltips
        document.querySelectorAll('[data-bs-toggle="tooltip"]').forEach(el => new bootstrap.Tooltip(el));
    });



    $('#clearTableState').on('click', function () {
        const table = $('#reviewTable').DataTable();
        table.state.clear();
        $('#reviewTable thead tr.filter-row input').each(function () {
            $(this).val('');
            const colIndex = $(this).closest('th').index();
            table.column(colIndex).search('').draw();
        });
        table.order([0, 'asc']).draw();
        window.location.href = 'ReviewServlet';
    });
</script>

<script>
    function showReplyModal(reviewId) {
        $('#replyReviewId').val(reviewId);
        $('#replyModal').modal('show');
    }
</script>


<script>
    function openDeleteConfirmModal(replyId) {
        $('#deleteReplyId').val(replyId); // Set the replyId inside the hidden input
        $('#deleteConfirmModal').modal('show'); // Show the confirmation modal
    }
</script>



<jsp:include page="../include/adminFooter.jsp" />