package com.ssafy.back_footp.controller;

import com.ssafy.back_footp.entity.*;
import com.ssafy.back_footp.repository.EventLikeRepository;
import com.ssafy.back_footp.repository.EventSpamRepository;
import com.ssafy.back_footp.request.EventPostReq;
import com.ssafy.back_footp.service.*;
import io.swagger.annotations.ApiOperation;
import lombok.extern.slf4j.Slf4j;
import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@Slf4j
@RequestMapping("/notice")
public class NoticeController {
	@Autowired
	NoticeService noticeService;
	
	@GetMapping("")
	@ApiOperation(value = "공지사항 조회", notes = "공지사항 목록을 조회한다.")
	public ResponseEntity<JSONObject> noticeSearch(){
		JSONObject result = null;
		
		try {
			result = noticeService.getNotice();
		}catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}
		
		return new ResponseEntity<>(result,HttpStatus.OK);
	}

	@PostMapping("/new")
	@ApiOperation(value = "(관리자용 페이지) 공지사항 작성", notes = "공지사항을 새로 작성한다.")
	public ResponseEntity<JSONObject> noticeWrite(@RequestBody Notice notice){
		JSONObject result = null;
		System.out.println("controller: "+notice.getNoticeTitle());
		try {
			noticeService.createNotice(notice);
			result = noticeService.getNotice();
		}catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}

		return new ResponseEntity<>(result,HttpStatus.OK);
	}
}
