package com.ssafy.back_footp.service;

import java.util.ArrayList;
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
import com.ssafy.back_footp.response.stamplikeDTO;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@RequiredArgsConstructor
public class StampboardLikeService {

	@Autowired
	StampboardLikeRepository stampboardLikeRepository;

	@Autowired
	StampboardRepository stampboardRepository;

	@Autowired
	StampboardSpamRepository stampboardSpamRepository;

	@Autowired
	UserRepository userRepository;

	// 좋아요하기
	public Integer likeStamp(long uid, long sid) {
		if (stampboardLikeRepository.findByUserIdAndStampboardId(userRepository.findByUserId(uid),
				stampboardRepository.findById(sid).get()) != null) {
			return 0;
		} else {
			StampboardLike stampboardLike = StampboardLike.builder().userId(userRepository.findByUserId(uid))
					.stampboardId(stampboardRepository.findById(sid).get()).build();
			stampboardLikeRepository.save(stampboardLike);
			return 1;
		}
	}
	
	//좋아요 취소
	public Integer unlikeStamp(long uid, long sid) {
		if(stampboardLikeRepository.existsByUserIdAndStampboardId(userRepository.findByUserId(uid), stampboardRepository.findById(sid).get())){
			stampboardLikeRepository.deleteByUserIdAndStampboardId(userRepository.findByUserId(uid), stampboardRepository.findById(sid).get());
			return 1;
		}else {
			return 0;
		}
	}

	// 유저가 좋아요한 스탬프 리스트 반환
	public List<stamplikeDTO> likeList(long uid) {
		List<StampboardLike> temps = stampboardLikeRepository.findAllByUserId(userRepository.findByUserId(uid));

		List<stamplikeDTO> list = new ArrayList<>();

		for (StampboardLike temp : temps) {

			stamplikeDTO dto = stamplikeDTO.builder().stampboardlikeId(temp.getStampboardlikeId())
					.stampboardId(temp.getStampboardId().getStampboardId()).userId(temp.getUserId().getUserId())
					.build();
			
			list.add(dto);
		}
		return list;
	}

	// 스탬프가 받은 좋아요 수를 반환
	public void likeNum(long sid) {
		int result = stampboardLikeRepository.countByStampboardId(stampboardRepository.findById(sid).get());

		Stampboard stamp = stampboardRepository.findById(sid).get();
		stamp.setStampboardLikenum(result);
		stampboardRepository.save(stamp);
	}
}
