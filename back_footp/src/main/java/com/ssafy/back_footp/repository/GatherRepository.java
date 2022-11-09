package com.ssafy.back_footp.repository;

import com.ssafy.back_footp.entity.User;

import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

import com.ssafy.back_footp.entity.Gather;

import javax.transaction.Transactional;

public interface GatherRepository extends JpaRepository<Gather, Long>, GatherCustomRepository {

    List<Gather> findByUserIdOrderByGatherWritedate(User id);
    List<Gather> findAllByOrderByGatherWritedate();
    List<Gather> findAllByOrderByGatherLikenumDesc();

    List<Gather> findAllByUserId(User userId);
    
    Gather findByGatherIdAndUserId(long Gatherid, User userid);
    @Transactional
    public void deleteAllByUserId(User uid);
}
