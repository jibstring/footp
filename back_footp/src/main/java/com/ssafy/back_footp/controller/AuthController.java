package com.ssafy.back_footp.controller;

import java.text.ParseException;
import java.time.LocalDateTime;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.config.authentication.UserServiceBeanDefinitionParser;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.util.WebUtils;

import com.ssafy.back_footp.entity.Mail;
import com.ssafy.back_footp.entity.User;
import com.ssafy.back_footp.jwt.JwtService;
import com.ssafy.back_footp.repository.UserRepository;
import com.ssafy.back_footp.request.UserSignInReq;
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

		User userEntity = User.builder().userEmail(user.getUserEmail()).userNickname(user.getUserNickname())
				.userPassword(EncryptionUtils.encryptSHA256(user.getUserPassword())).userCash(0).userEmailKey("N")
				.userIsplaying((long)-1).userStampclearnum(0).userStampcreatenum(0).userNickname(user.getUserNickname())
				.userAutologin(false).userSessionkey("none")
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
			@RequestBody @ApiParam(value = "이메일, 비밀번호로 로그인", required = true) UserSignInReq user, HttpSession session, HttpServletResponse response) throws Exception {
		Map<String, Object> result = new HashMap<>();

		HttpStatus status = null;
		try {
			User loginUser = authService.login(user.getUserEmail(), user.getUserPassword());

			if (loginUser != null) {
				session.setAttribute("login", loginUser);
				String token = jwtService.create("userid", loginUser.getUserId(), "Authorization");

				logger.debug("로그인 토큰 : {}", token);
				result.put("Authorization", token);
				result.put("message", SUCCESS);
				status = HttpStatus.ACCEPTED;
				
				if(loginUser.getUserAutologin()) {
					
					Cookie cookie = new Cookie( "loginCookie", session.getId());
					cookie.setPath("/");
					cookie.setMaxAge(60*60*24*30);
					
					response.addCookie(cookie);
					
					Date sessionLimit = new Date(System.currentTimeMillis() + (1000*60*60*24*30));
					authService.KeepLogin(loginUser.getUserId(), session.getId(), sessionLimit);
				}
				
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
	
	@GetMapping("/valid")
	@ApiOperation(value = "토큰 유효성 검사")
	public ResponseEntity<Map<String, Object>> tokenValidation(HttpServletRequest request) {
		logger.info("tokenValidation");
		Map<String, Object> result = new HashMap<>();
		if (jwtService.isUsable(request.getHeader("Authorization"))) {
			result.put("message", SUCCESS);
		} else {
			result.put("Authorization", null);
			result.put("message", FAIL);
		}
		return new ResponseEntity<Map<String, Object>>(result, HttpStatus.OK);
	}

	
	@GetMapping("/logout")
	@ApiOperation(value = "회원 로그아웃")
	public ResponseEntity<Map<String, Object>> logout(HttpServletRequest request, HttpSession session, HttpServletResponse response) throws Exception {

		logger.debug("logout - 호출");
		Map<String, Object> result = new HashMap<>();

		if (jwtService.isUsable(request.getHeader("Authorization"))) {
			
			Object obj = session.getAttribute("login");
			User user = (User)obj;
			result.put("Authorization", null);
			result.put("message", SUCCESS);
			session.removeAttribute("login");
			session.invalidate();
			
			Cookie loginCookie = WebUtils.getCookie(request, "loginCookie");
			if( loginCookie !=null) {
				loginCookie.setPath("/");
				loginCookie.setMaxAge(0);
				response.addCookie(loginCookie);
				
				Date date = new Date(System.currentTimeMillis());
				authService.KeepLogin(user.getUserId(), session.getId(), date);
			}
		} else {
			result.put("message", FAIL);
		}

		return new ResponseEntity<Map<String, Object>>(result, HttpStatus.OK);

	}

	@PostMapping("/info/{userid}")
	@ApiOperation(value = "유저 본인의 정보를 불러온다", notes = "보려는 정보가 본인의 것이면 정보를 반환한다")
	public ResponseEntity<Map<String, Object>> getUserInfo(@PathVariable("userid") int userid,
			@ApiParam(value = "인증할 회원의 아이디.", required = true) HttpServletRequest request) {
		// logger.debug("userid : {} ", userid);
		Map<String, Object> result = new HashMap<>();
		HttpStatus status = HttpStatus.ACCEPTED;
//		System.out.println(userid);

		// 유효한 토큰에 자기 정보 요청 맞을경우
		try {
			// 로그인 사용자 정보.
			User userInfo = authService.getUser(userid);
			result.put("userInfo", userInfo);
			result.put("message", SUCCESS);
			status = HttpStatus.ACCEPTED;
		} catch (Exception e) {
			logger.error("정보조회 실패 : {}", e);
			result.put("message", e.getMessage());
			status = HttpStatus.ACCEPTED;
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

			Mail mail = authService.sendEmailServiceForSignUp(email, user.getUserNickname());
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
