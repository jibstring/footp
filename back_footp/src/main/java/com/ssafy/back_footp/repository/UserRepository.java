package com.ssafy.back_footp.repository;

import java.util.Optional;

import javax.transaction.Transactional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.ssafy.back_footp.entity.User;

@Repository
public interface UserRepository extends JpaRepository<User, Long>{
	
	//중복처리
	public boolean existsByUserEmail(String email);
	public boolean existsByUserNickname(String nickname);
	
	//로그인에 쓰일거
	public User findByUserEmailAndUserPassword(String email, String password);
	
	public Optional<User> findByUserEmail(String email);
	public User findByUserId(Long uid);
	
	//회원탈퇴
	@Transactional
	public void deleteByUserId(Long uid);
	
}
