package com.ssafy.back_footp.service;

import javax.transaction.Transactional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ssafy.back_footp.entity.Message;
import com.ssafy.back_footp.entity.MessageLike;
import com.ssafy.back_footp.entity.User;
import com.ssafy.back_footp.repository.MessageLikeRepository;
import com.ssafy.back_footp.repository.MessageSpamRepository;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@RequiredArgsConstructor
public class MessageLikeService {
	
	@Autowired
	private MessageLikeRepository messageLikeRepository;
	
	@Autowired
	private MessageSpamRepository messageSpamRepository;
	
	
	// 발자국의 id를 받아와 해당 발자국이 받은 좋아요 수를 반환한다.
	public int likeNum(Message mid) {
		int result = messageLikeRepository.countByMessageId(mid);
		return result;
	}
	
	// 발자국이 받은 차단 수를 반환
	public int spamNum(Message mid) {
		int result = messageSpamRepository.countByMessageId(mid);
		return result;
	}
	
	//좋아요를 누르지 않은 상태에서 누른경우, Table에 추가하기 위해 Create한다.
	@Transactional
	public MessageLike createLike(MessageLike messageLike) {
		MessageLike savedLike = messageLikeRepository.save(messageLike);
		return savedLike;
	}
	
	//이미 좋아요를 누른 상태에서 취소할 경우, Table에서 삭제하기 위해 Delete한다.
	@Transactional
	public void deleteLike(Message mid, User uid) {
		messageLikeRepository.deleteByMessageIdAndUserId(mid, uid);
	}

}
