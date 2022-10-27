package com.ssafy.back_footp.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.ssafy.back_footp.entity.Message;
import com.ssafy.back_footp.entity.MessageLike;
import com.ssafy.back_footp.entity.MessageLike.MessageLikeBuilder;
import com.ssafy.back_footp.entity.MessageSpam;
import com.ssafy.back_footp.entity.User;
import com.ssafy.back_footp.repository.MessageLikeRepository;
import com.ssafy.back_footp.repository.MessageSpamRepository;
import com.ssafy.back_footp.service.MessageLikeService;
import com.ssafy.back_footp.service.MessageSpamService;

import io.swagger.annotations.ApiOperation;
import lombok.extern.slf4j.Slf4j;

@RestController
@Slf4j
@RequestMapping("/foot")
public class MessageController {

	//Autowired 하는곳
	
	@Autowired
	private MessageLikeService messageLikeService;
	@Autowired
	private MessageLikeRepository messageLikeRepository;
	
	@Autowired
	private MessageSpamService messageSpamService;
	@Autowired
	private MessageSpamRepository messageSpamRepository;
	
	
	
	@PostMapping("/like/{messageId}/{userId}")
	@ApiOperation(value = "발자국 좋아요하기", notes = "유저가 발자국에 좋아요를 누른다")
	public ResponseEntity<Integer> messageLike(@PathVariable Message messageId, @PathVariable User userId){
		
		
		MessageLike msg = MessageLike.builder().messageId(messageId).userId(userId).build();
		
		int result = 1;
		
		try {
			messageLikeService.createLike(msg);
		} catch (Exception e) {
			// TODO: handle exception
			result = 0;
		}
		
		// 정상적으로 좋아요되면 1, 아니면 0 반환
		return new ResponseEntity<Integer>(result, HttpStatus.OK);
	}
	
	@DeleteMapping("unlike/{messageId}/{userId}")
	@ApiOperation(value = "발자국 좋아요 취소",notes = "유저가 좋아요를 두번 누르면 취소된다")
	public ResponseEntity<Integer> messageUnlike(@PathVariable Message messageId, @PathVariable User userId){
		
		int result = 0;
		long mid = messageId.getMessageId();
		long uid = userId.getUserId();
		
		if(messageLikeRepository.findByMessageIdAndUserId(mid, uid)!=null) {
			messageLikeService.deleteLike(mid, uid);
			result = 1;
		}
		
		return new ResponseEntity<Integer>(result,HttpStatus.OK);
		
		
	}
	
	@PostMapping("/spam/{messageId}/{userId}")
	@ApiOperation(value = "발자국 차단하기(신고하기)", notes = "유저가 발자국을 신고(차단)한다")
	public ResponseEntity<Integer> messageSpam(@PathVariable Message messageId, @PathVariable User userId){
		
		int result =1;
		
		MessageSpam msg = MessageSpam.builder().messageId(messageId).userId(userId).build();
		
		try {
			messageSpamService.createSpam(msg);
		} catch (Exception e) {
			// TODO: handle exception
			result = 0;
		}
		
		//신고기능 정상 =1 아님 0
		return new ResponseEntity<Integer>(result, HttpStatus.OK);
	}
}
