package com.ssafy.back_footp.request;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@ApiModel("MessageSearchReq")
public class MessageSearchReq {
    @ApiModelProperty(name="검색 키워드")
    String keyword;
}
