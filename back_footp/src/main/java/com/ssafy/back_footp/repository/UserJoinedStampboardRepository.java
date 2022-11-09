package com.ssafy.back_footp.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.ssafy.back_footp.entity.Stampboard;
import com.ssafy.back_footp.entity.User;
import com.ssafy.back_footp.entity.UserJoinedStampboard;

import javax.transaction.Transactional;

@Repository
public interface UserJoinedStampboardRepository extends JpaRepository<UserJoinedStampboard, Long>{
	
	UserJoinedStampboard findByuserIdAndStampboardId(User uid, Stampboard sid);
	
	Integer deleteByUserIdAndStampboardId(User uid, Stampboard sid);

	@Transactional
	public void deleteAllByUserId(User uid);
	@Transactional
	public void deleteAllByStampboardId(Stampboard sid);

	public static final String playing = "SELECT * FROM userjoinedstampboard WHERE user_id =:userId AND userjoinedstampboard_isclear3 != TRUE";
	@Query(value = playing, nativeQuery = true)
	UserJoinedStampboard playingStamp(@Param("userId") User userId);
	
	public static final String cleared = "SELECT * FROM userjoinedstampboard WHERE user_id =:userId AND userjoinedstampboard_isclear1 = TRUE AND userjoinedstampboard_isclear2 = TRUE AND userjoinedstampboard_isclear3 = TRUE";
	@Query(value = cleared, nativeQuery = true)
	List<UserJoinedStampboard> clearedStamp(@Param("userId") User userId);

	public static final String isclear = "SELECT CASE WHEN EXISTS (SELECT * FROM userjoinedstampboard WHERE user_id =:userId AND stampboard_id =:stampboardId AND userjoinedstampboard_isclear1 = TRUE AND userjoinedstampboard_isclear2 = TRUE AND userjoinedstampboard_isclear3 = TRUE) THEN 'true' ELSE 'false' END";
	@Query(value = isclear, nativeQuery = true)
	Boolean isclearStamp(@Param("userId") User userId, @Param("stampboardId") Stampboard stampboardId);
	
	Boolean existsByUserIdAndStampboardId(User findByUserId, Stampboard temp);	
}
