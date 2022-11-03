package com.ssafy.back_footp.controller;

import java.text.ParseException;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.config.authentication.UserServiceBeanDefinitionParser;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.ssafy.back_footp.entity.Mail;
import com.ssafy.back_footp.entity.User;
import com.ssafy.back_footp.jwt.JwtService;
import com.ssafy.back_footp.repository.UserRepository;
import com.ssafy.back_footp.request.UserSignUpReq;
import com.ssafy.back_footp.security.EncryptionUtils;
import com.ssafy.back_footp.service.MailService;
import com.ssafy.back_footp.service.AuthService;

import io.swagger.annotations.ApiOperation;
import io.swagger.annotations.ApiParam;
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
	JwtService jwtService;

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
			// 이미 등록된 이메일이 아니라면
			if (!authService.emailCheck(userEntity.getUserEmail())) {
				System.out.println(userEntity);
				authService.createUser(userEntity);
				String token = jwtService.create("user_id", user.getUserId(), "Authorization");
				result.put("Authorization", token);
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

	@PostMapping("/signin")
	@ApiOperation(value = "로그인")
	public ResponseEntity<Map<String, Object>> signIn(
			@RequestBody @ApiParam(value = "이메일, 비밀번호로 로그인", required = true) User user) throws Exception {
		Map<String, Object> result = new HashMap<>();

		HttpStatus status = null;
		try {
			User loginUser = authService.login(user.getUserEmail(), user.getUserPassword());

			if (loginUser != null) {
				String token = jwtService.create("userid", loginUser.getUserId(), "Authorization");

				logger.debug("로그인 토큰 : {}", token);
				result.put("Authorization", token);
				result.put("message", SUCCESS);
				status = HttpStatus.ACCEPTED;
			} else {
				result.put("message", FAIL);
				status = HttpStatus.ACCEPTED;
			}
		} catch (Exception e) {
			// TODO: handle exception
			logger.error("로그인 에러 : {}", e);
			result.put("message", e.getMessage());
			status = HttpStatus.INTERNAL_SERVER_ERROR;
		}

		return new ResponseEntity<Map<String, Object>>(result, status);
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

	@PostMapping("/email/{email}")
	@ApiOperation(value = "해당 이메일의 회원 정보가 있으면 인증메일을 보냄(가입용)")
	public ResponseEntity<Integer> codeMailSend(@PathVariable String email) {

		int result = 1;

		User user = userRepository.findByUserEmail(email).get();

		// 이미 인증된 계정이거나, 존재하지 않는 계정이면 패스
		if (authService.emailCheck(email) && !user.getUserEmailKey().equals("Y")) {

			Mail mail = authService.sendEmailServiceForSignUp(email, "회원");
			System.out.println("메일이 잘 보내지나요");
			mailService.mailSend(mail);
			System.out.println("메일이 잘 보내지네요");
		} else {
			result = 0;
		}

		return new ResponseEntity<Integer>(result, HttpStatus.OK);
	}

	@PostMapping("/success/{userId}/{code}")
	@ApiOperation(value = "회원가입 후 이메일 인증")
	public ResponseEntity<Boolean> codeCheck(@PathVariable String code, @PathVariable long userId) {
		boolean result = false;
		User user = userRepository.findByUserId(userId);

		// 코드가 일치하고, 3분 기한 내에 입력하였을 경우
		if (user.getUserEmailKey().equals(code) && user.getUserPwfindtime().isAfter(LocalDateTime.now())) {
			user.setUserEmailKey("Y");

			userRepository.save(user);
			result = true;
		}

		return new ResponseEntity<Boolean>(result, HttpStatus.OK);
	}

	@PostMapping("/emailPW/{email}")
	@ApiOperation(value = "비밀번호 재설정 용 이메일 인증코드")
	public ResponseEntity<Integer> passwordMailSend(@PathVariable String email) {
		int result = 1;

		if (userRepository.existsByUserEmail(email)) {
			User user = userRepository.findByUserEmail(email).get();

			// 이미 인증된 계정이거나, 존재하지 않는 계정이면 패스
			if (authService.emailCheck(email)) {

				Mail mail = authService.sendEmailServiceForPassword(email, user.getUserNickname());
				System.out.println("메일이 잘 보내지나요");
				mailService.mailSend(mail);
				System.out.println("메일이 잘 보내지네요");
			} else {
				result = 0;
			}
		}

		return new ResponseEntity<Integer>(result, HttpStatus.OK);
	}

	@PostMapping("/validate/{userId}/{code}")
	@ApiOperation(value = "재설정 목적의 이메일 코드 인증")
	public ResponseEntity<Boolean> codeCheckPassword(@PathVariable String code, @PathVariable long userId) {
		boolean result = false;
		User user = userRepository.findByUserId(userId);

		// 코드가 일치하고, 3분 기한 내에 입력하였을 경우
		if (user.getUserPwfindkey().equals(code) && user.getUserPwfindtime().isAfter(LocalDateTime.now())) {
			result = true;
		}

		return new ResponseEntity<Boolean>(result, HttpStatus.OK);
	}

	@PostMapping("/lostPW/{userId}/{password}")
	@ApiOperation(value = "재설정 목적의 이메일 코드 인증 후 비밀번호 재설정")
	public ResponseEntity<Integer> resetPassword(@PathVariable long userId, @PathVariable String password) {
		int result = 0;

		User user = userRepository.findByUserId(userId);

		// 코드가 일치하고, 3분 기한 내에 입력하였을 경우
		try {
			user.setUserPassword(EncryptionUtils.encryptSHA256(password));
			userRepository.save(user);

			result = 1;
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}

		return new ResponseEntity<Integer>(result, HttpStatus.OK);
	}

}
