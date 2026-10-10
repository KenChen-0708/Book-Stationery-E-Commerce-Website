<%@page contentType="text/html" pageEncoding="UTF-8"%>
<jsp:include page="include/header.jsp" />

<% String errorMessage = (String) request.getAttribute("errorMessage"); %>
<% if (errorMessage != null) {%>
<div class="container alert alert-danger alert-dismissible fade show mt-5 mb-0 animate__animated animate__fadeInDown animate__fast" role="alert">
    <%= errorMessage%>
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
</div>
<% }%>

<!-- Register Form -->
<div class="text-dark py-5">
    <div class="container py-5">
        <div class="row d-flex justify-content-center align-items-center h-100">
            <div class="card text-bg-light shadow col-10 col-md-8 col-lg-5 col-xl-5 col-xxl-4 border-0" style="border-radius: 10px;">
                <div class="card-body px-2 py-4">
                    <div class="row justify-content-center align-items-center">
                        <h3 class="text-center h3 fw-bold mt-4 mb-4 mx-1 mx-md-4">Register</h3>

                        <form class="mx-1 mx-md-4 needs-validation" action="registerServlet" method="post" novalidate id="registerForm">
                            <div class="row justify-content-center">
                                <div class="col-md-10">

                                    <!-- Username -->
                                    <div class="d-flex flex-row align-items-center mb-4">
                                        <i class="fas fa-user me-3 fa-fw"></i>
                                        <div class="form-floating flex-fill mb-0 text-muted">
                                            <input type="text" id="username" name="username" class="form-control border-2 border-0 border-bottom border-dark pb-1" placeholder="Your Username" required pattern="^[a-zA-Z0-9_]{4,20}$" />
                                            <label class="form-label" for="username">Username</label>
                                            <div class="invalid-feedback fs-6 text-center pe-4">Username must be 4–20 characters, letters/numbers/underscores only.</div>
                                        </div>
                                    </div>

                                    <!-- Email -->
                                    <div class="d-flex flex-row align-items-center mb-4">
                                        <i class="fas fa-envelope me-3 fa-fw"></i>
                                        <div class="form-floating flex-fill mb-0 text-muted">
                                            <input type="email" id="email" name="email" class="form-control border-2 border-0 border-bottom border-dark pb-1" placeholder="Your Email" required />
                                            <label class="form-label" for="email">Email</label>
                                            <div class="invalid-feedback fs-6 text-center pe-4">Please enter a valid email.</div>
                                        </div>
                                    </div>

                                    <!-- Password -->
                                    <div class="d-flex flex-row align-items-center mb-4">
                                        <i class="fas fa-lock me-3 fa-fw"></i>
                                        <div class="form-floating flex-fill mb-0 text-muted position-relative">
                                            <input type="password" id="password" name="password" 
                                                   class="form-control border-2 border-0 border-bottom border-dark pb-1 pe-5" 
                                                   placeholder="Password" required minlength="8" />
                                            <label class="form-label" for="password">Password</label>
                                            <div class="invalid-feedback fs-6 text-center pe-4">Password must be at least 8 characters.</div>
                                            <!-- Eye Icon Inside Input -->
                                            <button class="btn btn-sm position-absolute top-50 end-0 translate-middle-y me-2 reveal" type="button" tabindex="-1">
                                                <i class="fa-regular fa-eye-slash"></i>
                                            </button>
                                        </div>
                                    </div>


                                    <!-- Confirm Password -->
                                    <div class="d-flex flex-row align-items-center mb-4">
                                        <i class="fas fa-lock me-3 fa-fw"></i>
                                        <div class="form-floating flex-fill mb-0 text-muted">
                                            <input type="password" id="confirmPassword" name="confirmPassword" class="form-control border-2 border-0 border-bottom border-dark pb-1" placeholder="Confirm Password" required minlength="8" />
                                            <label class="form-label" for="confirmPassword">Confirm Password</label>
                                            <div class="invalid-feedback fs-6 text-center pe-4">Passwords must be the same.</div>
                                        </div>
                                        <!-- Show/Hide Button Outside the Input Field but in the same row -->
                                        <button class="btn btn-default reveal ms-2" type="button">
                                            <i class="fa-regular fa-eye-slash"></i>
                                        </button>
                                    </div>

                                    <!-- Submit Button -->
                                    <div class="d-flex justify-content-center mx-4 mt-4 col-9">
                                        <button type="submit" name="submit" class="btn btn-success rounded-5 text-dark flex-fill">Register</button>
                                    </div>
                                </div>
                            </div>
                        </form>

                    </div>
                    <p class="text-center mt-3 mb-0 text-dark fs-6">Already have an account? 
                        <a href="login.jsp" class="link link-underline link-underline-opacity-0 text-success">Login Here</a>
                    </p>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="include/footer.jsp" />

<!-- JS: Show/Hide Password + Validation -->
<script>
// Show/Hide password functionality
    $(".reveal").on('click', function () {
        var $input = $(this).parent().find('input');
        var $icon = $(this).find('i');

        if ($input.attr('type') === 'password') {
            $input.attr('type', 'text');
            $icon.removeClass('fa-eye-slash').addClass('fa-eye');
        } else {
            $input.attr('type', 'password');
            $icon.removeClass('fa-eye').addClass('fa-eye-slash');
        }
    });

// Input validation feedback
    function validateInput(input, isValid) {
        if (isValid) {
            input.classList.remove("is-invalid");
            input.classList.add("is-valid");
        } else {
            input.classList.remove("is-valid");
            input.classList.add("is-invalid");
        }
    }

    $("#username").on("input", function () {
        const pattern = /^[a-zA-Z0-9_]{4,20}$/;
        validateInput(this, pattern.test(this.value));
    });

    $("#email").on("input", function () {
        const pattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        validateInput(this, pattern.test(this.value));
    });

    $("#password").on("input", function () {
        const isValid = this.value.length >= 8;
        validateInput(this, isValid);
        $("#confirmPassword").trigger("input"); // Revalidate confirm password
    });

    $("#confirmPassword").on("input", function () {
        const match = $("#password").val() === $(this).val();
        validateInput(this, match);
        $("#confirmPwdFeedback").text(match ? "Passwords match!" : "Passwords must match.");
    });

// Prevent form submission if validation fails
    $("#registerForm").on("submit", function (e) {
        if (!this.checkValidity()) {
            e.preventDefault();
            e.stopPropagation();
        }
        this.classList.add("was-validated");
    });
</script>