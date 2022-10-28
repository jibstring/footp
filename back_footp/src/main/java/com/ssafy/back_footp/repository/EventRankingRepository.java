package com.ssafy.back_footp.repository;

import com.ssafy.back_footp.entity.*;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface EventRankingRepository extends JpaRepository<EventRanking, Long>{
    public EventRanking findByEventIdAndUserId(Event eventId, User userId);
}
