package com.ssafy.back_footp.entity;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.experimental.SuperBuilder;

import javax.persistence.*;

import com.fasterxml.jackson.annotation.JsonIgnore;

@Entity
@Getter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Table(name="messagelike")

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
