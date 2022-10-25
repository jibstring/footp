package com.ssafy.back_footp.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import com.ssafy.back_footp.entity.Event;

public interface EventRepository extends JpaRepository<Event, Long>{

}
