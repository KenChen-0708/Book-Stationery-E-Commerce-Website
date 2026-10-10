package servlet;

import da.ReviewReplyDA;
import da.*;
import entity.*;
import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.Date;
import java.util.List;

@WebServlet("/ReviewServlet")
public class ReviewServlet extends HttpServlet {

    @EJB
    private ReviewDA reviewDA;

    @EJB
    private ReviewReplyDA reviewReplyDA;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Review> reviewList = reviewDA.findAllWithReplies();

        request.setAttribute("reviewList", reviewList);
        request.getRequestDispatcher("./manager/manageReview.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String action = request.getParameter("action");

            if (action == null || action.isEmpty()) {
                response.sendRedirect("ReviewServlet");
                return;
            }

            if ("deleteReply".equals(action)) {
                int replyId = Integer.parseInt(request.getParameter("replyId"));
                reviewReplyDA.deleteReply(replyId);

                // After delete, immediately redirect and STOP
                response.sendRedirect("ReviewServlet");
                return;

            } else if ("addReply".equals(action)) {
                String replyText = request.getParameter("replyText");
                String reviewIdStr = request.getParameter("reviewId");

                if (replyText == null || replyText.trim().isEmpty() || reviewIdStr == null) {
                    response.sendRedirect("ReviewServlet");
                    return;
                }

                int reviewId = Integer.parseInt(reviewIdStr);

                HttpSession session = request.getSession();
                Users user = (Users) session.getAttribute("user");

                if (user != null) {
                    Review review = reviewDA.find(reviewId);

                    ReviewReply reply = new ReviewReply();
                        reply.setReplyText(replyText.trim());
                    reply.setReplyDate(new Date());
                    reply.setReviewId(review);
                    reply.setUserId(user);

                    reviewReplyDA.create(reply);
                }
                // After reply, redirect
                response.sendRedirect("ReviewServlet");
                return;

            } else {
                // Unknown action
                System.out.println("Unknown action received: " + action);
                response.sendRedirect("ReviewServlet");
                return;
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("ReviewServlet");
        }
    }

}
