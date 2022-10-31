package com.ssafy.back_footp.repository;

import java.util.List;

import javax.transaction.Transactional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.ssafy.back_footp.entity.Event;
import com.ssafy.back_footp.entity.EventSpam;
import com.ssafy.back_footp.entity.MessageSpam;
import com.ssafy.back_footp.entity.User;

@Repository
public interface EventSpamRepository extends JpaRepository<EventSpam, Long>{

		// 한 유저가 신고 누른 이벤트 발자국들의 리스트를 반환
		public List<EventSpam> findByUserId(User uid);

		// 유저가 해당 발자국에 신고를 눌렀는지 파악하기
		public MessageSpam findByEventIdAndUserId(Event eid, User uid);

		// 발자국이 받은 신고 수 반환
		public int countByEventId(Event eid);

		// 글 삭제시 필요한 쿼리
		@Transactional
		public void deleteAllByEventId(Event eid);

		// 회원 탈퇴시 필요한 쿼리
		@Transactional
		public void deleteAllByUserId(User uid);
}
