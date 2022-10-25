package com.ssafy.back_footp.response;

import lombok.AllArgsConstructor;
import lombok.NoArgsConstructor;
import org.locationtech.jts.geom.Point;

import java.time.LocalDateTime;

@NoArgsConstructor
@AllArgsConstructor
public class messagelistDTO {

    private Long messageId;
    private String userNickname;
    private String messageText;
    private String messageFileurl;
    private Point messagePoint;
    private boolean isOpentoall;
    private boolean isMylike;
    private int messageLikenum;
    private int messageSpamnum;
    private LocalDateTime messageWritedate;

}
