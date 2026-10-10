package da;

import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.TypedQuery;
import java.util.List;

@Stateless
public class GenericDA<T> {

    @PersistenceContext(unitName = "AssignmentPU")
    EntityManager em;

    protected Class<T> entityClass;

    public void setEntityClass(Class<T> entityClass) {
        this.entityClass = entityClass;
    }

    public void create(T entity) {
        em.persist(entity);
        em.flush();
        em.refresh(entity); // Refresh immediately after create
    }

    public void update(T entity) {
        T mergedEntity = em.merge(entity);
        em.flush();
        em.refresh(mergedEntity); // Refresh the managed entity after merge
    }

    public void delete(Object id) {
        T entity = em.find(entityClass, id);
        if (entity != null) {
            em.remove(entity);
            em.flush(); // Optional: flush to DB immediately
        }
    }

    public T find(Object id) {
        T entity = em.find(entityClass, id);
        if (entity != null) {
            em.refresh(entity); // Refresh after find
        }
        return entity;
    }

    public List<T> findAll() {
        String queryName = entityClass.getSimpleName() + ".findAll";
        TypedQuery<T> query = em.createNamedQuery(queryName, entityClass);
        List<T> results = query.getResultList();

        for (T result : results) {
            em.refresh(result); // Refresh each result
        }
        return results;
    }

    public List<T> findByNamedQuery(String queryName, String paramName, Object paramValue) {
        TypedQuery<T> query = em.createNamedQuery(queryName, entityClass);
        query.setParameter(paramName, paramValue);
        List<T> results = query.getResultList();

        for (T result : results) {
            em.refresh(result);
        }
        return results;
    }

    public List<T> findByNamedQuery(String queryName, Object... params) {
        TypedQuery<T> query = em.createNamedQuery(queryName, entityClass);
        for (int i = 0; i < params.length; i += 2) {
            query.setParameter(params[i].toString(), params[i + 1]);
        }
        List<T> results = query.getResultList();

        for (T result : results) {
            em.refresh(result);
        }
        return results;
    }
}
