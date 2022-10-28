package com.ssafy.back_footp.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.ssafy.back_footp.entity.Event;

public interface EventRepository extends JpaRepository<Event, Long>{
	List<Event> findByUserIdOrderByEventWritedate(long id);
	List<Event> findAllByOrderByEventWritedate();
	List<Event> findAllByOrderByEventLikenumDesc();
}
