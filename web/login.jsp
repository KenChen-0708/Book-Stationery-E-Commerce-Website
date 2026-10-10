
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<jsp:include page="include/header.jsp" />

<% String errorMessage = (String) request.getAttribute("errorMessage"); %>
<% String informationMessage = (String) request.getAttribute("informationMessage"); %>

<% if (errorMessage != null) { %>
<div class="container alert alert-danger alert-dismissible fade show mt-5 mb-0 animate__animated animate__fadeInDown animate__fast" role="alert">
    <%= errorMessage %>
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
</div>
<% } %>

<% if (informationMessage != null) { %>
<div class="container alert alert-warning alert-dismissible fade show mt-5 mb-0 animate__animated animate__fadeInDown animate__fast" role="alert">
    <%= informationMessage %>
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
</div>
<% } %>


<%
    // Check login
    String username = (String) session.getAttribute("username");
    String role = (String) session.getAttribute("role");

    if (username != null || role != null) {
        if (role.equals("MANAGER")) {
            response.sendRedirect("./manager/dashboard.jsp");
        } else if (role.equals("STAFF")) {
            response.sendRedirect("./staff/dashboard.jsp");
        } else {
            response.sendRedirect("./");
        }
    }

    // Remember me
    String savedUsername = "";
    String savedPassword = "";

    Cookie[] cookies = request.getCookies();
    if (cookies != null) {
        for (Cookie c : cookies) {
            if (c.getName().equals("username")) {
                savedUsername = c.getValue();
                break;
            }
        }
    }

    if (session != null && session.getAttribute("password") != null) {
        savedPassword = session.getAttribute("password").toString();
    }

%>

<!-- form -->
<div class="text-dark py-5">
    <div class="container py-5">
        <div class="row d-flex justify-content-center align-items-center h-100">
            <div class="card text-bg-light shadow col-10 col-md-8 col-lg-5 col-xl-5 col-xxl-4 border-0" style="border-radius: 10px;">
                <div class="card-body px-2 py-4">
                    <div class="row justify-content-center align-items-center">
                        <h3 class="text-center h3 fw-bold mt-4 mb-4 mx-1 mx-md-4">Login</h3>
                        <form class="mx-1 mx-md-4 needs-validation" action="loginServlet" method="post" novalidate>
                            <div class="row justify-content-center">
                                <div class="col-md-10">
                                    <div class="d-flex flex-row align-items-center mb-4">
                                        <i class="fas fa-user me-3 fa-fw"></i>
                                        <div class="form-floating flex-fill mb-0 text-muted">
                                            <input type="username" id="username" name="username" class="form-control border-2 border-0 border-bottom border-dark pb-1" placeholder="Your Username" value="<%= savedUsername %>" required/>
                                            <label class="form-labzel" for="username">Username</label>
                                            <div class="invalid-feedback fs-6 text-center pe-4">Please enter a valid username.</div>
                                        </div>
                                    </div>
                                    <div class="d-flex flex-row align-items-center mb-4">
                                        <i class="fas fa-lock me-3 fa-fw"></i>
                                        <div class="form-floating flex-fill mb-0 text-muted position-relative">
                                            <input type="password" id="password" name="password" class="form-control border-2 border-0 border-bottom border-dark pb-1" placeholder="password" value="<%= savedPassword %>" required/>
                                            <label class="form-label" for="password">Password</label>
                                            <button class="btn btn-default reveal position-absolute" type="button" style="top: 50%; right: 0; transform: translateY(-50%);">
                                                <i class="fa-regular fa-eye-slash"></i>
                                            </button>
                                        </div>
                                    </div>
                                </div>



                                <div class="row col-12 mb-2">
                                    <div class="form-check d-flex col-5 offset-1 text-center">
                                        <input class="form-check-input me-2 border-dark text-success" type="checkbox" id="remember" name="remember" checked novalidate>
                                        <label class="form-check-label text-dark fs-6" for="remember">
                                            Remember Me
                                        </label>
                                    </div>
                                </div>

                                <div class="d-flex justify-content-center mx-4 mt-4 col-9">
                                    <button type="submit" name="submit" class="btn btn-success rounded-5 text-dark flex-fill">Login</button>
                                </div>
                            </div>
                        </form>

                    </div>
                    <p class="text-center mt-3 mb-0 text-dark fs-6">Not a member? <a href="register.jsp"
                                                                                     class="link link-underline link-underline-opacity-0 text-success">Register Here</a></p>
                </div>
            </div>
        </div>
    </div>
</div>


<jsp:include page="include/footer.jsp" />


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


</script>