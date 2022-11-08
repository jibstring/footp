package com.ssafy.back_footp.repository;

import java.util.List;

import com.ssafy.back_footp.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.ssafy.back_footp.entity.Message;

@Repository
public interface MessageRepository extends JpaRepository<Message, Long>{
	List<Message> findByUserIdOrderByMessageWritedateDesc(User id);
	List<Message> findAllByOrderByMessageWritedateDesc();
	List<Message> findAllByOrderByMessageLikenumDesc();
	List<Message> findAllByUserId(User userId);

	@Query(value = "select * from message as m where (ST_Distance_Sphere(m.message_point, point(:lon, :lat))) <= 500 order by m.message_writedate", nativeQuery = true)
	List<Message> findAllInRadiusOrderByMessageWritedate(@Param(value = "lon")double lon,@Param(value = "lat") double lat);
	@Query(value = "select * from message as m where (ST_Distance_Sphere(m.message_point, point(:lon, :lat))) <= 500 order by m.message_likenum", nativeQuery = true)
	List<Message> findAllInRadiusOrderByMessageLikenum(@Param(value = "lon")double lon,@Param(value = "lat") double lat);
	
	public static final String sortHot = "select * from message where message_writedate > date_sub(NOW(),INTERVAL 7 DAY) order by message_writedate DESC";
	@Query(value = sortHot, nativeQuery = true)
	List<Message> findAllByHot();

}
