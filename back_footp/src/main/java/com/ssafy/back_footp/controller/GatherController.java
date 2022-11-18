package com.ssafy.back_footp.controller;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

import com.ssafy.back_footp.request.*;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.ssafy.back_footp.entity.Gather;
import com.ssafy.back_footp.entity.GatherLike;
import com.ssafy.back_footp.entity.GatherSpam;
import com.ssafy.back_footp.entity.User;
import com.ssafy.back_footp.repository.GatherLikeRepository;
import com.ssafy.back_footp.repository.GatherRepository;
import com.ssafy.back_footp.repository.GatherSpamRepository;
import com.ssafy.back_footp.repository.UserRepository;
import com.ssafy.back_footp.request.GatherPostReq;
import com.ssafy.back_footp.service.GatherLikeService;
import com.ssafy.back_footp.service.GatherService;
import com.ssafy.back_footp.service.GatherSpamService;
import com.ssafy.back_footp.service.GatherService;

import io.swagger.annotations.ApiOperation;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.multipart.MultipartFile;

@RestController
@Slf4j
@RequestMapping("/gather")
public class GatherController {
	
	//Autowire 하는곳
	@Autowired
	private GatherLikeService gatherLikeService;
	@Autowired
	private GatherLikeRepository gatherLikeRepository;
	
	@Autowired
	private GatherSpamService GatherSpamService;
	@Autowired
	private GatherSpamRepository GatherSpamRepository;
	
	@Autowired
	private GatherService gatherService;
	
	@Autowired
	private GatherRepository gatherRepository;
	
	@Autowired
	private UserRepository userRepository;
	
	
	@PostMapping("/write")
	@ApiOperation(value = "확성기 발자국 쓰기", notes = "확성기 발자국을 작성한다")
	public ResponseEntity<String> GatherWrite(@RequestParam(value="gatherFile", required = false) MultipartFile gatherFile, @RequestParam("gatherContent") String gatherContent){
		String result = null;
		
		try {
			JSONParser parser = new JSONParser();
			Object obj = parser.parse( gatherContent );
			JSONObject jObject = new JSONObject((JSONObject)obj);

			GatherPostContent gatherPostContent = new GatherPostContent();

			gatherPostContent.setUserId((long) jObject.get("userId"));
			gatherPostContent.setGatherText((String) jObject.get("gatherText"));
			gatherPostContent.setGatherWritedate(LocalDateTime.now());
			gatherPostContent.setGatherFinishdate(LocalDateTime.parse((String) jObject.get("gatherFinishdate"), DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm")));
			gatherPostContent.setGatherLongitude((double) jObject.get("gatherLongitude"));
			gatherPostContent.setGatherLatitude((double) jObject.get("gatherLatitude"));
			gatherPostContent.setGatherDesigncode(Integer.parseInt(String.valueOf(jObject.get("gatherDesigncode"))));

			GatherPostReq gatherPostReq = new GatherPostReq();
			gatherPostReq.setGatherPostContent(gatherPostContent);
			gatherPostReq.setGatherFile(gatherFile);

			result = gatherService.createGather(gatherPostReq);
		}catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}
		
		return new ResponseEntity<>(result, HttpStatus.OK);
	}

	/*
	
	@PostMapping("/answer/")
	@ApiOperation(value = "확성기 퀴즈 정답 입력", notes = "확성기 발자국의 퀴즈 정답을 입력하고, 결과를 판단한다")
	public ResponseEntity<Integer> checkAnswer(@RequestBody GatherAnswerReq GatherAnswerReq){
		int result = 0;
		
		Gather gather = gatherRepository.findById(GatherAnswerReq.getGatherId()).get();
		
		// 정답이 맞으면 GatherRanking 테이블에 넣은 뒤 1 반환
		if(gather.getGatherAnswer().equals(GatherAnswerReq.getGatherAnswer())) {
			GatherRanking GatherRanking = GatherRanking.builder().gatherId(gatherRepository.findById(GatherAnswerReq.getGatherId()).get()).userId(userRepository.findById(GatherAnswerReq.getUserId()).get()).GatherrankingDate(LocalDateTime.now()).build();
			
			GatherRankingRepository.save(GatherRanking);
			result= 1;
		}
		// 1 반환시 정답 , 0 반환시 오답
		return new ResponseEntity<Integer>(result,HttpStatus.OK);
	}
	
	@GetMapping("/ranking/joiner/{userId}/{GatherId}")
	@ApiOperation(value = "확성기 퀴즈 상위 5명 확인", notes = "주최자의 경우 퀴즈를 가장 먼저 푼 5명 확인 가능")
	public ResponseEntity<List<UserRankingReq>> checkRankings(@PathVariable long userId, @PathVariable long GatherId){
		
		//주최자가 아니면 접근못함
		if(gatherRepository.findByGatherIdAndUserId(GatherId, userRepository.findById(userId).get())==null) {
			return null;
		}
		
		// 일단 문제에 대한 전체 정답자 빨리 맞힌 순으로 가져오기
		List<GatherRanking> GatherRankings = GatherRankingRepository.findAllByGatherIdOrderByGatherrankingDateAsc(gatherRepository.findById(GatherId).get());
		
		List<UserRankingReq> FiveRankings = new ArrayList<>();
		
		for(GatherRanking e : GatherRankings) {
			
			UserRankingReq temp = new UserRankingReq();
			
			temp.setUserId(e.getUserId().getUserId());
			temp.setUserNickname(e.getUserId().getUserNickname());
			
			FiveRankings.add(temp);
			// 5명까지 넣고 리턴
			if(FiveRankings.size()>=5) {
				break;
			}
			
		}
		
		return new ResponseEntity<>(FiveRankings,HttpStatus.OK);
	}
	
	@GetMapping("/ranking/owner/{userId}/{gatherId}")
	@ApiOperation(value = "확성기 퀴즈 랭킹 확인", notes = "본인이 몇번째로 이 문제에 대한 정답을 맞췄는지 확인")
	public ResponseEntity<Integer> checkMyRanking(@PathVariable User userId, @PathVariable Gather gatherId){
		
		List<GatherRanking> GatherRankings = GatherRankingRepository.findAllByGatherIdOrderByGatherrankingDateAsc(gatherId);
		
		int cnt = 1;
		
		// 아직 이 문제를 맞추지 않은 경우
		if(GatherRankingRepository.findByGatherIdAndUserId(gatherId, userId)==null) {
			cnt = -1;
			return new ResponseEntity<Integer>(cnt,HttpStatus.OK);
		}
		
		// 이 문제를 맞춘 모든 랭킹 리스트를 불러온 후, 빨리 맞힌 순(GatherrackingDate가 빠른 순)으로 정렬.
		for(GatherRanking e : GatherRankings) {
			// 현재 유저의 Id와 e의 Id가 일치하면 랭킹 순서인 cnt를 반환
			if(e.getUserId().getUserId()==userId.getUserId()) {
				break;
			}
			cnt++;
		}
		
		return new ResponseEntity<Integer>(cnt,HttpStatus.OK);
		
	}
	
	*/
	
	@PostMapping("/like/{GatherId}/{userId}")
	@ApiOperation(value = "확성기 좋아요하기", notes = "확성기 발자국일때 좋아요 누른다")
	public ResponseEntity<Integer> GatherLike(@PathVariable long GatherId, @PathVariable long userId){
		
		GatherLike msg = GatherLike.builder().gatherId(gatherRepository.findById(GatherId).get()).userId(userRepository.findById(userId).get()).build();
		
		int result = 1;
		try {
			gatherLikeService.createLike(msg);
		} catch (Exception e) {
			result = 0;
		}
		// 1 반환시 성공, 0 반환시 오류발생
		return new ResponseEntity<Integer>(result,HttpStatus.OK);
	}
	
	@DeleteMapping("/unlike/{GatherId}/{userId}")
	@ApiOperation(value = "확성기 좋아요 취소하기", notes="좋아요 두번 누르면 취소한다")
	public ResponseEntity<Integer> GatherUnlike(@PathVariable long GatherId, @PathVariable long userId){
		
		int result = 0;
		
		if(gatherLikeRepository.findByGatherIdAndUserId(gatherRepository.findById(GatherId).get(), userRepository.findById(userId).get())!=null) {
			gatherLikeService.deleteLike(GatherId, userId);
			result = 1;
		}
		// 1 반환시 성공, 0 반환시 오류발생
		return new ResponseEntity<Integer>(result,HttpStatus.OK);
	}
	
	@PutMapping("/like/{GatherId}")
	@ApiOperation(value = "발자국 좋아요/취소 후 likenum 재설정")
	public ResponseEntity<Integer> gatherLikenum(@PathVariable long GatherId){
		
		int result = 0;
		Gather ev = gatherRepository.findById(GatherId).get();
		try {
			// 좋아요 후 업데이트 
			int num = gatherLikeService.likeNum(GatherId);
			ev.setGatherLikenum(num);
			gatherRepository.save(ev);
			
			result = 1;
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}
		
		
		return new ResponseEntity<Integer>(result,HttpStatus.OK);
	}
	
	@PostMapping("/spam/{GatherId}/{userId}")
	@ApiOperation(value = "확성기 차단하기", notes = "확성기 발자국을 차단한다")
	public ResponseEntity<Integer> GatherSpam(@PathVariable long GatherId, @PathVariable long userId){
		
		int result = 1;
		GatherSpam msg = GatherSpam.builder().gatherId(gatherRepository.findById(GatherId).get()).userId(userRepository.findById(userId).get()).build();
		
		try {
			GatherSpamService.createSpam(msg);
		} catch (Exception e) {
			// TODO: handle exception
			result = 0;
		}
		// 1 반환시 성공, 0 반환시 오류발생
		return new ResponseEntity<Integer>(result,HttpStatus.OK);
	}
	
	@PutMapping("/spam/{GatherId}")
	@ApiOperation(value = "발자국 좋아요/취소 후 likenum 재설정")
	public ResponseEntity<Integer> gatherSpamnum(@PathVariable long GatherId){
		
		int result = 0;
		Gather ev = gatherRepository.findById(GatherId).get();
		try {
			// 좋아요 후 업데이트 
			int num = GatherSpamService.spamNum(GatherId);
			ev.setGatherSpamnum(num);
			gatherRepository.save(ev);
			
			result = 1;
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}
		
		
		return new ResponseEntity<Integer>(result,HttpStatus.OK);
	}


	// 화면에 들어오는 확성기만 조회
	@GetMapping("/list/hot/{userId}/{lon_r}/{lon_l}/{lat_d}/{lat_u}")
	@ApiOperation(value = "확성기 리스트(핫)")
	public ResponseEntity<JSONObject> gatherListHotInScreen(@PathVariable long userId, @PathVariable double lon_r, @PathVariable double lon_l, @PathVariable double lat_d, @PathVariable double lat_u){

		JSONObject result = gatherService.getGatherList("hot", userId, lon_r, lon_l, lat_d, lat_u);
		return new ResponseEntity<>(result, HttpStatus.OK);
	}

	@GetMapping("/list/like/{userId}/{lon_r}/{lon_l}/{lat_d}/{lat_u}")
	@ApiOperation(value = "확성기 리스트(좋아요)")
	public ResponseEntity<JSONObject> gatherListLikeInScreen(@PathVariable long userId, @PathVariable double lon_r, @PathVariable double lon_l, @PathVariable double lat_d, @PathVariable double lat_u){

		JSONObject result = gatherService.getGatherList("like", userId, lon_r, lon_l, lat_d, lat_u);
		return new ResponseEntity<>(result, HttpStatus.OK);
	}

	@GetMapping("/list/new/{userId}/{lon_r}/{lon_l}/{lat_d}/{lat_u}")
	@ApiOperation(value = "확성기 리스트(신규)")
	public ResponseEntity<JSONObject> gatherListNewInScreen(@PathVariable long userId, @PathVariable double lon_r, @PathVariable double lon_l, @PathVariable double lat_d, @PathVariable double lat_u){

		JSONObject result = gatherService.getGatherList("new", userId, lon_r, lon_l, lat_d, lat_u);
		return new ResponseEntity<>(result, HttpStatus.OK);
	}

	// 유저가 확성기에 참가
	@PostMapping("/join/{gatherId}/{userId}")
	@ApiOperation(value = "유저가 확성기에 참가")
	public ResponseEntity<String> joinInGather(@PathVariable long gatherId, @PathVariable long userId){
		String result = gatherService.joinGather(gatherId, userId);
		return new ResponseEntity<>(result, HttpStatus.OK);
	}

	// 유저가 확성기에서 떠나기
	@PostMapping("/leave/{gatherId}/{userId}")
	@ApiOperation(value = "유저가 확성기에서 떠나기")
	public ResponseEntity<String> leaveFromGather(@PathVariable long gatherId, @PathVariable long userId){
		String result = gatherService.leaveGather(gatherId, userId);
		return new ResponseEntity<>(result, HttpStatus.OK);
	}


	// 확성기 검색
	@PostMapping("/search/{userId}/{lon}/{lat}")
	@ApiOperation(value = "확성기 검색 기능")
	public ResponseEntity<JSONObject> gatherSearch(@PathVariable long userId, @PathVariable double lon, @PathVariable double lat, @RequestBody GatherSearchReq gatherSearchReq){

		JSONObject result = gatherService.searchGather(userId, lon, lat, gatherSearchReq.getKeyword());
		return new ResponseEntity<>(result, HttpStatus.OK);
	}
}
