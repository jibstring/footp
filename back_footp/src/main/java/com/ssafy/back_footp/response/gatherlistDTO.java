package com.ssafy.back_footp.response;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.io.Serializable;

@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
public class gatherlistDTO implements Serializable {

    private long gatherId;
    private String userNickname;
    private String gatherText;
    private String gatherFileurl;
    private String gatherWritedate;
    private String gatherFinishdate;
    private double gatherLongitude;
    private double gatherLatitude;
    private Boolean isMylike;
    private int gatherLikenum;
    private int gatherSpamnum;
    private int gatherDesigncode;
}
