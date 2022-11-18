package com.ssafy.back_footp.entity;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.locationtech.jts.geom.Point;
import org.springframework.data.annotation.CreatedDate;

import javax.persistence.*;
import java.time.LocalDateTime;

@Entity
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Table(name = "gather")
public class Gather {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "gather_id", nullable = false)
    private Long gatherId;

    @ManyToOne
    @JoinColumn(name = "user_id")
    private User userId;

    @Column(name = "user_nickname")
    private String userNickname;

    @Column(name = "gather_text")
    private String gatherText;

    @Column(name = "gather_fileurl", length = 1024)
    private String gatherFileurl;

    @CreatedDate
    @Column(name = "gather_writedate")
    private LocalDateTime gatherWritedate;

    @Column(name = "gather_finishdate")
    private LocalDateTime gatherFinishdate;

    @Column(name = "gather_point")
    private Point gatherPoint;

    @Column(name = "gather_likenum")
    private int gatherLikenum;

    @Column(name = "gather_spamnum")
    private int gatherSpamnum;

    @Column(name = "gather_designcode")
    private int gatherDesigncode;
}
