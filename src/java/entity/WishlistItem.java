/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package entity;

import jakarta.persistence.Basic;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.NamedQueries;
import jakarta.persistence.NamedQuery;
import jakarta.persistence.Table;
import jakarta.persistence.Temporal;
import jakarta.persistence.TemporalType;
import java.io.Serializable;
import java.util.Date;
import javax.xml.bind.annotation.XmlRootElement;

/**
 *
 * @author kench
 */
@Entity
@Table(name = "WISHLIST_ITEM")
@XmlRootElement
@NamedQueries({
    @NamedQuery(name = "WishlistItem.findAll", query = "SELECT w FROM WishlistItem w"),
    @NamedQuery(name = "WishlistItem.findByWishlistItemId", query = "SELECT w FROM WishlistItem w WHERE w.wishlistItemId = :wishlistItemId"),
    @NamedQuery(name = "WishlistItem.findByAddedAt", query = "SELECT w FROM WishlistItem w WHERE w.addedAt = :addedAt")})
public class WishlistItem implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Basic(optional = false)
    @Column(name = "WISHLIST_ITEM_ID")
    private Integer wishlistItemId;
    @Column(name = "ADDED_AT")
    @Temporal(TemporalType.TIMESTAMP)
    private Date addedAt;
    @JoinColumn(name = "PRODUCT_ID", referencedColumnName = "PRODUCT_ID")
    @ManyToOne(optional = false)
    private Product productId;
    @JoinColumn(name = "WISHLIST_ID", referencedColumnName = "WISHLIST_ID")
    @ManyToOne(optional = false)
    private Wishlist wishlistId;

    public WishlistItem() {
    }

    public WishlistItem(Integer wishlistItemId) {
        this.wishlistItemId = wishlistItemId;
    }

    public Integer getWishlistItemId() {
        return wishlistItemId;
    }

    public void setWishlistItemId(Integer wishlistItemId) {
        this.wishlistItemId = wishlistItemId;
    }

    public Date getAddedAt() {
        return addedAt;
    }

    public void setAddedAt(Date addedAt) {
        this.addedAt = addedAt;
    }

    public Product getProductId() {
        return productId;
    }

    public void setProductId(Product productId) {
        this.productId = productId;
    }

    public Wishlist getWishlistId() {
        return wishlistId;
    }

    public void setWishlistId(Wishlist wishlistId) {
        this.wishlistId = wishlistId;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (wishlistItemId != null ? wishlistItemId.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof WishlistItem)) {
            return false;
        }
        WishlistItem other = (WishlistItem) object;
        if ((this.wishlistItemId == null && other.wishlistItemId != null) || (this.wishlistItemId != null && !this.wishlistItemId.equals(other.wishlistItemId))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "entity.WishlistItem[ wishlistItemId=" + wishlistItemId + " ]";
    }
    
}
