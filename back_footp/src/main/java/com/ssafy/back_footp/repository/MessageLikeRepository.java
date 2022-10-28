package com.ssafy.back_footp.repository;

import java.util.List;

import javax.transaction.Transactional;

import com.ssafy.back_footp.entity.Message;
import com.ssafy.back_footp.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.ssafy.back_footp.entity.MessageLike;

@Repository
public interface MessageLikeRepository extends JpaRepository<MessageLike, Long>{

	// 한 유저가 좋아요 누른 발자국들의 리스트를 반환
	public List<MessageLike> findByUserId(User id);
	 
	// 유저가 해당 발자국에 좋아요를 눌렀는지 파악하기 
	public MessageLike findByMessageIdAndUserId(Message messageId, User userId);
	
	// 발자국이 받은 좋아요 수 반환
	public int countByMessageId(Message messageId);
	
	// 이미 좋아요를 누른 상태에서 취소하기 위한 쿼리
	@Transactional
	public int deleteByMessageIdAndUserId(Message messageId, User userId);
	
	// 글 삭제시 필요한 쿼리
	@Transactional
	public void deleteAllByMessageId(Message messageId);
	
	// 회원 탈퇴시 필요한 쿼리
	@Transactional
	public void deleteAllByUserId(User userId);
}
