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
import jakarta.persistence.Lob;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.NamedQueries;
import jakarta.persistence.NamedQuery;
import jakarta.persistence.Table;
import jakarta.persistence.Temporal;
import jakarta.persistence.TemporalType;
import java.io.Serializable;
import java.util.Date;
import javax.validation.constraints.NotNull;
import javax.xml.bind.annotation.XmlRootElement;

/**
 *
 * @author kench
 */
@Entity
@Table(name = "REVIEW_REPLY")
@XmlRootElement
@NamedQueries({
    @NamedQuery(name = "ReviewReply.findAll", query = "SELECT r FROM ReviewReply r"),
    @NamedQuery(name = "ReviewReply.findByReplyId", query = "SELECT r FROM ReviewReply r WHERE r.replyId = :replyId"),
    @NamedQuery(name = "ReviewReply.findByReplyDate", query = "SELECT r FROM ReviewReply r WHERE r.replyDate = :replyDate"),
    @NamedQuery(name = "ReviewReply.findByReviewId",query = "SELECT r FROM ReviewReply r WHERE r.reviewId = :review")
})
public class ReviewReply implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Basic(optional = false)
    @Column(name = "REPLY_ID")
    private Integer replyId;
    @Basic(optional = false)
    @NotNull
    @Lob
    @Column(name = "REPLY_TEXT")
    private String replyText;
    @Column(name = "REPLY_DATE")
    @Temporal(TemporalType.TIMESTAMP)
    private Date replyDate;
    @JoinColumn(name = "REVIEW_ID", referencedColumnName = "REVIEW_ID")
    @ManyToOne(optional = false)
    private Review reviewId;
    @JoinColumn(name = "USER_ID", referencedColumnName = "USER_ID")
    @ManyToOne(optional = false)
    private Users userId;

    public ReviewReply() {
    }

    public ReviewReply(Integer replyId) {
        this.replyId = replyId;
    }

    public ReviewReply(Integer replyId, String replyText) {
        this.replyId = replyId;
        this.replyText = replyText;
    }

    public Integer getReplyId() {
        return replyId;
    }

    public void setReplyId(Integer replyId) {
        this.replyId = replyId;
    }

    public String getReplyText() {
        return replyText;
    }

    public void setReplyText(String replyText) {
        this.replyText = replyText;
    }

    public Date getReplyDate() {
        return replyDate;
    }

    public void setReplyDate(Date replyDate) {
        this.replyDate = replyDate;
    }

    public Review getReviewId() {
        return reviewId;
    }

    public void setReviewId(Review reviewId) {
        this.reviewId = reviewId;
    }

    public Users getUserId() {
        return userId;
    }

    public void setUserId(Users userId) {
        this.userId = userId;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (replyId != null ? replyId.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof ReviewReply)) {
            return false;
        }
        ReviewReply other = (ReviewReply) object;
        if ((this.replyId == null && other.replyId != null) || (this.replyId != null && !this.replyId.equals(other.replyId))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "entity.ReviewReply[ replyId=" + replyId + " ]";
    }

}
