package com.ssafy.back_footp.service;

import javax.transaction.Transactional;

import com.ssafy.back_footp.repository.EventRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ssafy.back_footp.entity.Event;
import com.ssafy.back_footp.entity.EventSpam;
import com.ssafy.back_footp.entity.MessageSpam;
import com.ssafy.back_footp.repository.EventSpamRepository;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@RequiredArgsConstructor
public class EventSpamService {

	@Autowired
	private EventSpamRepository eventSpamRepository;
	@Autowired
	private EventRepository eventRepository;

	// 발자국의 id를 받아와 해당 발자국이 받은 신고 수를 반환한다.
	public int spamNum(long eid) {
		int result = eventSpamRepository.countByEventId(eventRepository.findById(eid).get());
		return result;
	}

	// 신고를 누르지 않은 상태에서 누른경우, Table에 추가하기 위해 Create한다.
	@Transactional
	public EventSpam createSpam(EventSpam eventSpam) {
		EventSpam savedSpam = eventSpamRepository.save(eventSpam);

		// Likenum 증가
		Event evt = eventRepository.findById(eventSpam.getEventId().getEventId()).get();
		evt.setEventSpamnum(evt.getEventSpamnum()+1);
		eventRepository.save(evt);

		return savedSpam;
	}

}
