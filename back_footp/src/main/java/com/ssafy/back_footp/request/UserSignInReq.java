package com.ssafy.back_footp.request;

import io.swagger.annotations.ApiModel;
import lombok.Data;

@Data
@ApiModel("UserSignInReq")
public class UserSignInReq {

	private String userEmail;
	
	private String userPassword;
}
