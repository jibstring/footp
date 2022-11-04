package com.ssafy.back_footp.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.ssafy.back_footp.entity.StampboardLike;

@Repository
public interface StampboardLikeRepository extends JpaRepository<StampboardLike, Long>{

}
