package com.ssafy.back_footp.repository;

import java.util.List;

import javax.transaction.Transactional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.ssafy.back_footp.entity.Gather;
import com.ssafy.back_footp.entity.GatherSpam;
import com.ssafy.back_footp.entity.User;

@Repository
public interface GatherSpamRepository extends JpaRepository<GatherSpam, Long>{

		// 한 유저가 신고 누른 이벤트 발자국들의 리스트를 반환
		public List<GatherSpam> findByUserId(User uid);

		// 유저가 해당 발자국에 신고를 눌렀는지 파악하기
		public GatherSpam findByGatherIdAndUserId(Gather gid, User uid);

		// 발자국이 받은 신고 수 반환
		public int countByGatherId(Gather gid);

		// 글 삭제시 필요한 쿼리
		@Transactional
		public void deleteAllByGatherId(Gather gid);

		// 회원 탈퇴시 필요한 쿼리
		@Transactional
		public void deleteAllByUserId(User uid);
}
