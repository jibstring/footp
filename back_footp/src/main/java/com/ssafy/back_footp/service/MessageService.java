package com.ssafy.back_footp.service;

import com.ssafy.back_footp.entity.Message;
import com.ssafy.back_footp.repository.*;
import com.ssafy.back_footp.request.MessagePostReq;
import org.json.simple.JSONObject;
import org.locationtech.jts.geom.Coordinate;
import org.locationtech.jts.geom.GeometryFactory;
import org.locationtech.jts.io.ParseException;
import org.locationtech.jts.io.WKTReader;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ssafy.back_footp.response.messagelistDTO;
import com.ssafy.back_footp.response.eventlistDTO;
import org.locationtech.jts.geom.Point;


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
	EventRepository eventRepository;
	@Autowired
	EventLikeRepository eventLikeRepository;
	@Autowired
	UserRepository userRepository;

	GeometryFactory gf = new GeometryFactory();

	@Transactional
	public JSONObject getMessageList(double lon, double lat) {
		List<messagelistDTO> messagelist = new ArrayList<>();
		messageRepository.findAll().forEach(Message->
//				System.out.println(messageLikeRepository.findByMessageIdAndUserId(Message, Message.getUserId()))
				messagelist.add(new messagelistDTO(
				Message.getMessageId(),
				Message.getUserId().getUserNickName(),
				Message.getMessageText(),
				Message.getMessageFileurl(),
				Message.getMessagePoint().getX(),
				Message.getMessagePoint().getY(),
				Message.isOpentoall(),
				messageLikeRepository.findByMessageIdAndUserId(Message, Message.getUserId())==null?false:true,
				Message.getMessageLikenum(),
				Message.getMessageSpamnum(),
				Message.getMessageWritedate().format(DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm"))))
		);

		List<eventlistDTO> eventlist = new ArrayList<>();
		eventRepository.findAll().forEach(Event->eventlist.add(new eventlistDTO(
				Event.getEventId(),
				Event.getUserId().getUserNickName(),
				Event.getEventText(),
				Event.getEventFileurl(),
				Event.getEventWritedate().format(DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm")),
				Event.getEventFinishdate().format(DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm")),
				Event.getEventPoint().getX(),
				Event.getEventPoint().getY(),
				Event.getEventLikenum(),
				Event.getEventSpamnum(),
				Event.isQuiz(),
				eventLikeRepository.findByEventIdAndUserId(Event.getEventId(), Event.getUserId().getUserId())==null?false:true,
				Event.getEventQuestion(),
				Event.getEventAnswer(),
				Event.getEventExplain(),
				Event.getEventExplainurl()
		)));

		JSONObject jsonObject = new JSONObject();
		jsonObject.put("message", messagelist);
		jsonObject.put("event", eventlist);

		return jsonObject;
	}

	@Transactional
	public String createMessage(MessagePostReq messageInfo) throws ParseException {
		Message message = new Message();

		message.setUserId(userRepository.findById(messageInfo.getUserId()).get());
		message.setMessageText(messageInfo.getMessageText());
		message.setMessageFileurl(messageInfo.getMessageFileurl());
//		message.setMessagePoint((Point) new WKTReader().read(String.format("POINT(%s %s)", messageInfo.getMessageLongitude(), messageInfo.getMessageLatitude())));
		message.setMessagePoint(gf.createPoint(new Coordinate(messageInfo.getMessageLongitude(), messageInfo.getMessageLatitude())));
		message.setOpentoall(messageInfo.getIsOpentoall());
		message.setMessageLikenum(message.getMessageLikenum());
		message.setMessageSpamnum(message.getMessageSpamnum());
		message.setMessageWritedate(LocalDateTime.now().plusHours(9));

		messageRepository.save(message);
		System.out.println("message saved");

		return "success";
	}

}
