package com.ssafy.back_footp.controller;

import java.net.URL;
import java.time.Duration;
import java.time.LocalDate;
import java.util.*;

import com.amazonaws.HttpMethod;
import com.amazonaws.services.s3.AmazonS3Client;
import com.amazonaws.services.s3.model.CannedAccessControlList;
import com.amazonaws.services.s3.model.GeneratePresignedUrlRequest;
import com.amazonaws.services.s3.model.ObjectMetadata;
import com.amazonaws.services.s3.model.PutObjectRequest;
import com.ssafy.back_footp.config.AWSConfig;
import com.ssafy.back_footp.entity.Event;
import com.ssafy.back_footp.entity.Message;
import com.ssafy.back_footp.repository.EventRepository;
import com.ssafy.back_footp.repository.MessageRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.multipart.MultipartFile;
import software.amazon.awssdk.services.s3.presigner.model.PresignedPutObjectRequest;
import software.amazon.awssdk.services.s3.presigner.S3Presigner;
import software.amazon.awssdk.services.s3.presigner.model.PutObjectPresignRequest;
import io.swagger.annotations.ApiOperation;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.bind.annotation.*;

@RestController
@Slf4j
@AllArgsConstructor
@RequestMapping("/fileupload")
public class FileUploadController {
/*
	@Autowired
	private AmazonS3Client amazonS3Client;

	public static final Logger logger = LoggerFactory.getLogger(FileUploadController.class);
	private static final String SUCCESS = "success";
	private static final String FAIL = "fail";

	@GetMapping("/message/{Type}")
	@ApiOperation(value = "파일 업로드용 URL을 GET")
	public String messageFileUpload(@PathVariable String Type) {
		String preSignedURL = "";
		String fileName = "message" + "/" + UUID.randomUUID();

		Date expiration = new Date();
		long expTimeMillis = expiration.getTime();
		expTimeMillis += 99999999;
		expiration.setTime(expTimeMillis);

		log.info(expiration.toString());

		try {

			GeneratePresignedUrlRequest generatePresignedUrlRequest =
					new GeneratePresignedUrlRequest("footp-bucket", fileName)
							.withMethod(HttpMethod.GET)
							.withContentType(Type)
							.withExpiration(expiration);
			URL url = amazonS3Client.generatePresignedUrl(generatePresignedUrlRequest);
			preSignedURL = url.toString();
			log.info("Pre-Signed URL : " + url.toString());
		} catch (Exception e) {
			e.printStackTrace();
		}

		return preSignedURL;
	}
*/




	@Autowired
	AmazonS3Client amazonS3Client;
	@GetMapping("/{dir}")
	public ResponseEntity<Object> messageFileUpload(MultipartFile[] multipartFileList, @PathVariable String dir) throws Exception {
		List<String> imagePathList = new ArrayList<>();

		for(MultipartFile multipartFile: multipartFileList) {
			String originalName = UUID.randomUUID()+multipartFile.getOriginalFilename(); // 파일 이름
			long size = multipartFile.getSize(); // 파일 크기
			String S3Bucket = "footp-bucket"; // Bucket 이름
			ObjectMetadata objectMetaData = new ObjectMetadata();
			objectMetaData.setContentType(multipartFile.getContentType());
			objectMetaData.setContentLength(size);

			// S3에 업로드
			amazonS3Client.putObject(
					new PutObjectRequest(S3Bucket+"/"+dir, originalName, multipartFile.getInputStream(), objectMetaData)
							.withCannedAcl(CannedAccessControlList.PublicRead)
			);

			String imagePath = amazonS3Client.getUrl(S3Bucket, originalName).toString(); // 접근가능한 URL 가져오기
			imagePathList.add(imagePath);
		}

		return new ResponseEntity<>(imagePathList, HttpStatus.OK);
	}



}
