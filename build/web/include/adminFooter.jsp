<%@page contentType="text/html" pageEncoding="UTF-8"%>

<% String company = getServletContext().getInitParameter("companyName"); %>
<footer class="bg-dark mt-auto">
    <div class="w-100 bg-black py-3">
        <div class="container">
            <div class="row pt-2">
                <div class="col-12">
                    <p class="text-left text-light">
                        Copyright &copy; 2021 <%= company%>
                    </p>
                </div>
            </div>
        </div>
    </div>
</footer>

<!-- Ensure that the body is styled correctly -->
<style>
    html, body {
        height: 100%; /* Ensure the page takes the full height of the viewport */
    }

    body {
        display: flex;
        flex-direction: column;
    }

    footer {
        margin-top: auto; /* Push the footer to the bottom */
    }
</style>
