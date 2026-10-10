package da;

import entity.Product;
import jakarta.annotation.PostConstruct;
import jakarta.ejb.Stateless;
import jakarta.persistence.TypedQuery;
import java.util.List;

@Stateless
public class ProductDA extends GenericDA<Product> {

    @PostConstruct
    public void init() {
        setEntityClass(Product.class);
    }

    public Product findByProductId(Integer productId) {
        return em.createNamedQuery("Product.findByProductId", Product.class)
                .setParameter("productId", productId)
                .getSingleResult();
    }

    // Method to find products by category and subcategory
    public List<Product> findByCategory(String categoryMain, String categorySub) {
        List<Product> products = null;

        try {
            String sql = "SELECT p FROM Product p WHERE 1=1";

            // Add conditions for category and subcategory
            if (categoryMain != null && !categoryMain.isEmpty()) {
                sql += " AND p.categoryMain = :categoryMain";
            }
            if (categorySub != null && !categorySub.isEmpty()) {
                sql += " AND p.categorySub = :categorySub";
            }

            // Create the query with dynamic parameters
            TypedQuery<Product> query = em.createQuery(sql, Product.class);

            // Set the parameters dynamically based on the provided values
            if (categoryMain != null && !categoryMain.isEmpty()) {
                query.setParameter("categoryMain", categoryMain);
            }
            if (categorySub != null && !categorySub.isEmpty()) {
                query.setParameter("categorySub", categorySub);
            }

            // Execute the query and fetch results
            products = query.getResultList();
        } catch (Exception e) {
            e.printStackTrace();
        }

        return products;
    }

    public List<Product> findByCategoryAndSort(String category, String subcategory, String sort) {
        String query = "SELECT p FROM Product p WHERE 1=1";

        if (category != null && !category.isEmpty()) {
            query += " AND p.categoryMain = :category";
        }
        if (subcategory != null && !subcategory.isEmpty()) {
            query += " AND p.categorySub = :subcategory";
        }

        // Add ORDER BY clause
        switch (sort) {
            case "aToZ":
                query += " ORDER BY p.name ASC";
                break;
            case "priceLowToHigh":
                query += " ORDER BY p.price ASC";
                break;
            case "priceHighToLow":
                query += " ORDER BY p.price DESC";
                break;
            case "newArrivals":
            default:
                query += " ORDER BY p.createdAt DESC";
                break;
        }

        TypedQuery<Product> typedQuery = em.createQuery(query, Product.class);

        if (category != null && !category.isEmpty()) {
            typedQuery.setParameter("category", category);
        }
        if (subcategory != null && !subcategory.isEmpty()) {
            typedQuery.setParameter("subcategory", subcategory);
        }

        return typedQuery.getResultList();
    }

    public List<Product> getProducts(String sortOption) {
        String query = "SELECT p FROM Product p";

        switch (sortOption) {
            case "newArrivals":
                query += " ORDER BY p.createdAt DESC"; // Assuming createdAt exists
                break;
            case "aToZ":
                query += " ORDER BY p.name ASC";
                break;
            case "priceLowToHigh":
                query += " ORDER BY p.price ASC";
                break;
            case "priceHighToLow":
                query += " ORDER BY p.price DESC";
                break;
            default:
                query += " ORDER BY p.name ASC"; // Default fallback
        }

        TypedQuery<Product> typedQuery = em.createQuery(query, Product.class);
        return typedQuery.getResultList();
    }

    public List<String> getAllDistinctMainCategories() {
        return em.createQuery("SELECT DISTINCT p.categoryMain FROM Product p ORDER BY p.categoryMain", String.class)
                .getResultList();
    }

    public List<String> getAllDistinctSubCategories() {
        return em.createQuery("SELECT DISTINCT p.categorySub FROM Product p ORDER BY p.categorySub", String.class)
                .getResultList();
    }

    public List<String> getSubCategoriesByMain(String mainCategory) {
        return em.createQuery("SELECT DISTINCT p.categorySub FROM Product p WHERE p.categoryMain = :mainCategory ORDER BY p.categorySub", String.class)
                .setParameter("mainCategory", mainCategory)
                .getResultList();
    }

}
