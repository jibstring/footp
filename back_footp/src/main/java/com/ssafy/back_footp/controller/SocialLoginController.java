package com.ssafy.back_footp.controller;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.ssafy.back_footp.entity.User;
import com.ssafy.back_footp.request.SocialUserInfoReq;
import com.ssafy.back_footp.service.KakaoLoginService;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@Slf4j
@AllArgsConstructor
public class SocialLoginController {
	@Autowired
	KakaoLoginService kakaoLoginService;

	// 카카오 로그인
	@GetMapping("/auth/kakao/callback")
	public User kakaoLogin(String code) throws JsonProcessingException {
		return kakaoLoginService.kakaoLogin(code);
	}
}
