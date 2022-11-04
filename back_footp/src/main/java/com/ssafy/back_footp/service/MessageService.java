package com.ssafy.back_footp.service;

import com.ssafy.back_footp.entity.Message;
import com.ssafy.back_footp.repository.*;
import com.ssafy.back_footp.request.MessagePostReq;
import org.json.simple.JSONObject;
import org.locationtech.jts.geom.Coordinate;
import org.locationtech.jts.geom.GeometryFactory;
import org.locationtech.jts.io.ParseException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ssafy.back_footp.response.messagelistDTO;
import com.ssafy.back_footp.response.gatherlistDTO;


import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
public class MessageService {
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

	GeometryFactory gf = new GeometryFactory();

	@Transactional
	public JSONObject getMessageList(long userId, double lon, double lat) {
		List<messagelistDTO> messagelist = new ArrayList<>();
		messageRepository.findAllInRadiusOrderByMessageWritedate(lon, lat).forEach(Message->
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

		List<gatherlistDTO> Gatherlist = new ArrayList<>();
		gatherRepository.findAllInRadiusOrderByGatherWritedate(lon, lat).forEach(Gather->Gatherlist.add(new gatherlistDTO(
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
		jsonObject.put("gather", Gatherlist);

		return jsonObject;
	}

	@Transactional
	public String createMessage(MessagePostReq messageInfo) throws ParseException {
		Message message = new Message();

		message.setUserId(userRepository.findById(messageInfo.getUserId()).get());
		message.setMessageText(messageInfo.getMessageText());
		message.setMessageBlurredtext(messageInfo.getMessageBlurredtext());
		message.setMessageFileurl(messageInfo.getMessageFileurl());
//		message.setMessagePoint((Point) new WKTReader().read(String.format("POINT(%s %s)", messageInfo.getMessageLongitude(), messageInfo.getMessageLatitude())));
		message.setMessagePoint(gf.createPoint(new Coordinate(messageInfo.getMessageLongitude(), messageInfo.getMessageLatitude())));
		message.setOpentoall(messageInfo.getIsOpentoall());
		message.setBlurred(messageInfo.getIsBlurred());
		message.setMessageLikenum(messageInfo.getMessageLikenum());
		message.setMessageSpamnum(messageInfo.getMessageSpamnum());
		message.setMessageWritedate(LocalDateTime.now());

		messageRepository.save(message);
		System.out.println("message saved");

		return "success";
	}

}
