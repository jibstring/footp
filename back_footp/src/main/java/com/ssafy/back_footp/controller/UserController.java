package com.ssafy.back_footp.controller;

import com.ssafy.back_footp.request.MypostUpdateReq;
import com.ssafy.back_footp.request.NicknameUpdateReq;
import com.ssafy.back_footp.request.PasswordUpdateReq;
import com.ssafy.back_footp.service.UserService;
import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.ssafy.back_footp.entity.Mail;
import com.ssafy.back_footp.service.MailService;

import io.swagger.annotations.ApiOperation;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@RestController
@Slf4j
@AllArgsConstructor
@RequestMapping("/user")
public class UserController {
	//Autowire 하는곳
	@Autowired
	UserService userService;


	@GetMapping("/myfoot/{userId}")
	@ApiOperation(value = "내가 남긴 글 조회")
	public ResponseEntity<JSONObject> mypostSearch(@PathVariable long userId) {
		JSONObject result = null;

		try {
			result = userService.getMymessages(userId);
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}

		return new ResponseEntity<JSONObject>(result, HttpStatus.OK);
	}

	@PutMapping("/myfoot/{messageId}")
	@ApiOperation(value = "내가 만든 글 보기 권한 수정")
	public ResponseEntity<String> mypostUpdate(@RequestBody MypostUpdateReq mypostUpdateReq) {
		String result = "fail";

		try {
			result = userService.updateMessage(mypostUpdateReq);
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}

		return new ResponseEntity<>(result, HttpStatus.OK);
	}

	@DeleteMapping("/myfoot/{messageId}")
	@ApiOperation(value = "내가 남긴 글 삭제")
	public ResponseEntity<String> mypostDelete(@PathVariable long messageId) {
		String result = "fail";

		try {
			result = userService.deleteMessage(messageId);
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}

		return new ResponseEntity<>(result, HttpStatus.OK);
	}


	@PutMapping("/password")
	@ApiOperation(value = "비밀번호 수정")
	public ResponseEntity<String> passwordUpdate(@RequestBody PasswordUpdateReq passwordUpdateReq) {
		String result = "fail";

		try {
			result = userService.updatePassword(passwordUpdateReq);
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}

		return new ResponseEntity<>(result, HttpStatus.OK);
	}


	@PutMapping("/nickname")
	@ApiOperation(value = "닉네임 수정")
	public ResponseEntity<String> nicknameUpdate(@RequestBody NicknameUpdateReq nicknameUpdateReq) {
		String result = "fail";

		try {
			result = userService.updateNickname(nicknameUpdateReq);
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}

		return new ResponseEntity<>(result, HttpStatus.OK);
	}
	
}
