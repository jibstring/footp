package com.ssafy.back_footp.request;

import java.time.LocalDateTime;

import io.swagger.annotations.ApiModel;
import lombok.Data;

@Data
@ApiModel("StampboardPostContent")
public class StampboardPostContent {

	Long userId;
	
	String stampboardTitle;
	
	String stampboardText;

	Long stampboardMessage1;
	
	Long stampboardMessage2;
	
	Long stampboardMessage3;

	Integer stampboardDesigncode;

	LocalDateTime stampboardWritedate;

}
