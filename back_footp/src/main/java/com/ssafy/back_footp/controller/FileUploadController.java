package com.ssafy.back_footp.controller;

import java.net.URL;
import java.time.Duration;
import java.time.LocalDate;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

import com.amazonaws.HttpMethod;
import com.amazonaws.services.s3.AmazonS3Client;
import com.amazonaws.services.s3.model.GeneratePresignedUrlRequest;
import com.ssafy.back_footp.entity.Event;
import com.ssafy.back_footp.entity.Message;
import com.ssafy.back_footp.repository.EventRepository;
import com.ssafy.back_footp.repository.MessageRepository;
import org.springframework.beans.factory.annotation.Autowired;
import software.amazon.awssdk.services.s3.model.PutObjectRequest;
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

	@Autowired
	private MessageRepository messageRepository;
	@Autowired
	private EventRepository eventRepository;

	private AmazonS3Client amazonS3Client;

	public static final Logger logger = LoggerFactory.getLogger(FileUploadController.class);
	private static final String SUCCESS = "success";
	private static final String FAIL = "fail";

	@GetMapping("/message/{Id}/{Type}")
	@ApiOperation(value = "파일 업로드용 URL을 GET")
	public String messageFileUpload(@PathVariable long Id, @PathVariable String Type) {
/*
		S3Presigner presigner = S3Presigner.create();;
		String bucketName = "footp-bucket/message";
		String keyName = UUID.randomUUID().toString()+"."+Type;
		System.out.println(keyName);
		Map<String, String> metadata = new HashMap<>();
		metadata.put("date", LocalDate.now().toString());

		PutObjectRequest objectRequest = PutObjectRequest.builder()
				.bucket(bucketName)
				.key(keyName)
				.metadata(metadata)
				.contentType(Type)
				.build();
		System.out.println(objectRequest.toString());
		PutObjectPresignRequest presignRequest = PutObjectPresignRequest.builder()
				.signatureDuration(Duration.ofMinutes(99999999))
				.putObjectRequest(objectRequest)
				.build();

		PresignedPutObjectRequest presignedRequest = presigner.presignPutObject(presignRequest);
		System.out.println("Presigned URL to upload a file to: " + presignedRequest.url().toString());

		return presignedRequest.url().toString();
		*/


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

			Message msg = messageRepository.findById(Id).get();
			msg.setMessageFileurl(preSignedURL);
			messageRepository.save(msg);

		} catch (Exception e) {
			e.printStackTrace();
		}

		return preSignedURL;
	}

	@GetMapping("/event/{Id}/{Type}")
	@ApiOperation(value = "파일 업로드용 URL을 GET")
	public String eventFileUpload(@PathVariable long Id, @PathVariable String Type) {
/*
		S3Presigner presigner = S3Presigner.create();;
		String bucketName = "footp-bucket/message";
		String keyName = UUID.randomUUID().toString()+"."+Type;
		System.out.println(keyName);
		Map<String, String> metadata = new HashMap<>();
		metadata.put("date", LocalDate.now().toString());

		PutObjectRequest objectRequest = PutObjectRequest.builder()
				.bucket(bucketName)
				.key(keyName)
				.metadata(metadata)
				.contentType(Type)
				.build();
		System.out.println(objectRequest.toString());
		PutObjectPresignRequest presignRequest = PutObjectPresignRequest.builder()
				.signatureDuration(Duration.ofMinutes(99999999))
				.putObjectRequest(objectRequest)
				.build();

		PresignedPutObjectRequest presignedRequest = presigner.presignPutObject(presignRequest);
		System.out.println("Presigned URL to upload a file to: " + presignedRequest.url().toString());

		return presignedRequest.url().toString();
		*/


		String preSignedURL = "";
		String fileName = "event" + "/" + UUID.randomUUID();

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

			Event evt = eventRepository.findById(Id).get();
			evt.setEventFileurl(preSignedURL);
			eventRepository.save(evt);

		} catch (Exception e) {
			e.printStackTrace();
		}

		return preSignedURL;
	}
}
