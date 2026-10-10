package da;

import entity.Review;
import jakarta.annotation.PostConstruct;
import jakarta.ejb.Stateless;
import java.util.*;
import java.util.stream.Collectors;

@Stateless
public class ReviewDA extends GenericDA<Review> {

    @PostConstruct
    public void init() {
        setEntityClass(Review.class);
    }

    public Review findByReviewId(Integer reviewId) {
        return em.createNamedQuery("Review.findByReviewId", Review.class)
                .setParameter("reviewId", reviewId)
                .getSingleResult();
    }

    public List<Review> findAllWithReplies() {
        List<Review> r = em.createQuery(
                "SELECT r FROM Review r "
                + "LEFT JOIN FETCH r.reviewReplyCollection rr "
                + "LEFT JOIN FETCH rr.userId "
                + "JOIN FETCH r.userId "
                + "JOIN FETCH r.productId", Review.class)
                .getResultList();
        for (Review r1 : r) {
            em.refresh(r1);
        }

        return r;
    }

    public List<Review> findByProductId(Integer productId) {
        return em.createQuery(
                "SELECT r FROM Review r "
                + "LEFT JOIN FETCH r.reviewReplyCollection rr "
                + "LEFT JOIN FETCH rr.userId "
                + "JOIN FETCH r.userId "
                + "JOIN FETCH r.productId "
                + "WHERE r.productId.productId = :productId "
                + "ORDER BY r.reviewDate DESC", Review.class)
                .setParameter("productId", productId)
                .getResultList();
    }

    public Map<Integer, Double> getAverageRatingsForProducts(List<Integer> productIds) {
        if (productIds == null || productIds.isEmpty()) {
            return new HashMap<>();
        }

        return em.createQuery(
                "SELECT r.productId.productId, AVG(r.rating) "
                + "FROM Review r "
                + "WHERE r.productId.productId IN :productIds "
                + "GROUP BY r.productId.productId", Object[].class)
                .setParameter("productIds", productIds)
                .getResultStream()
                .collect(Collectors.toMap(
                        obj -> (Integer) obj[0],
                        obj -> ((Number) obj[1]).doubleValue()
                ));
    }

    public Map<Integer, Long> getReviewCountsForProducts(List<Integer> productIds) {
        if (productIds == null || productIds.isEmpty()) {
            return new HashMap<>();
        }

        return em.createQuery(
                "SELECT r.productId.productId, COUNT(r) "
                + "FROM Review r "
                + "WHERE r.productId.productId IN :productIds "
                + "GROUP BY r.productId.productId", Object[].class)
                .setParameter("productIds", productIds)
                .getResultStream()
                .collect(Collectors.toMap(
                        obj -> (Integer) obj[0],
                        obj -> (Long) obj[1]
                ));
    }

    public void delete(Review review) {
        if (!em.contains(review)) {
            review = em.merge(review);
        }
        em.remove(review);
    }
}