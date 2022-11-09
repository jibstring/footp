package com.ssafy.back_footp.repository;

import java.util.List;

import com.ssafy.back_footp.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import com.ssafy.back_footp.entity.Message;

import javax.transaction.Transactional;

@Repository
public interface MessageRepository extends JpaRepository<Message, Long>{
	List<Message> findByUserIdOrderByMessageWritedateDesc(User id);
	List<Message> findAllByOrderByMessageWritedateDesc();
	List<Message> findAllByOrderByMessageLikenumDesc();
	List<Message> findAllByUserId(User userId);

	@Query(value = "SELECT * from message WHERE ST_CONTAINS(ST_GEOMFROMTEXT('POLYGON((:lon_l :lat_u, :lon_r :lat_u, :lon_r :lat_d, :lon_l :lat_d, :lon_l :lat_u))'), message_point)  order by message_writedate", nativeQuery = true)
	List<Message> findAllInScreenOrderByMessageWritedate(double lon_r, double lon_l, double lat_d, double lat_u);
	@Query(value = "SELECT * from message WHERE ST_CONTAINS(ST_GEOMFROMTEXT('POLYGON((:lon_l :lat_u, :lon_r :lat_u, :lon_r :lat_d, :lon_l :lat_d, :lon_l :lat_u))'), message_point)  order by message_likenum desc", nativeQuery = true)
	List<Message> findAllInScreenOrderByMessageLikenum(double lon_r, double lon_l, double lat_d, double lat_u);
	
	public static final String sortHot = "select * from message where message_writedate > date_sub(NOW(),INTERVAL 7 DAY) order by message_writedate DESC";
	@Query(value = sortHot, nativeQuery = true)
	List<Message> findAllByHot();

	@Transactional
	public void deleteAllByUserId(User uid);

}
