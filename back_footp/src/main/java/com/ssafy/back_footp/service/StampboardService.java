package com.ssafy.back_footp.service;

import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import javax.transaction.Transactional;

import com.amazonaws.services.s3.AmazonS3Client;
import com.amazonaws.services.s3.model.CannedAccessControlList;
import com.amazonaws.services.s3.model.ObjectMetadata;
import com.amazonaws.services.s3.model.PutObjectRequest;
import com.ssafy.back_footp.request.StampboardPostReq;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ssafy.back_footp.entity.Message;
import com.ssafy.back_footp.entity.Stampboard;
import com.ssafy.back_footp.entity.User;
import com.ssafy.back_footp.repository.MessageLikeRepository;
import com.ssafy.back_footp.repository.MessageRepository;
import com.ssafy.back_footp.repository.MessageSpamRepository;
import com.ssafy.back_footp.repository.StampboardLikeRepository;
import com.ssafy.back_footp.repository.StampboardRepository;
import com.ssafy.back_footp.repository.StampboardSpamRepository;
import com.ssafy.back_footp.repository.UserJoinedStampboardRepository;
import com.ssafy.back_footp.repository.UserRepository;
import com.ssafy.back_footp.request.MessagePostContent;
import com.ssafy.back_footp.request.StampboardPostContent;
import com.ssafy.back_footp.response.messagelistDTO;
import com.ssafy.back_footp.response.myStampDTO;
import com.ssafy.back_footp.response.stampboardDTO;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.multipart.MultipartFile;

@Service
@Slf4j
@RequiredArgsConstructor
public class StampboardService {
	@Autowired
	private AmazonS3Client amazonS3Client;

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
	
	@Autowired
	MessageLikeRepository messageLikeRepository;
	
	@Autowired
	MessageSpamRepository messageSpamRepository;

	// 스탬푸 생성
	@Transactional
	public int createStampboard(StampboardPostReq stampboardPostReq) throws IOException {
		Stampboard stampboard = new Stampboard();
		StampboardPostContent stampboardInfo = stampboardPostReq.getStampboardPostContent();
		User usr = userRepository.findById(stampboardInfo.getUserId()).get();

		stampboard = Stampboard.builder().stampboardTitle(stampboardInfo.getStampboardTitle())
				.stampboardText(stampboardInfo.getStampboardText()).stampboardLikenum(0).stampboardSpamnum(0)
				.stampboardDesignimgurl("empty").stampboardDesigncode(stampboardInfo.getStampboardDesigncode())
				.stampboardMessage1(messageRepository.findById(stampboardInfo.getStampboardMessage1()).get())
				.stampboardMessage2(messageRepository.findById(stampboardInfo.getStampboardMessage2()).get())
				.stampboardMessage3(messageRepository.findById(stampboardInfo.getStampboardMessage3()).get())
				.userId(userRepository.findByUserId(stampboardInfo.getUserId()))
				.stampboardWritedate(LocalDateTime.now()).build();

		// file upload
		if (stampboardInfo.getStampboardDesigncode() == 1) {
			MultipartFile mfile = stampboardPostReq.getStampboardFile();
			String originalName = UUID.randomUUID() + mfile.getOriginalFilename(); // 파일 이름
			long size = mfile.getSize(); // 파일 크기
			String S3Bucket = "footp-bucket"; // Bucket 이름
			ObjectMetadata objectMetaData = new ObjectMetadata();
			objectMetaData.setContentType(mfile.getContentType());
			objectMetaData.setContentLength(size);

			// S3에 업로드
			amazonS3Client.putObject(
					new PutObjectRequest(S3Bucket + "/stampboard", originalName, mfile.getInputStream(), objectMetaData)
							.withCannedAcl(CannedAccessControlList.PublicRead));

			String imagePath = amazonS3Client.getUrl(S3Bucket + "/stampboard", originalName).toString(); // 접근가능한 URL
																											// 가져오기

			stampboard.setStampboardDesignimgurl(imagePath);
		} else if (stampboardInfo.getStampboardDesigncode() > 1) {
			String imagePath = "https://s3.ap-northeast-2.amazonaws.com/footp-bucket/stampboard/frame"
					+ stampboardInfo.getStampboardDesigncode() + ".png"; // 접근가능한 URL 가져오기
			stampboard.setStampboardDesignimgurl(imagePath);
		}

		// save
		stampboardRepository.save(stampboard);

		usr.setUserStampcreatenum(usr.getUserStampcreatenum() == null ? 0 : usr.getUserStampcreatenum() + 1);
		userRepository.save(usr);

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
					.isMyclear(userJoinedStampboardRepository.isclearStamp(userRepository.findByUserId(uid), temp))
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
					.isMyclear(userJoinedStampboardRepository.isclearStamp(userRepository.findByUserId(uid), temp))
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
					.isMyclear(userJoinedStampboardRepository.isclearStamp(userRepository.findByUserId(uid), temp))
					.build();

			list.add(dto);
		}

		return list;
	}

	// 검색 결과 최신순
	public List<stampboardDTO> sortSearchNew(String text, long uid) {
		List<Stampboard> temps = stampboardRepository
				.findByStampboardTextContainingIgnoreCaseOrStampboardTitleContainingIgnoreCaseOrderByStampboardWritedateDesc(text,text);

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
					.isMyclear(userJoinedStampboardRepository.isclearStamp(userRepository.findByUserId(uid), temp))
					.build();

			list.add(dto);
		}

		return list;
	}

	// 스탬프 참가하기
	public List<messagelistDTO> messageInStamp(long mid1, long mid2, long mid3, long uid) {

		List<messagelistDTO> result = new ArrayList<>();

		List<Long> arr = new ArrayList<>();

		arr.add(mid1);
		arr.add(mid2);
		arr.add(mid3);

		for (long temp : arr) {

			Message m = messageRepository.findById(temp).get();

			messagelistDTO dto = messagelistDTO.builder().messageId(m.getMessageId()).userNickname(m.getUserNickname())
					.messageText(m.getMessageText()).messageBlurredtext(m.getMessageBlurredtext())
					.messageFileurl(m.getMessageFileurl()).messageLongitude(m.getMessagePoint().getX())
					.messageLatitude(m.getMessagePoint().getY()).isOpentoall(m.getIsOpentoall())
					.isBlurred(m.getIsBlurred()).messageLikenum(m.getMessageLikenum())
					.messageSpamnum(m.getMessageSpamnum())
					.messageWritedate(m.getMessageWritedate().format(DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm")))
					.isMylike(messageLikeRepository.existsByMessageIdAndUserId(m, userRepository.findByUserId(uid)))
					.isMyspam(messageSpamRepository.existsByMessageIdAndUserId(m, userRepository.findByUserId(uid)))
					.build();
			
			result.add(dto);
		}
		
		return result;

	}

}
