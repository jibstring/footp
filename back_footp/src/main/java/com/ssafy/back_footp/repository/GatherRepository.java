package com.ssafy.back_footp.repository;

import com.ssafy.back_footp.entity.Message;
import com.ssafy.back_footp.entity.User;

import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

import com.ssafy.back_footp.entity.Gather;
import org.springframework.data.jpa.repository.Query;

import javax.transaction.Transactional;

public interface GatherRepository extends JpaRepository<Gather, Long>{

    @Query(value = "SELECT * from gather WHERE ST_CONTAINS(ST_GEOMFROMTEXT('POLYGON((:lon_l :lat_u, :lon_r :lat_u, :lon_r :lat_d, :lon_l :lat_d, :lon_l :lat_u))'), gather_point)  order by gather_writedate", nativeQuery = true)
    List<Gather> findAllInScreenOrderByGatherWritedate(double lon_r, double lon_l, double lat_d, double lat_u);
    @Query(value = "SELECT * from gather WHERE ST_CONTAINS(ST_GEOMFROMTEXT('POLYGON((:lon_l :lat_u, :lon_r :lat_u, :lon_r :lat_d, :lon_l :lat_d, :lon_l :lat_u))'), gather_point)  order by gather_likenum desc ", nativeQuery = true)
    List<Gather> findAllInScreenOrderByGatherLikenum(double lon_r, double lon_l, double lat_d, double lat_u);


    List<Gather> findByUserIdOrderByGatherWritedate(User id);
    List<Gather> findAllByOrderByGatherWritedate();
    List<Gather> findAllByOrderByGatherLikenumDesc();

    List<Gather> findAllByUserId(User userId);
    
    Gather findByGatherIdAndUserId(long Gatherid, User userid);
    @Transactional
    public void deleteAllByUserId(User uid);
}
