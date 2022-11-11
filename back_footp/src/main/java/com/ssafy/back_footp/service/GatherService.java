package com.ssafy.back_footp.service;

import java.io.IOException;
import java.text.ParseException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import javax.transaction.Transactional;

import com.amazonaws.services.s3.AmazonS3Client;
import com.amazonaws.services.s3.model.CannedAccessControlList;
import com.amazonaws.services.s3.model.ObjectMetadata;
import com.amazonaws.services.s3.model.PutObjectRequest;
import com.ssafy.back_footp.entity.Gather;
import com.ssafy.back_footp.entity.UserJoinedGather;
import com.ssafy.back_footp.repository.UserJoinedGatherRepository;
import com.ssafy.back_footp.request.GatherPostContent;
import com.ssafy.back_footp.request.GatherPostReq;
import com.ssafy.back_footp.response.gatherlistDTO;
import org.json.simple.JSONObject;
import org.locationtech.jts.geom.Coordinate;
import org.locationtech.jts.geom.GeometryFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ssafy.back_footp.entity.Gather;
import com.ssafy.back_footp.repository.GatherLikeRepository;
import com.ssafy.back_footp.repository.GatherRepository;
import com.ssafy.back_footp.repository.UserRepository;
import com.ssafy.back_footp.request.GatherPostReq;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.multipart.MultipartFile;

@Slf4j
@Service
@RequiredArgsConstructor
public class GatherService {
	@Autowired
	private AmazonS3Client amazonS3Client;

	@Autowired
	GatherRepository gatherRepository;
	@Autowired
    GatherLikeRepository gatherLikeRepository;
	@Autowired
	UserRepository userRepository;
	@Autowired
	UserJoinedGatherRepository userJoinedGatherRepository;
	
	GeometryFactory gf = new GeometryFactory();

	@Transactional
	public JSONObject getGatherList(String sortstr, long userId, double lon_r, double lon_l, double lat_d, double lat_u) {
		List<gatherlistDTO> gatherlist = new ArrayList<>();

		List<Gather> gathers = new ArrayList<>();
		if(sortstr.equals("new"))
			gathers = gatherRepository.findAllInScreenOrderByGatherWritedate(lon_r, lon_l, lat_d, lat_u);
		else if(sortstr.equals("like"))
			gathers = gatherRepository.findAllInScreenOrderByGatherLikenum(lon_r, lon_l, lat_d, lat_u);
		else if(sortstr.equals("hot"))
			gathers = gatherRepository.findAllInScreenOrderByGatherLikenum(lon_r, lon_l, lat_d, lat_u);

		gathers.forEach(Gather->gatherlist.add(new gatherlistDTO(
				Gather.getGatherId(),
				Gather.getUserId().getUserNickname(),
				Gather.getGatherText(),
				Gather.getGatherFileurl(),
				Gather.getGatherWritedate().format(DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm")),
				Gather.getGatherFinishdate().format(DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm")),
				Gather.getGatherPoint().getX(),
				Gather.getGatherPoint().getY(),
				gatherLikeRepository.findByGatherIdAndUserId(Gather, Gather.getUserId()) != null,
				Gather.getGatherLikenum(),
				Gather.getGatherSpamnum(),
				Gather.getGatherDesigncode()
		)));

		JSONObject jsonObject = new JSONObject();
		jsonObject.put("gather", gatherlist);

		return jsonObject;
	}




	@Transactional
	public String createGather(GatherPostReq GatherPostReq) throws ParseException, IOException {
		Gather Gather = new Gather();

		// gather content
		GatherPostContent GatherInfo = GatherPostReq.getGatherPostContent();

		Gather.setUserId(userRepository.findById(GatherInfo.getUserId()).get());
		Gather.setUserNickname(userRepository.findByUserId(GatherInfo.getUserId()).getUserNickname());
		Gather.setGatherText(GatherInfo.getGatherText());
		Gather.setGatherFileurl("empty");
		Gather.setGatherWritedate(LocalDateTime.now());
		Gather.setGatherFinishdate(GatherInfo.getGatherFinishdate());
		Gather.setGatherPoint(gf.createPoint(new Coordinate(GatherInfo.getGatherLongitude(), GatherInfo.getGatherLatitude())));
		Gather.setGatherLikenum(0);
		Gather.setGatherSpamnum(0);
		Gather.setGatherDesigncode(GatherInfo.getGatherDesigncode());


		// file upload
		if(GatherPostReq.getGatherFile() != null){
			MultipartFile mfile = GatherPostReq.getGatherFile();
			String originalName = UUID.randomUUID()+mfile.getOriginalFilename(); // 파일 이름
			long size = mfile.getSize(); // 파일 크기
			String S3Bucket = "footp-bucket"; // Bucket 이름
			ObjectMetadata objectMetaData = new ObjectMetadata();
			objectMetaData.setContentType(mfile.getContentType());
			objectMetaData.setContentLength(size);

			// S3에 업로드
			amazonS3Client.putObject(
					new PutObjectRequest(S3Bucket+"/gather", originalName, mfile.getInputStream(), objectMetaData)
							.withCannedAcl(CannedAccessControlList.PublicRead)
			);

			String imagePath = amazonS3Client.getUrl(S3Bucket+"/gather", originalName).toString(); // 접근가능한 URL 가져오기

			Gather.setGatherFileurl(imagePath);
		}

		// save
		gatherRepository.save(Gather);
		System.out.println("Gather saved");

		return "success";
	}

	// 유저가 확성기에 참가
	public String joinGather(long gid, long uid){
		if(userJoinedGatherRepository.existsByUserIdAndGatherId(userRepository.findById(uid).get(), gatherRepository.findById(gid).get()) == true)
			return "fail";

		UserJoinedGather userJoinedGather = new UserJoinedGather(null, userRepository.findById(uid).get(), gatherRepository.findById(gid).get());
		userJoinedGatherRepository.save(userJoinedGather);

		return "success";
	}

	// 유저가 확성기 떠나기
	public String leaveGather(long gid, long uid){
		userJoinedGatherRepository.deleteByUserIdAndGatherId(userRepository.findById(uid).get(), gatherRepository.findById(gid).get());
		return "success";
	}
	
}
