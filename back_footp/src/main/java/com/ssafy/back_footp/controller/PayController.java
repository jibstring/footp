package com.ssafy.back_footp.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.ssafy.back_footp.request.KakaoPay;
import com.ssafy.back_footp.service.PayService;

import io.swagger.annotations.ApiOperation;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@RestController
@Slf4j
@AllArgsConstructor
@RequestMapping("/pay")
public class PayController {
	
	@Autowired
	PayService payService;
	
	@PostMapping("/kakaoPay/{userId}")
	@ApiOperation(value = "카카오페이 테스트")
	public ResponseEntity<String> kakaoPay(@PathVariable long userId){
		
		String result = payService.kakaoPay(userId);
		System.out.println(result);
		return new ResponseEntity<String>(result,HttpStatus.OK);
	}
	
	@GetMapping("/kakaoPaySuccess")
    public void kakaoPaySuccess(@RequestParam("pg_token") String pg_token, Model model) {
        log.info("kakaoPaySuccess get............................................");
        log.info("kakaoPaySuccess pg_token : " + pg_token);
        
        model.addAttribute("info", payService.kakaoPayInfo(pg_token));
        
    }

}
