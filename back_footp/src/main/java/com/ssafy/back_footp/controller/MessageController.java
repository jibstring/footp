package com.ssafy.back_footp.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.ssafy.back_footp.entity.MessageLike;
import com.ssafy.back_footp.repository.MessageLikeRepository;
import com.ssafy.back_footp.service.MessageLikeService;

import io.swagger.annotations.ApiOperation;
import lombok.extern.slf4j.Slf4j;

@RestController
@Slf4j
@RequestMapping("/foot")
public class MessageController {

	//Autowired 하는곳
	
	@Autowired
	private MessageLikeService messageLikeService;
	@Autowired
	private MessageLikeRepository messageLikeRepository;
	
	
	
	@PostMapping("/like/{messageId}/{userId}")
	@ApiOperation(value = "발자국 좋아요하기", notes = "유저가 발자국에 좋아요를 누른다")
	public ResponseEntity<Integer> messageLike(@PathVariable long messageId, @PathVariable long userId){
		
		
		
		
		
		return null;
		//return new ResponseEntity<Integer>(result, HttpStatus.OK);
	}
}
