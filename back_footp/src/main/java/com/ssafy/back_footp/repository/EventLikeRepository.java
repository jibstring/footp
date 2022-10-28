package com.ssafy.back_footp.repository;

import com.ssafy.back_footp.entity.EventLike;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.ssafy.back_footp.entity.EventLike;
import com.ssafy.back_footp.entity.MessageLike;

import javax.transaction.Transactional;
import java.util.List;

@Repository
public interface EventLikeRepository extends JpaRepository<EventLike, Long>{


		// 한 유저가 좋아요 누른 이벤트발자국들의 리스트를 반환
		public List<EventLike> findByUserId(long uid);

		// 유저가 해당 발자국에 좋아요를 눌렀는지 파악하기
		public MessageLike findByEventIdAndUserId(long eid, long uid);

		// 발자국이 받은 좋아요 수 반환
		public int countByEventId(long eid);

		// 이미 좋아요를 누른 상태에서 취소하기 위한 쿼리
		@Transactional
		public int deleteByEventIdAndUserId(long eid, long uid);

		// 글 삭제시 필요한 쿼리
		@Transactional
		public void deleteAllByEventId(long eid);

		// 회원 탈퇴시 필요한 쿼리
		@Transactional
		public void deleteAllByUserId(long uid);