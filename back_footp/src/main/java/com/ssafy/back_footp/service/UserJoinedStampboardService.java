package com.ssafy.back_footp.service;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import javax.transaction.Transactional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ssafy.back_footp.entity.Stampboard;
import com.ssafy.back_footp.entity.User;
import com.ssafy.back_footp.entity.UserJoinedStampboard;
import com.ssafy.back_footp.repository.StampboardLikeRepository;
import com.ssafy.back_footp.repository.StampboardRepository;
import com.ssafy.back_footp.repository.UserJoinedStampboardRepository;
import com.ssafy.back_footp.repository.UserRepository;
import com.ssafy.back_footp.response.stampboardDTO;
import com.ssafy.back_footp.response.userjoinedstampboardDTO;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
@RequiredArgsConstructor
public class UserJoinedStampboardService {

	@Autowired
	UserJoinedStampboardRepository userJoinedStampboardRepository;

	@Autowired
	StampboardService stampboardService;

	@Autowired
	StampboardRepository stampboardRepository;

	@Autowired
	StampboardLikeRepository stampboardLikeRepository;

	@Autowired
	UserRepository userRepository;

	// 내가 진행중인 스탬푸 (스탬푸는 동시에 여러개 진행할 수 없다)
	public userjoinedstampboardDTO playingStamp(long userId) {

		Optional<UserJoinedStampboard> tempO = userJoinedStampboardRepository
				.findById(userRepository.findByUserId(userId).getUserIsplaying());

		if (tempO.isPresent()) {

			UserJoinedStampboard temp = tempO.get();

			Stampboard stampboard = stampboardRepository.findById(temp.getStampboardId().getStampboardId()).get();

			userjoinedstampboardDTO result = userjoinedstampboardDTO.builder()
					.stampboard_id(temp.getStampboardId().getStampboardId()).user_id(temp.getUserId().getUserId())
					.stampboard_title(stampboard.getStampboardTitle()).stampboard_text(stampboard.getStampboardText())
					.stampboard_designcode(stampboard.getStampboardDesigncode())
					.stampboard_designurl(stampboard.getStampboardDesignimgurl())
					.stampboard_writedate(stampboard.getStampboardWritedate())
					.stampboard_likenum(stampboard.getStampboardLikenum())
					.stampboard_spamnum(stampboard.getStampboardSpamnum())
					.stampboard_message1(stampboard.getStampboardMessage1().getMessageId())
					.stampboard_message2(stampboard.getStampboardMessage2().getMessageId())
					.stampboard_message3(stampboard.getStampboardMessage3().getMessageId())
					.UserjoinedStampboard_cleardate1(temp.getUserjoinedstampboardCleardate1())
					.UserjoinedStampboard_cleardate2(temp.getUserjoinedstampboardCleardate2())
					.UserjoinedStampboard_cleardate3(temp.getUserjoinedstampboardCleardate3())
					.isMylike(stampboardLikeRepository.existsByUserId(userRepository.findByUserId(userId))).build();

			return result;
		}
		
		return null;
	}

	// 내가 완료한 스탬푸 목록들 반환
	public List<userjoinedstampboardDTO> clearedStamp(long userId) {

		List<UserJoinedStampboard> list = userJoinedStampboardRepository
				.clearedStamp(userRepository.findByUserId(userId));

		List<userjoinedstampboardDTO> result = new ArrayList<>();
		for (UserJoinedStampboard temp : list) {

			Stampboard stampboard = stampboardRepository.findById(temp.getStampboardId().getStampboardId()).get();

			userjoinedstampboardDTO DTO = userjoinedstampboardDTO.builder()
					.stampboard_id(temp.getStampboardId().getStampboardId()).user_id(temp.getUserId().getUserId())
					.stampboard_title(stampboard.getStampboardTitle()).stampboard_text(stampboard.getStampboardText())
					.stampboard_designcode(stampboard.getStampboardDesigncode())
					.stampboard_designurl(stampboard.getStampboardDesignimgurl())
					.stampboard_writedate(stampboard.getStampboardWritedate())
					.stampboard_likenum(stampboard.getStampboardLikenum())
					.stampboard_spamnum(stampboard.getStampboardSpamnum())
					.stampboard_message1(stampboard.getStampboardMessage1().getMessageId())
					.stampboard_message2(stampboard.getStampboardMessage2().getMessageId())
					.stampboard_message3(stampboard.getStampboardMessage3().getMessageId())
					.UserjoinedStampboard_cleardate1(temp.getUserjoinedstampboardCleardate1())
					.UserjoinedStampboard_cleardate2(temp.getUserjoinedstampboardCleardate2())
					.UserjoinedStampboard_cleardate3(temp.getUserjoinedstampboardCleardate3())
					.isMylike(stampboardLikeRepository.existsByUserId(userRepository.findByUserId(userId))).build();

			result.add(DTO);
		}

		return result;
	}

	// 스탬푸 시작(참가)
	@Transactional
	public Integer startStamp(long uid, long sid) {

		User user = userRepository.findByUserId(uid);
		Stampboard stampboard = stampboardRepository.findById(sid).get();

		UserJoinedStampboard result = UserJoinedStampboard.builder().userId(user).stampboardId(stampboard)
				.userjoinedstampboardIsclear1(false).userjoinedstampboardIsclear2(false)
				.userjoinedstampboardIsclear3(false).build();

		userJoinedStampboardRepository.save(result);
		user.setUserIsplaying(result.getUserjoinedstampboardId());
		userRepository.save(user);

		return 1;
	}

	// 진행중인 스탬푸 삭제(취소)
	@Transactional
	public Integer deleteStamp(long uid) {

		User user = userRepository.findByUserId(uid);

		if (user.getUserIsplaying() != -1)
			userJoinedStampboardRepository.deleteById(user.getUserIsplaying());

		// 유저의 스탬푸를 진행가능상태로 변경
		user.setUserIsplaying((long) -1);
		userRepository.save(user);

		return 1;
	}

	// 스탬푸 도장 찍기 + 스탬푸 도장 완료
	@Transactional
	public Integer clearStamp(long uid, long mid) {

		Optional<UserJoinedStampboard> userJoinedStampboardO = userJoinedStampboardRepository
				.findById(userRepository.findByUserId(uid).getUserIsplaying());

		if (userJoinedStampboardO.isPresent()) {

			UserJoinedStampboard userJoinedStampboard = userJoinedStampboardO.get();
			Stampboard stampboard = stampboardRepository
					.findById(userJoinedStampboard.getStampboardId().getStampboardId()).get();
			User user = userRepository.findByUserId(userJoinedStampboard.getUserId().getUserId());

			if (!userJoinedStampboard.getUserjoinedstampboardIsclear1()
					&& stampboard.getStampboardMessage1().getMessageId() == mid) {

				userJoinedStampboard.setUserjoinedstampboardIsclear1(true);
				userJoinedStampboard.setUserjoinedstampboardCleardate1(LocalDateTime.now());
			} else if (!userJoinedStampboard.getUserjoinedstampboardIsclear2()
					&& stampboard.getStampboardMessage2().getMessageId() == mid) {

				userJoinedStampboard.setUserjoinedstampboardIsclear2(true);
				userJoinedStampboard.setUserjoinedstampboardCleardate2(LocalDateTime.now());
			} else if (!userJoinedStampboard.getUserjoinedstampboardIsclear3()
					&& stampboard.getStampboardMessage3().getMessageId() == mid) {

				userJoinedStampboard.setUserjoinedstampboardIsclear3(true);
				userJoinedStampboard.setUserjoinedstampboardCleardate3(LocalDateTime.now());
			}

			userJoinedStampboardRepository.save(userJoinedStampboard);

			// 세개 전부 도장이 찍혔으면 스탬푸가 완료되었으므로 처리해줌

			if (userJoinedStampboard.getUserjoinedstampboardIsclear1()
					&& userJoinedStampboard.getUserjoinedstampboardIsclear2()
					&& userJoinedStampboard.getUserjoinedstampboardIsclear3()) {

				user.setUserIsplaying((long) -1);
				user.setUserStampclearnum(user.getUserStampclearnum() + 1);

				userRepository.save(user);
			}

			return 1;
		} else {
			return 0;
		}

	}

	// 내가 완성한 스탬푸들 조회

}
