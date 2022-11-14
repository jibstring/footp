package com.ssafy.back_footp.service;

import com.ssafy.back_footp.entity.User;
import com.ssafy.back_footp.response.KakaoUserResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Component;
import org.springframework.web.reactive.function.client.WebClient;
import reactor.core.publisher.Mono;

@Component
@RequiredArgsConstructor
public class ClientKakao{
    private final WebClient webClient;

    public User getUserData(String accessToken) {
        KakaoUserResponse kakaoUserResponse = webClient.get()
                .uri("https://kapi.kakao.com/v2/user/me")
                .headers(h -> h.setBearerAuth(accessToken))
                .retrieve()
                .onStatus(HttpStatus::is4xxClientError, response -> Mono.error((Throwable) null))
                .onStatus(HttpStatus::is5xxServerError, response -> Mono.error((Throwable) null))
                .bodyToMono(KakaoUserResponse.class)
                .block();

        return User.builder()
                .userEmail(kakaoUserResponse.getKakaoAccount().getEmail())
                .userNickname(kakaoUserResponse.getProperties().getNickname())
                .build();
    }
}
