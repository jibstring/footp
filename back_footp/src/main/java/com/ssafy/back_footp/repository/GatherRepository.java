package com.ssafy.back_footp.repository;

import com.ssafy.back_footp.entity.Message;
import com.ssafy.back_footp.entity.User;

import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

import com.ssafy.back_footp.entity.Gather;
import org.springframework.data.jpa.repository.Query;

import javax.transaction.Transactional;

public interface GatherRepository extends JpaRepository<Gather, Long>, GatherCustomRepository {

    List<Gather> findByUserIdOrderByGatherWritedate(User id);
    List<Gather> findAllByOrderByGatherWritedate();
    List<Gather> findAllByOrderByGatherLikenumDesc();

    List<Gather> findAllByUserId(User userId);
    
    Gather findByGatherIdAndUserId(long Gatherid, User userid);

    @Query(value = "select * from gather as g where g.gather_text like %:keyword% ORDER BY ST_Distance(g.gather_point , point(:lon, :lat))", nativeQuery = true)
    List<Gather> searchGatherSortingByDistance(String keyword, double lon, double lat);

    @Transactional
    public void deleteAllByUserId(User uid);
}
