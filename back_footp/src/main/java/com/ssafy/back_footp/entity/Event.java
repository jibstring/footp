package com.ssafy.back_footp.entity;

import lombok.AllArgsConstructor;
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
@NoArgsConstructor
@AllArgsConstructor
@Table(name = "event")
public class Event {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "event_id", nullable = false)
    private Long eventId;

    @ManyToOne
    @JoinColumn(name = "user_id")
    private User userId;

    @Column(name = "event_text")
    private String eventText;

    @Column(name = "event_fileurl", length = 1024)
    private String eventFileurl;

    @CreatedDate
    @Column(name = "event_writedate")
    private LocalDateTime eventWritedate;

    @Column(name = "event_finishdate")
    private LocalDateTime eventFinishdate;

    @Column(name = "event_point")
    private Point eventPoint;

    @Column(name = "event_likenum")
    private int eventLikenum;

    @Column(name = "event_spamnum")
    private int eventSpamnum;

    @Column(name = "is_quiz")
    private boolean isQuiz;

    @Column(name = "event_question")
    private String eventQuestion;

    @Column(name = "event_answer")
    private String eventAnswer;

    @Column(name = "event_explain")
    private String eventExplain;

    @Column(name = "event_explainurl", length = 1024)
    private String eventExplainurl;

}
