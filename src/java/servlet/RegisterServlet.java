package servlet;

import da.GenericDA;
import entity.Users;

import java.io.IOException;
import java.util.List;
import java.util.regex.Pattern;

import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/registerServlet")
public class RegisterServlet extends HttpServlet {

    @EJB
    private GenericDA<Users> userDa;

    private static final Pattern EMAIL_PATTERN =
        Pattern.compile("^[A-Za-z0-9+_.-]+@(.+)$");

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String email = request.getParameter("email");

        // Basic field validation
        if (username == null || password == null || confirmPassword == null || email == null ||
            username.trim().isEmpty() || password.trim().isEmpty() ||
            confirmPassword.trim().isEmpty() || email.trim().isEmpty()) {

            request.setAttribute("errorMessage", "All fields are required.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        username = username.trim();
        password = password.trim();
        email = email.trim();

        // Username validation
        if (!username.matches("^[a-zA-Z0-9_]{4,20}$")) {
            request.setAttribute("errorMessage", "Username must be 4-20 characters long and contain only letters, numbers, or underscores.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        // Password validation
        if (password.length() < 8) {
            request.setAttribute("errorMessage", "Password must be at least 8 characters long.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        if (!password.equals(confirmPassword)) {
            request.setAttribute("errorMessage", "Passwords do not match!");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        // Email validation
        if (!EMAIL_PATTERN.matcher(email).matches()) {
            request.setAttribute("errorMessage", "Please enter a valid email address.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        userDa.setEntityClass(Users.class);

        // Username already taken?
        List<Users> existingUsers = userDa.findByNamedQuery("Users.findByUsername", "username", username);
        if (!existingUsers.isEmpty()) {
            request.setAttribute("errorMessage", "Username already exists!");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        // Email already registered?
        List<Users> existingEmails = userDa.findByNamedQuery("Users.findByEmail", "email", email);
        if (!existingEmails.isEmpty()) {
            request.setAttribute("errorMessage", "Email already registered!");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        // Create and persist new user
        Users newUser = new Users();
        newUser.setUsername(username);
        newUser.setPassword(password); // ⚠️ In real apps, hash the password
        newUser.setEmail(email);
        newUser.setRole("CUSTOMER");

        userDa.create(newUser);

        // Auto-login
        HttpSession session = request.getSession();
        session.setAttribute("user", newUser);

        // Redirect to homepage
        response.sendRedirect(request.getContextPath() + "/index.jsp");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("register.jsp").forward(request, response);
    }
}
