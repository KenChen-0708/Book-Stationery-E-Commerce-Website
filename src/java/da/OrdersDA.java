package da;

import entity.*;
import jakarta.annotation.PostConstruct;
import jakarta.ejb.Stateless;
import java.util.List;

@Stateless
public class OrdersDA extends GenericDA<Orders> {

    @PostConstruct
    public void init() {
        setEntityClass(Orders.class);
    }

    public Orders findByOrderId(Integer orderId) {
        return em.createNamedQuery("Orders.findByOrderId", Orders.class)
                .setParameter("orderId", orderId)
                .getSingleResult();
    }

    public List<Orders> findByUser(Users user) {
        return em.createQuery("SELECT o FROM Orders o WHERE o.userId = :user ORDER BY o.orderDate DESC", Orders.class)
                .setParameter("user", user)
                .getResultList();
    }

    public List<Orders> findByUserId(int userId) {
        String jpql = "SELECT o FROM Orders o WHERE o.userId.userId = :userId";
        return em.createQuery(jpql, Orders.class)
                .setParameter("userId", userId)
                .getResultList();
    }

}
