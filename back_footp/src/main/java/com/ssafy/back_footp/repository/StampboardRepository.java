package com.ssafy.back_footp.repository;

import java.util.List;

import javax.transaction.Transactional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.ssafy.back_footp.entity.Stampboard;

@Repository
public interface StampboardRepository extends JpaRepository<Stampboard, Long>{

	public List<Stampboard> findAllByOrderByStampboardLikenum();
	public List<Stampboard> findAllByOrderByStampboardWritedateDesc();
	
	@Transactional
	public void deleteByStampboardId(long sid);
	
	// 이름으로 검색했을 때 결과
	public List<Stampboard> findByStampboardTextContainingIgnoreCase(String text);
}
