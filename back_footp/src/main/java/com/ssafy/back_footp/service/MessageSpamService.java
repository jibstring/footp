package com.ssafy.back_footp.service;

import javax.transaction.Transactional;

import com.ssafy.back_footp.repository.MessageRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ssafy.back_footp.entity.Message;
import com.ssafy.back_footp.entity.MessageLike;
import com.ssafy.back_footp.entity.MessageSpam;
import com.ssafy.back_footp.repository.MessageSpamRepository;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@RequiredArgsConstructor
public class MessageSpamService {
	@Autowired
	private MessageRepository messageRepository;
	@Autowired
	private MessageSpamRepository messageSpamRepository;
	
	// 발자국의 id를 받아와 해당 발자국이 받은 신고 수를 반환한다.
		public int spamNum(long mid) {
			int result = messageSpamRepository.countByMessageId(messageRepository.findById(mid).get());
			return result;
		}
		
		//신고를 누르지 않은 상태에서 누른경우, Table에 추가하기 위해 Create한다.
		@Transactional
		public MessageSpam createSpam(MessageSpam messageSpam) {
			MessageSpam savedSpam = messageSpamRepository.save(messageSpam);

			// Spamnum 증가
			Message msg = messageRepository.findById(messageSpam.getMessageId().getMessageId()).get();
			msg.setMessageSpamnum(msg.getMessageSpamnum()+1);
			messageRepository.save(msg);

			return savedSpam;
		}
		

}
