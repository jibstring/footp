package com.ssafy.back_footp.request;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;
import lombok.Getter;
import lombok.NoArgsConstructor;
import org.springframework.web.multipart.MultipartFile;

import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@ApiModel("MessagePostReq")
public class MessagePostReq {
    @ApiModelProperty(name="messagePostContent")
    MessagePostContent messagePostContent;

    @ApiModelProperty(name="메세지 첨부파일")
    MultipartFile messageFile;
}
