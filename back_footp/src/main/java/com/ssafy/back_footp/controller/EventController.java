package com.ssafy.back_footp.controller;

import java.time.LocalDateTime;
import java.util.List;

import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.ssafy.back_footp.entity.Event;
import com.ssafy.back_footp.entity.EventLike;
import com.ssafy.back_footp.entity.EventRanking;
import com.ssafy.back_footp.entity.EventSpam;
import com.ssafy.back_footp.entity.Message;
import com.ssafy.back_footp.entity.User;
import com.ssafy.back_footp.repository.EventLikeRepository;
import com.ssafy.back_footp.repository.EventRankingRepository;
import com.ssafy.back_footp.repository.EventRepository;
import com.ssafy.back_footp.repository.EventSpamRepository;
import com.ssafy.back_footp.repository.UserRepository;
import com.ssafy.back_footp.request.EventAnswerReq;
import com.ssafy.back_footp.request.EventPostReq;
import com.ssafy.back_footp.service.EventLikeService;
import com.ssafy.back_footp.service.EventService;
import com.ssafy.back_footp.service.EventSpamService;
import com.ssafy.back_footp.service.MessageService;

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
	
	@Autowired
	private EventService eventService;
	@Autowired
	private MessageService messageService;
	
	@Autowired
	private EventRepository eventRepository;
	@Autowired
	private EventRankingRepository eventRankingRepository;
	
	@Autowired
	private UserRepository userRepository;
	
	
	@PostMapping("/event")
	@ApiOperation(value = "이벤트 발자국 쓰기", notes = "이벤트 발자국을 작성한다")
	public ResponseEntity<JSONObject> eventWrite(@RequestBody EventPostReq eventPostReq){
		JSONObject result = null;
		
		try {
			eventService.createEvent(eventPostReq);
			result = messageService.getMessageList(eventPostReq.getUserId(), eventPostReq.getEventLongitude(), eventPostReq.getEventLatitude());
		}catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}
		
		return new ResponseEntity<JSONObject>(result,HttpStatus.OK);
	}
	
	@PostMapping("/answer/")
	@ApiOperation(value = "이벤트 퀴즈 정답 입력", notes = "이벤트 발자국의 퀴즈 정답을 입력하고, 결과를 판단한다")
	public ResponseEntity<Integer> checkAnswer(@RequestBody EventAnswerReq eventAnswerReq){
		int result = 0;
		
		Event event = eventRepository.findById(eventAnswerReq.getEventId()).get();
		
		// 정답이 맞으면 EventRanking 테이블에 넣은 뒤 1 반환
		if(event.getEventAnswer().equals(eventAnswerReq.getEventAnswer())) {
			EventRanking eventRanking = EventRanking.builder().eventId(eventRepository.findById(eventAnswerReq.getEventId()).get()).userId(userRepository.findById(eventAnswerReq.getUserId()).get()).eventrankingDate(LocalDateTime.now()).build();
			
			eventRankingRepository.save(eventRanking);
			result= 1;
		}
		// 1 반환시 정답 , 0 반환시 오답
		return new ResponseEntity<Integer>(result,HttpStatus.OK);
	}
	
	@GetMapping("/ranking/{userId}/{eventId}")
	@ApiOperation(value = "이벤트 퀴즈 랭킹 확인", notes = "본인이 몇번째로 이 문제에 대한 정답을 맞췄는지 확인")
	public ResponseEntity<Integer> checkRanking(@PathVariable long userId, @PathVariable long eventId){
		
		List<EventRanking> eventRankings = eventRankingRepository.findAllByOrderByEventrankingDateAsc();
		
		int cnt = 1;
		// 이 문제를 맞춘 모든 랭킹 리스트를 불러온 후, 빨리 맞힌 순(EventrackingDate가 빠른 순)으로 정렬.
		for(EventRanking e : eventRankings) {
			// 현재 유저의 Id와 e의 Id가 일치하면 랭킹 순서인 cnt를 반환
			if(e.getUserId().getUserId()==userId) {
				break;
			}
			cnt++;
		}
		
		return new ResponseEntity<Integer>(cnt,HttpStatus.OK);
		
	}
	
	
	
	@PostMapping("/like/{eventId}/{userId}")
	@ApiOperation(value = "이벤트 좋아요하기", notes = "이벤트 발자국일때 좋아요 누른다")
	public ResponseEntity<Integer> eventLike(@PathVariable long eventId, @PathVariable long userId){
		
		EventLike msg = EventLike.builder().eventId(eventRepository.findById(eventId).get()).userId(userRepository.findById(userId).get()).build();
		
		int result = 1;
		try {
			eventLikeService.createLike(msg);
		} catch (Exception e) {
			result = 0;
		}
		// 1 반환시 성공, 0 반환시 오류발생
		return new ResponseEntity<Integer>(result,HttpStatus.OK);
	}
	
	@DeleteMapping("/unlike/{eventId}/{userId}")
	@ApiOperation(value = "이벤트 좋아요 취소하기", notes="좋아요 두번 누르면 취소한다")
	public ResponseEntity<Integer> eventUnlike(@PathVariable long eventId, @PathVariable long userId){
		
		int result = 0;
		
		if(eventLikeRepository.findByEventIdAndUserId(eventRepository.findById(eventId).get(), userRepository.findById(userId).get())!=null) {
			eventLikeService.deleteLike(eventId, userId);
			result = 1;
		}
		// 1 반환시 성공, 0 반환시 오류발생
		return new ResponseEntity<Integer>(result,HttpStatus.OK);
	}
	
	@PutMapping("/like/{eventId}")
	@ApiOperation(value = "발자국 좋아요/취소 후 likenum 재설정")
	public ResponseEntity<Integer> messageLikenum(@PathVariable long eventId){
		
		int result = 0;
		Event ev = eventRepository.findById(eventId).get();
		try {
			// 좋아요 후 업데이트 
			int num = eventLikeService.likeNum(eventId);
			ev.setEventLikenum(num);
			eventRepository.save(ev);
			
			result = 1;
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}
		
		
		return new ResponseEntity<Integer>(result,HttpStatus.OK);
	}
	
	@PostMapping("/spam/{eventId}/{userId}")
	@ApiOperation(value = "이벤트 차단하기", notes = "이벤트 발자국을 차단한다")
	public ResponseEntity<Integer> eventSpam(@PathVariable long eventId, @PathVariable long userId){
		
		int result = 1;
		EventSpam msg = EventSpam.builder().eventId(eventRepository.findById(eventId).get()).userId(userRepository.findById(userId).get()).build();
		
		try {
			eventSpamService.createSpam(msg);
		} catch (Exception e) {
			// TODO: handle exception
			result = 0;
		}
		// 1 반환시 성공, 0 반환시 오류발생
		return new ResponseEntity<Integer>(result,HttpStatus.OK);
	}
	
	@PutMapping("/spam/{eventId}")
	@ApiOperation(value = "발자국 좋아요/취소 후 likenum 재설정")
	public ResponseEntity<Integer> messageSpamnum(@PathVariable long eventId){
		
		int result = 0;
		Event ev = eventRepository.findById(eventId).get();
		try {
			// 좋아요 후 업데이트 
			int num = eventSpamService.spamNum(eventId);
			ev.setEventSpamnum(num);
			eventRepository.save(ev);
			
			result = 1;
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}
		
		
		return new ResponseEntity<Integer>(result,HttpStatus.OK);
	}
	
	
	

}
