package com.ssafy.back_footp.service;

import com.amazonaws.services.s3.AmazonS3Client;
import com.amazonaws.services.s3.model.CannedAccessControlList;
import com.amazonaws.services.s3.model.ObjectMetadata;
import com.amazonaws.services.s3.model.PutObjectRequest;
import com.ssafy.back_footp.entity.Message;
import com.ssafy.back_footp.repository.*;
import com.ssafy.back_footp.request.MessagePostContent;
import com.ssafy.back_footp.request.MessagePostReq;
import com.ssafy.back_footp.response.gatherlistDTO;
import org.json.simple.JSONObject;
import org.locationtech.jts.geom.Coordinate;
import org.locationtech.jts.geom.GeometryFactory;
import org.locationtech.jts.io.ParseException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ssafy.back_footp.response.messagelistDTO;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@Slf4j
@Service
@RequiredArgsConstructor
public class MessageService {
	@Autowired
	private AmazonS3Client amazonS3Client;
	@Autowired
	MessageRepository messageRepository;
	@Autowired
	MessageLikeRepository messageLikeRepository;
	@Autowired
	MessageSpamRepository messageSpamRepository;
	@Autowired
	EventRepository eventRepository;
	@Autowired
	EventLikeRepository eventLikeRepository;
	@Autowired
	UserRepository userRepository;


	GeometryFactory gf = new GeometryFactory();

	@Transactional
	public JSONObject getMessageList(String sortstr, long userId, double lon_r, double lon_l, double lat_d, double lat_u) {
		List<messagelistDTO> messagelist = new ArrayList<>();

		List<Message> messages = new ArrayList<>();
		if(sortstr.equals("new"))
			messages = messageRepository.findAllInScreenOrderByMessageWritedate(lon_r, lon_l, lat_d, lat_u);
		else if(sortstr.equals("like"))
			messages = messageRepository.findAllInScreenOrderByMessageLikenum(lon_r, lon_l, lat_d, lat_u);
		else if(sortstr.equals("hot"))
			messages = messageRepository.findAllInScreenOrderByMessageLikenum(lon_r, lon_l, lat_d, lat_u);

		messages.forEach(Message->
				messagelist.add(new messagelistDTO(
				Message.getMessageId(),
				Message.getUserId().getUserNickname(),
				Message.getMessageText(),
				Message.getMessageFileurl(),
				Message.getMessagePoint().getX(),
				Message.getMessagePoint().getY(),
				Message.isOpentoall(),
				messageLikeRepository.existsByMessageIdAndUserId(Message, userRepository.findByUserId(userId)),
				messageSpamRepository.existsByMessageIdAndUserId(Message, userRepository.findById(userId).get()),
				Message.getMessageLikenum(),
				Message.getMessageSpamnum(),
				Message.getMessageWritedate().format(DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm"))))
		);

		JSONObject jsonObject = new JSONObject();
		jsonObject.put("message", messagelist);

		return jsonObject;
	}

	@Transactional
	public String createMessage(MessagePostReq messagePostReq) throws ParseException, IOException {
		Message message = new Message();

		// messege content
		MessagePostContent messageInfo = messagePostReq.getMessagePostContent();

		message.setUserId(userRepository.findById(messageInfo.getUserId()).get());
		message.setMessageText(messageInfo.getMessageText());
		message.setMessageBlurredtext(messageInfo.getMessageBlurredtext());
		message.setMessageFileurl("empty");
		message.setUserNickname(userRepository.findByUserId(messageInfo.getUserId()).getUserNickname());
		//System.out.println(userRepository.findByUserId(messageInfo.getUserId()).getUserNickname());
//		message.setMessagePoint((Point) new WKTReader().read(String.format("POINT(%s %s)", messageInfo.getMessageLongitude(), messageInfo.getMessageLatitude())));
		message.setMessagePoint(gf.createPoint(new Coordinate(messageInfo.getMessageLongitude(), messageInfo.getMessageLatitude())));
		message.setBlurred(messageInfo.getIsBlurred());
		message.setOpentoall(messageInfo.getIsOpentoall());
		message.setMessageLikenum(0);
		message.setMessageSpamnum(0);
		message.setMessageWritedate(LocalDateTime.now());

		// file upload
		if(messagePostReq.getMessageFile() != null){
			MultipartFile mfile = messagePostReq.getMessageFile();
			String originalName = UUID.randomUUID()+mfile.getOriginalFilename(); // 파일 이름
			long size = mfile.getSize(); // 파일 크기
			String S3Bucket = "footp-bucket"; // Bucket 이름
			ObjectMetadata objectMetaData = new ObjectMetadata();
			objectMetaData.setContentType(mfile.getContentType());
			objectMetaData.setContentLength(size);

			// S3에 업로드
			amazonS3Client.putObject(
					new PutObjectRequest(S3Bucket+"/message", originalName, mfile.getInputStream(), objectMetaData)
							.withCannedAcl(CannedAccessControlList.PublicRead)
			);

			String imagePath = amazonS3Client.getUrl(S3Bucket+"/message", originalName).toString(); // 접근가능한 URL 가져오기

			message.setMessageFileurl(imagePath);
		}

		// save
		messageRepository.save(message);
		System.out.println("message saved");

		return "success";
	}

}
