package com.ssafy.back_footp.request;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

@Data
@ApiModel("MessagePostReq")
public class MessagePostReq {
    @ApiModelProperty(name="메세지 ID", example = "1")
    Long messageId;
/*
    @ApiModelProperty(name="유저 ID", example = "1")
    userId : long,

    @ApiModelProperty(name="메세지 내용", example = "여기 맛있어!")
    messageText : string,

    @ApiModelProperty(name="메세지 첨부파일 URL", example = "https://mblogthumb-phinf.pstatic.net/MjAxOTEyMTdfMjM5/MDAxNTc2NTgwNjQxMzIw.UIw2A-EU9OUtt5FQ_6iRP2QJQS-aFE7L_EkI_VK6ED0g.dGYlktZJPVI8Jn9z6czNo1FmNIKqNk6ap1tODyDVmswg.JPEG.ideaeditor_lee/officialDobes.jpg?type=w800")
    messageFileurl : string,

    @ApiModelProperty(name="메세지 위치", example = "")
    messagePoint : ?,

    @ApiModelProperty(name="메세지 ID", example = "1")
    isOpentoall : boolean,

    @ApiModelProperty(name="메세지 ID", example = "1")
    messageLikenum : int,

    @ApiModelProperty(name="메세지 ID", example = "1")
    messageSpamnum : int,

    @ApiModelProperty(name="메세지 ID", example = "1")
    messageWritedate : ?,
    */

}
