package com.ssafy.back_footp.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface EventRankingRepository extends JpaRepository<EventRanking, Long>{
    public EventRanking findByEventIdAndUserId(Event eventId, User userId);
}
