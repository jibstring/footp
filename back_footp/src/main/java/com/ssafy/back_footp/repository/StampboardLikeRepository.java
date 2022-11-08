package com.ssafy.back_footp.repository;

import java.util.List;

import javax.transaction.Transactional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.ssafy.back_footp.entity.Stampboard;
import com.ssafy.back_footp.entity.StampboardLike;
import com.ssafy.back_footp.entity.User;

@Repository
public interface StampboardLikeRepository extends JpaRepository<StampboardLike, Long>{

	public List<StampboardLike> findAllByUserId(User uid);
	
	public StampboardLike findByUserIdAndStampboardId(User uid, Stampboard sid);
	
	@Transactional
	public void deleteByUserIdAndStampboardId(User uid, Stampboard sid);
	
	@Transactional
	public void deleteAllByStampboardId(Stampboard sid);
	
	@Transactional
	public void deleteAllByUserId(User user);

	
	public int countByStampboardId(Stampboard sid);
	
	
}
