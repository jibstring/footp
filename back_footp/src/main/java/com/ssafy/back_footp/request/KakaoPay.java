package com.ssafy.back_footp.request;

import java.util.Date;

import io.swagger.annotations.ApiModel;
import lombok.Data;

@Data
@ApiModel("KakaoPay")
public class KakaoPay {

	private String tid;
	private String next_redirect_pc_url;
	private String next_redirect_app_url;
	private Date created_at;
}
