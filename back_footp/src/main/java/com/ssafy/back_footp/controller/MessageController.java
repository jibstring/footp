package com.ssafy.back_footp.controller;

import com.ssafy.back_footp.repository.UserRepository;
import com.ssafy.back_footp.request.MessagePostContent;
import com.ssafy.back_footp.request.MessagePostReq;
import com.ssafy.back_footp.response.messagelikeDTO;
import com.ssafy.back_footp.response.messagelistDTO;
import com.ssafy.back_footp.service.MessageService;
import io.swagger.annotations.Api;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

import javax.transaction.Transactional;

import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
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
import org.springframework.web.multipart.MultipartFile;

import java.time.LocalDateTime;
import java.util.List;

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


	@GetMapping("/message/likelist/{userId}")
	@ApiOperation(value = "유저가 좋아요한 발자국 리스트를 전부 조회한다.")
	public ResponseEntity<List<messagelikeDTO>> messageLikeList(@RequestParam long userId){
		
		List<MessageLike> temps = messageLikeRepository.findAllByUserId(userRepository.findByUserId(userId));
		
		List<messagelikeDTO> list = new ArrayList<>();
		
		for(MessageLike temp : temps) {
			messagelikeDTO dto = messagelikeDTO.builder().messagelikeId(temp.getMessagelikeId()).userId(temp.getUserId().getUserId()).messageId(temp.getMessageId().getMessageId()).build();
			
			list.add(dto);
		}
		
		return new ResponseEntity<List<messagelikeDTO>>(list,HttpStatus.OK);
		
	}
	
	@PostMapping("/write")
	@ApiOperation(value = "메세지 발자국 쓰기", notes = "일반 메세지 발자국을 작성한다.")
	public ResponseEntity<String> messageWrite(@RequestParam(value="messageFile", required = false) MultipartFile messageFile, @RequestParam("messageContent") String messageContent){
		String result = null;

		try {
			JSONParser parser = new JSONParser();
			Object obj = parser.parse( messageContent );
			JSONObject jObject = new JSONObject((JSONObject)obj);

			MessagePostContent messagePostContent = new MessagePostContent();

			messagePostContent.setMessageLatitude((double) jObject.get("messageLatitude"));
			messagePostContent.setMessageLongitude((double) jObject.get("messageLongitude"));
			messagePostContent.setMessageText((String) jObject.get("messageText"));
			messagePostContent.setMessageWritedate(LocalDateTime.now());
			messagePostContent.setUserId((long) jObject.get("userId"));
			messagePostContent.setIsOpentoall((boolean) jObject.get("isOpentoall"));

			MessagePostReq messagePostReq = new MessagePostReq();
			messagePostReq.setMessagePostContent(messagePostContent);
			messagePostReq.setMessageFile(messageFile);

			result = messageService.createMessage(messagePostReq);
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}

		return new ResponseEntity<>(result, HttpStatus.OK);
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
	
	@Transactional
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

	// 화면 상관없이 모든 메세지 조회
	@GetMapping("/list/hot")
	@ApiOperation(value = "일반 발자국 리스트(핫)")
	public ResponseEntity<List<Message>> messageListHot(){
		
		List<Message> list = messageRepository.findAllByHot();
		
		return new ResponseEntity<List<Message>>(list,HttpStatus.OK);
	}
	
	@GetMapping("/list/like")
	@ApiOperation(value = "일반 발자국 리스트(좋아요)")
	public ResponseEntity<List<Message>> messageListLike(){
		
		List<Message> list = messageRepository.findAllByOrderByMessageLikenumDesc();
		
		return new ResponseEntity<List<Message>>(list,HttpStatus.OK);
	}
	
	@GetMapping("/list/new")
	@ApiOperation(value = "일반 발자국 리스트(신규)")
	public ResponseEntity<List<Message>> messageListNew(){
		
		List<Message> list = messageRepository.findAllByOrderByMessageWritedateDesc();
		
		return new ResponseEntity<List<Message>>(list,HttpStatus.OK);
	}

	// 화면에 들어오는 메세지만 조회
	@GetMapping("/list/hot/{userId}/{lon_r}/{lon_l}/{lat_d}/{lat_u}")
	@ApiOperation(value = "일반 발자국 리스트(핫)")
	public ResponseEntity<JSONObject> messageListHotInScreen(@PathVariable long userId, @PathVariable double lon_r, @PathVariable double lon_l, @PathVariable double lat_d, @PathVariable double lat_u){

		JSONObject result = messageService.getMessageList("hot", userId, lon_r, lon_l, lat_d, lat_u);
		return new ResponseEntity<>(result, HttpStatus.OK);
	}

	@GetMapping("/list/like/{userId}/{lon_r}/{lon_l}/{lat_d}/{lat_u}")
	@ApiOperation(value = "일반 발자국 리스트(좋아요)")
	public ResponseEntity<JSONObject> messageListLikeInScreen(@PathVariable long userId, @PathVariable double lon_r, @PathVariable double lon_l, @PathVariable double lat_d, @PathVariable double lat_u){

		JSONObject result = messageService.getMessageList("like", userId, lon_r, lon_l, lat_d, lat_u);
		return new ResponseEntity<>(result, HttpStatus.OK);
	}

	@GetMapping("/list/new/{userId}/{lon_r}/{lon_l}/{lat_d}/{lat_u}")
	@ApiOperation(value = "일반 발자국 리스트(신규)")
	public ResponseEntity<JSONObject> messageListNewInScreen(@PathVariable long userId, @PathVariable double lon_r, @PathVariable double lon_l, @PathVariable double lat_d, @PathVariable double lat_u){

		JSONObject result = messageService.getMessageList("new", userId, lon_r, lon_l, lat_d, lat_u);
		return new ResponseEntity<>(result, HttpStatus.OK);
	}
}
