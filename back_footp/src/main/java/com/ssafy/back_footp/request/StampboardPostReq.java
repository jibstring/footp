package com.ssafy.back_footp.request;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.web.multipart.MultipartFile;

@Data
@NoArgsConstructor
@ApiModel("StampboardPostReq")
public class StampboardPostReq {
    @ApiModelProperty(name="stampboardPostContent")
    StampboardPostContent stampboardPostContent;

    @ApiModelProperty(name="메세지 첨부파일")
    MultipartFile stampboardFile;
}
