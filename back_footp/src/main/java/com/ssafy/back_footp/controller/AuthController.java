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
import javax.transaction.Transactional;

import com.ssafy.back_footp.request.KakaoLoginReq;
import com.ssafy.back_footp.response.KakaoLoginResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
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
import com.ssafy.back_footp.repository.ChatBlockRepository;
import com.ssafy.back_footp.repository.GatherLikeRepository;
import com.ssafy.back_footp.repository.GatherRepository;
import com.ssafy.back_footp.repository.GatherSpamRepository;
import com.ssafy.back_footp.repository.MessageLikeRepository;
import com.ssafy.back_footp.repository.MessageRepository;
import com.ssafy.back_footp.repository.MessageSpamRepository;
import com.ssafy.back_footp.repository.StampboardLikeRepository;
import com.ssafy.back_footp.repository.StampboardRepository;
import com.ssafy.back_footp.repository.StampboardSpamRepository;
import com.ssafy.back_footp.repository.UserJoinedGatherRepository;
import com.ssafy.back_footp.repository.UserJoinedStampboardRepository;
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
	
	@Autowired
	MessageLikeRepository messageLikeRepository;
	@Autowired
	MessageSpamRepository messageSpamRepository;
	@Autowired
	StampboardLikeRepository stampboardLikeRepository;
	@Autowired
	StampboardSpamRepository stampboardSpamRepository;
	@Autowired
	GatherLikeRepository gatherLikeRepository;
	@Autowired
	GatherSpamRepository gatherSpamRepository;
	@Autowired
	ChatBlockRepository chatBlockRepository;
	@Autowired
	UserJoinedGatherRepository userJoinedGatherRepository;
	@Autowired
	UserJoinedStampboardRepository userJoinedStampboardRepository;
	@Autowired
	StampboardRepository stampboardRepository;
	@Autowired
	MessageRepository messageRepository;
	@Autowired
	GatherRepository gatherRepository;
	
	

	@PostMapping("/signup")
	@ApiOperation(value = "?????? ??????")
	public ResponseEntity<Map<String, Object>> signUp(@RequestBody UserSignUpReq user) throws ParseException {

		Map<String, Object> result = new HashMap<>();

		User userEntity = User.builder().userEmail(user.getUserEmail()).userNickname(user.getUserNickname())
				.userPassword(EncryptionUtils.encryptSHA256(user.getUserPassword())).userCash(0).userEmailKey("N")
				.userIsplaying((long) -1).userStampclearnum(0).userStampcreatenum(0)
				.userNickname(user.getUserNickname()).userAutologin(false).userSessionkey("none").build();

		try {
			// ?????? ????????? ???????????? ????????????
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
	@ApiOperation(value = "?????????")
	public ResponseEntity<Map<String, Object>> signIn(
			@RequestBody @ApiParam(value = "?????????, ??????????????? ?????????", required = true) UserSignInReq user, HttpSession session,
			HttpServletResponse response) throws Exception {
		Map<String, Object> result = new HashMap<>();

		HttpStatus status = null;
		try {
			User loginUser = authService.login(user.getUserEmail(), user.getUserPassword());

			if (loginUser != null) {
				session.setAttribute("login", loginUser);
				String token = jwtService.create("userid", loginUser.getUserId(), "Authorization");

				logger.debug("????????? ?????? : {}", token);
				result.put("Authorization", token);
				result.put("message", SUCCESS);
				status = HttpStatus.ACCEPTED;

				if (user.getUserAutologin()) {

					Cookie cookie = new Cookie("loginCookie", session.getId());
					cookie.setPath("/");
					cookie.setMaxAge(60 * 60 * 24 * 30);

					response.addCookie(cookie);

					LocalDateTime sessionLimit = LocalDateTime.now().plusSeconds(60 * 60 * 24 * 30);
					System.out.println(loginUser.getUserId() + " " + session.getId() + " " + sessionLimit);
					authService.KeepLogin(loginUser.getUserId(), session.getId(), sessionLimit);

					loginUser.setUserAutologin(true);

					userRepository.save(loginUser);
				}

			} else {
				result.put("message", FAIL);
				status = HttpStatus.ACCEPTED;
			}
		} catch (Exception e) {
			// TODO: handle exception
			logger.error("????????? ?????? : {}", e);
			result.put("message", e.getMessage());
			status = HttpStatus.INTERNAL_SERVER_ERROR;
		}

		return new ResponseEntity<Map<String, Object>>(result, status);
	}

	@GetMapping("/valid")
	@ApiOperation(value = "?????? ????????? ??????")
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
	@ApiOperation(value = "?????? ????????????")
	public ResponseEntity<Map<String, Object>> logout(HttpServletRequest request, HttpSession session,
			HttpServletResponse response) throws Exception {

		logger.debug("logout - ??????");
		Map<String, Object> result = new HashMap<>();

		if (jwtService.isUsable(request.getHeader("Authorization"))) {

			Object obj = session.getAttribute("login");
			User user = (User) obj;
			result.put("Authorization", null);
			result.put("message", SUCCESS);
//			session.removeAttribute("login");
//			session.invalidate();

//			Cookie loginCookie = WebUtils.getCookie(request, "loginCookie");
//			if( loginCookie !=null) {
//				loginCookie.setPath("/");
//				loginCookie.setMaxAge(0);
//				response.addCookie(loginCookie);
//				
//				LocalDateTime date = LocalDateTime.now();
//				authService.KeepLogin(user.getUserId(), session.getId(), date);
//			}
		} else {
			result.put("message", FAIL);
		}

		return new ResponseEntity<Map<String, Object>>(result, HttpStatus.OK);

	}

	@PostMapping("/info/{userid}")
	@ApiOperation(value = "?????? ????????? ????????? ????????????", notes = "????????? ????????? ????????? ????????? ????????? ????????????")
	public ResponseEntity<Map<String, Object>> getUserInfo(@PathVariable("userid") int userid,
			@ApiParam(value = "????????? ????????? ?????????.", required = true) HttpServletRequest request) {
		// logger.debug("userid : {} ", userid);
		Map<String, Object> result = new HashMap<>();
		HttpStatus status = HttpStatus.ACCEPTED;
//		System.out.println(userid);

		// ????????? ????????? ?????? ?????? ?????? ????????????
		try {
			// ????????? ????????? ??????.
			User userInfo = authService.getUser(userid);
			result.put("userInfo", userInfo);
			result.put("message", SUCCESS);
			status = HttpStatus.ACCEPTED;
		} catch (Exception e) {
			logger.error("???????????? ?????? : {}", e);
			result.put("message", e.getMessage());
			status = HttpStatus.ACCEPTED;
		}

		return new ResponseEntity<Map<String, Object>>(result, status);
	}

	@PostMapping("/duplicate/{email}")
	@ApiOperation(value = "????????? ?????? ??????")
	public ResponseEntity<Boolean> checkEmail(@PathVariable String email) {

		boolean check = authService.emailCheck(email);

		return new ResponseEntity<Boolean>(check, HttpStatus.OK);

	}

	@PostMapping("/nickname/{nickname}")
	@ApiOperation(value = "????????? ?????? ??????")
	public ResponseEntity<Boolean> checkNick(@PathVariable String nickname) {

		boolean check = authService.nickCheck(nickname);

		return new ResponseEntity<Boolean>(check, HttpStatus.OK);

	}

	@PostMapping("/email/{email}")
	@ApiOperation(value = "?????? ???????????? ?????? ????????? ????????? ??????????????? ??????(?????????)")
	public ResponseEntity<Integer> codeMailSend(@PathVariable String email) {

		int result = 1;

		User user = userRepository.findByUserEmail(email).get();

		// ?????? ????????? ???????????????, ???????????? ?????? ???????????? ??????
		if (authService.emailCheck(email) && !user.getUserEmailKey().equals("Y")) {

			Mail mail = authService.sendEmailServiceForSignUp(email, user.getUserNickname());
			System.out.println("????????? ??? ???????????????");
			mailService.mailSend(mail);
			System.out.println("????????? ??? ???????????????");
		} else {
			result = 0;
		}

		return new ResponseEntity<Integer>(result, HttpStatus.OK);
	}

	@PostMapping("/success/{userId}/{code}")
	@ApiOperation(value = "???????????? ??? ????????? ??????")
	public ResponseEntity<Boolean> codeCheck(@PathVariable String code, @PathVariable long userId) {
		boolean result = false;
		User user = userRepository.findByUserId(userId);

		// ????????? ????????????, 3??? ?????? ?????? ??????????????? ??????
		if (user.getUserEmailKey().equals(code) && user.getUserPwfindtime().isAfter(LocalDateTime.now())) {
			user.setUserEmailKey("Y");

			userRepository.save(user);
			result = true;
		}

		return new ResponseEntity<Boolean>(result, HttpStatus.OK);
	}

	@PostMapping("/emailPW/{email}")
	@ApiOperation(value = "???????????? ????????? ??? ????????? ????????????")
	public ResponseEntity<Integer> passwordMailSend(@PathVariable String email) {
		int result = 1;

		if (userRepository.existsByUserEmail(email)) {
			User user = userRepository.findByUserEmail(email).get();

			// ?????? ????????? ???????????????, ???????????? ?????? ???????????? ??????
			if (authService.emailCheck(email)) {

				Mail mail = authService.sendEmailServiceForPassword(email, user.getUserNickname());
				System.out.println("????????? ??? ???????????????");
				mailService.mailSend(mail);
				System.out.println("????????? ??? ???????????????");
			} else {
				result = 0;
			}
		}

		return new ResponseEntity<Integer>(result, HttpStatus.OK);
	}

	@PostMapping("/validate/{userId}/{code}")
	@ApiOperation(value = "????????? ????????? ????????? ?????? ??????")
	public ResponseEntity<Boolean> codeCheckPassword(@PathVariable String code, @PathVariable long userId) {
		boolean result = false;
		User user = userRepository.findByUserId(userId);

		// ????????? ????????????, 3??? ?????? ?????? ??????????????? ??????
		if (user.getUserPwfindkey().equals(code) && user.getUserPwfindtime().isAfter(LocalDateTime.now())) {
			result = true;
		}

		return new ResponseEntity<Boolean>(result, HttpStatus.OK);
	}

	@PostMapping("/lostPW/{userId}/{password}")
	@ApiOperation(value = "????????? ????????? ????????? ?????? ?????? ??? ???????????? ?????????")
	public ResponseEntity<Integer> resetPassword(@PathVariable long userId, @PathVariable String password) {
		int result = 0;

		User user = userRepository.findByUserId(userId);

		// ????????? ????????????, 3??? ?????? ?????? ??????????????? ??????
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

	// kakao ?????? ?????????
	@ApiOperation(value = "Kakao ?????????")
	@PostMapping(value = "/kakao")
	public ResponseEntity<Map<String, Object>> kakaoAuthRequest(@RequestBody KakaoLoginReq kakaoLoginReq,
			HttpSession session, HttpServletResponse response) {
		Map<String, Object> result = new HashMap<>();
		HttpStatus status = null;

		try {
			KakaoLoginResponse kakaoLoginResponse = authService.kakaoLogin(kakaoLoginReq);

			result.put("Authorization", kakaoLoginResponse.getAppToken());
			result.put("message", SUCCESS);
			status = HttpStatus.ACCEPTED;

			User loginUser = kakaoLoginResponse.getUser();

			if (loginUser.getUserAutologin()) {

				Cookie cookie = new Cookie("loginCookie", session.getId());
				cookie.setPath("/");
				cookie.setMaxAge(60 * 60 * 24 * 30);

				response.addCookie(cookie);

				LocalDateTime sessionLimit = LocalDateTime.now().plusSeconds(60 * 60 * 24 * 30);
				authService.KeepLogin(loginUser.getUserId(), session.getId(), sessionLimit);
			}
		} catch (Exception e) {
			// TODO: handle exception
			logger.error("????????? ?????? : {}", e);
			result.put("message", e.getMessage());
			status = HttpStatus.INTERNAL_SERVER_ERROR;
		}

		return new ResponseEntity<Map<String, Object>>(result, status);
	}

	@PostMapping("/reset/{Password}/{userId}")
	@ApiOperation(value = "???????????? ????????? ??? ???????????? ??????????????? ???????????? ?????? ????????? ??????????????? ??????")
	public ResponseEntity<Boolean> checkMyPassword(@PathVariable String Password, @PathVariable long userId) {

		
		boolean result = false;
		if (userRepository.findById(userId).isPresent()) {
			User user = userRepository.findByUserId(userId);
			
			if (user.getUserPassword().equals(EncryptionUtils.encryptSHA256(Password))) {
				result = true;
			}
		}

		return new ResponseEntity<Boolean>(result, HttpStatus.OK);
	}
}
