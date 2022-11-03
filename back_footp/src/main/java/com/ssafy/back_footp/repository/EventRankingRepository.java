package com.ssafy.back_footp.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.ssafy.back_footp.entity.Gather;
import com.ssafy.back_footp.entity.EventRanking;
import com.ssafy.back_footp.entity.User;

@Repository
public interface EventRankingRepository extends JpaRepository<EventRanking, Long>{
    public EventRanking findByEventIdAndUserId(Gather gatherId, User userId);

	public List<EventRanking> findAllByEventIdOrderByEventrankingDateAsc(Gather gatherId);
}
