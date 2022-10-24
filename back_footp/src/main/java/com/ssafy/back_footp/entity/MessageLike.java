package com.ssafy.back_footp.entity;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import javax.persistence.*;

@Entity
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Table(name="MessageLike")
public class MessageLike {
    @Id @GeneratedValue(strategy=GenerationType.IDENTITY)
    @Column(name="messagelike_id")
    private Long messagelikeId;

    // 단방향 다대일
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name="user_id")
    private User userId;

    // 단방향 다대일
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name="message_id")
    private Message messageId;
}
