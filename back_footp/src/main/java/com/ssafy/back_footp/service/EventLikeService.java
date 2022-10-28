package com.ssafy.back_footp.service;

import javax.transaction.Transactional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ssafy.back_footp.entity.Event;
import com.ssafy.back_footp.entity.EventLike;
import com.ssafy.back_footp.entity.MessageLike;
import com.ssafy.back_footp.entity.User;
import com.ssafy.back_footp.repository.EventLikeRepository;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@RequiredArgsConstructor
public class EventLikeService {

	@Autowired
	private EventLikeRepository eventLikeRepository;
	
	// 발자국의 id를 받아와 해당 발자국이 받은 좋아요 수를 반환한다.
		public int likeNum(Event eid) {
			int result = eventLikeRepository.countByEventId(eid);
			return result;
		}
		
		//좋아요를 누르지 않은 상태에서 누른경우, Table에 추가하기 위해 Create한다.
		@Transactional
		public EventLike createLike(EventLike eventLike) {
			EventLike savedLike = eventLikeRepository.save(eventLike);
			return savedLike;
		}
		
		//이미 좋아요를 누른 상태에서 취소할 경우, Table에서 삭제하기 위해 Delete한다.
		@Transactional
		public void deleteLike(Event eid, User uid) {
			eventLikeRepository.deleteByEventIdAndUserId(eid, uid);
		}
}
