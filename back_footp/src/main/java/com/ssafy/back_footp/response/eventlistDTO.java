package com.ssafy.back_footp.response;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.locationtech.jts.geom.Point;

import java.io.Serializable;
import java.time.LocalDateTime;

@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
public class eventlistDTO implements Serializable {

    private long eventId;
    private String userNickname;
    private String eventText;
    private String eventFileurl;
    private String eventWritedate;
    private String eventFinishdate;
    private double eventLongitude;
    private double eventLatitude;
    private int eventLikenum;
    private int eventSpamnum;
    private boolean isQuiz;
    private boolean isMylike;
    private String eventQuestion;
    private String eventAnswer;
    private String eventExplain;
    private String eventExplainurl;
}
