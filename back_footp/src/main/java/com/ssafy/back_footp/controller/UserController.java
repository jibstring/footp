package com.ssafy.back_footp.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.ssafy.back_footp.entity.Mail;
import com.ssafy.back_footp.service.MailService;

import io.swagger.annotations.ApiOperation;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@RestController
@Slf4j
@AllArgsConstructor
@RequestMapping("/auth")
public class UserController {

	//Autowire 하는곳
	MailService mailService;
	
	
	
	@PostMapping("/email/{email}/{name}")
	@ApiOperation(value = "이메일 전송 테스트")
	public ResponseEntity<Integer> test(@PathVariable String email, @PathVariable String name) {
		int result = 0;
		
		Mail mail = mailService.sendEmailService(email, name);
		
		mailService.mailSend(mail);
		result = 1;
		System.out.println(result);
		return new ResponseEntity<Integer>(result,HttpStatus.OK);

	}
	
}
