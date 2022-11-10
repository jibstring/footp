package com.ssafy.back_footp.response;

import java.io.Serializable;
import java.time.LocalDateTime;

import com.ssafy.back_footp.entity.Stampboard;

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
public class stampboardDTO implements Serializable{
	
	Long stampboard_id;
	Long user_id;
	String stampboard_title;
	String stampboard_text;
	Integer stampboard_designcode;
	String stampboard_designurl;
	LocalDateTime stampboard_writedate;
	Integer stampboard_likenum;
	Integer stampboard_spamnum;
	Long stampboard_message1;
	Long stampboard_message2;
	Long stampboard_message3;
	Boolean isMylike;
	Boolean isMyspam;
	Boolean isMyclear;

}
