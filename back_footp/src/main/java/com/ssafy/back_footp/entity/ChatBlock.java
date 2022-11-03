package com.ssafy.back_footp.entity;

import javax.persistence.*;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Entity
@Getter
@Builder
@AllArgsConstructor
@NoArgsConstructor
@Table(name = "chatblock")
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
