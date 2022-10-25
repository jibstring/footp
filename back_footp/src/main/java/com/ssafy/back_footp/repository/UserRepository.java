package com.ssafy.back_footp.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import com.ssafy.back_footp.entity.User;

public interface UserRepository extends JpaRepository<User, Long>{
	boolean existByUserEmail(String email);
}
