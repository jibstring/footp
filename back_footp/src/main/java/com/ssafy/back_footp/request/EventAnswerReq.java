package com.ssafy.back_footp.request;

import io.swagger.annotations.ApiModel;
import lombok.Data;

@Data
@ApiModel("EventAnswerReq")
public class EventAnswerReq {

	Long eventId;
	
	Long userId;
	
	String eventAnswer;
}
