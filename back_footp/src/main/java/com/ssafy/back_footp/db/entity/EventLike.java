package com.ssafy.back_footp.db.entity;

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
@Table(name="EventLike")
public class EventLike {
    @Id @GeneratedValue(strategy=GenerationType.IDENTITY)
    @Column(name="eventlike_id")
    private Long eventlikeId;

    // 단방향 다대일
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name="user_id")
    private User userId;

    // 단방향 다대일
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name="event_id")
    private Message eventId;
}
