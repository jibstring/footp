package com.ssafy.back_footp.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ssafy.back_footp.repository.StampboardLikeRepository;
import com.ssafy.back_footp.repository.StampboardRepository;
import com.ssafy.back_footp.repository.StampboardSpamRepository;

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
	
	//스탬프가 받은 신고수를 반환
	public int spamNum(long sid) {
		int result = stampboardSpamRepository.countByStampboardId(stampboardRepository.findById(sid).get());
		return result;
	}

}
