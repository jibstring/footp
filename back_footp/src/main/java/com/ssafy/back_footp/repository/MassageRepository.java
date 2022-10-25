package com.ssafy.back_footp.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.ssafy.back_footp.entity.Message;

@Repository
public interface MassageRepository extends JpaRepository<Message, Long>{
	
	List<Message> findByUserIdOrderByMessageWritedate(long id);
	
	List<Message> findAllByOrderByMessageWritedate();
	List<Message> findAllByMessageLikenum();

}
