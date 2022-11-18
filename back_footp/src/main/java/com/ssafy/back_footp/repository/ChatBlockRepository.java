package com.ssafy.back_footp.repository;

import java.util.List;

import javax.transaction.Transactional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.ssafy.back_footp.entity.ChatBlock;
import com.ssafy.back_footp.entity.User;

@Repository
public interface ChatBlockRepository extends JpaRepository<ChatBlock, Long>{
	
	public List<ChatBlock> findAllByUserBlocking(User userid);
	
	public boolean existsByUserBlockingAndUserBlocked(User blocking, User blocked);
	public ChatBlock findByUserBlockingAndUserBlocked(User blocking, User blocked);
	
	@Transactional
	public void deleteByUserBlockingAndUserBlocked(User blocking, User blocked);
	@Transactional
	public void deleteAllByUserBlocking(User blocking);
	
	@Transactional
	public void deleteAllByUserBlocked(User blocked);

}
