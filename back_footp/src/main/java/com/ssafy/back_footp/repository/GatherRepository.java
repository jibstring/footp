package com.ssafy.back_footp.repository;

import com.ssafy.back_footp.entity.User;

import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

import com.ssafy.back_footp.entity.Gather;
import org.springframework.data.jpa.repository.Query;

public interface GatherRepository extends JpaRepository<Gather, Long>{
    @Query(value = "select * from Gather as e where (ST_Distance_Sphere(e.Gather_point, point(:lon, :lat))) <= 500 order by e.Gather_writedate", nativeQuery = true)
    List<Gather> findAllInRadiusOrderByGatherWritedate(double lon, double lat);
    @Query(value = "select * from Gather as e where (ST_Distance_Sphere(e.Gather_point, point(:lon, :lat))) <= 500 order by e.Gather_likenum", nativeQuery = true)
    List<Gather> findAllInRadiusOrderByGatherLikenum(double lon, double lat);
    List<Gather> findByUserIdOrderByGatherWritedate(User id);
    List<Gather> findAllByOrderByGatherWritedate();
    List<Gather> findAllByOrderByGatherLikenumDesc();

    List<Gather> findAllByUserId(User userId);
    
    Gather findByGatherIdAndUserId(long Gatherid, User userid);
}
