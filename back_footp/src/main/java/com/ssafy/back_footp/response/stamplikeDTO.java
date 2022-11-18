package com.ssafy.back_footp.response;

import java.io.Serializable;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
@Builder
public class stamplikeDTO implements Serializable{
	
	private Long stampboardlikeId;
	
	private Long stampboardId;
	
	private Long userId;

}
