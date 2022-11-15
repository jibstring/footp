package com.ssafy.back_footp.request;

import io.swagger.annotations.ApiModel;
import lombok.Data;

@Data
@ApiModel("UserRankingReq")
public class UserRankingReq {
	
	long userId;
	
	String userNickname;
	

}
