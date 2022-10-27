package com.ssafy.back_footp.service;

import com.ssafy.back_footp.entity.Message;
import com.ssafy.back_footp.repository.EventRepository;
import com.ssafy.back_footp.repository.UserRepository;
import com.ssafy.back_footp.request.MessagePostReq;
import org.json.simple.JSONObject;
import org.locationtech.jts.io.ParseException;
import org.locationtech.jts.io.WKTReader;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ssafy.back_footp.repository.MessageRepository;
import com.ssafy.back_footp.response.messagelistDTO;
import com.ssafy.back_footp.response.eventlistDTO;
import org.locationtech.jts.geom.Point;


import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
public class MessageService {
	@Autowired
	MessageRepository messageRepository;
	@Autowired
	EventRepository eventRepository;
	@Autowired
	UserRepository userRepository;

	@Transactional
	public JSONObject getMessageList(int page) {
		List<messagelistDTO> messagelist = new ArrayList<>();
		messageRepository.findAll().forEach(Message->messagelist.add(new messagelistDTO()));

		List<eventlistDTO> eventlist = new ArrayList<>();
		eventRepository.findAll().forEach(Event->eventlist.add(new eventlistDTO()));

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
		message.setMessagePoint((Point) new WKTReader().read(messageInfo.getMessagePoint()));
		message.setOpentoall(messageInfo.getIsOpentoall());
		message.setMessageLikenum(message.getMessageLikenum());
		message.setMessageSpamnum(message.getMessageSpamnum());
		message.setMessageWritedate(LocalDateTime.now().plusHours(9));

		messageRepository.save(message);

		return "success";
	}

}
