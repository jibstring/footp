package com.ssafy.back_footp.entity;

import java.time.LocalDateTime;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Table(name = "userjoinedstampboard")
public class UserJoinedStampboard {
	
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name = "userjoinedstampboard_id")
	private Long userjoinedstampboardId;
	
	@ManyToOne
    @JoinColumn(name = "user_id")
    private User userId;
	
	@ManyToOne
    @JoinColumn(name = "stampboard_id")
    private Stampboard stampboardId;
	
	@Column(name = "userjoinedstampboard_isclear1")
	private Boolean userjoinedstampboardIsclear1;
	
	@Column(name = "userjoinedstampboard_isclear2")
	private Boolean userjoinedstampboardIsclear2;
	
	@Column(name = "userjoinedstampboard_isclear3")
	private Boolean userjoinedstampboardIsclear3;
	
	@Column(name = "userjoinedstampboard_cleardate1")
	private LocalDateTime userjoinedstampboardCleardate1;
	
	@Column(name = "userjoinedstampboard_cleardate2")
	private LocalDateTime userjoinedstampboardCleardate2;
	
	@Column(name = "userjoinedstampboard_cleardate3")
	private LocalDateTime userjoinedstampboardCleardate3;
	
}
