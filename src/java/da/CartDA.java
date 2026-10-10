package da;

import entity.Cart;
import jakarta.annotation.PostConstruct;
import jakarta.ejb.Stateless;

@Stateless
public class CartDA extends GenericDA<Cart> {

    @PostConstruct
    public void init() {
        setEntityClass(Cart.class);
    }
    
    public Cart findCartByUserId(Integer userId) {
    return em.createQuery("SELECT c FROM Cart c WHERE c.userId.userId = :userId", Cart.class)
             .setParameter("userId", userId)
             .getResultStream()
             .findFirst()
             .orElse(null);
}

}
