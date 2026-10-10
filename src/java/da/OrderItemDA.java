package da;

import entity.OrderItem;
import jakarta.annotation.PostConstruct;
import jakarta.ejb.Stateless;

@Stateless
public class OrderItemDA extends GenericDA<OrderItem> {

    @PostConstruct
    public void init() {
        this.setEntityClass(OrderItem.class);
    }
}
