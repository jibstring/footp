package com.ssafy.back_footp.service;

import java.text.ParseException;
import java.time.LocalDateTime;

import javax.transaction.Transactional;

import org.locationtech.jts.geom.Coordinate;
import org.locationtech.jts.geom.GeometryFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ssafy.back_footp.entity.Event;
import com.ssafy.back_footp.repository.EventLikeRepository;
import com.ssafy.back_footp.repository.EventRepository;
import com.ssafy.back_footp.repository.UserRepository;
import com.ssafy.back_footp.request.EventPostReq;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@RequiredArgsConstructor
public class EventService {

	@Autowired
	EventRepository eventRepository;
	@Autowired
	EventLikeRepository eventLikeRepository;
	@Autowired
	UserRepository userRepository;
	
	GeometryFactory gf = new GeometryFactory();
	
	
	@Transactional
	public String createEvent(EventPostReq eventInfo) throws ParseException{
		Event savedEvent = new Event();
		
		savedEvent.setUserId(userRepository.findById(eventInfo.getUserId()).get());
		savedEvent.setEventText(eventInfo.getEventText());
		savedEvent.setEventFileurl(eventInfo.getEventFileurl());
		savedEvent.setEventPoint(gf.createPoint(new Coordinate(eventInfo.getEventLongitude(), eventInfo.getEventLatitude())));
		savedEvent.setEventLikenum(eventInfo.getEventLikenum());
		savedEvent.setEventSpamnum(eventInfo.getEventSpamnum());
		savedEvent.setEventWritedate(LocalDateTime.now());
		savedEvent.setEventFinishdate(LocalDateTime.now().plusHours(48));
		savedEvent.setQuiz(eventInfo.isQuiz());
		savedEvent.setEventQuestion(eventInfo.getEventQuestion());
		savedEvent.setEventAnswer(eventInfo.getEventAnswer());
		savedEvent.setEventExplain(eventInfo.getEventExplain());
		savedEvent.setEventExplainurl(eventInfo.getEventExplainurl());
		
		eventRepository.save(savedEvent);
		System.out.println("event saved");
		
		return "success";
	}
	
}
