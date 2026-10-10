package servlet;

import da.MessageDA;
import da.UserDA;
import entity.Message;
import entity.Users;
import jakarta.ejb.EJB;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.Date;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet("/MessageServlet")
public class MessageServlet extends HttpServlet {

    @EJB
    private MessageDA messageDA;

    @EJB
    private UserDA userDA;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            Users currentUser = (Users) request.getSession().getAttribute("user");
            if (currentUser == null) {
                request.setAttribute("informationMessage", "You must be logged in to contact seller.");
                RequestDispatcher dispatcher = request.getRequestDispatcher("/login.jsp");
                dispatcher.forward(request, response);
                return;
            }

            String action = request.getParameter("action");
            String view = getViewPath(currentUser);

            if ("delete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                messageDA.delete(id);
                response.sendRedirect("MessageServlet");
                return;
            } else if ("conversation".equals(action)) {
                int contactId = Integer.parseInt(request.getParameter("contactId"));
                Users contactUser = userDA.find(contactId);
                List<Message> conversation = messageDA.findConversation(currentUser, contactUser);

                for (Message msg : conversation) {
                    if (msg.getReceiverId().getUserId().equals(currentUser.getUserId())
                            && (msg.getIsRead() == null || !msg.getIsRead())) {
                        msg.setIsRead(true);
                        messageDA.update(msg);
                    }
                }

                request.setAttribute("messageList", conversation);
                request.setAttribute("conversationPartner", contactUser);
                loadContacts(request, currentUser);
                request.getRequestDispatcher(view).forward(request, response);
                return;
            } else if ("list".equals(action)) {
                List<Message> sentMessages = messageDA.findBySender(currentUser);
                List<Message> receivedMessages = messageDA.findByReceiver(currentUser);

                sentMessages.addAll(receivedMessages);
                sentMessages.sort((m1, m2) -> m1.getMessageId().compareTo(m2.getMessageId()));

                request.setAttribute("messageList", sentMessages);
                loadContacts(request, currentUser);
                request.getRequestDispatcher(view).forward(request, response);
                return;
            }

            List<Message> messageList = messageDA.findAll();
            request.setAttribute("messageList", messageList);
            loadContacts(request, currentUser);
            request.getRequestDispatcher(view).forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("MessageServlet?error=" + e.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            Users currentUser = (Users) request.getSession().getAttribute("user");
            if (currentUser == null) {
                request.setAttribute("informationMessage", "You must be logged in to contact seller.");
                RequestDispatcher dispatcher = request.getRequestDispatcher("/login.jsp");
                dispatcher.forward(request, response);
                return;
            }

            String action = request.getParameter("action");

            if ("delete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                messageDA.delete(id);
                response.sendRedirect("MessageServlet");
                return;
            }

            String content = request.getParameter("content");
            int senderId = Integer.parseInt(request.getParameter("senderId"));
            int receiverId = Integer.parseInt(request.getParameter("receiverId"));

            Users sender = userDA.find(senderId);
            Users receiver = userDA.find(receiverId);

            Message message = new Message();
            message.setContent(content);
            message.setSenderId(sender);
            message.setReceiverId(receiver);
            message.setIsRead(false);
            message.setSentAt(new Date());

            if ("edit".equals(action)) {
                int messageId = Integer.parseInt(request.getParameter("messageId"));
                message.setMessageId(messageId);
                messageDA.update(message);
            } else {
                messageDA.create(message);
            }

            String xRequestedWith = request.getHeader("X-Requested-With");
            if ("XMLHttpRequest".equals(xRequestedWith)) {
                response.setContentType("application/json");
                response.getWriter().write("{\"status\":\"success\", \"message\": {\"content\":\"" + message.getContent()
                        + "\", \"sender\":\"" + sender.getUsername()
                        + "\", \"timestamp\":\"" + message.getSentAt().toString() + "\"}}");
                return;
            }

            if (receiverId > 0) {
                response.sendRedirect("MessageServlet?action=conversation&contactId=" + receiverId);
            } else {
                response.sendRedirect("MessageServlet");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("MessageServlet?error=" + e.getMessage());
        }
    }

    private void loadContacts(HttpServletRequest request, Users currentUser) {
        try {
            List<Users> allUsers = userDA.findAll();

            if (isManager(currentUser) || isStaff(currentUser)) {
                List<Users> contacts = allUsers.stream()
                        .filter(u -> isCustomer(u)) // Only customer role
                        .collect(Collectors.toList());
                request.setAttribute("contactsList", contacts);
            } else {
                List<Users> staffList = allUsers.stream()
                        .filter(u -> isManager(u) || isStaff(u))
                        .collect(Collectors.toList());
                request.setAttribute("staffList", staffList);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private boolean isManager(Users user) {
        return "MANAGER".equals(user.getRole());
    }

    private boolean isStaff(Users user) {
        return "STAFF".equals(user.getRole());
    }

    private boolean isCustomer(Users user) {
        return "CUSTOMER".equals(user.getRole());
    }

    private String getViewPath(Users user) {
        if (isCustomer(user)) {
            return "./inbox.jsp";
        } else {
            return "./manager/manageMessage.jsp";
        }
    }
}
