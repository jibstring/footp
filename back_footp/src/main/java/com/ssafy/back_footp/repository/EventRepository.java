package com.ssafy.back_footp.repository;

import com.ssafy.back_footp.entity.User;

import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

import com.ssafy.back_footp.entity.Gather;
import org.springframework.data.jpa.repository.Query;

public interface EventRepository extends JpaRepository<Gather, Long>{
    @Query(value = "select * from event as e where (ST_Distance_Sphere(e.event_point, point(:lon, :lat))) <= 500 order by e.event_writedate", nativeQuery = true)
    List<Gather> findAllInRadiusOrderByEventWritedate(double lon, double lat);
    @Query(value = "select * from event as e where (ST_Distance_Sphere(e.event_point, point(:lon, :lat))) <= 500 order by e.event_likenum", nativeQuery = true)
    List<Gather> findAllInRadiusOrderByEventLikenum(double lon, double lat);
    List<Gather> findByUserIdOrderByEventWritedate(User id);
    List<Gather> findAllByOrderByEventWritedate();
    List<Gather> findAllByOrderByEventLikenumDesc();

    List<Gather> findAllByUserId(User userId);
    
    Gather findByEventIdAndUserId(long eventid, User userid);
}
