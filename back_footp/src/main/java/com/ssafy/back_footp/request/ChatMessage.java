package com.ssafy.back_footp.request;
import lombok.*;
import org.locationtech.jts.geom.Point;

/**
 * 실시간 채팅정보를 담는 클래스
 */

@Data
@AllArgsConstructor
@NoArgsConstructor
public class ChatMessage {
    //유저 고유 ID 번호
    private Long userId;
    //유저 닉네임
    private String userNickName;
    //유저 채팅 메시지 내용
    private String chat;
    //유저의 위도, 경도 정보
    private Point chatPoint;
    //현재 시간
    private String now;
}// end of class
