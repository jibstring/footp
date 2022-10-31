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
@Table(name = "ChatBlock")
public class ChatBlock {
	
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name = "chat_id")
	private Long chatId;

	@ManyToOne
	@JoinColumn(name="user_blocking")
	private User userBlocking;

	@ManyToOne
	@JoinColumn(name="user_blocked")
	private User userBlocked;

}
