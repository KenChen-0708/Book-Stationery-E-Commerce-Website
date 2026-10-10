package da;

import entity.Review;
import entity.ReviewReply;
import jakarta.ejb.Stateless;
import jakarta.annotation.PostConstruct;

@Stateless
public class ReviewReplyDA extends GenericDA<ReviewReply> {

    @PostConstruct
    public void init() {
        this.setEntityClass(ReviewReply.class);
    }

    public void deleteReply(int replyId) {
        ReviewReply reply = em.find(ReviewReply.class, replyId);
        if (reply != null) {
            Review parentReview = reply.getReviewId();
            if (parentReview != null) {
                parentReview.getReviewReplyCollection().remove(reply); // remove from parent's collection
            }
            em.remove(reply);
            em.flush();
        }
    }
}
