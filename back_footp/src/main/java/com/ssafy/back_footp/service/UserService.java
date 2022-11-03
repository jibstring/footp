package com.ssafy.back_footp.service;

import com.ssafy.back_footp.entity.Mail;
import com.ssafy.back_footp.entity.Message;
import com.ssafy.back_footp.entity.User;
import com.ssafy.back_footp.repository.*;
import com.ssafy.back_footp.request.MypostUpdateReq;
import com.ssafy.back_footp.request.NicknameUpdateReq;
import com.ssafy.back_footp.request.PasswordUpdateReq;
import com.ssafy.back_footp.response.eventlistDTO;
import com.ssafy.back_footp.response.messagelistDTO;
import com.ssafy.back_footp.security.EncryptionUtils;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Slf4j
@Service
@RequiredArgsConstructor
public class UserService {
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

}
