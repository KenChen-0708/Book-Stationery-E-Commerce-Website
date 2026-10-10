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
import javax.validation.constraints.NotNull;
import javax.validation.constraints.Size;
import javax.xml.bind.annotation.XmlRootElement;

/**
 *
 * @author kench
 */
@Entity
@Table(name = "CARD_DETAILS")
@XmlRootElement
@NamedQueries({
    @NamedQuery(name = "CardDetails.findAll", query = "SELECT c FROM CardDetails c"),
    @NamedQuery(name = "CardDetails.findByCardId", query = "SELECT c FROM CardDetails c WHERE c.cardId = :cardId"),
    @NamedQuery(name = "CardDetails.findByCardholderName", query = "SELECT c FROM CardDetails c WHERE c.cardholderName = :cardholderName"),
    @NamedQuery(name = "CardDetails.findByCardNumber", query = "SELECT c FROM CardDetails c WHERE c.cardNumber = :cardNumber"),
    @NamedQuery(name = "CardDetails.findByExpiryMonth", query = "SELECT c FROM CardDetails c WHERE c.expiryMonth = :expiryMonth"),
    @NamedQuery(name = "CardDetails.findByExpiryYear", query = "SELECT c FROM CardDetails c WHERE c.expiryYear = :expiryYear"),
    @NamedQuery(name = "CardDetails.findByBillingAddress", query = "SELECT c FROM CardDetails c WHERE c.billingAddress = :billingAddress"),
    @NamedQuery(name = "CardDetails.findByIsDefault", query = "SELECT c FROM CardDetails c WHERE c.isDefault = :isDefault"),
    @NamedQuery(name = "CardDetails.findBySavedAt", query = "SELECT c FROM CardDetails c WHERE c.savedAt = :savedAt")})
public class CardDetails implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Basic(optional = false)
    @Column(name = "CARD_ID")
    private Integer cardId;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 100)
    @Column(name = "CARDHOLDER_NAME")
    private String cardholderName;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 20)
    @Column(name = "CARD_NUMBER")
    private String cardNumber;
    @Basic(optional = false)
    @NotNull
    @Column(name = "EXPIRY_MONTH")
    private int expiryMonth;
    @Basic(optional = false)
    @NotNull
    @Column(name = "EXPIRY_YEAR")
    private int expiryYear;
    @Size(max = 255)
    @Column(name = "BILLING_ADDRESS")
    private String billingAddress;
    @Column(name = "IS_DEFAULT")
    private Boolean isDefault;
    @Column(name = "SAVED_AT")
    @Temporal(TemporalType.TIMESTAMP)
    private Date savedAt;
    @JoinColumn(name = "USER_ID", referencedColumnName = "USER_ID")
    @ManyToOne(optional = false)
    private Users userId;
    @Column(name = "PAYMENT_METHOD")
    private String paymentMethod;

    public CardDetails() {
    }

    public CardDetails(Integer cardId) {
        this.cardId = cardId;
    }

    public CardDetails(Integer cardId, String cardholderName, String cardNumber, int expiryMonth, int expiryYear) {
        this.cardId = cardId;
        this.cardholderName = cardholderName;
        this.cardNumber = cardNumber;
        this.expiryMonth = expiryMonth;
        this.expiryYear = expiryYear;
    }

    public Integer getCardId() {
        return cardId;
    }

    public void setCardId(Integer cardId) {
        this.cardId = cardId;
    }

    public String getCardholderName() {
        return cardholderName;
    }

    public void setCardholderName(String cardholderName) {
        this.cardholderName = cardholderName;
    }

    public String getCardNumber() {
        return cardNumber;
    }

    public void setCardNumber(String cardNumber) {
        this.cardNumber = cardNumber;
    }

    public int getExpiryMonth() {
        return expiryMonth;
    }

    public void setExpiryMonth(int expiryMonth) {
        this.expiryMonth = expiryMonth;
    }

    public int getExpiryYear() {
        return expiryYear;
    }

    public void setExpiryYear(int expiryYear) {
        this.expiryYear = expiryYear;
    }

    public String getBillingAddress() {
        return billingAddress;
    }

    public void setBillingAddress(String billingAddress) {
        this.billingAddress = billingAddress;
    }

    public Boolean getIsDefault() {
        return isDefault;
    }

    public void setIsDefault(Boolean isDefault) {
        this.isDefault = isDefault;
    }

    public Date getSavedAt() {
        return savedAt;
    }

    public void setSavedAt(Date savedAt) {
        this.savedAt = savedAt;
    }

    public Users getUserId() {
        return userId;
    }

    public void setUserId(Users userId) {
        this.userId = userId;
    }

    public String getPaymentMethod() {
        return paymentMethod;
    }

    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (cardId != null ? cardId.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof CardDetails)) {
            return false;
        }
        CardDetails other = (CardDetails) object;
        if ((this.cardId == null && other.cardId != null) || (this.cardId != null && !this.cardId.equals(other.cardId))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "entity.CardDetails[ cardId=" + cardId + " ]";
    }

}
