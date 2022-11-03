package com.ssafy.back_footp.repository;

import com.ssafy.back_footp.entity.User;
import com.ssafy.back_footp.entity.UserJoinedGather;
import com.ssafy.back_footp.entity.UserJoinedStampboard;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import javax.transaction.Transactional;
import java.util.Optional;

@Repository
public interface UserJoinedGatherRepository extends JpaRepository<UserJoinedGather, Long>{

	
}
