package com.ssafy.back_footp.response;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import javax.persistence.SecondaryTable;
import java.io.Serializable;
import java.time.LocalDateTime;

@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
public class messagelistDTO implements Serializable{

    private Long messageId;
    private String userNickname;
    private String messageText;
    private String messageBlurredtext;
    private String messageFileurl;
    private double messageLongitude;
    private double messageLatitude;
    private Boolean isOpentoall;
    private Boolean isBlurred;
    private Boolean isMylike;
    private int messageLikenum;
    private int messageSpamnum;
    private String messageWritedate;

}
