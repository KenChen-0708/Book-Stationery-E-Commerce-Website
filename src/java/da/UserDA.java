package da;

import entity.Users;
import jakarta.annotation.PostConstruct;
import jakarta.ejb.Stateless;
import jakarta.persistence.TypedQuery;
import java.util.List;

@Stateless
public class UserDA extends GenericDA<Users> {

    @PostConstruct
    public void init() {
        this.setEntityClass(Users.class);
    }
    
    public List<String> getAllDistinctRoles() {
        String jpql = "SELECT DISTINCT u.role FROM Users u ORDER BY u.role";
        TypedQuery<String> query = em.createQuery(jpql, String.class);
        return query.getResultList();
    }
}
