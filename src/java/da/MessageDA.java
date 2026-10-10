package da;

import entity.Message;
import entity.Users;
import jakarta.annotation.PostConstruct;
import jakarta.ejb.Stateless;
import java.util.List;

@Stateless
public class MessageDA extends GenericDA<Message> {

    @PostConstruct
    public void init() {
        setEntityClass(Message.class);
    }

    // Find messages sent by a specific user
    public List<Message> findBySender(Users sender) {
        return findByNamedQuery("Message.findBySenderId", "senderId", sender);
    }

    // Find messages received by a specific user
    public List<Message> findByReceiver(Users receiver) {
        return findByNamedQuery("Message.findByReceiverId", "receiverId", receiver);
    }

    // Find conversation between two users
    public List<Message> findConversation(Users user1, Users user2) {
        String jpql = "SELECT m FROM Message m " +
                      "WHERE (m.senderId = :user1 AND m.receiverId = :user2) " +
                      "   OR (m.senderId = :user2 AND m.receiverId = :user1) " +
                      "ORDER BY m.messageId ASC";

        return em.createQuery(jpql, Message.class)
                 .setParameter("user1", user1)
                 .setParameter("user2", user2)
                 .getResultList();
    }
}
