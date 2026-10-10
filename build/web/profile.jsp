<%@page import="javax.naming.InitialContext"%>
<%@page import="entity.Address"%>
<%@page import="da.AddressDA"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<jsp:include page="include/header.jsp" />

<%
    entity.Users user = (entity.Users) session.getAttribute("user");

    if (user == null || !user.getRole().equals("CUSTOMER")) {
        response.sendRedirect("login.jsp");
        return;
    }

    AddressDA addressDA = null;
    Address savedAddress = null;
    try {
        InitialContext ctx = new InitialContext();
        addressDA = (AddressDA) ctx.lookup("java:global/Assignment/AddressDA");
        savedAddress = addressDA.findLatestByUserId(user.getUserId());
        request.setAttribute("savedAddress", savedAddress);
    } catch (Exception e) {
        e.printStackTrace();
    }

    // Calculate profile completeness percentage (username, email, phone, and address)
    int totalFields = 7; // username, email, phone, and 4 address fields
    int filledFields = 0;

    if (user.getUsername() != null && !user.getUsername().isEmpty()) {
        filledFields++;
    }
    if (user.getEmail() != null && !user.getEmail().isEmpty()) {
        filledFields++;
    }
    if (user.getPhone() != null && !user.getPhone().isEmpty()) {
        filledFields++;
    }
    
    // Address fields
    if (savedAddress != null) {
        if (savedAddress.getRecipientName() != null && !savedAddress.getRecipientName().isEmpty()) {
            filledFields++;
        }
        if (savedAddress.getAddressLine() != null && !savedAddress.getAddressLine().isEmpty()) {
            filledFields++;
        }
        if (savedAddress.getState() != null && !savedAddress.getState().isEmpty()) {
            filledFields++;
        }
        if (savedAddress.getPostalCode() != null && !savedAddress.getPostalCode().isEmpty()) {
            filledFields++;
        }
    }

    int completionPercentage = (int) ((double) filledFields / totalFields * 100);
%>


<style>
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

    .edit-btn {
        transition: background-color 0.3s ease, color 0.3s ease, transform 0.2s ease;
    }

    .edit-btn:hover {
        background-color: #28a745;
        color: white;
        transform: translateY(-3px);
        box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
    }

    .edit-btn:active {
        background-color: #218838;
        transform: translateY(0);
    }

    .edit-btn:focus {
        outline: none;
        box-shadow: 0 0 0 0.25rem rgba(40, 167, 69, 0.5);
    }
</style>

<section style="background-color: #eee;" class="pb-5">
    <div class="container py-5">
        <div class="row">
            <div class="col">
                <!-- Account page navigation-->
                <nav class="nav nav-borders">
                    <a class="nav-link ms-0 active" href="profile.jsp">User Profile</a>
                    <a class="nav-link" href="WishlistServlet">Wishlist</a>
                    <a class="nav-link" href="OrderStatus.jsp">My Order</a>
                    <a class="nav-link" href="billing.jsp">Billing & Card</a>
                </nav>
                <hr class="mt-0 mb-4">
            </div>
        </div>

        <div class="row">
            <div class="col-lg-6">
                <div class="card mb-4 py-5">
                    <div class="card-body text-center py-3">
                        <img src="https://s3.eu-central-1.amazonaws.com/bootstrapbaymisc/blog/24_days_bootstrap/fox.jpg" 
                             alt="avatar" class="rounded-circle img-fluid" style="width: 210px;">
                        <h5 class="my-3"><%= user.getUsername()%></h5>
                    </div>
                </div>

                <div class="card mb-4 mb-lg-0">
                    <div class="card-body p-0">
                        <ul class="list-group list-group-flush rounded-3">
                            <!-- Social media links -->
                            <li class="list-group-item d-flex align-items-center p-3">
                                <a class="text-light text-decoration-none" target="_blank" href="https://twitter.com/"
                                   style="display: flex; width: 100%; justify-content: flex-start; align-items: center;">
                                    <i class="fab fa-twitter fa-lg" style="color: #55acee;"></i>
                                    <p class="mb-0 ms-2 text-dark fw-bold text-center" style="flex-grow: 1;">Twitter</p>
                                </a>
                            </li>
                            <li class="list-group-item d-flex align-items-center p-3">
                                <a class="text-light text-decoration-none" target="_blank" href="https://www.instagram.com/"
                                   style="display: flex; width: 100%; justify-content: flex-start; align-items: center;">
                                    <i class="fab fa-instagram fa-lg" style="color: #ac2bac;"></i>
                                    <p class="mb-0 ms-2 text-dark fw-bold text-center" style="flex-grow: 1;">Instagram</p>
                                </a>
                            </li>
                            <li class="list-group-item d-flex align-items-center p-3">
                                <a class="text-light text-decoration-none" target="_blank" href="http://facebook.com/"
                                   style="display: flex; width: 100%; justify-content: flex-start; align-items: center;">
                                    <i class="fab fa-facebook-f fa-lg" style="color: #3b5998;"></i>
                                    <p class="mb-0 ms-2 text-dark fw-bold text-center" style="flex-grow: 1;">Facebook</p>
                                </a>
                            </li>
                        </ul>
                    </div>
                </div>
            </div>

            <div class="col-lg-6">
                <!-- User Info Card -->
                <div class="card mb-4">
                    <div class="card-header bg-white border-0 d-flex justify-content-between align-items-center">
                        <h5 class="text-success fw-bold mb-0"><i class="fas fa-user-circle me-2"></i>Profile Information</h5>
                        <button type="button" class="btn btn-sm btn-success" data-bs-toggle="modal" data-bs-target="#editProfileModal">
                            <i class="fas fa-edit me-1"></i> Edit
                        </button>
                    </div>

                    <div class="card-body">
                        <!-- Full Name -->
                        <div class="row">
                            <div class="col-sm-3">
                                <p class="mb-0 fw-bolder">
                                    <i class="fas fa-user me-2 text-muted"></i>Full Name
                                </p>
                            </div>
                            <div class="col-sm-9 text-center">
                                <p class="text-muted mb-0"><%= user.getUsername()%></p>
                            </div>
                        </div>
                        <hr>

                        <!-- Email -->
                        <div class="row">
                            <div class="col-sm-3">
                                <p class="mb-0 fw-bolder">
                                    <i class="fas fa-envelope me-2 text-muted"></i>Email
                                </p>
                            </div>
                            <div class="col-sm-9 text-center">
                                <p class="text-muted mb-0"><%= user.getEmail()%></p>
                            </div>
                        </div>
                        <hr>

                        <!-- Phone -->
                        <div class="row">
                            <div class="col-sm-3">
                                <p class="mb-0 fw-bolder">
                                    <i class="fas fa-phone me-2 text-muted"></i>Phone
                                </p>
                            </div>
                            <div class="col-sm-9 text-center">
                                <p class="text-muted mb-0"><%= user.getPhone() != null ? user.getPhone() : "-"%></p>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Saved Address Card -->
                <div class="card mb-4">
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <h5 class="mb-0 text-success fw-bold">
                                <i class="fas fa-map-marker-alt me-2"></i> Saved Address
                            </h5>
                            <button type="button" class="btn btn-sm btn-success" data-bs-toggle="modal" data-bs-target="#editAddressModal">
                                <i class="fas fa-edit me-1"></i> Edit
                            </button>
                        </div>

                        <!-- Recipient -->
                        <div class="row mb-2">
                            <div class="col-sm-3">
                                <p class="mb-0 fw-bolder">
                                    <i class="fas fa-user me-2 text-muted"></i>Recipient
                                </p>
                            </div>
                            <div class="col-sm-9 text-center">
                                <p class="text-muted mb-0">${not empty savedAddress ? savedAddress.recipientName : "-"}</p>
                            </div>
                        </div>
                        <hr>

                        <!-- Address -->
                        <div class="row mb-2">
                            <div class="col-sm-3">
                                <p class="mb-0 fw-bolder">
                                    <i class="fas fa-home me-2 text-muted"></i>Address
                                </p>
                            </div>
                            <div class="col-sm-9 text-center">
                                <p class="text-muted mb-0">${not empty savedAddress ? savedAddress.addressLine : "-"}</p>
                            </div>
                        </div>
                        <hr>

                        <!-- State -->
                        <div class="row mb-2">
                            <div class="col-sm-3">
                                <p class="mb-0 fw-bolder">
                                    <i class="fas fa-map me-2 text-muted"></i>State
                                </p>
                            </div>
                            <div class="col-sm-9 text-center">
                                <p class="text-muted mb-0">${not empty savedAddress ? savedAddress.state : "-"}</p>
                            </div>
                        </div>
                        <hr>

                        <!-- Postcode -->
                        <div class="row mb-2">
                            <div class="col-sm-3">
                                <p class="mb-0 fw-bolder">
                                    <i class="fas fa-mail-bulk me-2 text-muted"></i>Postcode
                                </p>
                            </div>
                            <div class="col-sm-9 text-center">
                                <p class="text-muted mb-0">${not empty savedAddress ? savedAddress.postalCode : "-"}</p>
                            </div>
                        </div>
                        <hr>

                        <!-- Country -->
                        <div class="row">
                            <div class="col-sm-3">
                                <p class="mb-0 fw-bolder">
                                    <i class="fas fa-flag me-2 text-muted"></i>Country
                                </p>
                            </div>
                            <div class="col-sm-9 text-center">
                                <p class="text-muted mb-0">${not empty savedAddress ? savedAddress.country : "-"}</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="row mt-2">
            <div class="col">
                <div class="card mb-4">
                    <div class="card-body">
                        <p class="mb-4">
                            <span class="text-success font-italic me-1">
                                <i class="fas fa-user-check"></i> Profile Completion
                            </span>
                        </p>
                        <div class="progress rounded" style="height: 5px;">
                            <div class="progress-bar bg-success" role="progressbar" style="width: <%= completionPercentage%>%" 
                                 aria-valuenow="<%= completionPercentage%>" aria-valuemin="0" aria-valuemax="100"></div>
                        </div>
                        <p class="mt-2 text-success" style="font-size: .77rem;">
                            <%
                                if (completionPercentage < 100) {
                                    out.print("Add your missing contact info and shipping address to complete your profile.");
                                } else {
                                    out.print("Your profile is complete!");
                                }
                            %>
                        </p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- Edit Profile Modal -->
<div class="modal fade" id="editProfileModal" tabindex="-1" aria-labelledby="editProfileLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg modal-dialog-centered">
        <div class="modal-content">
            <form method="post" action="/Assignment/EditProfileServlet">
                <div class="modal-header">
                    <h5 class="modal-title" id="editProfileLabel">Edit Profile</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>

                <div class="modal-body">
                    <!-- Full Name -->
                    <div class="mb-3">
                        <label for="username" class="form-label">Full Name</label>
                        <input type="text" class="form-control" id="username" name="username" value="<%= user.getUsername()%>" required>
                    </div>

                    <!-- Email -->
                    <div class="mb-3">
                        <label for="email" class="form-label">Email address</label>
                        <input type="email" class="form-control" id="email" name="email" value="<%= user.getEmail()%>" required>
                    </div>

                    <!-- Phone -->
                    <div class="mb-3">
                        <label for="phone" class="form-label">Phone</label>
                        <input type="text" class="form-control" id="phone" name="phone" value="<%= user.getPhone() != null ? user.getPhone() : ""%>">
                    </div>

                    <!-- Password -->
                    <div class="mb-3">
                        <label for="password" class="form-label">New Password</label>
                        <div class="position-relative">
                            <input type="password" class="form-control pe-5" id="password" name="password" value="<%= user.getPassword()%>">
                            <button class="btn position-absolute top-50 end-0 translate-middle-y reveal" type="button" tabindex="-1">
                                <i class="fa-regular fa-eye-slash"></i>
                            </button>
                        </div>
                    </div>

                    <!-- Confirm Password -->
                    <div class="mb-3">
                        <label for="confirmPassword" class="form-label">Confirm Password</label>
                        <div class="position-relative">
                            <input type="password" class="form-control pe-5" id="confirmPassword" name="confirmPassword" value="<%= user.getPassword()%>">
                            <button class="btn position-absolute top-50 end-0 translate-middle-y reveal" type="button" tabindex="-1">
                                <i class="fa-regular fa-eye-slash"></i>
                            </button>
                        </div>
                    </div>
                </div>

                <div class="modal-footer">
                    <button type="submit" class="btn btn-primary">Save Changes</button>
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Edit Address Modal -->
<div class="modal fade" id="editAddressModal" tabindex="-1" aria-labelledby="editAddressLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg modal-dialog-centered">
        <div class="modal-content">
            <form method="post" action="UpdateAddressServlet">
                <div class="modal-header">
                    <h5 class="modal-title" id="editAddressLabel">Edit Saved Address</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>

                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label">Recipient Name</label>
                        <input type="text" class="form-control" name="recipientName" value="${savedAddress.recipientName}" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Address</label>
                        <input type="text" class="form-control" name="addressLine" value="${savedAddress.addressLine}" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">State</label>
                        <input type="text" class="form-control" name="state" value="${savedAddress.state}" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Postal Code</label>
                        <input type="text" class="form-control" name="postalCode" value="${savedAddress.postalCode}" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Country</label>
                        <input type="text" class="form-control" name="country" value="${savedAddress.country}" required>
                    </div>
                </div>

                <div class="modal-footer">
                    <button type="submit" class="btn btn-primary">Save Address</button>
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
    document.querySelectorAll('.reveal').forEach(btn => {
        btn.addEventListener('click', () => {
            const input = btn.previousElementSibling;
            const icon = btn.querySelector('i');
            if (input.type === 'password') {
                input.type = 'text';
                icon.classList.remove('fa-eye-slash');
                icon.classList.add('fa-eye');
            } else {
                input.type = 'password';
                icon.classList.remove('fa-eye');
                icon.classList.add('fa-eye-slash');
            }
        });
    });
</script>

<jsp:include page="include/footer.jsp" />