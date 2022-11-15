package com.ssafy.back_footp.service;

import com.ssafy.back_footp.entity.User;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ssafy.back_footp.entity.Mail;
import com.ssafy.back_footp.repository.UserRepository;
import com.ssafy.back_footp.security.EncryptionUtils;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.Date;
import java.util.Optional;

@Slf4j
@Service
@RequiredArgsConstructor
public class AuthService {
	@Autowired
	UserRepository userRepository;

	@Transactional
	public int createUser(User user) {

		int result = 1;
		User temp = user;
		try {
			userRepository.save(temp);
		} catch (Exception e) {
			e.printStackTrace();
			result = 0;
		}

		return result;
	}

	@Transactional
	public int modifyNickname(long uid, String nick) {

		if (userRepository.existsById(uid)) {
			User user = userRepository.findByUserId(uid);

			if (StringUtils.isNotBlank(nick) && nickCheck(nick)) {
				user.setUserNickname(nick);
			}

			userRepository.save(user);

			return 1;
		} else {
			return 0;
		}
	}

	// 로그인 (입력받은 비밀번호를 암호화하여 DB와 비교)
	public User login(String email, String password) {
		return userRepository.findByUserEmailAndUserPassword(email, EncryptionUtils.encryptSHA256(password));
	}

	public boolean emailCheck(String email) {
		return userRepository.existsByUserEmail(email);
	}

	public boolean nickCheck(String Nickname) {
		return userRepository.existsByUserNickname(Nickname);
	}

	// 인증 시 랜덤으로 코드 생성해주는 함수
	public String getRandomCode() {
		char[] charSet = new char[] { '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F',
				'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z' };

		String str = "";

		int idx = 0;
		for (int i = 0; i < 10; i++) {
			idx = (int) (charSet.length * Math.random());
			str += charSet[idx];
		}
		return str;
	}

	@Transactional
	public User resetPassword(String str, long userId) {

		User user = userRepository.findByUserId(userId);

		user.setUserPassword(EncryptionUtils.encryptSHA256(str));

		userRepository.save(user);

		return user;
	}

	public Mail sendEmailServiceForSignUp(String email, String name) {

		Optional<User> user = userRepository.findByUserEmail(email);

		if (user.isPresent()) {
			User temp = user.get();
			
			String str = getRandomCode();
			Mail mail = new Mail();

			mail.setAddress(email);
			mail.setTitle(name+" 님의 회원가입 안내 인증코드 입니다.");
			mail.setContent("안녕하세요. 푸프 회원가입 인증을 위한 인증번호 입니다. | "+ str +" | 시간내로 입력하여 주시기 바랍니다.");

			//여기서 재발급 키담고 + 제한시간3분 설정
			temp.setUserEmailKey(str);
			temp.setUserPwfindtime(LocalDateTime.now().plusMinutes(3));
			
			userRepository.save(temp);
			
			return mail;

		}
		
		return null;
	}
	
	public Mail sendEmailServiceForPassword(String email, String name) {

		Optional<User> user = userRepository.findByUserEmail(email);

		if (user.isPresent()) {
			User temp = user.get();
			
			String str = getRandomCode();
			Mail mail = new Mail();

			mail.setAddress(email);
			mail.setTitle(name+" 님의 비밀번호 재발급 안내 인증코드 입니다.");
			mail.setContent("안녕하세요. 푸프 비밀번호 재발급을 위한 인증번호 입니다. | "+ str +" | 시간내로 입력하여 주시기 바랍니다.");

			//여기서 재발급 키담고 + 제한시간3분 설정
			temp.setUserPwfindkey(str);
			temp.setUserPwfindtime(LocalDateTime.now().plusMinutes(3));
			
			userRepository.save(temp);
			
			return mail;

		}
		
		return null;
	}

	public User getUser(long userid) {
		// TODO Auto-generated method stub
		return userRepository.findByUserId(userid);
	}
	
	public void KeepLogin(long uid, String sessionId, LocalDateTime next) {
		userRepository.keepLogin(uid, sessionId, next);
	}
	
	public User checkUserWithSessionKey(String sessionId) {
		return userRepository.checkUserWithSessionKey(sessionId);
	}

}
