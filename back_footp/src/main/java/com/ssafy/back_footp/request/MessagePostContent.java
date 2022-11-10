package com.ssafy.back_footp.request;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.web.multipart.MultipartFile;

import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@ApiModel("MessagePostContent")
public class MessagePostContent {

    @ApiModelProperty(name="유저 ID", example = "1")
    Long userId;

    @ApiModelProperty(name="메세지 내용", example = "여기 맛있어!")
    String messageText;

    @ApiModelProperty(name="메세지 숨겨진 내용", example = "사실 맛없어")
    String messageBlurredtext;

    @ApiModelProperty(name="메세지 경도", example = "128.71639982661415")
    double messageLongitude;

    @ApiModelProperty(name="메세지 위도", example = "37.72479485462167")
    double messageLatitude;

    @ApiModelProperty(name="메세지 공개 여부", example = "True")
    Boolean isOpentoall;

    @ApiModelProperty(name="물음표 메세지 여부", example = "True")
    Boolean isBlurred;

    @ApiModelProperty(name="메세지 작성 날짜", example = "2022-11-07T01:11:28.402Z")
    LocalDateTime messageWritedate;
}
