package com.ssafy.back_footp.request;

import io.swagger.annotations.ApiModel;
import lombok.Data;

@Data
@ApiModel("NicknameUpdateReq")
public class NicknameUpdateReq {
	Long userId;
	String userNickname;
}
