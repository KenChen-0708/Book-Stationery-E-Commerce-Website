package servlet;
import da.OrdersDA;
import entity.Orders;
import entity.Users;
import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.*;
import java.math.BigDecimal;
import java.sql.Date;
import java.text.SimpleDateFormat;
import java.util.List;

@MultipartConfig
@WebServlet("/OrderServlet")
public class OrderServlet extends HttpServlet {
    @EJB
    private OrdersDA ordersDA;
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("delete".equals(action)) {
            int deleteId = Integer.parseInt(request.getParameter("id"));
            ordersDA.delete(deleteId);
            response.sendRedirect("OrderServlet");
            return;
        }
        List<Orders> ordersList = ordersDA.findAll();
        request.setAttribute("ordersList", ordersList);
        request.getRequestDispatcher("./manager/manageOrders.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String action = request.getParameter("action");
            if ("delete".equals(action)) {
                int deleteId = Integer.parseInt(request.getParameter("id"));
                ordersDA.delete(deleteId);
                response.sendRedirect("OrderServlet");
                return;
            }
            
            Orders order = new Orders();
            order.setTotalPrice(new BigDecimal(request.getParameter("totalPrice")));
            order.setShippingAddress(request.getParameter("shippingAddress"));
            order.setPaymentMethod(request.getParameter("paymentMethod"));
            order.setShippingFee(new BigDecimal(request.getParameter("shippingFee")));
            order.setDiscount(new BigDecimal(request.getParameter("discount")));
            order.setStatus(request.getParameter("status"));
            order.setTransactionNumber(request.getParameter("transactionNumber"));
            
            // Handle the date parameter
            String dateParam = request.getParameter("orderDate");
            if (dateParam != null && !dateParam.isEmpty()) {
                try {
                    // Try to parse as yyyy-MM-dd (HTML5 date input format)
                    order.setOrderDate(Date.valueOf(dateParam));
                } catch (IllegalArgumentException e) {
                    // If not in yyyy-MM-dd format, try to parse the full date string
                    try {
                        SimpleDateFormat sdf = new SimpleDateFormat("EEE MMM dd HH:mm:ss zzz yyyy");
                        java.util.Date parsed = sdf.parse(dateParam);
                        order.setOrderDate(new Date(parsed.getTime()));
                    } catch (Exception ex) {
                        // If all parsing fails, set to current date
                        order.setOrderDate(new Date(System.currentTimeMillis()));
                    }
                }
            }
            
            if ("edit".equals(action)) {
                String orderIdParam = request.getParameter("orderId");
                if (orderIdParam != null && !orderIdParam.isEmpty()) {
                    try {
                        int orderId = Integer.parseInt(orderIdParam);
                        order.setOrderId(orderId);
                        
                        // For edit, we need to get the existing order to preserve the userId
                        Orders existingOrder = ordersDA.findByOrderId(orderId);
                        if (existingOrder != null && existingOrder.getUserId() != null) {
                            order.setUserId(existingOrder.getUserId());
                        } else {
                            // If for some reason we can't get the existing user, use the current user
                            HttpSession session = request.getSession();
                            Users currentUser = (Users) session.getAttribute("user");
                            if (currentUser != null) {
                                order.setUserId(currentUser);
                            }
                        }
                        
                        ordersDA.update(order);
                    } catch (NumberFormatException e) {
                        // Log the error
                        System.err.println("Error parsing orderId: " + orderIdParam);
                        e.printStackTrace();
                    }
                }
            } else {
                // For new orders, set the current user
                HttpSession session = request.getSession();
                Users currentUser = (Users) session.getAttribute("user");
                if (currentUser != null) {
                    order.setUserId(currentUser);
                }
                ordersDA.create(order);
            }
            
            response.sendRedirect("OrderServlet");
        } catch (Exception e) {
            // Log any errors
            e.printStackTrace();
            response.sendRedirect("OrderServlet?error=" + e.getMessage());
        }
    }
}