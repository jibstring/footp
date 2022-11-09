package com.ssafy.back_footp.entity;

import lombok.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.locationtech.jts.geom.Point;

import com.fasterxml.jackson.annotation.JsonIgnore;

import javax.persistence.*;
import java.time.LocalDateTime;

@Entity
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Table(name="message")
public class Message {
    @Id @GeneratedValue(strategy=GenerationType.IDENTITY)
    @Column(name="message_id")
    private Long messageId;

    // 단방향 다대일
    @JsonIgnore
    @ManyToOne
    @JoinColumn(name="user_id")
    private User userId;

    @Column(name = "user_nickname")
    private String userNickname;
    
    @Column(name="message_text", length = 255, nullable = false)
    private String messageText;

    @Column(name="message_blurredtext", length = 255, nullable = false)
    private String messageBlurredtext;

    @Column(name="message_fileurl", length = 1024)
    private String messageFileurl;

    @Column(name="message_point")
    private Point messagePoint;

    @Column(name="is_opentoall", columnDefinition = "TINYINT", length = 1)
    private boolean isOpentoall;

    @Column(name="is_blurred", columnDefinition = "TINYINT", length = 1)
    private boolean isBlurred;

    @Column(name="message_likenum")
    private int messageLikenum;

    @Column(name="message_spamnum")
    private int messageSpamnum;

    @Column(name="message_writedate", nullable = false)
    private LocalDateTime messageWritedate;
}
