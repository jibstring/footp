package com.ssafy.back_footp.controller;

import java.io.IOException;
import java.io.OutputStreamWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.time.Duration;
import java.time.LocalDate;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;
import software.amazon.awssdk.services.s3.model.PutObjectRequest;
import software.amazon.awssdk.services.s3.model.S3Exception;
import software.amazon.awssdk.services.s3.presigner.model.PresignedPutObjectRequest;
import software.amazon.awssdk.services.s3.presigner.S3Presigner;
import software.amazon.awssdk.services.s3.presigner.model.PutObjectPresignRequest;
import com.ssafy.back_footp.service.AuthService;
import io.swagger.annotations.ApiOperation;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;


@RestController
@Slf4j
@AllArgsConstructor
@RequestMapping("/fileupload")
public class FileUploadController {

	public static final Logger logger = LoggerFactory.getLogger(FileUploadController.class);
	private static final String SUCCESS = "success";
	private static final String FAIL = "fail";

	@Autowired
	AuthService authService;

	@GetMapping("/{dir}")
	@ApiOperation(value = "파일 업로드용 URL을 GET")
	public static String signBucket(@PathVariable String dir) {

		S3Presigner presigner = S3Presigner.create();;
		String bucketName = "footp-bucket/"+dir;
		String keyName = UUID.randomUUID().toString();

		Map<String, String> metadata = new HashMap<>();
		metadata.put("date", LocalDate.now().toString());

		PutObjectRequest objectRequest = PutObjectRequest.builder()
				.bucket(bucketName)
				.key(keyName)
				.metadata(metadata)
				.build();

		PutObjectPresignRequest presignRequest = PutObjectPresignRequest.builder()
				.signatureDuration(Duration.ofMinutes(Long.MAX_VALUE))
				.putObjectRequest(objectRequest)
				.build();

		PresignedPutObjectRequest presignedRequest = presigner.presignPutObject(presignRequest);
		System.out.println("Presigned URL to upload a file to: " + presignedRequest.url().toString());

		return presignedRequest.url().toString();
	}
}
