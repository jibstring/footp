package com.ssafy.back_footp.request;

import java.time.LocalDateTime;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

@Data
@ApiModel("EventPostReq")
public class EventPostReq {

	@ApiModelProperty(name = "이벤트 ID")
	Long eventId;
	
	@ApiModelProperty(name = "유저 ID")
	Long userId;
	
	@ApiModelProperty(name = "이벤트 내용")
	String eventText;
	
	String eventFileurl;
	
	LocalDateTime eventWritedate;
	
	LocalDateTime eventFinishdate;
	
	double eventLongitude;
	
	double eventLatitude;
	
	int eventLikenum;
	
	int eventSpamnum;
	
	Boolean isQuiz;
	
	String eventQuestion;
	
	String eventAnswer;
	
	String eventExplain;
	
	String eventExplainurl;
	
}
