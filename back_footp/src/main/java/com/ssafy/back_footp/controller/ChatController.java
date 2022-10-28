package com.ssafy.back_footp.controller;

import com.ssafy.back_footp.request.ChatMessage;
import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.simp.SimpMessageSendingOperations;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.time.LocalTime;
import java.time.ZoneId;

@RestController
@RequiredArgsConstructor
@RequestMapping("/chat")
public class ChatController {

    private static final Logger logger = LoggerFactory.getLogger(ChatController.class);
    private final SimpMessageSendingOperations sendingOperations;
    private final String rootURL = new String("/topic");

    /**
     * 채팅을 입력받으면 모두에게 뿌려주는 함수
     * @param msg
     */
    @MessageMapping("/send")
    public void chat(ChatMessage msg) {
        logger.info("{} 님의 채팅 전송", msg.getUserNickName());
        LocalTime now = LocalTime.now(ZoneId.of(("Asia/Seoul")));
        msg.setNow(""+now.getHour() + ':' + now.getMinute());
        sendingOperations.convertAndSend(rootURL, msg);
    }

//    @EventListener
//    public void exit(SessionDisconnectEvent event) {
//        //퇴장 이벤트 처리
//        StompHeaderAccessor headerAccessor = StompHeaderAccessor.wrap(event.getMessage());
//    }
}// end of class
