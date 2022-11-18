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
@Table(name = "stampboardlike")
public class StampboardLike {

	@Id @GeneratedValue(strategy=GenerationType.IDENTITY)
    @Column(name="stampboardlike_id")
    private Long stampboardlikeId;
	
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name="user_id")
    private User userId;
	
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name="stampboard_id")
    private Stampboard stampboardId;
}
