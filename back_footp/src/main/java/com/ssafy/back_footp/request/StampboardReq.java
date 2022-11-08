package com.ssafy.back_footp.request;

import java.time.LocalDateTime;

import io.swagger.annotations.ApiModel;
import lombok.Data;

@Data
@ApiModel("StampboardReq")
public class StampboardReq {
	
	Long stampboardId;
	
	Long userId;
	
	String stampboardTitle;
	
	String stampboardText;
	
	Integer stampboardDesigncode;
	
	String stampboardDesignimgurl;
	
	LocalDateTime stampboardWritedate;
	
	Integer stampboardLikenum;
	
	Integer stampboardSpamnum;
	
	Long stampboardMessage1;
	
	Long stampboardMessage2;
	
	Long stampboardMessage3;
	
}
