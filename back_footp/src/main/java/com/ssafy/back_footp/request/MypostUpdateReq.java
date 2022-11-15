package com.ssafy.back_footp.request;

import io.swagger.annotations.ApiModel;
import lombok.Data;

@Data
@ApiModel("MypostUpdateReq")
public class MypostUpdateReq {
	Long userId;
	Long messageId;
	boolean type;
}
