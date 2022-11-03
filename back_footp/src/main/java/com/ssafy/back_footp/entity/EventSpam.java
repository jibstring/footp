package com.ssafy.back_footp.entity;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import javax.persistence.*;

@Entity
@Getter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Table(name="eventspam")
public class EventSpam {
    @Id @GeneratedValue(strategy=GenerationType.IDENTITY)
    @Column(name="eventspam_id")
    private Long eventspamId;

    // 단방향 다대일
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name="user_id")
    private User userId;

    // 단방향 다대일
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name="event_id")
    private Event eventId;
}
