package com.ssafy.back_footp.response;

import lombok.AllArgsConstructor;
import lombok.NoArgsConstructor;
import org.locationtech.jts.geom.Point;

import java.time.LocalDateTime;

@NoArgsConstructor
@AllArgsConstructor
public class eventlistDTO {

    private long eventId;
    private String userNickname;
    private String eventText;
    private String eventFileurl;
    private String eventWritedate;
    private String eventFinishdate;
    private String eventPoint;
    private int eventLikenum;
    private int eventSpamnum;
    private boolean isQuiz;
    private boolean isMylike;
    private String eventQuestion;
    private String eventAnswer;
    private String eventExplain;
    private String eventExplainurl;
}
