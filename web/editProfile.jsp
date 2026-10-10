<%@page contentType="text/html" pageEncoding="UTF-8"%>
<jsp:include page="include/header.jsp" />

<%
    entity.Users user = (entity.Users) session.getAttribute("user");

    if (user == null || !user.getRole().equals("CUSTOMER")) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<% String informationMessage = (String) request.getAttribute("informationMessage"); %>
<% if (informationMessage != null) { %>
<div class="container alert alert-warning alert-dismissible fade show mt-5 mb-0 animate__animated animate__fadeInDown animate__fast" role="alert">
    <%= informationMessage %>
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
</div>
<% } %>


<div class="container mt-5 mb-5">
    <h2 class="mb-4">Edit Profile</h2>
    <form method="post" action="/Assignment/EditProfileServlet">
        <div class="mb-3">
            <label for="username" class="form-label">Full Name</label>
            <input type="text" class="form-control" id="username" name="username" value="<%= user.getUsername()%>" required>
        </div>
        <div class="mb-3">
            <label for="email" class="form-label">Email address</label>
            <input type="email" class="form-control" id="email" name="email" value="<%= user.getEmail()%>" required>
        </div>
        <div class="mb-3">
            <label for="phone" class="form-label">Phone</label>
            <input type="text" class="form-control" id="phone" name="phone" value="<%= user.getPhone() != null ? user.getPhone() : ""%>">
        </div>
        <div class="mb-3">
            <label for="password" class="form-label">New Password</label>
            <div class="position-relative">
                <input type="password" class="form-control pe-5" id="password" name="password" value="<%= user.getPassword()%>">
                <button class="btn position-absolute top-50 end-0 translate-middle-y reveal" type="button" tabindex="-1">
                    <i class="fa-regular fa-eye-slash"></i>
                </button>
            </div>
        </div>
        <div class="mb-3">
            <label for="confirmPassword" class="form-label">Confirm Password</label>
            <div class="position-relative">
                <input type="password" class="form-control pe-5" id="confirmPassword" name="confirmPassword" value="<%= user.getPassword()%>">
                <button class="btn position-absolute top-50 end-0 translate-middle-y reveal" type="button" tabindex="-1">
                    <i class="fa-regular fa-eye-slash"></i>
                </button>
            </div>
        </div>

        <button type="submit" class="btn btn-primary">Save Changes</button>
        <a href="profile.jsp" class="btn btn-secondary ms-2">Cancel</a>
    </form>
</div>

<jsp:include page="include/footer.jsp" />

<!-- Reveal/hide password toggle script -->
<script>
    $(".reveal").on('click', function () {
        var $input = $(this).siblings("input");
        var $icon = $(this).find('i');

        if ($input.attr('type') === 'password') {
            $input.attr('type', 'text');
            $icon.removeClass('fa-eye-slash').addClass('fa-eye');
        } else {
            $input.attr('type', 'password');
            $icon.removeClass('fa-eye').addClass('fa-eye-slash');
        }
    });
</script>
