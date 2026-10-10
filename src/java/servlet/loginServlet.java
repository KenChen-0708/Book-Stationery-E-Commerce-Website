
package servlet;

import da.UserDA;
import entity.Users;

import java.io.IOException;
import java.util.List;

import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;

public class loginServlet extends HttpServlet {

    @EJB
    private UserDA userDa;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String remember = request.getParameter("remember");

        if (username == null || username.isEmpty() || password == null || password.isEmpty()) {
            request.setAttribute("errorMessage", "Username or Password cannot be empty.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        List<Users> users = userDa.findByNamedQuery("Users.findByUsername", "username", username);

        if (users.isEmpty() || !users.get(0).getPassword().equals(password)) {
            request.setAttribute("errorMessage", "Invalid username or password!");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        Users user = users.get(0);

        // Store username in session (for app logic)
        HttpSession session = request.getSession();
        session.setAttribute("user", user);

        // Handle "Remember Me" using cookie
        if ("on".equals(remember)) {
            Cookie usernameCookie = new Cookie("username", username);
            usernameCookie.setMaxAge(7 * 24 * 60 * 60); // 7 days
            usernameCookie.setPath(request.getContextPath());
            response.addCookie(usernameCookie);
        } else {
            // Clear cookie if "Remember Me" is not checked
            Cookie usernameCookie = new Cookie("username", null);
            usernameCookie.setMaxAge(0); // Delete cookie
            usernameCookie.setPath(request.getContextPath());
            response.addCookie(usernameCookie);
        }

        // Redirect based on user role
        switch (user.getRole().toUpperCase()) {
            case "MANAGER":
                response.sendRedirect("./manager/dashboard.jsp");
                break;
            case "STAFF":
                response.sendRedirect("./staff/dashboard.jsp");
                break;
            case "CUSTOMER":
                response.sendRedirect("./");
                break;
            default:
                request.setAttribute("errorMessage", "Invalid user role!");
                request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
}
