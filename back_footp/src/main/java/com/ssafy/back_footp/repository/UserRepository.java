package com.ssafy.back_footp.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.ssafy.back_footp.entity.User;

@Repository
public interface UserRepository extends JpaRepository<User, Long>{
	public boolean existsByUserEmail(String email);
	public boolean existsByUserNickName(String nickname);
	public User findByUserEmailAndUserPassword(String email, String password);
	
}
