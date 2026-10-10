package servlet;

import da.*;
import entity.*;
import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.Date;
import java.util.List;
import java.util.UUID;

public class PaymentServlet extends HttpServlet {

    @EJB
    private CartItemDA cartItemDA;

    @EJB
    private OrdersDA ordersDA;

    @EJB
    private ProductDA productDA;

    @EJB
    private CardDetailsDA cardDetailsDA;

    @EJB
    private AddressDA addressDA;

    @EJB
    private OrderItemDA orderItemDA;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Users user = (Users) request.getSession().getAttribute("user");

        if (user == null || !"CUSTOMER".equals(user.getRole())) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");

        if ("display".equalsIgnoreCase(action)) {
            displayCheckoutPage(request, response, user);
        } else if ("checkout".equalsIgnoreCase(action)) {
            processCheckout(request, response, user);
        } else if ("buyNow".equalsIgnoreCase(action)) {
            processBuyNow(request, response, user);
        }

    }

    private void displayCheckoutPage(HttpServletRequest request, HttpServletResponse response, Users user)
            throws ServletException, IOException {
        List<CartItem> cartItems = cartItemDA.findByUserId(user.getUserId());

        if (cartItems.isEmpty()) {
            request.setAttribute("error", "Your cart is empty");
            response.sendRedirect("cart.jsp");
            return;
        }

        BigDecimal cartTotal = calculateCartTotal(cartItems);
        BigDecimal deliveryFee = calculateDeliveryFee(cartTotal);
        BigDecimal grandTotal = cartTotal.add(deliveryFee);

        request.setAttribute("cartItems", cartItems);
        request.setAttribute("cartTotal", cartTotal);
        request.setAttribute("deliveryFee", deliveryFee);
        request.setAttribute("grandTotal", grandTotal);

        request.setAttribute("savedAddress", addressDA.findLatestByUserId(user.getUserId()));
        request.setAttribute("savedCard", cardDetailsDA.findDefaultByUserId(user.getUserId()));
        request.setAttribute("isFirstTime", ordersDA.findByUserId(user.getUserId()).isEmpty());

        request.getRequestDispatcher("payment.jsp").forward(request, response);
    }

    private void processCheckout(HttpServletRequest request, HttpServletResponse response, Users user)
            throws ServletException, IOException {
        try {
            List<CartItem> cartItems = cartItemDA.findByUserId(user.getUserId());

            if (cartItems.isEmpty()) {
                request.setAttribute("error", "Your cart is empty");
                response.sendRedirect("cart.jsp");
                return;
            }

            BigDecimal cartTotal = calculateCartTotal(cartItems);
            BigDecimal deliveryFee = calculateDeliveryFee(cartTotal);
            BigDecimal discount = BigDecimal.ZERO;

            // === Handle Promo Code ===
            String promoCode = request.getParameter("promoCode");
            if (promoCode != null && promoCode.trim().equalsIgnoreCase("HelloWorld")) {
                discount = BigDecimal.valueOf(5);
            }

            BigDecimal grandTotal = cartTotal.add(deliveryFee).subtract(discount);
            if (grandTotal.compareTo(BigDecimal.ZERO) < 0) {
                grandTotal = BigDecimal.ZERO;
            }

            // === Collect address information ===
            String addressLine = request.getParameter("address");
            String state = request.getParameter("state");
            String postalCode = request.getParameter("zip");
            String country = request.getParameter("country");
            String fullAddress = addressLine + ", " + state + ", " + postalCode + ", " + country;

            // === Collect card information ===
            String cardholderName = request.getParameter("ccName");
            String cardNumber = request.getParameter("ccNumber");
            String expiryMonthStr = request.getParameter("expiryMonth");
            String expiryYearStr = request.getParameter("expiryYear");

            Integer expiryMonth = null;
            Integer expiryYear = null;

            if (expiryMonthStr != null && !expiryMonthStr.trim().isEmpty()
                    && expiryYearStr != null && !expiryYearStr.trim().isEmpty()) {

                expiryMonth = Integer.parseInt(expiryMonthStr.trim());
                expiryYear = Integer.parseInt(expiryYearStr.trim());
            }

            String paymentMethod = request.getParameter("paymentMethod");
            if (paymentMethod == null) {
                paymentMethod = "UNKNOWN";
            }

            boolean saveAddress = "on".equals(request.getParameter("saveAddress"));
            boolean saveCard = "on".equals(request.getParameter("saveCard"));

            // === Handle address saving or updating ===
            if (saveAddress) {
                Address existing = addressDA.findLatestByUserId(user.getUserId());
                if (existing != null) {
                    existing.setRecipientName(user.getUsername());
                    existing.setAddressLine(addressLine);
                    existing.setPostalCode(postalCode);
                    existing.setState(state);
                    existing.setCountry(country);
                    existing.setSavedAt(new Date());
                    addressDA.update(existing);
                } else {
                    Address addr = new Address();
                    addr.setUserId(user);
                    addr.setRecipientName(user.getUsername());
                    addr.setAddressLine(addressLine);
                    addr.setPostalCode(postalCode);
                    addr.setState(state);
                    addr.setCountry(country);
                    addr.setSavedAt(new Date());
                    addressDA.create(addr);
                }
            }

            // === Process card saving or updating ===
            if (saveCard) {
                CardDetails existing = cardDetailsDA.findDefaultByUserId(user.getUserId());
                if (existing != null) {
                    existing.setCardholderName(cardholderName);
                    existing.setCardNumber(cardNumber);
                    existing.setExpiryMonth(expiryMonth);
                    existing.setExpiryYear(expiryYear);
                    existing.setBillingAddress(fullAddress);
                    existing.setPaymentMethod(paymentMethod);
                    existing.setSavedAt(new Date());
                    cardDetailsDA.update(existing);
                } else {
                    CardDetails card = new CardDetails();
                    card.setUserId(user);
                    card.setCardholderName(cardholderName);
                    card.setCardNumber(cardNumber);
                    card.setExpiryMonth(expiryMonth);
                    card.setExpiryYear(expiryYear);
                    card.setBillingAddress(fullAddress);
                    card.setPaymentMethod(paymentMethod);
                    card.setSavedAt(new Date());
                    cardDetailsDA.create(card);
                }
            }

            // === Create an order ===
            Orders order = new Orders();
            order.setUserId(user);
            order.setOrderDate(new Date());
            order.setStatus("PAID");
            order.setTotalPrice(grandTotal);
            order.setShippingFee(deliveryFee);
            order.setDiscount(discount);
            order.setShippingAddress(fullAddress);
            order.setPaymentMethod(paymentMethod);
            order.setTransactionNumber(generateTransactionNumber());
            ordersDA.create(order);

            // === Create order item & update inventory ===
            for (CartItem cartItem : cartItems) {
                OrderItem orderItem = new OrderItem();
                orderItem.setOrderId(order);
                orderItem.setProductId(cartItem.getProductId());
                orderItem.setQuantity(cartItem.getQuantity());
                orderItem.setPrice(
                        cartItem.getProductId().getPrice().multiply(BigDecimal.valueOf(cartItem.getQuantity()))
                );
                orderItemDA.create(orderItem);

                Product product = cartItem.getProductId();
                product.setStock(product.getStock() - cartItem.getQuantity());
                productDA.update(product);
            }

            clearUserCart(user.getUserId());
            request.setAttribute("order", order);
            request.getRequestDispatcher("payment-success.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Checkout failed: " + e.getMessage());
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
    }

    private void processBuyNow(HttpServletRequest request, HttpServletResponse response, Users user)
            throws ServletException, IOException {
        try {
            int productId = Integer.parseInt(request.getParameter("productId"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));

            Product product = productDA.find(productId);

            if (product == null || product.getStock() < quantity) {
                request.setAttribute("error", "Product is unavailable or out of stock.");
                response.sendRedirect("ProductServlet?action=single&id=" + productId);
                return;
            }

            // Calculate totals
            BigDecimal subtotal = product.getPrice().multiply(BigDecimal.valueOf(quantity));
            BigDecimal deliveryFee = calculateDeliveryFee(subtotal);
            BigDecimal discount = BigDecimal.ZERO;

            String promoCode = request.getParameter("promoCode");
            if (promoCode != null && promoCode.trim().equalsIgnoreCase("HelloWorld")) {
                discount = BigDecimal.valueOf(5);
            }

            BigDecimal grandTotal = subtotal.add(deliveryFee).subtract(discount);
            if (grandTotal.compareTo(BigDecimal.ZERO) < 0) {
                grandTotal = BigDecimal.ZERO;
            }

            // Address info
            String addressLine = request.getParameter("address");
            String state = request.getParameter("state");
            String postalCode = request.getParameter("zip");
            String country = request.getParameter("country");
            String fullAddress = addressLine + ", " + state + ", " + postalCode + ", " + country;

            // Card info
            String cardholderName = request.getParameter("ccName");
            String cardNumber = request.getParameter("ccNumber");
            String expiryMonthStr = request.getParameter("expiryMonth");
            String expiryYearStr = request.getParameter("expiryYear");

            Integer expiryMonth = null;
            Integer expiryYear = null;

            if (expiryMonthStr != null && !expiryMonthStr.trim().isEmpty()
                    && expiryYearStr != null && !expiryYearStr.trim().isEmpty()) {

                expiryMonth = Integer.parseInt(expiryMonthStr.trim());
                expiryYear = Integer.parseInt(expiryYearStr.trim());
            }

            String paymentMethod = request.getParameter("paymentMethod");
            if (paymentMethod == null) {
                paymentMethod = "UNKNOWN";
            }

            boolean saveAddress = "on".equals(request.getParameter("saveAddress"));
            boolean saveCard = "on".equals(request.getParameter("saveCard"));

            // Save address
            if (saveAddress) {
                Address existing = addressDA.findLatestByUserId(user.getUserId());
                if (existing != null) {
                    existing.setRecipientName(user.getUsername());
                    existing.setAddressLine(addressLine);
                    existing.setPostalCode(postalCode);
                    existing.setState(state);
                    existing.setCountry(country);
                    existing.setSavedAt(new Date());
                    addressDA.update(existing);
                } else {
                    Address addr = new Address();
                    addr.setUserId(user);
                    addr.setRecipientName(user.getUsername());
                    addr.setAddressLine(addressLine);
                    addr.setPostalCode(postalCode);
                    addr.setState(state);
                    addr.setCountry(country);
                    addr.setSavedAt(new Date());
                    addressDA.create(addr);
                }
            }

            // Save card
            if (saveCard) {
                CardDetails existing = cardDetailsDA.findDefaultByUserId(user.getUserId());
                if (existing != null) {
                    existing.setCardholderName(cardholderName);
                    existing.setCardNumber(cardNumber);
                    existing.setExpiryMonth(expiryMonth);
                    existing.setExpiryYear(expiryYear);
                    existing.setBillingAddress(fullAddress);
                    existing.setPaymentMethod(paymentMethod);
                    existing.setSavedAt(new Date());
                    cardDetailsDA.update(existing);
                } else {
                    CardDetails card = new CardDetails();
                    card.setUserId(user);
                    card.setCardholderName(cardholderName);
                    card.setCardNumber(cardNumber);
                    card.setExpiryMonth(expiryMonth);
                    card.setExpiryYear(expiryYear);
                    card.setBillingAddress(fullAddress);
                    card.setPaymentMethod(paymentMethod);
                    card.setSavedAt(new Date());
                    cardDetailsDA.create(card);
                }
            }

            // Create order
            Orders order = new Orders();
            order.setUserId(user);
            order.setOrderDate(new Date());
            order.setStatus("PAID");
            order.setTotalPrice(grandTotal);
            order.setShippingFee(deliveryFee);
            order.setDiscount(discount);
            order.setShippingAddress(fullAddress);
            order.setPaymentMethod(paymentMethod);
            order.setTransactionNumber(generateTransactionNumber());
            ordersDA.create(order);

            // Create order item
            OrderItem orderItem = new OrderItem();
            orderItem.setOrderId(order);
            orderItem.setProductId(product);
            orderItem.setQuantity(quantity);
            orderItem.setPrice(product.getPrice().multiply(BigDecimal.valueOf(quantity)));
            orderItemDA.create(orderItem);

            // Update stock
            product.setStock(product.getStock() - quantity);
            productDA.update(product);

            request.setAttribute("order", order);
            request.getRequestDispatcher("payment-success.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Buy Now checkout failed: " + e.getMessage());
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
    }

    private BigDecimal calculateCartTotal(List<CartItem> cartItems) {
        return cartItems.stream()
                .map(CartItem::getSubtotal)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
    }

    private BigDecimal calculateDeliveryFee(BigDecimal cartTotal) {
        return cartTotal.compareTo(BigDecimal.valueOf(100)) >= 0
                ? BigDecimal.ZERO
                : BigDecimal.valueOf(5);
    }

    private void clearUserCart(Integer userId) {
        List<CartItem> cartItems = cartItemDA.findByUserId(userId);
        for (CartItem item : cartItems) {
            cartItemDA.delete(item.getCartItemId());
        }
    }

    private String generateTransactionNumber() {
        return "TXN-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase();
    }
}
