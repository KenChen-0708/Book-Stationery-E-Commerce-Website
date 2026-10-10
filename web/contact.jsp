<%@page contentType="text/html" pageEncoding="UTF-8"%>
<jsp:include page="include/header.jsp" />

<!-- Start Content Page -->
<div class="container-fluid py-5" style="background-color: #198754;"> <%-- Match 'Let’s Talk' button color --%>
    <div class="col-md-6 m-auto text-center">
        <h1 class="h1 fw-bolder text-white" style="font-weight: bold;">Contact Us</h1>
        <h3 style="color: white; font-weight: normal; font-size: 18pt;">
            We'd love to hear from you about our Book & Stationery collection ! ! !
        </h3>
    </div>
</div>

<!-- Contact Form Section -->
<div class="container" style="max-width: 90%; padding-top: 20px;">

    <div class="row py-5">
        <form class="col-md-9 m-auto" method="post" action="ContactServlet" role="form">
            <div class="row">
                <div class="form-group col-md-6 mb-3">
                    <label for="inputname" class="fw-bold" style="font-size: 15pt;">Name</label>
                    <input type="text" class="form-control mt-1 fw-lighter" id="name" name="name" placeholder="John Doe">
                </div>
                <div class="form-group col-md-6 mb-3">
                    <label for="inputemail" class="fw-bold" style="font-size: 15pt;">Email</label>
                    <input type="email" class="form-control mt-1 fw-lighter" id="email" name="email" placeholder="example@domain.com">
                </div>
            </div>
            <div class="mb-3">
                <label for="inputsubject" class="fw-bold" style="font-size: 15pt;">Subject</label>
                <input type="text" class="form-control mt-1 fw-lighter" id="subject" name="subject" placeholder="Inquiry about new book arrivals">
            </div>
            <div class="mb-3">
                <label for="inputmessage" class="fw-bold" style="font-size: 15pt;">Message</label>
                <textarea class="form-control mt-1 fw-lighter" id="message" name="message" placeholder="Write your message here" rows="8"></textarea>
            </div>
            <div class="row">
                <div class="col text-end mt-2">
                    <button type="submit" class="btn btn-lg px-3" style="background-color: #198754; color: white;">Let’s Talk</button>
                </div>
            </div>
        </form>
    </div>
</div>

<jsp:include page="include/footer.jsp" />