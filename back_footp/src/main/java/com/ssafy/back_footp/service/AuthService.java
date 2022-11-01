package com.ssafy.back_footp.service;

import com.ssafy.back_footp.entity.Message;
import com.ssafy.back_footp.entity.User;
import com.ssafy.back_footp.repository.*;
import com.ssafy.back_footp.request.MypostUpdateReq;
import com.ssafy.back_footp.request.NicknameUpdateReq;
import com.ssafy.back_footp.request.PasswordUpdateReq;
import com.ssafy.back_footp.response.eventlistDTO;
import com.ssafy.back_footp.response.messagelistDTO;

import org.apache.commons.lang3.StringUtils;
import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ssafy.back_footp.entity.Mail;
import com.ssafy.back_footp.entity.User;
import com.ssafy.back_footp.repository.UserRepository;
import com.ssafy.back_footp.security.EncryptionUtils;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Slf4j
@Service
@RequiredArgsConstructor
public class AuthService {
    @Autowired
    MessageRepository messageRepository;
    @Autowired
    MessageLikeRepository messageLikeRepository;
    @Autowired
    EventRepository eventRepository;
    @Autowired
    EventLikeRepository eventLikeRepository;
    @Autowired
    UserRepository userRepository;
    @Autowired
    EventRankingRepository eventRankingRepository;

    @Transactional
    public JSONObject getMymessages(long userId) {
        List<messagelistDTO> messagelist = new ArrayList<>();
        messageRepository.findAllByUserId(userRepository.findById(userId).get()).forEach(Message->
//				System.out.println(messageLikeRepository.findByMessageIdAndUserId(Message, Message.getUserId()))
                        messagelist.add(new messagelistDTO(
                                Message.getMessageId(),
                                Message.getUserId().getUserNickname(),
                                Message.getMessageText(),
                                Message.getMessageFileurl(),
                                Message.getMessagePoint().getX(),
                                Message.getMessagePoint().getY(),
                                Message.isOpentoall(),
                                messageLikeRepository.findByMessageIdAndUserId(Message, userRepository.findById(userId).get()) != null,
                                Message.getMessageLikenum(),
                                Message.getMessageSpamnum(),
                                Message.getMessageWritedate().format(DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm"))))
        );

        List<eventlistDTO> eventlist = new ArrayList<>();
        eventRepository.findAllByUserId(userRepository.findById(userId).get()).forEach(Event->eventlist.add(new eventlistDTO(
                Event.getEventId(),
                Event.getUserId().getUserNickname(),
                Event.getEventText(),
                Event.getEventFileurl(),
                Event.getEventWritedate().format(DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm")),
                Event.getEventFinishdate().format(DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm")),
                Event.getEventPoint().getX(),
                Event.getEventPoint().getY(),
                Event.getEventLikenum(),
                Event.getEventSpamnum(),
                Event.isQuiz(),
                eventLikeRepository.findByEventIdAndUserId(Event, userRepository.findById(userId).get()) != null,
                Event.getEventQuestion(),
                Event.getEventAnswer(),
                Event.getEventExplain(),
                Event.getEventExplainurl(),
                eventRankingRepository.findByEventIdAndUserId(Event, userRepository.findById(userId).get()) != null
        )));

        JSONObject jsonObject = new JSONObject();
        jsonObject.put("message", messagelist);
        jsonObject.put("event", eventlist);

        return jsonObject;
    }

    public String updateMessage(MypostUpdateReq mypostUpdateReq){
        Message msg = messageRepository.findById(mypostUpdateReq.getMessageId()).get();
        msg.setOpentoall(mypostUpdateReq.isType());
//        msg = Message.builder().isOpentoall((mypostUpdateReq.isType())).build();
        messageRepository.save(msg);

        return "success";
    }

    public String deleteMessage(long mid){

        messageRepository.delete(messageRepository.findById(mid).get());

        return "success";
    }

    public String updatePassword(PasswordUpdateReq passwordUpdateReq){
        User usr = userRepository.findById(passwordUpdateReq.getUserId()).get();
        usr.setUserPassword(passwordUpdateReq.getUserPassword());
//        usr = User.builder().userPassword(passwordUpdateReq.getUserPassword()).build();
        userRepository.save(usr);

        return "success";
    }

    public String updateNickname(NicknameUpdateReq nicknameUpdateReq){
        User usr = userRepository.findById(nicknameUpdateReq.getUserId()).get();
        usr.setUserNickname(nicknameUpdateReq.getUserNickname());
//        usr = User.builder().userPassword(nicknameUpdateReq.getUserNickname()).build();
        userRepository.save(usr);

        return "success";
    }

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

	@Transactional
	public void deleteUser(long uid) {
		userRepository.deleteByUserId(uid);
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

}
