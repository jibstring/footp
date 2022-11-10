package com.ssafy.back_footp.request;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;
import lombok.Getter;

import java.time.LocalDateTime;

@Data
@Getter
@ApiModel("GatherPostReq")
public class GatherPostContent {

	@ApiModelProperty(name="유저 ID", example = "1")
	Long userId;

	@ApiModelProperty(name = "이벤트 내용")
	String gatherText;
	
	LocalDateTime gatherWritedate;
	
	LocalDateTime gatherFinishdate;
	
	double gatherLongitude;
	
	double gatherLatitude;

	int gatherDesigncode;

}
