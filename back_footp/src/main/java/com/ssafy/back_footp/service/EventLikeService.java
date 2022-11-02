package com.ssafy.back_footp.service;

import javax.transaction.Transactional;

import com.ssafy.back_footp.entity.*;
import com.ssafy.back_footp.repository.EventRepository;
import com.ssafy.back_footp.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ssafy.back_footp.repository.EventLikeRepository;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@RequiredArgsConstructor
public class EventLikeService {

	@Autowired
	private EventLikeRepository eventLikeRepository;
	@Autowired
	private EventRepository eventRepository;
	@Autowired
	private UserRepository userRepository;
	
	// 발자국의 id를 받아와 해당 발자국이 받은 좋아요 수를 반환한다.
		public int likeNum(long eid) {
			int result = eventLikeRepository.countByEventId(eventRepository.findById(eid).get());
			return result;
		}
		
		//좋아요를 누르지 않은 상태에서 누른경우, Table에 추가하기 위해 Create한다.
		@Transactional
		public EventLike createLike(EventLike eventLike) {
			EventLike savedLike = eventLikeRepository.save(eventLike);

			// Likenum 증가
			Event evt = eventRepository.findById(eventLike.getEventId().getEventId()).get();
			evt.setEventLikenum(evt.getEventLikenum()+1);
			eventRepository.save(evt);

			return savedLike;
		}
		
		//이미 좋아요를 누른 상태에서 취소할 경우, Table에서 삭제하기 위해 Delete한다.
		@Transactional
		public void deleteLike(long eid, long uid) {

			// Likenum 감소
			Event evt = eventRepository.findById(eid).get();
			evt.setEventLikenum(evt.getEventLikenum()-1);
			eventRepository.save(evt);

			eventLikeRepository.deleteByEventIdAndUserId(eventRepository.findById(eid).get(), userRepository.findById(uid).get());
		}
}
