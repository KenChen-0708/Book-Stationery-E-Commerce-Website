package servlet;

import da.CartItemDA;
import entity.CartItem;
import entity.Users;
import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

public class CartCountServlet extends HttpServlet {

    @EJB
    private CartItemDA cartItemDA;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Users user = (Users) request.getSession().getAttribute("user");
        int cartCount = 0;

        if (user != null) {
            List<CartItem> cartItems = cartItemDA.findByUserId(user.getUserId());
            for (CartItem item : cartItems) {
                cartCount++;
            }
        }

        response.setContentType("text/plain");
        PrintWriter out = response.getWriter();
        out.print(cartCount);
        out.flush();
    }
}
