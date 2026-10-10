<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="entity.Message" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<jsp:include page="../include/adminHeader.jsp" />

<%
    entity.Users user = (entity.Users) session.getAttribute("user");
    if (user == null || !(user.getRole().equals("MANAGER") || user.getRole().equals("STAFF"))) {
        response.sendRedirect("../login.jsp");
        return;
    }

    if (request.getAttribute("messageList") == null) {
        response.sendRedirect(request.getContextPath() + "/MessageServlet?action=list");
        return;
    }
%>

<div class="container my-5">
    <h2 class="text-center mb-4">Customer Support Messages</h2>

    <div class="row mb-3">
        <div class="col text-end">
            <button class="btn btn-outline-primary" data-bs-toggle="modal" data-bs-target="#contactsModal">
                <i class="fas fa-users"></i> Customer Contacts
            </button>
        </div>
    </div>

    <!-- Chat header -->
    <div class="chat-header">
        <c:choose>
            <c:when test="${not empty conversationPartner}">
                <div class="d-flex align-items-center">
                    <div class="avatar">
                        <i class="fas fa-user-circle fa-2x"></i>
                    </div>
                    <div class="ms-3">
                        <h5 class="mb-0">${conversationPartner.username}</h5>
                        <small class="text-muted">Customer</small>
                    </div>
                </div>
            </c:when>
            <c:otherwise>
                <div class="text-center text-muted">
                    <i class="fas fa-comments"></i> Select a customer to start messaging
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- Chatbox Area -->
    <div class="chat-box" id="chatBox">
        <c:if test="${not empty conversationPartner}">
            <c:forEach var="m" items="${messageList}">
                <div class="chat-entry ${m.senderId.username == user.username ? 'sent' : 'received'}">
                    <div class="chat-bubble">
                        <p>${m.content}</p>
                        <span class="timestamp">${m.sentAt}</span>
                    </div>
                </div>
            </c:forEach>
        </c:if>

        <c:if test="${empty conversationPartner}">
            <div class="text-center text-muted p-5">
                <i class="fas fa-inbox fa-3x mb-3"></i>
                <p>No messages yet. Select a customer to start a conversation.</p>
            </div>
        </c:if>
    </div>

    <!-- Message input area -->
    <div class="message-input-container">
        <form id="sendMessageForm" action="${pageContext.request.contextPath}/MessageServlet" method="post">
            <input type="hidden" name="action" value="add">
            <input type="hidden" name="senderId" value="${user.userId}">
            <input type="hidden" name="receiverId" value="${conversationPartner != null ? conversationPartner.userId : ''}">

            <div class="input-group">
                <textarea class="form-control" id="messageContent" name="content" 
                          placeholder="Type your message..." rows="1" required></textarea>

                <button class="btn btn-primary" type="submit" ${empty conversationPartner ? 'disabled' : ''}>
                    <i class="fas fa-paper-plane"></i> Send
                </button>
            </div>
        </form>
    </div>
</div>

<!-- Contacts Modal -->
<div class="modal fade" id="contactsModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Customer Contacts</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <!-- Search -->
                <div class="input-group mb-3">
                    <span class="input-group-text"><i class="fas fa-search"></i></span>
                    <input type="text" class="form-control" id="contactSearch" placeholder="Search customers by name...">
                </div>

                <!-- Contact List -->
                <div class="list-group contact-list">
                    <c:forEach var="contact" items="${contactsList}">
                        <a href="MessageServlet?action=conversation&contactId=${contact.userId}" 
                           class="list-group-item list-group-item-action">
                            <div class="d-flex w-100 justify-content-between">
                                <h6 class="mb-1">${contact.username}</h6>
                                <small>${contact.role}</small>
                            </div>
                            <small class="text-muted">Click to start conversation</small>
                        </a>
                    </c:forEach>

                    <c:if test="${empty contactsList}">
                        <div class="text-center text-muted p-4">
                            <p>No customers found</p>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    $(document).ready(function () {
        
        $('#messageContent').focus();

        function scrollToBottom() {
            var chatBox = document.getElementById('chatBox');
            chatBox.scrollTop = chatBox.scrollHeight;
        }

        scrollToBottom();

        $('#messageContent').on('input', function () {
            this.style.height = 'auto';
            this.style.height = (this.scrollHeight) + 'px';
        });

        function sendMessage() {
            if ($('input[name="receiverId"]').val() === '') {
                return false;
            }

            $.ajax({
                type: 'POST',
                url: $('#sendMessageForm').attr('action'),
                data: $('#sendMessageForm').serialize(),
                success: function () {
                    $('#messageContent').val('');
                    $('#messageContent').css('height', 'auto');
                    location.reload(); // Refresh to show new message
                },
                error: function (error) {
                    alert('Error sending message. Please try again.');
                    console.error(error);
                }
            });
        }

        // Trigger sendMessage() on Enter key press (without Shift)
        $('#messageContent').on('keydown', function (e) {
            if (e.key === 'Enter' && !e.shiftKey) {
                e.preventDefault();
                sendMessage();
            }
        });

        // Trigger sendMessage() on form submit (Send button)
        $('#sendMessageForm').on('submit', function (e) {
            e.preventDefault();
            sendMessage();
        });

        // Contact search filter
        $('#contactSearch').on('keyup', function () {
            var searchTerm = $(this).val().toLowerCase();
            $('.contact-list .list-group-item').each(function () {
                var userName = $(this).find('h6').text().toLowerCase();
                var userRole = $(this).find('small').first().text().toLowerCase();
                var userInfo = userName + " " + userRole;
                $(this).toggle(userInfo.includes(searchTerm));
            });
        });
    });
</script>

<style>
    .chat-header {
        background-color: #f8f9fa;
        border: 1px solid #ccc;
        border-bottom: none;
        padding: 15px;
        border-radius: 8px 8px 0 0;
    }

    .chat-box {
        border: 1px solid #ccc;
        padding: 20px;
        background-color: #f9f9f9;
        height: 400px;
        overflow-y: auto;
        border-radius: 0;
    }

    .chat-entry {
        margin-bottom: 15px;
        display: flex;
        flex-direction: column;
    }

    .sent {
        align-items: flex-end;
    }

    .received {
        align-items: flex-start;
    }

    .sent .chat-bubble {
        background-color: #007bff;
        color: white;
        border-radius: 18px 18px 0 18px;
        padding: 10px 15px;
        max-width: 70%;
        margin-bottom: 5px;
        word-wrap: break-word;
    }

    .received .chat-bubble {
        background-color: #e2e2e2;
        color: #333;
        border-radius: 18px 18px 18px 0;
        padding: 10px 15px;
        max-width: 70%;
        margin-bottom: 5px;
        word-wrap: break-word;
    }

    .chat-bubble p {
        margin: 0;
    }

    .timestamp {
        font-size: 0.8em;
        color: rgba(255,255,255,0.7);
        display: block;
        margin-top: 5px;
        text-align: right;
    }

    .received .timestamp {
        color: #aaa;
    }

    .message-input-container {
        border: 1px solid #ccc;
        border-top: none;
        padding: 15px;
        background-color: #f8f9fa;
        border-radius: 0 0 8px 8px;
    }

    #messageContent {
        resize: none;
        overflow: hidden;
        min-height: 38px;
        max-height: 120px;
    }

    .avatar {
        color: #6c757d;
    }

    .contact-list {
        max-height: 400px;
        overflow-y: auto;
    }
</style>

<jsp:include page="../include/adminFooter.jsp" />
