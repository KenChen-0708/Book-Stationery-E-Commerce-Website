package da;

import entity.Report;
import entity.OrderItem;
import entity.Orders;
import jakarta.annotation.PostConstruct;
import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.Query;
import jakarta.persistence.TypedQuery;
import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Stateless
public class ReportDA extends GenericDA<Report> {

    @PersistenceContext
    private EntityManager em;

    @PostConstruct
    public void init() {
        setEntityClass(Report.class);
    }

    public List<Integer> getAvailableYears() {
        String jpql = "SELECT DISTINCT FUNCTION('YEAR', o.orderDate) FROM Orders o WHERE o.status = 'COMPLETED' ORDER BY FUNCTION('YEAR', o.orderDate) DESC";
        TypedQuery<Integer> query = em.createQuery(jpql, Integer.class);
        List<Integer> years = query.getResultList();

        // If no years were found, add the current year
        if (years.isEmpty()) {
            years.add(Calendar.getInstance().get(Calendar.YEAR));
        }

        return years;
    }

    public Map<String, Double> generateSalesReportByDateRange(String fromDate, String toDate) {
        Map<String, Double> salesData = new HashMap<>();

        try {
            // No need to convert to Date if we use strings in SQL
            // But still parse for potential error checking
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            sdf.parse(fromDate);
            sdf.parse(toDate);

            // Native SQL query with DATE() to group by date only
            String sql = "SELECT DATE(order_date) AS order_day, SUM(total_price) AS total_sales "
                    + "FROM orders "
                    + "WHERE DATE(order_date) BETWEEN ? AND ? "
                    + "AND status = 'DELIVERED' "
                    + "GROUP BY DATE(order_date) "
                    + "ORDER BY DATE(order_date)";

            Query query = em.createNativeQuery(sql);
            query.setParameter(1, fromDate);
            query.setParameter(2, toDate);

            @SuppressWarnings("unchecked")
            List<Object[]> results = query.getResultList();

            for (Object[] row : results) {
                String orderDay = row[0].toString(); // Already in yyyy-MM-dd format
                double total = 0.0;

                if (row[1] instanceof BigDecimal) {
                    total = ((BigDecimal) row[1]).doubleValue();
                } else if (row[1] instanceof Double) {
                    total = (Double) row[1];
                }

                salesData.put(orderDay, total);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return salesData;
    }

    public List<Report> generateTopSoldProductsReport(int limit) {
        String jpql = "SELECT oi.productId.productId, oi.productId.name, SUM(oi.quantity) as totalSold "
                + "FROM OrderItem oi "
                + "GROUP BY oi.productId.productId, oi.productId.name "
                + "ORDER BY totalSold DESC";

        TypedQuery<Object[]> query = em.createQuery(jpql, Object[].class);
        query.setMaxResults(limit);  // Limit the number of products
        List<Object[]> results = query.getResultList();

        List<Report> topProducts = new ArrayList<>();
        for (Object[] row : results) {
            Integer productId = (Integer) row[0];
            String productName = (String) row[1];
            Long totalSold = (Long) row[2];

            topProducts.add(new Report(productId, productName, totalSold));
        }

        return topProducts;
    }

    public int getMaxProductCount() {
        // Query to get the total number of distinct products in the system
        String jpql = "SELECT COUNT(DISTINCT oi.productId) FROM OrderItem oi";

        Query query = em.createQuery(jpql);
        Long count = (Long) query.getSingleResult();

        // Return the count as an integer (defaulting to 1000 if no products exist)
        return count != null ? count.intValue() : 1000;  // Fallback to a large number if there are no products
    }

}
