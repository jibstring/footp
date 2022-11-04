package com.ssafy.back_footp.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ssafy.back_footp.entity.Stampboard;
import com.ssafy.back_footp.entity.StampboardLike;
import com.ssafy.back_footp.entity.StampboardSpam;
import com.ssafy.back_footp.repository.StampboardLikeRepository;
import com.ssafy.back_footp.repository.StampboardRepository;
import com.ssafy.back_footp.repository.StampboardSpamRepository;
import com.ssafy.back_footp.repository.UserRepository;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@RequiredArgsConstructor
public class StampboardSpamService {
	
	@Autowired
	StampboardLikeRepository stampboardLikeRepository;
	
	@Autowired
	StampboardRepository stampboardRepository;
	
	@Autowired
	StampboardSpamRepository stampboardSpamRepository;
	
	@Autowired
	UserRepository userRepository;
	
	//신고하기
	public Integer spamStamp(long uid, long sid) {
		if(stampboardSpamRepository.findByUserIdAndStampboardId(userRepository.findByUserId(uid), stampboardRepository.findById(sid).get())!=null){
			return 0;
		}else {
			StampboardSpam stampboardSpam = StampboardSpam.builder().userId(userRepository.findByUserId(uid)).stampboardId(stampboardRepository.findById(sid).get()).build();
			stampboardSpamRepository.save(stampboardSpam);
			return 1;
		}
	}
	
	
	//유저의 신고 리스트 반환
	public List<StampboardSpam> spamList(long uid){
		List<StampboardSpam> list = stampboardSpamRepository.findAllByUserId(userRepository.findByUserId(uid));
		
		return list;
	}
	
	//스탬프가 받은 신고수를 반환
	public void spamNum(long sid) {
		int result = stampboardSpamRepository.countByStampboardId(stampboardRepository.findById(sid).get());
		
		Stampboard stamp = stampboardRepository.findById(sid).get();
		stamp.setStampboardSpamnum(result);
		stampboardRepository.save(stamp);
	}

}
