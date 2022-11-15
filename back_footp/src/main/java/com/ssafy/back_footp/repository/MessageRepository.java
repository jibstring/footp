package com.ssafy.back_footp.repository;

import java.util.List;

import com.ssafy.back_footp.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import com.ssafy.back_footp.entity.Message;

import javax.transaction.Transactional;

@Repository
public interface MessageRepository extends JpaRepository<Message, Long>, MessageCustomRepository {
	List<Message> findByUserIdOrderByMessageWritedateDesc(User id);
	List<Message> findAllByOrderByMessageWritedateDesc();
	List<Message> findAllByOrderByMessageLikenumDesc();
	List<Message> findAllByUserId(User userId);

	public static final String sortHot = "select * from message where message_writedate > date_sub(NOW(),INTERVAL 7 DAY) order by message_writedate DESC";
	@Query(value = sortHot, nativeQuery = true)
	List<Message> findAllByHot();

	@Transactional
	public void deleteAllByUserId(User uid);

}
