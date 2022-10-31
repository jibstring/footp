package com.ssafy.back_footp.controller;

import com.ssafy.back_footp.entity.ChatBlock;
import com.ssafy.back_footp.entity.User;
import com.ssafy.back_footp.repository.ChatBlockRepository;
import com.ssafy.back_footp.repository.UserRepository;
import com.ssafy.back_footp.request.ChatMessage;

import io.swagger.annotations.ApiOperation;
import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.simp.SimpMessageSendingOperations;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.time.LocalTime;
import java.time.ZoneId;
import java.util.List;

@RestController
@RequiredArgsConstructor
@RequestMapping("/chat")
public class ChatController {
	
	@Autowired
	ChatBlockRepository chatBlockRepository;
	
	@Autowired
	UserRepository userRepository;

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
    
    @PostMapping("/ban/{blocking}/{blocked}")
    @ApiOperation(value = "채팅 차단 유저 등록", notes = "특정 유저를 차단하여 더이상 실시간 채팅에 띄우지 않을 수 있다")
    public ResponseEntity<Integer> addBlocking(@RequestParam long blocking, @RequestParam long blocked){
    	
    	int result = 1;
    	
    	try {
			ChatBlock chatBlock = ChatBlock.builder().userBlocking(userRepository.findById(blocking).get()).userBlocked(userRepository.findById(blocked).get()).build();
			chatBlockRepository.save(chatBlock);
			
		} catch (Exception e) {
			e.printStackTrace();
			result = 0;
		}
		return new ResponseEntity<Integer>(result,HttpStatus.OK);
    	
    	
    	
    }
    
    @DeleteMapping("/ban/{blocking}/{blocked}")
    @ApiOperation(value = "채팅 차단 유저 삭제",notes = "차단한 유저를 다시 정상으로 되돌린다")
    public ResponseEntity<Integer> deleteBlocking(@RequestParam long blocking, @RequestParam long blocked){
    	
    	int result = 1;
    	
    	
    	try {
    		//내가 이미 차단한 유저인 경우
			if(chatBlockRepository.existsByChatBlockingAndChatBlocked(blocking, blocked)) {
				chatBlockRepository.deleteByChatBlockingAndChatBlocked(blocking, blocked);
			}else {
				//아닌경우 (잘못된 접근임)
				result = 0;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
    	
    	return new ResponseEntity<Integer>(result,HttpStatus.OK);
    }
    
    @GetMapping("/ban/{blocking}")
    @ApiOperation(value = "유저의 차단리스트 조회(FE용)",notes = "유저가 차단한 리스트 반환")
    public ResponseEntity<List<ChatBlock>> checkBlocking(@RequestParam long blocking){
    	
    	List<ChatBlock> check = chatBlockRepository.findAllByChatBlocking(blocking);
    	
    	
    	return new ResponseEntity<List<ChatBlock>>(check,HttpStatus.OK);
    }
    

//    @EventListener
//    public void exit(SessionDisconnectEvent event) {
//        //퇴장 이벤트 처리
//        StompHeaderAccessor headerAccessor = StompHeaderAccessor.wrap(event.getMessage());
//    }
}// end of class
