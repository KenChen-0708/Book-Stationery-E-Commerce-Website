
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">

    <head>
        <title>C&C Management</title>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">

        <!-- Bootstrap 5 CSS -->
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.5/dist/css/bootstrap.min.css">

        <!-- DataTables CSS -->
        <link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/dataTables.bootstrap5.min.css">

        <!-- DataTables Buttons CSS -->
        <link rel="stylesheet" href="https://cdn.datatables.net/buttons/2.4.1/css/buttons.bootstrap5.min.css">

        <!-- DataTables ColReorder CSS -->
        <link rel="stylesheet" href="https://cdn.datatables.net/colreorder/1.6.2/css/colReorder.bootstrap5.min.css">

        <!-- Font Awesome CSS -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/all.min.css">

        <!-- Animate.css -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css"/>

        <!-- Bootstrap Icons -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">

        <!-- Google Fonts: Roboto -->
        <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Roboto:wght@100;200;300;400;500;700;900&display=swap">

        <!-- Leaflet CSS -->
        <link rel="stylesheet" href="https://unpkg.com/leaflet@1.7.1/dist/leaflet.css" integrity="sha512-xodZBNTC5n17Xt2atTPuE1HxjVMSvLVW9ocqUKLsCC5CXdbqCmblAshOMAS6/keqq/sMZMZ19scR4PsZChSR7A==" crossorigin="anonymous" />

        <!-- jQuery -->
        <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>

        <!-- Bootstrap 5 Bundle JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.5/dist/js/bootstrap.bundle.min.js"></script>

        <!-- DataTables JS -->
        <script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>

        <!-- DataTables Bootstrap 5 Integration JS -->
        <script src="https://cdn.datatables.net/1.13.6/js/dataTables.bootstrap5.min.js"></script>

        <!-- DataTables Buttons JS -->
        <script src="https://cdn.datatables.net/buttons/2.4.1/js/dataTables.buttons.min.js"></script>

        <!-- DataTables Buttons Bootstrap 5 Integration JS -->
        <script src="https://cdn.datatables.net/buttons/2.4.1/js/buttons.bootstrap5.min.js"></script>

        <!-- JSZip (required for Excel export) -->
        <script src="https://cdnjs.cloudflare.com/ajax/libs/jszip/3.10.1/jszip.min.js"></script>

        <!-- PDFMake (required for PDF export) -->
        <script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.2.7/pdfmake.min.js"></script>

        <!-- PDFMake Virtual File System (required for PDF export) -->
        <script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.2.7/vfs_fonts.js"></script>

        <!-- DataTables Buttons HTML5 Export JS -->
        <script src="https://cdn.datatables.net/buttons/2.4.1/js/buttons.html5.min.js"></script>

        <!-- DataTables Buttons Print JS -->
        <script src="https://cdn.datatables.net/buttons/2.4.1/js/buttons.print.min.js"></script>

        <!-- DataTables ColReorder JS -->
        <script src="https://cdn.datatables.net/colreorder/1.6.2/js/dataTables.colReorder.min.js"></script>

        <!-- Chart.js -->
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

        <!-- html2pdf.js -->
        <script src="https://cdnjs.cloudflare.com/ajax/libs/html2pdf.js/0.10.1/html2pdf.bundle.min.js"></script>



    </head>

    <body>
        <!-- Start Top Nav -->
        <nav class="navbar navbar-expand-lg bg-dark navbar-light d-none d-lg-block" id="templatemo_nav_top">
            <div class="container text-light">
                <div class="w-100 d-flex justify-content-between">
                    <div>
                        <i class="fa fa-envelope mx-2"></i>
                        <a class="navbar-sm-brand text-light text-decoration-none" href="mailto:info@company.com">info@company.com</a>
                        <i class="fa fa-phone mx-2"></i>
                        <a class="navbar-sm-brand text-light text-decoration-none" href="tel:010-020-0340">010-020-0340</a>
                    </div>
                    <div>
                        <a class="text-light" href="https://fb.com/templatemo" target="_blank" rel="sponsored"><i class="fab fa-facebook-f fa-sm fa-fw me-2"></i></a>
                        <a class="text-light" href="https://www.instagram.com/" target="_blank"><i class="fab fa-instagram fa-sm fa-fw me-2"></i></a>
                        <a class="text-light" href="https://twitter.com/" target="_blank"><i class="fab fa-twitter fa-sm fa-fw me-2"></i></a>
                        <a class="text-light" href="https://www.linkedin.com/" target="_blank"><i class="fab fa-linkedin fa-sm fa-fw"></i></a>
                    </div>
                </div>
            </div>
        </nav>
        <!-- Close Top Nav -->


        <!-- Header -->
        <nav class="navbar navbar-expand-lg navbar-light shadow">
            <div class="container d-flex justify-content-between align-items-center">

                <%
                    entity.Users user = (entity.Users) session.getAttribute("user");
                    if (user != null) {
                        if (user.getRole().equals("MANAGER")) {
                %>
                <a href="/Assignment/manager/dashboard.jsp">
                    <img src="/Assignment/assets/img/logo1.png" width="70" height="70" alt="logo">
                </a>
                <%
                } else if (user.getRole().equals("STAFF")) {
                %>
                <a href="/Assignment/staff/dashboard.jsp">
                    <img src="/Assignment/assets/img/logo1.png" width="70" height="70" alt="logo">
                </a>
                <%
                        }
                    }
                %>

                <button class="navbar-toggler border-0" type="button" data-bs-toggle="collapse" data-bs-target="#templatemo_main_nav" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
                    <span class="navbar-toggler-icon"></span>
                </button>

                <!-- Navbar Structure -->
                <div class="align-self-center collapse navbar-collapse flex-fill d-lg-flex justify-content-lg-between" id="templatemo_main_nav">
                    <!-- Left Side Menu Items -->
                    <div class="flex-fill">
                        <ul class="nav navbar-nav d-flex justify-content-between mx-lg-auto px-5 flex-wrap">
                            <!-- Dashboard -->
                            <li class="nav-item">
                                <%
                                    if (user != null) {
                                        if (user.getRole().equals("MANAGER")) {
                                %>
                                <a class="nav-link" href="/Assignment/manager/dashboard.jsp">Dashboard</a>
                                <%
                                } else if (user.getRole().equals("STAFF")) {
                                %>
                                <a class="nav-link" href="/Assignment/staff/dashboard.jsp">Dashboard</a>
                                <%
                                        }
                                    }
                                %>
                            </li>

                            <!-- Menu Items -->
                            <%
                                if (user != null && user.getRole().equals("MANAGER")) {
                            %>
                            <!-- MANAGER View with Dropdowns -->
                            <li class="nav-item dropdown">
                                <a class="nav-link dropdown-toggle" href="#" id="productOrderDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                                    Manage Products / Orders
                                </a>
                                <ul class="dropdown-menu" aria-labelledby="productOrderDropdown">
                                    <li><a class="dropdown-item" href="/Assignment/ProductDataServlet">Manage Product</a></li>
                                    <li><a class="dropdown-item" href="/Assignment/manager/manageOrders.jsp">Manage Orders</a></li>
                                </ul>
                            </li>

                            <li class="nav-item dropdown">
                                <a class="nav-link dropdown-toggle" href="#" id="reviewInquiryDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                                    Manage Reviews / Inquiries
                                </a>
                                <ul class="dropdown-menu" aria-labelledby="reviewInquiryDropdown">
                                    <li><a class="dropdown-item" href="/Assignment/manager/manageReview.jsp">Manage Reviews</a></li>
                                    <li><a class="dropdown-item" href="/Assignment/manager/manageMessage.jsp">Manage Inquiries</a></li>
                                </ul>
                            </li>

                            <li class="nav-item">
                                <a class="nav-link" href="/Assignment/UserDataServlet">Manage User</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="/Assignment/ReportServlet">Reports</a>
                            </li>
                            <%
                            } else if (user != null && user.getRole().equals("STAFF")) {
                            %>
                            <!-- STAFF View with Separate Links -->
                            <li class="nav-item">
                                <a class="nav-link" href="/Assignment/ProductDataServlet">Manage Product</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="/Assignment/manager/manageOrders.jsp">Manage Orders</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="/Assignment/manager/manageReview.jsp">Manage Reviews</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="/Assignment/manager/manageMessage.jsp">Manage Inquiries</a>
                            </li>
                            <%
                                }
                            %>
                        </ul>

                    </div>

                    <!-- Right Side User Profile and Logout -->
                    <div class="navbar align-self-center d-flex">
                        <ul class="navbar-nav">
                            <li class="nav-item dropdown">
                                <a class="nav-link dropdown-toggle" id="navbarDropdownMenuLink" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                                    <img src="https://s3.eu-central-1.amazonaws.com/bootstrapbaymisc/blog/24_days_bootstrap/fox.jpg" width="40" height="40" class="rounded-circle border border-1 border-dark">
                                </a>
                                <div class="dropdown-menu" aria-labelledby="navbarDropdownMenuLink">
                                    <div class="px-3 py-2 text-muted">
                                        <strong>Role:</strong> <%= user.getRole()%>
                                    </div>
                                    <hr class="dropdown-divider">
                                    <a class="dropdown-item" href="/Assignment/LogoutServlet">Log Out</a>
                                </div>
                            </li>   
                        </ul>
                    </div>
                </div>

            </div>
        </nav>
        <!-- Close Header -->

