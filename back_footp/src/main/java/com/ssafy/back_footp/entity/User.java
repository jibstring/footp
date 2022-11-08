package com.ssafy.back_footp.entity;

import java.time.LocalDateTime;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;

import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@Setter
@Getter
@Builder
@AllArgsConstructor
@NoArgsConstructor
@Table(name = "user")
public class User {

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name = "user_id")
	private Long userId;

	@Column(name = "user_email", nullable = false)
	private String userEmail;

	@Column(name = "user_password", nullable = false)
	private String userPassword;

	@Column(name = "user_nickname")
	private String userNickname;

	@Column(name = "user_emailkey")
	private String userEmailKey;

	@Column(name = "user_social")
	private Long userSocial;

	@Column(name = "user_socialtoken")
	private String userSocialToken;
	
	@Column(name = "user_pwfindkey")
	private String userPwfindkey;
	
	@Column(name = "user_pwfindtime")
	private LocalDateTime userPwfindtime;

	@Column(name = "user_cash", nullable = false)
	private Integer userCash;
	
	@Column(name = "user_isplaying")
	private Long userIsplaying;
	
	@Column(name = "user_stampclearnum")
	private Integer userStampclearnum;
	
	@Column(name = "user_stampcreatenum")
	private Integer userStampcreatenum;
	
//	@Column(name = "user_autologin")
//	private Boolean userAutologin;
//	
//	@Column(name = "user_sessionkey")
//	private String userSessionkey;
//	
//	@Column(name = "user_sessionlimit")
//	private LocalDateTime userSessionlimit;
	
}
