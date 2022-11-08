package com.ssafy.back_footp.repository;

import com.ssafy.back_footp.entity.Message;
import com.ssafy.back_footp.entity.User;

import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

import com.ssafy.back_footp.entity.Event;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface EventRepository extends JpaRepository<Event, Long>{
    @Query(value = "select * from event as e where (ST_Distance_Sphere(e.event_point, point(:lon, :lat))) <= 500 order by e.event_writedate", nativeQuery = true)
    List<Event> findAllInRadiusOrderByEventWritedate(@Param(value = "lon")double lon,@Param(value = "lat")double lat);
    @Query(value = "select * from event as e where (ST_Distance_Sphere(e.event_point, point(:lon, :lat))) <= 500 order by e.event_likenum", nativeQuery = true)
    List<Event> findAllInRadiusOrderByEventLikenum(@Param(value = "lon")double lon,@Param(value = "lat") double lat);
    List<Event> findByUserIdOrderByEventWritedate(User id);
    List<Event> findAllByOrderByEventWritedate();
    List<Event> findAllByOrderByEventLikenumDesc();

    List<Event> findAllByUserId(User userId);
    
    Event findByEventIdAndUserId(long eventid, User userid);
}
