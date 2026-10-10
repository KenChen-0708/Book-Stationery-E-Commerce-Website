package da;

import entity.CartItem;
import jakarta.annotation.PostConstruct;
import jakarta.ejb.Stateless;
import jakarta.persistence.NoResultException;
import java.util.List;

@Stateless
public class CartItemDA extends GenericDA<CartItem> {

    @PostConstruct
    public void init() {
        setEntityClass(CartItem.class);
    }

    public List<CartItem> findByUserId(Integer userId) {
        return em.createQuery("SELECT ci FROM CartItem ci WHERE ci.cartId.userId.userId = :uid", CartItem.class)
                .setParameter("uid", userId)
                .getResultList();
    }

    public CartItem findByCartAndProduct(int cartId, int productId) {
        try {
            return em.createQuery("SELECT ci FROM CartItem ci WHERE ci.cartId.cartId = :cartId AND ci.productId.productId = :productId", CartItem.class)
                    .setParameter("cartId", cartId)
                    .setParameter("productId", productId)
                    .getSingleResult();
        } catch (NoResultException e) {
            return null;
        }
    }
}
