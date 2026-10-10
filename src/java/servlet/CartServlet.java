package servlet;

import da.*;
import entity.*;
import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

public class CartServlet extends HttpServlet {

    @EJB
    private CartItemDA cartItemDA;

    @EJB
    private CartDA cartDA;

    @EJB
    private ProductDA productDA;

    @EJB
    private CardDetailsDA cardDetailsDA;

    @EJB
    private AddressDA addressDA;

    @EJB
    private OrdersDA ordersDA;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Users user = (Users) request.getSession().getAttribute("user");
        if (user == null) {
            request.setAttribute("informationMessage", "You must log in first.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        String action = request.getParameter("action");

        try {
            // Handle delete action
            if ("delete".equals(action)) {
                handleDelete(request, response, user);
                return;
            }

            // Handle quantity changes (increase/decrease)
//            if ("increase".equals(action) || "decrease".equals(action)) {
//                handleQuantityChange(request, response, user, action);
//                return;
//            }
            if ("update".equals(action)) {
                handleUpdateQuantity(request, response, user);
                return;
            }

            if ("buyNow".equals(action)) {
                handleBuyNow(request, response, user);
                return;
            }

            // Default action - add to cart
            handleAddToCart(request, response, user);

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid parameters");
        } catch (Exception e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Server error: " + e.getMessage());
        }
    }

    private void handleDelete(HttpServletRequest request, HttpServletResponse response, Users user)
            throws Exception {
        String cartItemIdParam = request.getParameter("cartItemId");
        if (cartItemIdParam == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing cart item ID");
            return;
        }

        int cartItemId = Integer.parseInt(cartItemIdParam);
        cartItemDA.delete(cartItemId);
        response.sendRedirect("CartServlet");
    }

//    private void handleQuantityChange(HttpServletRequest request, HttpServletResponse response,
//            Users user, String action) throws Exception {
//        String cartItemIdParam = request.getParameter("cartItemId");
//        String quantityParam = request.getParameter("quantity");
//
//        if (cartItemIdParam == null || quantityParam == null) {
//            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing parameters");
//            return;
//        }
//
//        int cartItemId = Integer.parseInt(cartItemIdParam);
//        int quantity = Integer.parseInt(quantityParam);
//
//        CartItem item = cartItemDA.find(cartItemId);
//        if (item == null) {
//            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Item not found");
//            return;
//        }
//
//        // Verify the item belongs to the user's cart
//        if (item.getCartId().getUserId().getUserId() != user.getUserId()) {
//            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Not authorized");
//            return;
//        }
//
//        // Update quantity
//        Product product = item.getProductId(); // Get associated product
//
//        if ("increase".equals(action)) {
//            if (item.getQuantity() < product.getStock()) {
//                item.setQuantity(item.getQuantity() + 1);
//            }
//        } else if ("decrease".equals(action)) {
//            if (item.getQuantity() > 1) {
//                item.setQuantity(item.getQuantity() - 1);
//            }
//        }
//
//        cartItemDA.update(item);
//        response.sendRedirect("CartServlet");
//    }
    private void handleUpdateQuantity(HttpServletRequest request, HttpServletResponse response, Users user)
            throws Exception {
        String cartItemIdParam = request.getParameter("cartItemId");
        String quantityParam = request.getParameter("quantity");

        if (cartItemIdParam == null || quantityParam == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing parameters");
            return;
        }

        int cartItemId = Integer.parseInt(cartItemIdParam);
        int quantity = Integer.parseInt(quantityParam);

        CartItem item = cartItemDA.find(cartItemId);
        if (item == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Item not found");
            return;
        }

        if (item.getCartId().getUserId().getUserId() != user.getUserId()) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Not authorized");
            return;
        }

        if (quantity < 1) {
            quantity = 1; // minimum 1
        }
        if (quantity > item.getProductId().getStock()) {
            quantity = item.getProductId().getStock(); // cap to stock
        }

        item.setQuantity(quantity);
        cartItemDA.update(item);

        response.sendRedirect("CartServlet");
    }

    private void handleAddToCart(HttpServletRequest request, HttpServletResponse response, Users user)
            throws Exception {
        String productIdParam = request.getParameter("productId");
        String quantityParam = request.getParameter("quantity");
        String redirect = request.getParameter("redirect");

        if (productIdParam == null || quantityParam == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing parameters");
            return;
        }

        int productId = Integer.parseInt(productIdParam);
        int quantity = Integer.parseInt(quantityParam);

        // Get or create user's cart
        Cart userCart = cartDA.findCartByUserId(user.getUserId());
        if (userCart == null) {
            userCart = new Cart();
            userCart.setUserId(user);
            cartDA.create(userCart);
        }

        // Check if product exists
        Product product = productDA.find(productId);
        if (product == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Product not found");
            return;
        }

        // Check if item already in cart
        CartItem existingItem = cartItemDA.findByCartAndProduct(userCart.getCartId(), productId);
        if (existingItem != null) {
            int newQuantity = existingItem.getQuantity() + quantity;
            if (newQuantity > product.getStock()) {
                newQuantity = product.getStock(); // Limit to available stock
            }
            existingItem.setQuantity(newQuantity);
            cartItemDA.update(existingItem);
        } else {
            if (quantity > product.getStock()) {
                quantity = product.getStock(); // Limit to available stock
            }

            CartItem newItem = new CartItem();
            newItem.setCartId(userCart);
            newItem.setProductId(product);
            newItem.setQuantity(quantity);
            cartItemDA.create(newItem);
        }

        if (redirect != null && !redirect.isEmpty()) {
            response.sendRedirect(redirect);
        } else {
            response.sendRedirect("CartServlet");
        }
    }

    private void handleBuyNow(HttpServletRequest request, HttpServletResponse response, Users user)
            throws Exception {
        String productIdParam = request.getParameter("productId");
        String quantityParam = request.getParameter("quantity");

        if (productIdParam == null || quantityParam == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing parameters");
            return;
        }

        int productId = Integer.parseInt(productIdParam);
        int quantity = Integer.parseInt(quantityParam);

        Product product = productDA.find(productId);
        if (product == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Product not found");
            return;
        }

        if (quantity > product.getStock()) {
            quantity = product.getStock();
        }

        CartItem tempItem = new CartItem();
        tempItem.setProductId(product);
        tempItem.setQuantity(quantity);

        BigDecimal cartTotal = tempItem.getSubtotal(); // Will be calculated correctly
        BigDecimal deliveryFee = cartTotal.compareTo(BigDecimal.valueOf(100)) >= 0
                ? BigDecimal.ZERO
                : BigDecimal.valueOf(5);
        BigDecimal grandTotal = cartTotal.add(deliveryFee);

        request.setAttribute("cartItems", List.of(tempItem));
        request.setAttribute("cartTotal", cartTotal);
        request.setAttribute("deliveryFee", deliveryFee);
        request.setAttribute("grandTotal", grandTotal);
        request.setAttribute("productId", productIdParam);
        request.setAttribute("quantity", quantityParam);
        request.setAttribute("isBuyNow", true);

        request.setAttribute("savedAddress", addressDA.findLatestByUserId(user.getUserId()));
        request.setAttribute("savedCard", cardDetailsDA.findDefaultByUserId(user.getUserId()));
        request.setAttribute("isFirstTime", ordersDA.findByUserId(user.getUserId()).isEmpty());

        request.getRequestDispatcher("/payment.jsp").forward(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Users user = (Users) request.getSession().getAttribute("user");
        if (user == null) {
            request.setAttribute("informationMessage", "You must log in to view your cart.");
            request.getRequestDispatcher("./login.jsp").forward(request, response);
            return;
        }

        List<CartItem> cartItems = cartItemDA.findByUserId(user.getUserId());

        BigDecimal cartTotal = BigDecimal.ZERO;
        for (CartItem item : cartItems) {
            cartTotal = cartTotal.add(item.getSubtotal());
        }

        BigDecimal deliveryFee = cartTotal.compareTo(BigDecimal.valueOf(100)) >= 0
                ? BigDecimal.ZERO
                : BigDecimal.valueOf(5);

        BigDecimal grandTotal = cartTotal.add(deliveryFee);

        request.setAttribute("cartItems", cartItems);
        request.setAttribute("cartTotal", cartTotal);
        request.setAttribute("deliveryFee", deliveryFee);
        request.setAttribute("grandTotal", grandTotal);

        request.getRequestDispatcher("/cart.jsp").forward(request, response);
    }
}
