package com.ssafy.back_footp.service;

import java.time.LocalDateTime;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ssafy.back_footp.entity.Stampboard;
import com.ssafy.back_footp.repository.StampboardLikeRepository;
import com.ssafy.back_footp.repository.StampboardRepository;
import com.ssafy.back_footp.repository.StampboardSpamRepository;
import com.ssafy.back_footp.repository.UserRepository;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
@RequiredArgsConstructor
public class StampboardService {

	@Autowired
	StampboardLikeRepository stampboardLikeRepository;

	@Autowired
	StampboardRepository stampboardRepository;

	@Autowired
	StampboardSpamRepository stampboardSpamRepository;

	@Autowired
	UserRepository userRepository;

	// 스탬푸 생성
	public Integer createStamp(Stampboard stampboard) {

		Stampboard st = Stampboard.builder().stampboardTitle(stampboard.getStampboardTitle())
				.stampboardText(stampboard.getStampboardText()).stampboardLikenum(0).stampboardSpamnum(0)
				.stampboardDesigncode(stampboard.getStampboardDesigncode())
				.stampboardDesignimgurl(stampboard.getStampboardDesignimgurl())
				.stampboardMessage1(stampboard.getStampboardMessage1())
				.stampboardMessage2(stampboard.getStampboardMessage2())
				.stampboardMessage3(stampboard.getStampboardMessage3()).userId(stampboard.getUserId())
				.stampboardWritedate(LocalDateTime.now())
				.build();
		
		stampboardRepository.save(st);
		
		return 1;
	}

	// 내가 만든 스탬푸 리스트 반환
	public List<Stampboard> myStamp(long uid) {
		List<Stampboard> list = stampboardRepository
				.findAllByUserIdOrderByStampboardWritedateDesc(userRepository.findByUserId(uid));

		return list;
	}

	// 내가 만든 스탬프 삭제
	public Integer deleteStamp(long uid, long sid) {
		Stampboard stampboard = stampboardRepository.findById(sid).get();

		if (stampboard.getUserId().getUserId() == uid) {
			stampboardRepository.deleteByStampboardIdAndUserId(sid, userRepository.findByUserId(uid));
			return 1;
		} else {
			return 0;
		}
	}

	// 좋아요 순으로 정렬

	public List<Stampboard> sortLike() {

		List<Stampboard> list = stampboardRepository.findAllByOrderByStampboardLikenumDesc();

		return list;
	}

	// 최신순으로 정렬
	public List<Stampboard> sortNew() {

		List<Stampboard> list = stampboardRepository.findAllByOrderByStampboardWritedateDesc();

		return list;
	}

	// 검색 결과 좋아요순
	public List<Stampboard> sortSearchLike(String text) {
		List<Stampboard> list = stampboardRepository
				.findByStampboardTextContainingIgnoreCaseOrderByStampboardLikenumDesc(text);

		return list;
	}

	// 검색 결과 최신순
	public List<Stampboard> sortSearchNew(String text) {
		List<Stampboard> list = stampboardRepository
				.findByStampboardTextContainingIgnoreCaseOrderByStampboardWritedateDesc(text);

		return list;
	}
	
//	//스탬프 참가하기
//	public Integer joinStamp(long uid, long sid) {
//		
//		
//	}

}
