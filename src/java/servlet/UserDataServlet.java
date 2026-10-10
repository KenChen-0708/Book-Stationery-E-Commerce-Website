package servlet;

import da.*;
import entity.Users;
import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

public class UserDataServlet extends HttpServlet {

    @EJB
    private UserDA userDA;

    @Override
    public void init() {
        userDA.setEntityClass(Users.class);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Users> userList = userDA.findAll();
        List<String> roles = userDA.getAllDistinctRoles();
        request.setAttribute("roleList", roles);

        request.setAttribute("userList", userList);
        request.getRequestDispatcher("./manager/users.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        try {
            switch (action) {
                case "add":
                    Users newUser = new Users();
                    populateUserFromRequest(request, newUser);
                    userDA.create(newUser);
                    break;
                case "edit":
                    int userId = Integer.parseInt(request.getParameter("userId"));
                    Users existingUser = userDA.find(userId);
                    populateUserFromRequest(request, existingUser);
                    userDA.update(existingUser);
                    break;
                case "delete":
                    int deleteId = Integer.parseInt(request.getParameter("userId"));
                    userDA.delete(deleteId);
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect("UserDataServlet");
    }

    private void populateUserFromRequest(HttpServletRequest request, Users user) {
        user.setUsername(request.getParameter("username"));
        user.setEmail(request.getParameter("email"));
        user.setPhone(request.getParameter("phone"));
        user.setRole(request.getParameter("role"));
        user.setPassword(request.getParameter("password"));
    }
}
