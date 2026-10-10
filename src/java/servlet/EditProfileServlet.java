package servlet;

import da.GenericDA;
import entity.Users;
import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "EditProfileServlet", urlPatterns = {"/EditProfileServlet"})
public class EditProfileServlet extends HttpServlet {

    @EJB
    private GenericDA<Users> userDA;

    @Override
    public void init() throws ServletException {
        userDA.setEntityClass(Users.class);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Users user = (Users) session.getAttribute("user");

        if (user == null || !user.getRole().equals("CUSTOMER")) {
            response.sendRedirect("login.jsp");
            return;
        }

        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        // Password validation
        if ((password != null && !password.isEmpty()) || (confirmPassword != null && !confirmPassword.isEmpty())) {
            if (!password.equals(confirmPassword)) {
                request.setAttribute("informationMessage", "Passwords do not match.");
                request.getRequestDispatcher("editProfile.jsp").forward(request, response);
                return;
            } else {
                // Optionally hash the password before saving!
                user.setPassword(password);
            }
        }

        // Update user details
        user.setUsername(username);
        user.setEmail(email);
        user.setPhone(phone);

        userDA.update(user);
        session.setAttribute("user", user);

        // Optionally show a success message
        request.setAttribute("informationMessage", "Profile updated successfully.");
        request.getRequestDispatcher("profile.jsp").forward(request, response);
    }
}
