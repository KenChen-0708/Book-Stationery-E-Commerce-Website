package servlet;

import da.*;
import entity.OrderItem;
import entity.Orders;
import entity.Product;
import entity.Review;
import entity.Users;
import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class OrderStatusServlet extends HttpServlet {

    @EJB
    private OrdersDA ordersDA;

    @EJB
    private ReviewDA reviewDA;

    @EJB
    private ProductDA productDA;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Users currentUser = (Users) request.getSession().getAttribute("user");

        if (currentUser == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        List<Orders> userOrders = ordersDA.findByNamedQuery("Orders.findByUserId", "userId", currentUser);
        List<OrderItem> orderItems = new ArrayList<>();
        List<Review> userReviews = reviewDA.findByNamedQuery("Review.findByUserId", "userId", currentUser);
        Map<Integer, Review> reviewMap = new HashMap<>();

        for (Review r : userReviews) {
            // Force fetch seller reply so it's ready in JSP (e.g. first reply only)
            r.getReviewReplyCollection().size(); // trigger loading
            reviewMap.put(r.getProductId().getProductId(), r);
        }

        for (Orders order : userOrders) {
            orderItems.addAll(order.getOrderItemCollection());
        }

        orderItems.sort((o1, o2) -> o2.getOrderId().getOrderDate().compareTo(o1.getOrderId().getOrderDate()));

        request.setAttribute("orderDetails", orderItems);
        request.setAttribute("reviewMap", reviewMap);

        request.getRequestDispatcher("OrderStatus.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        Users user = (Users) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        if ("review".equals(action)) {
            int productId = Integer.parseInt(request.getParameter("productId"));
            String comment = request.getParameter("reviewText");
            int rating = Integer.parseInt(request.getParameter("rating"));

            Product product = productDA.find(productId);

            Review review = new Review();
            review.setProductId(product);
            review.setUserId(user);
            review.setRating(rating);
            review.setComment(comment);
            review.setReviewDate(new Date());

            reviewDA.create(review);
        } else if ("deleteReview".equals(action)) {
            int reviewId = Integer.parseInt(request.getParameter("reviewId"));
            Review review = reviewDA.find(reviewId);

            if (review != null && review.getUserId().getUserId().equals(user.getUserId())) {
                reviewDA.delete(review);
            }
        }

        response.sendRedirect("OrderStatusServlet");
    }
}