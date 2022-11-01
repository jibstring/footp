package com.ssafy.back_footp.controller;

import java.text.ParseException;
import java.util.HashMap;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.ssafy.back_footp.entity.User;
import com.ssafy.back_footp.repository.UserRepository;
import com.ssafy.back_footp.request.UserSignUpReq;
import com.ssafy.back_footp.security.EncryptionUtils;
import com.ssafy.back_footp.service.MailService;
import com.ssafy.back_footp.service.AuthService;

import io.swagger.annotations.ApiOperation;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@RestController
@Slf4j
@AllArgsConstructor
@RequestMapping("/auth")
public class AuthController {

	public static final Logger logger = LoggerFactory.getLogger(AuthController.class);
	private static final String SUCCESS = "success";
	private static final String FAIL = "fail";

	@Autowired
	MailService mailService;

	@Autowired
	UserRepository userRepository;
	@Autowired
	AuthService authService;

	@PostMapping("/signup")
	@ApiOperation(value = "회원 등록")
	public ResponseEntity<Map<String, Object>> signUp(@RequestBody UserSignUpReq user) throws ParseException {

		Map<String, Object> result = new HashMap<>();

		User userEntity = User.builder().userEmail(user.getUserEmail())
				.userPassword(EncryptionUtils.encryptSHA256(user.getUserPassword())).userCash(0).userEmailKey("N")
				.build();

		try {
			if (!authService.emailCheck(userEntity.getUserEmail())) {
				authService.createUser(userEntity);
				result.put("message", SUCCESS);
			} else {
				result.put("message", "Duplicate Email");
			}
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
			result.put("message", FAIL);
		}

		return new ResponseEntity<Map<String, Object>>(result, HttpStatus.OK);
	}

	@PostMapping("/duplicate/{email}")
	@ApiOperation(value = "이메일 중복 체크")
	public ResponseEntity<Boolean> checkEmail(@PathVariable String email) {

		boolean check = authService.emailCheck(email);

		return new ResponseEntity<Boolean>(check, HttpStatus.OK);

	}

	@PostMapping("/nickname/{nickname}")
	@ApiOperation(value = "닉네임 중복 체크")
	public ResponseEntity<Boolean> checkNick(@PathVariable String nickname) {

		boolean check = authService.nickCheck(nickname);

		return new ResponseEntity<Boolean>(check, HttpStatus.OK);

	}

}
