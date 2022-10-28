package com.ssafy.back_footp.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.ssafy.back_footp.entity.Event;
import com.ssafy.back_footp.entity.EventLike;
import com.ssafy.back_footp.entity.EventSpam;
import com.ssafy.back_footp.entity.User;
import com.ssafy.back_footp.repository.EventLikeRepository;
import com.ssafy.back_footp.repository.EventSpamRepository;
import com.ssafy.back_footp.service.EventLikeService;
import com.ssafy.back_footp.service.EventSpamService;

import io.swagger.annotations.ApiOperation;
import lombok.extern.slf4j.Slf4j;

@RestController
@Slf4j
@RequestMapping("/event")
public class EventController {
	
	//Autowire 하는곳
	@Autowired
	private EventLikeService eventLikeService;
	@Autowired
	private EventLikeRepository eventLikeRepository;
	
	@Autowired
	private EventSpamService eventSpamService;
	@Autowired
	private EventSpamRepository eventSpamRepository;
	
	
	@PostMapping("/like/{eventId}/{userId}")
	@ApiOperation(value = "이벤트 좋아요하기", notes = "이벤트 발자국일때 좋아요 누른다")
	public ResponseEntity<Integer> eventLike(@PathVariable Event eventId, @PathVariable User userId){
		
		EventLike msg = EventLike.builder().eventId(eventId).userId(userId).build();
		
		int result = 1;
		try {
			eventLikeService.createLike(msg);
		} catch (Exception e) {
			result = 0;
		}
		return new ResponseEntity<Integer>(result,HttpStatus.OK);
	}
	
	@DeleteMapping("/unlike/{eventId}/{userId}")
	@ApiOperation(value = "이벤트 좋아요 취소하기", notes="좋아요 두번 누르면 취소한다")
	public ResponseEntity<Integer> eventUnlike(@PathVariable Event eventId, @PathVariable User userId){
		
		int result = 0;
		long eid = eventId.getEventId();
		long uid = userId.getUserId();
		
		if(eventLikeRepository.findByEventIdAndUserId(eventId, userId)!=null) {
			eventLikeService.deleteLike(eid, uid);
			result = 1;
		}
		
		return new ResponseEntity<Integer>(result,HttpStatus.OK);
	}
	
	@PostMapping("/spam/{eventId}/{userId}")
	@ApiOperation(value = "이벤트 차단하기", notes = "이벤트 발자국을 차단한다")
	public ResponseEntity<Integer> eventSpam(@PathVariable Event eventId, @PathVariable User userId){
		
		int result = 1;
		EventSpam msg = EventSpam.builder().eventId(eventId).userId(userId).build();
		
		try {
			eventSpamService.createSpam(msg);
		} catch (Exception e) {
			// TODO: handle exception
			result = 0;
		}
		return new ResponseEntity<Integer>(result,HttpStatus.OK);
	}
	
	
	

}
