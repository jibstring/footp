package com.ssafy.back_footp.service;

import java.text.ParseException;
import java.time.LocalDateTime;

import javax.transaction.Transactional;

import org.locationtech.jts.geom.Coordinate;
import org.locationtech.jts.geom.GeometryFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ssafy.back_footp.entity.Gather;
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
		Gather savedGather = new Gather();
		
		savedGather.setUserId(userRepository.findById(eventInfo.getUserId()).get());
		savedGather.setEventText(eventInfo.getEventText());
		savedGather.setEventFileurl(eventInfo.getEventFileurl());
		savedGather.setEventPoint(gf.createPoint(new Coordinate(eventInfo.getEventLongitude(), eventInfo.getEventLatitude())));
		savedGather.setEventLikenum(eventInfo.getEventLikenum());
		savedGather.setEventSpamnum(eventInfo.getEventSpamnum());
		savedGather.setEventWritedate(LocalDateTime.now());
		savedGather.setEventFinishdate(LocalDateTime.now().plusHours(48));
		savedGather.setQuiz(eventInfo.getIsQuiz());
		savedGather.setEventQuestion(eventInfo.getEventQuestion());
		savedGather.setEventAnswer(eventInfo.getEventAnswer());
		savedGather.setEventExplain(eventInfo.getEventExplain());
		savedGather.setEventExplainurl(eventInfo.getEventExplainurl());
		
		eventRepository.save(savedGather);
		System.out.println("event saved");
		
		return "success";
	}
	
}
