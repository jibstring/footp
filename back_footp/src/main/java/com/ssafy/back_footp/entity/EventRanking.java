package com.ssafy.back_footp.entity;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import javax.persistence.*;
import java.time.LocalDateTime;

@Entity
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Table(name = "eventranking")
public class EventRanking {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "eventranking_id", nullable = false)
    private Long eventrankingId;

    @OneToOne
    @JoinColumn(name = "event_id")
    private Event eventId;

    @OneToOne
    @JoinColumn(name = "user_id")
    private User userId;

    @Column(name = "eventranking_date")
    private LocalDateTime eventrankingDate;
}
