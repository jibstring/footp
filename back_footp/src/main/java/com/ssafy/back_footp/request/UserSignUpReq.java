package com.ssafy.back_footp.request;

import io.swagger.annotations.ApiModel;
import lombok.Data;

@Data
@ApiModel("UserSignUpReq")
public class UserSignUpReq {
	
	Long userId;
	
	String userEmail;
	
	String userPassword;

}
