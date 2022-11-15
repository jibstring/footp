package com.ssafy.back_footp.service;

import com.ssafy.back_footp.entity.Gather;
import com.ssafy.back_footp.entity.Message;
import com.ssafy.back_footp.entity.Stampboard;
import com.ssafy.back_footp.entity.User;
import com.ssafy.back_footp.repository.*;
import com.ssafy.back_footp.request.MypostUpdateReq;
import com.ssafy.back_footp.request.NicknameUpdateReq;
import com.ssafy.back_footp.request.PasswordUpdateReq;
import com.ssafy.back_footp.response.gatherlistDTO;
import com.ssafy.back_footp.response.messagelistDTO;
import com.ssafy.back_footp.security.EncryptionUtils;

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
    MessageSpamRepository messageSpamRepository;
    @Autowired
    GatherRepository gatherRepository;
    @Autowired
    GatherLikeRepository gatherLikeRepository;
    @Autowired
    GatherSpamRepository gatherSpamRepository;
    @Autowired
    StampboardRepository stampboardRepository;
    @Autowired
    StampboardSpamRepository stampboardSpamRepository;
    @Autowired
    StampboardLikeRepository stampboardLikeRepository;
    @Autowired
    UserJoinedStampboardRepository userJoinedStampboardRepository;
    @Autowired
    UserJoinedGatherRepository userJoinedGatherRepository;
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
                                Message.getIsOpentoall(),
                                Message.getIsBlurred(),
                                messageLikeRepository.existsByMessageIdAndUserId(Message, userRepository.findById(userId).get()),
                                messageSpamRepository.existsByMessageIdAndUserId(Message, userRepository.findById(userId).get()),
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
                gatherLikeRepository.findByGatherIdAndUserId(Gather, userRepository.findById(userId).get()) != null,
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
        msg.setIsOpentoall(mypostUpdateReq.isType());
//        msg = Message.builder().isOpentoall((mypostUpdateReq.isType())).build();
        messageRepository.save(msg);

        return "success";
    }

    public String deleteMessage(long mid){
        Message message = messageRepository.findById(mid).get();
        if(stampboardRepository.existsByStampboardMessage1(message) || stampboardRepository.existsByStampboardMessage2(message) || stampboardRepository.existsByStampboardMessage3(message))
            return "fail";
        else
            messageRepository.delete(message);
        return "success";
    }

    public String updatePassword(PasswordUpdateReq passwordUpdateReq){
        User usr = userRepository.findById(passwordUpdateReq.getUserId()).get();
        
        //비밀번호 암호화해서 저장하기 
        usr.setUserPassword(EncryptionUtils.encryptSHA256(passwordUpdateReq.getUserPassword()));
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

    public String deleteUser(long uid){
        User usr = userRepository.findById(uid).get();

        // 스탬프 이용 내역 삭제
        stampboardSpamRepository.deleteAllByUserId(usr);
        stampboardLikeRepository.deleteAllByUserId(usr);
        userJoinedStampboardRepository.deleteAllByUserId(usr);

        // 이 유저가 작성한 스탬프를 서비스에서 삭제
        List<Stampboard> sblist = stampboardRepository.findAllByUserId(usr);
        for(Stampboard sb : sblist){
            stampboardSpamRepository.deleteAllByStampboardId(sb);
            stampboardLikeRepository.deleteAllByStampboardId(sb);
            userJoinedStampboardRepository.deleteAllByStampboardId(sb);
        }

        // 확성기 삭제
        gatherLikeRepository.deleteAllByUserId(usr);
        gatherSpamRepository.deleteAllByUserId(usr);
        gatherRepository.deleteAllByUserId(usr);
        userJoinedGatherRepository.deleteAllByUserId(usr);

        // 메세지 삭제
        messageLikeRepository.deleteAllByUserId(usr);
        messageSpamRepository.deleteAllByUserId(usr);
        messageRepository.deleteAllByUserId(usr);

        // 유저 삭제
        userRepository.deleteByUserId(usr);

        return "success";
    }

    public String deleteGather(long gid) {
        Gather gather = gatherRepository.findById(gid).get();

        gatherLikeRepository.deleteAllByGatherId(gather);
        gatherSpamRepository.deleteAllByGatherId(gather);
        userJoinedGatherRepository.deleteAllByGatherId(gather);

        gatherRepository.delete(gather);

        return "success";
    }
}
