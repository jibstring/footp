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
@Table(name="userjoinedstampboard")
public class UserJoinedStampboard {
    @Id @GeneratedValue(strategy=GenerationType.IDENTITY)
    @Column(name="userjoinedstampboard_id")
    private Long userjoinedstampboardId;

    // 단방향 다대일
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name="user_id")
    private User userId;

    // 단방향 다대일
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name="stampboard_id")
    private Stampboard stampboardId;

    @Column(name = "userjoinedstampboard_isclear1", columnDefinition = "TINYINT", length = 1)
    private boolean userjoinedstampboardIsclear1;

    @Column(name = "userjoinedstampboard_isclear2", columnDefinition = "TINYINT", length = 1)
    private boolean userjoinedstampboardIsclear2;

    @Column(name = "userjoinedstampboard_isclear3", columnDefinition = "TINYINT", length = 1)
    private boolean userjoinedstampboardIsclear3;
}
