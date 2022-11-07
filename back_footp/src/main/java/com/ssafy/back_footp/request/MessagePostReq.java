package com.ssafy.back_footp.request;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;
import org.locationtech.jts.geom.Point;

import java.time.LocalDateTime;

@Data
@ApiModel("MessagePostReq")
public class MessagePostReq {
    @ApiModelProperty(name="메세지 ID", example = "1")
    Long messageId;

    @ApiModelProperty(name="유저 ID", example = "1")
    Long userId;  

    @ApiModelProperty(name="메세지 내용", example = "여기 맛있어!")
    String messageText;

    @ApiModelProperty(name="메세지 첨부파일 URL", example = "https://mblogthumb-phinf.pstatic.net/MjAxOTEyMTdfMjM5/MDAxNTc2NTgwNjQxMzIw.UIw2A-EU9OUtt5FQ_6iRP2QJQS-aFE7L_EkI_VK6ED0g.dGYlktZJPVI8Jn9z6czNo1FmNIKqNk6ap1tODyDVmswg.JPEG.ideaeditor_lee/officialDobes.jpg?type=w800")
    String messageFileurl;

    @ApiModelProperty(name="메세지 경도", example = "128.71639982661415")
    double messageLongitude;

    @ApiModelProperty(name="메세지 위도", example = "37.72479485462167")
    double messageLatitude;

    @ApiModelProperty(name="메세지 공개 여부", example = "True")
    Boolean isOpentoall;

    @ApiModelProperty(name="메세지 좋아요 수", example = "0")
    int messageLikenum;

    @ApiModelProperty(name="메세지 신고 수", example = "0")
    int messageSpamnum;

    @ApiModelProperty(name="메세지 작성 날짜", example = "")
    LocalDateTime messageWritedate;

}
