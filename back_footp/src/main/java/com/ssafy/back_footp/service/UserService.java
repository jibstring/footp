package com.ssafy.back_footp.service;

import com.ssafy.back_footp.entity.Message;
import com.ssafy.back_footp.entity.User;
import com.ssafy.back_footp.repository.*;
import com.ssafy.back_footp.request.MypostUpdateReq;
import com.ssafy.back_footp.request.NicknameUpdateReq;
import com.ssafy.back_footp.request.PasswordUpdateReq;
import com.ssafy.back_footp.response.gatherlistDTO;
import com.ssafy.back_footp.response.messagelistDTO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
public class UserService {
    @Autowired
    MessageRepository messageRepository;
    @Autowired
    MessageLikeRepository messageLikeRepository;
    @Autowired
    GatherRepository gatherRepository;
    @Autowired
    GatherLikeRepository gatherLikeRepository;
    @Autowired
    UserRepository userRepository;

    @Transactional
    public JSONObject getMymessages(long userId) {
        List<messagelistDTO> messagelist = new ArrayList<>();
        messageRepository.findAllByUserId(userRepository.findById(userId).get()).forEach(Message->
//				System.out.println(messageLikeRepository.findByMessageIdAndUserId(Message, Message.getUserId()))
                        messagelist.add(new messagelistDTO(
                                Message.getMessageId(),
                                Message.getUserId().getUserNickname(),
                                Message.getMessageText(),
                                Message.getMessageBlurredtext(),
                                Message.getMessageFileurl(),
                                Message.getMessagePoint().getX(),
                                Message.getMessagePoint().getY(),
                                Message.isOpentoall(),
                                Message.isBlurred(),
                                messageLikeRepository.findByMessageIdAndUserId(Message, userRepository.findById(userId).get()) != null,
                                Message.getMessageLikenum(),
                                Message.getMessageSpamnum(),
                                Message.getMessageWritedate().format(DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm"))))
        );

        List<gatherlistDTO> gatherlist = new ArrayList<>();
        gatherRepository.findAllByUserId(userRepository.findById(userId).get()).forEach(Gather->gatherlist.add(new gatherlistDTO(
                Gather.getGatherId(),
                Gather.getUserId().getUserNickname(),
                Gather.getGatherText(),
                Gather.getGatherFileurl(),
                Gather.getGatherWritedate().format(DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm")),
                Gather.getGatherFinishdate().format(DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm")),
                Gather.getGatherPoint().getX(),
                Gather.getGatherPoint().getY(),
                Gather.getGatherLikenum(),
                Gather.getGatherSpamnum(),
                Gather.getGatherDesigncode()
        )));

        JSONObject jsonObject = new JSONObject();
        jsonObject.put("message", messagelist);
        jsonObject.put("gather", gatherlist);

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
