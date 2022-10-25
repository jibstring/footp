package com.ssafy.back_footp.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.ssafy.back_footp.entity.EventRanking;

@Repository
public interface EventRankingRepository extends JpaRepository<EventRanking, Long>{

}
