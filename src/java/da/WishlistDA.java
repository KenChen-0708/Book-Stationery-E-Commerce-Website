package da;

import entity.Users;
import entity.Wishlist;
import entity.WishlistItem;
import jakarta.annotation.PostConstruct;
import jakarta.ejb.Stateless;

@Stateless
public class WishlistDA extends GenericDA<Wishlist> {

    @PostConstruct
    public void init() {
        setEntityClass(Wishlist.class);
    }

    public void addItem(WishlistItem item) {
        if (item.getAddedAt() == null) {
            item.setAddedAt(new java.util.Date());
        }
        em.persist(item);
    }

    public void removeItem(WishlistItem item) {
        WishlistItem managedItem = em.merge(item);
        em.remove(managedItem);
    }

    public WishlistItem findWishlistItemById(int id) {
        return em.find(WishlistItem.class, id);
    }

    public WishlistItem findItemByProductAndWishlist(int productId, int wishlistId) {
        try {
            return em.createQuery(
                    "SELECT wi FROM WishlistItem wi WHERE wi.productId.productId = :productId AND wi.wishlistId.wishlistId = :wishlistId",
                    WishlistItem.class)
                    .setParameter("productId", productId)
                    .setParameter("wishlistId", wishlistId)
                    .getSingleResult();
        } catch (jakarta.persistence.NoResultException e) {
            return null;
        }
    }

    public boolean isProductInWishlist(int productId, Users user) {
        try {
            return em.createQuery("SELECT COUNT(wi) FROM WishlistItem wi WHERE wi.productId.productId = :pid AND wi.wishlistId.userId = :user", Long.class)
                    .setParameter("pid", productId)
                    .setParameter("user", user)
                    .getSingleResult() > 0;
        } catch (Exception e) {
            return false;
        }
    }

    public Wishlist findByUser(Users user) {
        try {
            Wishlist w =  em.createQuery(
                    "SELECT w FROM Wishlist w WHERE w.userId = :user",
                    Wishlist.class)
                    .setParameter("user", user)
                    .getSingleResult();
            
            em.refresh(w); 
            return w;
        } catch (jakarta.persistence.NoResultException e) {
            return null;
        }
    }

}
