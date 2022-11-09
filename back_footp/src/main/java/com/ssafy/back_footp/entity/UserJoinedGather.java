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
@Table(name="userjoinedgather")
public class UserJoinedGather {
    @Id @GeneratedValue(strategy=GenerationType.IDENTITY)
    @Column(name="userjoinedgather_id")
    private Long userjoinedgatherId;

    // 단방향 다대일
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name="user_id")
    private User userId;

    // 단방향 다대일
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name="gather_id")
    private Gather gatherId;
}
