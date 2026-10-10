package da;

import entity.CardDetails;
import entity.Users;
import jakarta.annotation.PostConstruct;
import jakarta.ejb.Stateless;
import java.util.List;

@Stateless
public class CardDetailsDA extends GenericDA<CardDetails> {

    @PostConstruct
    public void init() {
        this.setEntityClass(CardDetails.class);
    }

    public List<CardDetails> findByUser(Users user) {
        String jpql = "SELECT c FROM CardDetails c WHERE c.userId = :user";
        return em.createQuery(jpql, CardDetails.class)
                .setParameter("user", user)
                .getResultList();
    }

    public void deleteByCardId(int cardId) {
        CardDetails c = em.find(CardDetails.class, cardId);
        if (c != null) {
            em.remove(c);
        }
    }

    public CardDetails findDefaultByUserId(int userId) {
        String jpql = "SELECT c FROM CardDetails c WHERE c.userId.userId = :userId AND c.isDefault = :isDefault";
        List<CardDetails> result = em.createQuery(jpql, CardDetails.class)
                .setParameter("userId", userId)
                .setParameter("isDefault", Boolean.TRUE)
                .setMaxResults(1)
                .getResultList();
        return result.isEmpty() ? null : result.get(0);
    }

}
