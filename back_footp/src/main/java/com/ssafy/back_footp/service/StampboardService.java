package com.ssafy.back_footp.service;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

import javax.transaction.Transactional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ssafy.back_footp.entity.Stampboard;
import com.ssafy.back_footp.entity.User;
import com.ssafy.back_footp.repository.MessageRepository;
import com.ssafy.back_footp.repository.StampboardLikeRepository;
import com.ssafy.back_footp.repository.StampboardRepository;
import com.ssafy.back_footp.repository.StampboardSpamRepository;
import com.ssafy.back_footp.repository.UserJoinedStampboardRepository;
import com.ssafy.back_footp.repository.UserRepository;
import com.ssafy.back_footp.request.StampboardReq;
import com.ssafy.back_footp.response.myStampDTO;
import com.ssafy.back_footp.response.stampboardDTO;

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

	@Autowired
	MessageRepository messageRepository;

	@Autowired
	UserJoinedStampboardRepository userJoinedStampboardRepository;

	// 스탬푸 생성
	@Transactional
	public Integer createStamp(StampboardReq stampboardReq) {

		User user = userRepository.findByUserId(stampboardReq.getUserId());

		Stampboard st = Stampboard.builder().stampboardTitle(stampboardReq.getStampboardTitle())
				.stampboardText(stampboardReq.getStampboardText()).stampboardLikenum(0).stampboardSpamnum(0)
				//Designcode 0 = empty, 1 = food, 2 = dating course, 3 = game, 4 = travel, 5 = custom 
				.stampboardDesigncode(stampboardReq.getStampboardDesigncode())
				//code 0일때 url = "empty", 1~3은 우리가 만든 이미지 탬플릿 url, 4는 사용자가 임의로 이미지넣기
				.stampboardDesignimgurl(stampboardReq.getStampboardDesignimgurl())
				.stampboardMessage1(messageRepository.findById(stampboardReq.getStampboardMessage1()).get())
				.stampboardMessage2(messageRepository.findById(stampboardReq.getStampboardMessage2()).get())
				.stampboardMessage3(messageRepository.findById(stampboardReq.getStampboardMessage3()).get())
				.userId(userRepository.findByUserId(stampboardReq.getUserId())).stampboardWritedate(LocalDateTime.now())
				.build();

		stampboardRepository.save(st);

		user.setUserStampcreatenum(user.getUserStampcreatenum() + 1);
		userRepository.save(user);

		return 1;
	}

	// 내가 만든 스탬푸 리스트 반환
	public List<myStampDTO> myStamp(long uid) {
		List<Stampboard> temps = stampboardRepository
				.findAllByUserIdOrderByStampboardWritedateDesc(userRepository.findByUserId(uid));

		List<myStampDTO> list = new ArrayList<>();

		for (Stampboard temp : temps) {

			myStampDTO dto = myStampDTO.builder().stampboard_id(temp.getStampboardId())
					.stampboard_title(temp.getStampboardTitle()).stampboard_text(temp.getStampboardText())
					.stampboard_spamnum(temp.getStampboardSpamnum()).stampboard_likenum(temp.getStampboardLikenum())
					.stampboard_designcode(temp.getStampboardDesigncode())
					.stampboard_designurl(temp.getStampboardDesignimgurl())
					.stampboard_message1(temp.getStampboardMessage1().getMessageId())
					.stampboard_message2(temp.getStampboardMessage2().getMessageId())
					.stampboard_message3(temp.getStampboardMessage3().getMessageId()).build();

			list.add(dto);
		}

		return list;
	}

	// 내가 만든 스탬프 삭제
	@Transactional
	public Integer deleteStamp(long uid, long sid) {
		Stampboard stampboard = stampboardRepository.findById(sid).get();
		User user = userRepository.findByUserId(uid);

		if (stampboard.getUserId().getUserId() == uid) {
			stampboardRepository.deleteByStampboardIdAndUserId(sid, userRepository.findByUserId(uid));
			user.setUserStampcreatenum(user.getUserStampcreatenum() - 1);
			userRepository.save(user);
			return 1;
		} else {
			return 0;
		}
	}

	// 좋아요 순으로 정렬

	public List<stampboardDTO> sortLike(long uid) {

		List<Stampboard> temps = stampboardRepository.findAllByOrderByStampboardLikenumDesc();

		List<stampboardDTO> list = new ArrayList<>();

		for (Stampboard temp : temps) {

			stampboardDTO dto = stampboardDTO.builder().stampboard_id(temp.getStampboardId())
					.user_id(temp.getUserId().getUserId()).stampboard_title(temp.getStampboardTitle())
					.stampboard_text(temp.getStampboardText()).stampboard_designcode(temp.getStampboardDesigncode())
					.stampboard_designurl(temp.getStampboardDesignimgurl())
					.stampboard_writedate(temp.getStampboardWritedate()).stampboard_likenum(temp.getStampboardLikenum())
					.stampboard_spamnum(temp.getStampboardSpamnum())
					.stampboard_message1(temp.getStampboardMessage1().getMessageId())
					.stampboard_message2(temp.getStampboardMessage2().getMessageId())
					.stampboard_message3(temp.getStampboardMessage3().getMessageId())
					.isMylike(stampboardLikeRepository.existsByUserIdAndStampboardId(userRepository.findByUserId(uid),
							temp))
					.isMyspam(stampboardSpamRepository.existsByUserIdAndStampboardId(userRepository.findByUserId(uid),
							temp))
					.isMyclear(userJoinedStampboardRepository
							.isclearStamp(userRepository.findByUserId(uid), temp))
					.build();

			list.add(dto);
		}

		return list;
	}

	// 최신순으로 정렬
	public List<stampboardDTO> sortNew(long uid) {

		List<Stampboard> temps = stampboardRepository.findAllByOrderByStampboardWritedateDesc();

		List<stampboardDTO> list = new ArrayList<>();

		for (Stampboard temp : temps) {

			stampboardDTO dto = stampboardDTO.builder().stampboard_id(temp.getStampboardId())
					.user_id(temp.getUserId().getUserId()).stampboard_title(temp.getStampboardTitle())
					.stampboard_text(temp.getStampboardText()).stampboard_designcode(temp.getStampboardDesigncode())
					.stampboard_designurl(temp.getStampboardDesignimgurl())
					.stampboard_writedate(temp.getStampboardWritedate()).stampboard_likenum(temp.getStampboardLikenum())
					.stampboard_spamnum(temp.getStampboardSpamnum())
					.stampboard_message1(temp.getStampboardMessage1().getMessageId())
					.stampboard_message2(temp.getStampboardMessage2().getMessageId())
					.stampboard_message3(temp.getStampboardMessage3().getMessageId())
					.isMylike(stampboardLikeRepository.existsByUserIdAndStampboardId(userRepository.findByUserId(uid),
							temp))
					.isMyspam(stampboardSpamRepository.existsByUserIdAndStampboardId(userRepository.findByUserId(uid),
							temp))
					.isMyclear(userJoinedStampboardRepository
							.isclearStamp(userRepository.findByUserId(uid), temp))
					.build();

			list.add(dto);
		}

		return list;
	}

	// 검색 결과 좋아요순
	public List<stampboardDTO> sortSearchLike(String text, long uid) {
		List<Stampboard> temps = stampboardRepository
				.findByStampboardTextContainingIgnoreCaseOrderByStampboardLikenumDesc(text);

		List<stampboardDTO> list = new ArrayList<>();

		for (Stampboard temp : temps) {

			stampboardDTO dto = stampboardDTO.builder().stampboard_id(temp.getStampboardId())
					.user_id(temp.getUserId().getUserId()).stampboard_title(temp.getStampboardTitle())
					.stampboard_text(temp.getStampboardText()).stampboard_designcode(temp.getStampboardDesigncode())
					.stampboard_designurl(temp.getStampboardDesignimgurl())
					.stampboard_writedate(temp.getStampboardWritedate()).stampboard_likenum(temp.getStampboardLikenum())
					.stampboard_spamnum(temp.getStampboardSpamnum())
					.stampboard_message1(temp.getStampboardMessage1().getMessageId())
					.stampboard_message2(temp.getStampboardMessage2().getMessageId())
					.stampboard_message3(temp.getStampboardMessage3().getMessageId())
					.isMylike(stampboardLikeRepository.existsByUserIdAndStampboardId(userRepository.findByUserId(uid),
							temp))
					.isMyspam(stampboardSpamRepository.existsByUserIdAndStampboardId(userRepository.findByUserId(uid),
							temp))
					.isMyclear(userJoinedStampboardRepository
							.isclearStamp(userRepository.findByUserId(uid), temp))
					.build();

			list.add(dto);
		}

		return list;
	}

	// 검색 결과 최신순
	public List<stampboardDTO> sortSearchNew(String text, long uid) {
		List<Stampboard> temps = stampboardRepository
				.findByStampboardTextContainingIgnoreCaseOrderByStampboardWritedateDesc(text);

		List<stampboardDTO> list = new ArrayList<>();

		for (Stampboard temp : temps) {

			stampboardDTO dto = stampboardDTO.builder().stampboard_id(temp.getStampboardId())
					.user_id(temp.getUserId().getUserId()).stampboard_title(temp.getStampboardTitle())
					.stampboard_text(temp.getStampboardText()).stampboard_designcode(temp.getStampboardDesigncode())
					.stampboard_designurl(temp.getStampboardDesignimgurl())
					.stampboard_writedate(temp.getStampboardWritedate()).stampboard_likenum(temp.getStampboardLikenum())
					.stampboard_spamnum(temp.getStampboardSpamnum())
					.stampboard_message1(temp.getStampboardMessage1().getMessageId())
					.stampboard_message2(temp.getStampboardMessage2().getMessageId())
					.stampboard_message3(temp.getStampboardMessage3().getMessageId())
					.isMylike(stampboardLikeRepository.existsByUserIdAndStampboardId(userRepository.findByUserId(uid),
							temp))
					.isMyspam(stampboardSpamRepository.existsByUserIdAndStampboardId(userRepository.findByUserId(uid),
							temp))
					.isMyclear(userJoinedStampboardRepository
							.isclearStamp(userRepository.findByUserId(uid), temp))
					.build();

			list.add(dto);
		}

		return list;
	}

//	//스탬프 참가하기
//	public Integer joinStamp(long uid, long sid) {
//		
//		
//	}

}
