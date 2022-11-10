package com.ssafy.back_footp.request;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;
import lombok.Getter;
import org.springframework.web.multipart.MultipartFile;

@Data
@Getter
@ApiModel("GatherPostReq")
public class GatherPostReq {
	@ApiModelProperty(name="gatherPostContent")
	GatherPostContent gatherPostContent;

	@ApiModelProperty(name="메세지 첨부파일")
	MultipartFile gatherFile;
	
}
