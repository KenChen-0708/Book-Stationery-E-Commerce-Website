package servlet;

import da.CardDetailsDA;
import da.OrdersDA;
import entity.CardDetails;
import entity.Orders;
import entity.Users;
import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/CardServlet")
public class CardServlet extends HttpServlet {

    @EJB
    private CardDetailsDA cardDA;

    @EJB
    private OrdersDA ordersDA;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) action = "list";

        switch (action) {
            case "delete":
                deleteCard(request, response);
                break;
            case "edit":
                showEditForm(request, response);
                break;
            default:
                listCards(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if ("add".equals(action)) {
            addCard(request, response);
        } else if ("update".equals(action)) {
            updateCard(request, response);
        }
    }

    private void listCards(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Users user = (Users) request.getSession().getAttribute("user");
        List<CardDetails> cardList = cardDA.findByUser(user);
        List<Orders> orderList = ordersDA.findByUser(user);

        request.setAttribute("cardList", cardList);
        request.setAttribute("orderList", orderList);
        request.setAttribute("activeTab", "billing");
        request.getRequestDispatcher("billing.jsp").forward(request, response);
        
    }

    private void addCard(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        Users user = (Users) request.getSession().getAttribute("user");

        String cardholderName = request.getParameter("cardholderName");
        String cardNumber = request.getParameter("cardNumber");
        String expiryMonthStr = request.getParameter("expiryMonth");
        String expiryYearStr = request.getParameter("expiryYear");
        String billingAddress = request.getParameter("billingAddress");
        String isDefaultStr = request.getParameter("isDefault");

        String errorMsg = null;

        if (cardholderName == null || cardholderName.length() < 2 || cardholderName.length() > 100) {
            errorMsg = "Cardholder name must be 2-100 characters.";
        } else if (cardNumber == null || !cardNumber.matches("\\d{16}")) {
            errorMsg = "Card number must be exactly 16 digits.";
        } else if (expiryMonthStr == null || expiryYearStr == null) {
            errorMsg = "Expiry date is required.";
        }

        int expiryMonth = 0;
        int expiryYear = 0;
        try {
            expiryMonth = Integer.parseInt(expiryMonthStr);
            expiryYear = Integer.parseInt(expiryYearStr);
            if (expiryMonth < 1 || expiryMonth > 12) {
                errorMsg = "Expiry month must be between 1 and 12.";
            } else if (expiryYear < 2024) {
                errorMsg = "Expiry year must be 2024 or later.";
            }
        } catch (NumberFormatException e) {
            errorMsg = "Expiry month and year must be valid numbers.";
        }

        if (errorMsg != null) {
            request.setAttribute("error", errorMsg);
            listCards(request, response);
            return;
        }

        CardDetails card = new CardDetails();
        card.setUserId(user);
        card.setCardholderName(cardholderName);
        card.setCardNumber(cardNumber);
        card.setExpiryMonth(expiryMonth);
        card.setExpiryYear(expiryYear);
        card.setBillingAddress(billingAddress);
        String paymentMethod = request.getParameter("paymentMethod");
        card.setPaymentMethod(paymentMethod);
        card.setIsDefault("on".equals(isDefaultStr));

        cardDA.create(card);
        response.sendRedirect("CardServlet?action=list");
    }

    private void deleteCard(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int cardId = Integer.parseInt(request.getParameter("id"));
        cardDA.delete(cardId);
        response.sendRedirect("CardServlet?action=list");
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int cardId = Integer.parseInt(request.getParameter("id"));
        CardDetails card = cardDA.find(cardId);
        request.setAttribute("card", card);
        request.getRequestDispatcher("editCard.jsp").forward(request, response);
    }

    private void updateCard(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int cardId = Integer.parseInt(request.getParameter("cardId"));
        CardDetails card = cardDA.find(cardId);

        card.setCardholderName(request.getParameter("cardholderName"));
        card.setCardNumber(request.getParameter("cardNumber"));
        card.setExpiryMonth(Integer.parseInt(request.getParameter("expiryMonth")));
        card.setExpiryYear(Integer.parseInt(request.getParameter("expiryYear")));
        card.setBillingAddress(request.getParameter("billingAddress"));
        card.setPaymentMethod(request.getParameter("paymentMethod"));
        card.setIsDefault("on".equals(request.getParameter("isDefault")));

        cardDA.update(card);
        response.sendRedirect("CardServlet?action=list");
    }
}
