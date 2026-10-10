package servlet;

import da.ProductDA;
import da.WishlistDA;
import entity.Product;
import entity.Users;
import entity.Wishlist;
import entity.WishlistItem;
import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.LinkedHashMap;
import java.util.Map;

public class WishlistServlet extends HttpServlet {

    @EJB
    private WishlistDA wishlistDA;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Users user = (Users) request.getSession().getAttribute("user");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        Wishlist wishlist = wishlistDA.findByUser(user);

        Map<WishlistItem, Product> wishlistItemMap = new LinkedHashMap<>();

        if (wishlist != null) {
            for (WishlistItem item : wishlist.getWishlistItemCollection()) {
                Product product = item.getProductId();
                wishlistItemMap.put(item, product);
            }
        }

        request.setAttribute("wishlistItemMap", wishlistItemMap);

        request.getRequestDispatcher("wishlist.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Users user = (Users) request.getSession().getAttribute("user");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");

        if ("remove".equals(action)) {
            String wishlistItemIdParam = request.getParameter("wishlistItemId");

            if (wishlistItemIdParam != null) {
                int wishlistItemId = Integer.parseInt(wishlistItemIdParam);

                WishlistItem item = wishlistDA.findWishlistItemById(wishlistItemId);
                wishlistDA.removeItem(item);
            }

            response.sendRedirect("WishlistServlet");
            return;
        }

        int productId = Integer.parseInt(request.getParameter("productId"));

        Wishlist wishlist = wishlistDA.findByNamedQuery("Wishlist.findByUserId", "userId", user)
                .stream().findFirst().orElse(null);

        if (wishlist == null) {
            wishlist = new Wishlist();
            wishlist.setUserId(user);
            wishlistDA.create(wishlist);
        }

        WishlistItem existingItem = wishlistDA.findItemByProductAndWishlist(productId, wishlist.getWishlistId());

        if (existingItem != null) {
            wishlistDA.removeItem(existingItem);
        } else {
            WishlistItem newItem = new WishlistItem();
            newItem.setProductId(new Product(productId));
            newItem.setWishlistId(wishlist);
            wishlistDA.addItem(newItem);
        }

        response.sendRedirect("/Assignment/ProductServlet?action=single&id=" + productId);
    }

}
