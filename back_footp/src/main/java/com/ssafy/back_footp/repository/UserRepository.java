package com.ssafy.back_footp.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.ssafy.back_footp.entity.User;

@Repository
public interface UserRepository extends JpaRepository<User, Long>{
	public boolean existByUserEmail(String email);
	public boolean existByUserNickName(String nickname);
	public User findByEmailAndUserPassword(String email, String password);
	
}
