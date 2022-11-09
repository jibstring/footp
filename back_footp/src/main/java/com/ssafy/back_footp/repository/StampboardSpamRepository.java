package com.ssafy.back_footp.repository;

import java.util.List;

import javax.transaction.Transactional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.ssafy.back_footp.entity.Stampboard;
import com.ssafy.back_footp.entity.StampboardSpam;
import com.ssafy.back_footp.entity.User;

@Repository
public interface StampboardSpamRepository extends JpaRepository<StampboardSpam, Long>{

	public StampboardSpam findByUserIdAndStampboardId(User uid, Stampboard sid);
	
	@Transactional
	public void deleteAllByStampboardId(Stampboard sid);
	
	@Transactional
	public void deleteAllByUserId(User uid);

	public int countByStampboardId(Stampboard sid);

	public List<StampboardSpam> findAllByUserId(User findByUserId);
}
