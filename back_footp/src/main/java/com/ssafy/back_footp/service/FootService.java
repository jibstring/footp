package com.ssafy.back_footp.service;

import com.ssafy.back_footp.entity.Message;
import com.ssafy.back_footp.repository.EventRepository;
import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ssafy.back_footp.repository.MessageRepository;
import com.ssafy.back_footp.response.messagelistDTO;
import com.ssafy.back_footp.response.eventlistDTO;


import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
public class FootService {
	@Autowired
	MessageRepository messageRepository;
	@Autowired
	EventRepository eventRepository;

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
/*
	@Transactional
	public String createMessage(MessagePostReq messageInfo) {
		Message message = new Message();

		message.setUserId();


		messageRepository.save(message);

		return "success";
	}

 */
}
