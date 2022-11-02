package com.ssafy.back_footp.repository;

import java.util.List;

import com.ssafy.back_footp.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import com.ssafy.back_footp.entity.Message;

@Repository
public interface MessageRepository extends JpaRepository<Message, Long>{
	List<Message> findByUserIdOrderByMessageWritedate(User id);
	List<Message> findAllByOrderByMessageWritedate();
	List<Message> findAllByOrderByMessageLikenum();
	List<Message> findAllByUserId(User userId);

	@Query(value = "select * from message as m where (ST_Distance_Sphere(m.message_point, point(:lon, :lat))) <= 500 order by m.message_writedate", nativeQuery = true)
	List<Message> findAllInRadiusOrderByMessageWritedate(double lon, double lat);
	@Query(value = "select * from message as m where (ST_Distance_Sphere(m.message_point, point(:lon, :lat))) <= 500 order by m.message_likenum", nativeQuery = true)
	List<Message> findAllInRadiusOrderByMessageLikenum(double lon, double lat);

}
