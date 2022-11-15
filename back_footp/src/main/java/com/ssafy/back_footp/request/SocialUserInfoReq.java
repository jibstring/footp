package com.ssafy.back_footp.request;

import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
public class SocialUserInfoReq {
    private Long id;
    private String nickname;
    private String email;

    public SocialUserInfoReq(Long id, String nickname, String email) {
        this.id = id;
        this.nickname = nickname;
        this.email = email;
    }
}
