package com.ssafy.back_footp.entity;

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

@Entity
@Getter
@Builder
@AllArgsConstructor
@NoArgsConstructor
@Table(name = "ChatBlock")
public class ChatBlock {
	
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name = "chat_id")
	private Long chatId;
	
	@JoinColumn(name = "user_blocking")
	@ManyToOne(fetch = FetchType.LAZY)
	private User userBlocking;
	
	@JoinColumn(name = "user_blocked")
	@ManyToOne(fetch = FetchType.LAZY)
	private User userBlocked;

}
