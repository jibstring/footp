package com.ssafy.back_footp.request;

import io.swagger.annotations.ApiModel;
import lombok.Data;

@Data
@ApiModel("PasswordUpdateReq")
public class PasswordUpdateReq {
	Long userId;
	String userPassword;
}
