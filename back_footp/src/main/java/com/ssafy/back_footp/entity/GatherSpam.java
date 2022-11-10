package com.ssafy.back_footp.entity;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import javax.persistence.*;

@Entity
@Getter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Table(name="gatherspam")
public class GatherSpam {
    @Id @GeneratedValue(strategy=GenerationType.IDENTITY)
    @Column(name="gatherspam_id")
    private Long gatherspamId;

    // 단방향 다대일
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name="user_id")
    private User userId;

    // 단방향 다대일
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name="gather_id")
    private Gather gatherId;
}
