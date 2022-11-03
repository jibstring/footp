package com.ssafy.back_footp.entity;

import java.time.LocalDateTime;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
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
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Table(name = "Stampboard")
public class Stampboard {
	
	@Id @GeneratedValue(strategy=GenerationType.IDENTITY)
    @Column(name="stampboard_id")
    private Long stampboardId;
	
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name="user_id")
    private User userId;
	
	@Column(name = "stampboard_title", length = 255)
	private String stampboardTitle;
	
	@Column(name = "stampboard_text", length = 255)
	private String stampboardText;
	
	@Column(name = "stampboard_designcode")
	private Integer stampboardDesigncode;
	
	@Column(name = "stampboard_designimgurl", length = 1024)
	private String stampboardDesignimgurl;
	
	@Column(name = "stampboard_writedate")
	private LocalDateTime stampboardWritedate;
	
	@Column(name = "stampboard_likenum")
	private Integer stampboardLikenum;
	
	@Column(name = "stampboard_spamnum")
	private Integer stampboardSpamnum;

	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name="stampboard_message1")
    private Message stampboardMessage1;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name="stampboard_message2")
	private Message stampboardMessage2;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name="stampboard_message3")
	private Message stampboardMessage3;

}
