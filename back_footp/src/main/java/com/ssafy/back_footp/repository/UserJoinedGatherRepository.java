package com.ssafy.back_footp.repository;

import com.ssafy.back_footp.entity.User;
import com.ssafy.back_footp.entity.UserJoinedGather;
import com.ssafy.back_footp.entity.Gather;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import javax.transaction.Transactional;

@Repository
public interface UserJoinedGatherRepository extends JpaRepository<UserJoinedGather, Long>{
    @Transactional
    public void deleteAllByUserId(User uid);

    @Transactional
    public void deleteByUserIdAndGatherId(User uid, Gather gid);

    public boolean existsByUserIdAndGatherId(User uid, Gather gid);
}
