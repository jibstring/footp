package com.ssafy.back_footp.controller;

import java.util.List;

import javax.transaction.Transactional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.ssafy.back_footp.entity.Stampboard;
import com.ssafy.back_footp.entity.StampboardLike;
import com.ssafy.back_footp.entity.StampboardSpam;
import com.ssafy.back_footp.entity.User;
import com.ssafy.back_footp.request.StampboardReq;
import com.ssafy.back_footp.response.myStampDTO;
import com.ssafy.back_footp.response.stampboardDTO;
import com.ssafy.back_footp.service.StampboardLikeService;
import com.ssafy.back_footp.service.StampboardService;
import com.ssafy.back_footp.service.StampboardSpamService;
import com.ssafy.back_footp.service.UserJoinedStampboardService;

import io.swagger.annotations.ApiOperation;
import lombok.extern.slf4j.Slf4j;

@RestController
@Slf4j
@RequestMapping("/stamp")
public class StampController {

	@Autowired
	StampboardService stampboardService;
	
	@Autowired
	StampboardLikeService stampboardLikeService;
	
	@Autowired
	StampboardSpamService stampboardSpamService;
	
	@Autowired
	UserJoinedStampboardService userJoinedStampboardService;
	
	@PostMapping("/create")
	@ApiOperation(value = "스탬푸 작성")
	@Transactional
	public ResponseEntity<Integer> createStamp(@RequestBody StampboardReq stamp){
		
		int result = stampboardService.createStamp(stamp);
		
		return new ResponseEntity<Integer>(result,HttpStatus.OK);
	}
	
	@DeleteMapping("/delete/{userId}/{stampboardId}")
	@ApiOperation(value = "내가 작성한 스탬프 삭제")
	@Transactional
	public ResponseEntity<Integer> deleteStamp(@PathVariable long userId, @PathVariable long stampboardId){
		int result = 0;
		
		//삭제 성공 1 , 에러 발생 0
		result = stampboardService.deleteStamp(userId, stampboardId);
		
		return new ResponseEntity<Integer>(result,HttpStatus.OK);
	}
	
	@GetMapping("/likelist/{userId}")
	@ApiOperation(value = "유저의 좋아요 리스트 반환")
	public ResponseEntity<List<StampboardLike>> likeList(@PathVariable long userId){
		
		List<StampboardLike> list = stampboardLikeService.likeList(userId);
		
		return new ResponseEntity<List<StampboardLike>>(list,HttpStatus.OK);
	}
	
	@GetMapping("spamlist/{userId}")
	@ApiOperation(value = "유저의 신고 리스트 반환")
	public ResponseEntity<List<StampboardSpam>> spamList(@PathVariable long userId){
		
		List<StampboardSpam> list = stampboardSpamService.spamList(userId);
		
		return new ResponseEntity<List<StampboardSpam>>(list,HttpStatus.OK);
	}
	
	@PostMapping("/like/{userId}/{stampboardId}")
	@ApiOperation(value = "좋아요 누르기")
	public ResponseEntity<Integer> likeStamp(@PathVariable long userId, @PathVariable long stampboardId){
		int result = 0;
		
		//정상 처리시 1,  문제 발생시 0
		result = stampboardLikeService.likeStamp(userId, stampboardId);
		//좋아요 처리 후 총 좋아요 개수 갱신
		stampboardLikeService.likeNum(stampboardId);
		return new ResponseEntity<Integer>(result,HttpStatus.OK);
	}
	
	@PostMapping("/spam/{userId}/{stampboardId}")
	@ApiOperation(value = "신고하기")
	public ResponseEntity<Integer> spamStamp(@PathVariable long userId, @PathVariable long stampboardId){
		int result = 0;
		
		result = stampboardSpamService.spamStamp(userId, stampboardId);
		//신고 처리 후 총 신고받은 개수 갱신
		stampboardSpamService.spamNum(stampboardId);
		return new ResponseEntity<Integer>(result,HttpStatus.OK);
	}
	
	@GetMapping("/sort/like")
	@ApiOperation(value = "스탬프 좋아요 순으로 정렬")
	public ResponseEntity<List<Stampboard>> sortLike(){
		List<Stampboard> list = stampboardService.sortLike();
		
		return new ResponseEntity<List<Stampboard>>(list,HttpStatus.OK);
	}
	
	@GetMapping("/sort/new")
	@ApiOperation(value = "스탬프 최신 순으로 정렬")
	public ResponseEntity<List<Stampboard>> sortNew(){
		List<Stampboard> list = stampboardService.sortNew();
		
		return new ResponseEntity<List<Stampboard>>(list,HttpStatus.OK);
	}
	
	@GetMapping("/search/like/{text}")
	@ApiOperation(value = "스탬프 검색을 통해 나온 결과 조회")
	public ResponseEntity<List<Stampboard>> searchNew(@PathVariable String text){
		List<Stampboard> list = stampboardService.sortSearchNew(text);
		
		return new ResponseEntity<List<Stampboard>>(list,HttpStatus.OK);
	}
	
	@GetMapping("/mystamp/{userId}")
	@ApiOperation(value = "내가 작성한 스탬프들 조회(최신순)")
	public ResponseEntity<List<myStampDTO>> myStamp(@PathVariable long userId){
		
		List<myStampDTO> list = stampboardService.myStamp(userId);
		
		return new ResponseEntity<List<myStampDTO>>(list,HttpStatus.OK);
	}
	
	@GetMapping("/joinList/{userId}")
	@ApiOperation(value = "내가 진행중인 스탬푸 조회")
	public ResponseEntity<stampboardDTO> playingStamp(@PathVariable long userId){
		
		stampboardDTO result = userJoinedStampboardService.playingStamp(userId);
		
		return new ResponseEntity<stampboardDTO>(result,HttpStatus.OK);
	}
	
	@PostMapping("/join/{userId}/{stampboardId}")
	@ApiOperation(value = "스탬푸 참가하기")
	public ResponseEntity<Integer> joinStamp(@PathVariable long userId, @PathVariable long stampboardId){
		
		int result = userJoinedStampboardService.startStamp(userId, stampboardId);
		
		return new ResponseEntity<Integer>(result,HttpStatus.OK);
		
	}
	
	@GetMapping("/clearList/{userId}")
	@ApiOperation(value = "내가 완료한 스탬푸 조회")
	public ResponseEntity<List<stampboardDTO>> myClearStamp(@PathVariable long userId){
		
		List<stampboardDTO> list = userJoinedStampboardService.clearedStamp(userId);
		
		return new ResponseEntity<List<stampboardDTO>>(list,HttpStatus.OK);
	}
}
