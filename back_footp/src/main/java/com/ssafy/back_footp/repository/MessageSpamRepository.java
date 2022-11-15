package com.ssafy.back_footp.repository;

import java.util.List;

import javax.transaction.Transactional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.ssafy.back_footp.entity.Message;
import com.ssafy.back_footp.entity.MessageSpam;
import com.ssafy.back_footp.entity.User;

@Repository
public interface MessageSpamRepository extends JpaRepository<MessageSpam, Long> {

	// 한 유저가 신고 누른 발자국들의 리스트를 반환
	public List<MessageSpam> findByUserId(User id);

	// 유저가 해당 발자국에 신고를 눌렀는지 파악하기
	public MessageSpam findByMessageIdAndUserId(Message messageId, User userId);

	// 발자국이 받은 신고 수 반환
	public int countByMessageId(Message messageId);

	// 글 삭제시 필요한 쿼리
	@Transactional
	public void deleteAllByMessageId(Message messageId);

	// 회원 탈퇴시 필요한 쿼리
	@Transactional
	public void deleteAllByUserId(User userId);

	public Boolean existsByMessageIdAndUserId(Message messageId, User userId);

}
