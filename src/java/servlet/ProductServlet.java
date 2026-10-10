package servlet;

import da.ProductDA;
import da.ReviewDA;
import da.WishlistDA;
import entity.Product;
import entity.Review;
import entity.Users;
import entity.Wishlist;
import jakarta.ejb.EJB;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.*;
import java.util.stream.Collectors;

public class ProductServlet extends HttpServlet {

    @EJB
    private ProductDA productDA;

    @EJB
    private ReviewDA reviewDA;

    @EJB
    private WishlistDA wishlistDA;
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("list".equals(action)) {
            handleProductList(request, response);
        } else if ("single".equals(action)) {
            handleSingleProduct(request, response);
        } else if ("best".equals(action)) {
            handleBestProducts(request, response);
        } else if ("search".equals(action)) {
            handleSearch(request, response);
        }

    }

    private void handleProductList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String category = request.getParameter("category");
        String subcategory = request.getParameter("subcategory");
        String sort = request.getParameter("sort");

        List<Product> productList = getFilteredProducts(category, subcategory, sort);
        setProductRatings(productList);

        request.setAttribute("productList", productList);
        request.getRequestDispatcher("shop.jsp").forward(request, response);
    }

    private List<Product> getFilteredProducts(String category, String subcategory, String sort) {
        if ((category != null || subcategory != null) && sort != null) {
            return productDA.findByCategoryAndSort(category, subcategory, sort);
        } else if (category != null || subcategory != null) {
            return productDA.findByCategory(category, subcategory);
        } else if (sort != null) {
            return productDA.getProducts(sort);
        }
        return productDA.findAll();
    }

    private void setProductRatings(List<Product> products) {
        List<Integer> productIds = products.stream()
                .map(Product::getProductId)
                .collect(Collectors.toList());

        Map<Integer, Double> averageRatings = reviewDA.getAverageRatingsForProducts(productIds);
        Map<Integer, Long> reviewCounts = reviewDA.getReviewCountsForProducts(productIds);

        products.forEach(product -> {
            product.setAverageRating(averageRatings.getOrDefault(product.getProductId(), 0.0));
            product.setReviewCount(reviewCounts.getOrDefault(product.getProductId(), 0L).intValue());
        });
    }

    private void handleSingleProduct(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        Users user = (Users) request.getSession().getAttribute("user");

        int productId = Integer.parseInt(request.getParameter("id"));
        Product product = productDA.findByProductId(productId);

        boolean isInWishlist = false;
        if (user != null) {
            isInWishlist = wishlistDA.isProductInWishlist(productId, user);
        }
        
        if (product == null) {
            response.sendRedirect(request.getContextPath() + "/ProductServlet?action=list");
            return;
        }

        List<Review> reviews = reviewDA.findByProductId(productId);

        // Calculate ratings
        double averageRating = reviews.stream()
                .mapToInt(Review::getRating)
                .average()
                .orElse(0.0);

        Map<Integer, Long> ratingCounts = reviews.stream()
                .collect(Collectors.groupingBy(Review::getRating, Collectors.counting()));

        // Set product ratings
        product.setAverageRating(averageRating);
        product.setReviewCount(reviews.size());

        // Set request attributes
        request.setAttribute("product", product);
        request.setAttribute("reviews", reviews);
        request.setAttribute("averageRating", averageRating);
        request.setAttribute("reviewCount", reviews.size());
        request.setAttribute("ratingCounts", ratingCounts);
        request.setAttribute("isInWishlist", isInWishlist);

        request.getRequestDispatcher("shop-single.jsp").forward(request, response);
    }

    private void handleBestProducts(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Product> allProducts = productDA.findAll();
        setProductRatings(allProducts);

        List<Product> bestProducts = allProducts.stream()
                .sorted(Comparator.comparing(Product::getAverageRating).reversed()
                        .thenComparing(Product::getReviewCount, Comparator.reverseOrder()))
                .limit(3)
                .collect(Collectors.toList());

        request.setAttribute("bestProducts", bestProducts);
        request.getRequestDispatcher("index.jsp").forward(request, response);
    }

    private void handleSearch(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String query = request.getParameter("q");

        if (query == null || query.trim().isEmpty()) {
            request.getSession().setAttribute("informationMessage", "Please enter a search term.");
            response.sendRedirect("shop.jsp");
            return;
        }

        // Sanitize and search
        List<Product> matchingProducts = productDA.findAll().stream()
                .filter(p -> p.getName().toLowerCase().contains(query.toLowerCase()))
                .collect(Collectors.toList());

        setProductRatings(matchingProducts); // Optional if you want ratings shown

        if (matchingProducts.isEmpty()) {
            request.setAttribute("informationMessage", "No products found for: " + query);
        }

        request.setAttribute("searchQuery", query);
        request.setAttribute("productList", matchingProducts);
        request.getRequestDispatcher("shop.jsp").forward(request, response);
    }

}
