package com.ssafy.back_footp.response;

import com.ssafy.back_footp.entity.User;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class KakaoLoginResponse {

    private String appToken;
    private User user;
    private Boolean isNewMember;
}