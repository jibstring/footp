package com.ssafy.back_footp.controller;

import com.ssafy.back_footp.repository.UserRepository;
import com.ssafy.back_footp.request.MessagePostReq;
import com.ssafy.back_footp.service.MessageService;
import io.swagger.annotations.Api;
import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.ssafy.back_footp.entity.Message;
import com.ssafy.back_footp.entity.MessageLike;
import com.ssafy.back_footp.entity.MessageLike.MessageLikeBuilder;
import com.ssafy.back_footp.entity.MessageSpam;
import com.ssafy.back_footp.entity.User;
import com.ssafy.back_footp.repository.MessageLikeRepository;
import com.ssafy.back_footp.repository.MessageRepository;
import com.ssafy.back_footp.repository.MessageSpamRepository;
import com.ssafy.back_footp.service.MessageLikeService;
import com.ssafy.back_footp.service.MessageSpamService;

import io.swagger.annotations.ApiOperation;
import lombok.extern.slf4j.Slf4j;

@Api(value = "메세지 API", tags = {"Message"})
@RestController
@Slf4j
@RequestMapping("/foot")
public class MessageController {

	//Autowired 하는곳
	@Autowired
	private MessageService messageService;
	
	@Autowired
	private MessageLikeService messageLikeService;
	@Autowired
	private MessageLikeRepository messageLikeRepository;
	
	@Autowired
	private MessageSpamService messageSpamService;
	@Autowired
	private MessageSpamRepository messageSpamRepository;
	
	@Autowired
	private MessageRepository messageRepository;

	@Autowired
	private UserRepository userRepository;

	@GetMapping("/main/{userId}/{lon}/{lat}")
	@ApiOperation(value = "메세지 발자국, 이벤트 발자국 조회", notes = "반경 500m 이내의 메세지 발자국과 이벤트 발자국을 조회한다.")
	public ResponseEntity<JSONObject> messageSearch(@PathVariable long userId, @PathVariable double lon, @PathVariable double lat){
		JSONObject result = null;

		try {
			result = messageService.getMessageList(userId, lon, lat);
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}

		return new ResponseEntity<JSONObject>(result, HttpStatus.OK);
	}

	@PostMapping("/message")
	@ApiOperation(value = "메세지 발자국 쓰기", notes = "일반 메세지 발자국을 작성한다.")
	public ResponseEntity<JSONObject> messageWrite(@RequestBody MessagePostReq messagePostReq){
		JSONObject result = null;

		try {
			messageService.createMessage(messagePostReq);
			result = messageService.getMessageList(messagePostReq.getUserId(), messagePostReq.getMessageLongitude(), messagePostReq.getMessageLatitude());
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}

		return new ResponseEntity<JSONObject>(result, HttpStatus.OK);
	}
	
	@PostMapping("/like/{messageId}/{userId}")
	@ApiOperation(value = "발자국 좋아요하기", notes = "유저가 발자국에 좋아요를 누른다")
	public ResponseEntity<Integer> messageLike(@PathVariable long messageId, @PathVariable long userId){
		
		
		MessageLike msg = MessageLike.builder().messageId(messageRepository.findById(messageId).get()).userId(userRepository.findById(userId).get()).build();
		
		int result = 1;		
		
		try {
			messageLikeService.createLike(msg);	
		} catch (Exception e) {
			// TODO: handle exception
			result = 0;
		}
		
		// 정상적으로 좋아요되면 1, 아니면 0 반환
		return new ResponseEntity<>(result, HttpStatus.OK);
	}
	
	@DeleteMapping("unlike/{messageId}/{userId}")
	@ApiOperation(value = "발자국 좋아요 취소",notes = "유저가 좋아요를 두번 누르면 취소된다")
	public ResponseEntity<Integer> messageUnlike(@PathVariable long messageId, @PathVariable long userId){
		
		int result = 0;
		
		if(messageLikeRepository.findByMessageIdAndUserId(messageRepository.findById(messageId).get(), userRepository.findById(userId).get())!=null) {
			messageLikeService.deleteLike(messageId, userId);
			result = 1;
		}
		
		return new ResponseEntity<Integer>(result,HttpStatus.OK);
		
		
	}
	
	@PutMapping("/like/{messageId}")
	@ApiOperation(value = "발자국 좋아요/취소 후 likenum 재설정")
	public ResponseEntity<Integer> messageLikenum(@PathVariable long messageId){
		
		int result = 0;
		Message m = messageRepository.findById(messageId).get();
		try {
			// 좋아요 후 업데이트 
			int num = messageLikeService.likeNum(messageId);
			m.setMessageLikenum(num);
			messageRepository.save(m);
			
			result = 1;
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}
		
		
		return new ResponseEntity<Integer>(result,HttpStatus.OK);
	}
	
	@PostMapping("/spam/{messageId}/{userId}")
	@ApiOperation(value = "발자국 차단하기(신고하기)", notes = "유저가 발자국을 신고(차단)한다")
	public ResponseEntity<Integer> messageSpam(@PathVariable long messageId, @PathVariable long userId){
		
		int result =1;
		
		MessageSpam msg = MessageSpam.builder().messageId(messageRepository.findById(messageId).get()).userId(userRepository.findById(userId).get()).build();
		
		try {
			messageSpamService.createSpam(msg);
		} catch (Exception e) {
			// TODO: handle exception
			result = 0;
		}
		
		//신고기능 정상 =1 아님 0
		return new ResponseEntity<Integer>(result, HttpStatus.OK);
	}
	
	@PutMapping("/spam/{messageId}")
	@ApiOperation(value = "발자국 차단 후 개수 갱신")
	public ResponseEntity<Integer> messageSpamnum(@PathVariable long messageId){
		
		int result = 0;
		
		Message m = messageRepository.findById(messageId).get();
		try {
			// 차단 후 업데이트 
			int num = messageSpamService.spamNum(messageId);
			m.setMessageSpamnum(num);
			messageRepository.save(m);
			
			result = 1;
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}
		
		
		return new ResponseEntity<Integer>(result,HttpStatus.OK);
	}
}
