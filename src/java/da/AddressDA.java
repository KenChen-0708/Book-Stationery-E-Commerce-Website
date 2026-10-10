package da;

import entity.Address;
import entity.Users;
import jakarta.annotation.PostConstruct;
import jakarta.ejb.Stateless;
import java.util.List;

@Stateless
public class AddressDA extends GenericDA<Address> {

    @PostConstruct
    public void init() {
        this.setEntityClass(Address.class);
    }

    public List<Address> findByUser(Users user) {
        String jpql = "SELECT a FROM Address a WHERE a.userId = :user";
        return em.createQuery(jpql, Address.class)
                 .setParameter("user", user)
                 .getResultList();
    }

    public Address findMatchingAddress(Users user, String fullAddress, String postcode) {
        String jpql = "SELECT a FROM Address a WHERE a.userId = :user AND a.fullAddress = :addr AND a.postcode = :postcode";
        List<Address> results = em.createQuery(jpql, Address.class)
                                  .setParameter("user", user)
                                  .setParameter("addr", fullAddress)
                                  .setParameter("postcode", postcode)
                                  .getResultList();
        return results.isEmpty() ? null : results.get(0);
    }
    
    public Address findLatestByUserId(int userId) {
    String jpql = "SELECT a FROM Address a WHERE a.userId.userId = :userId ORDER BY a.savedAt DESC";
    List<Address> result = em.createQuery(jpql, Address.class)
                             .setParameter("userId", userId)
                             .setMaxResults(1)
                             .getResultList();
    return result.isEmpty() ? null : result.get(0);
}
}
