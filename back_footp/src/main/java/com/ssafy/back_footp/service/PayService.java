package com.ssafy.back_footp.service;

import java.net.URI;
import java.net.URISyntaxException;

import javax.transaction.Transactional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Service;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.client.RestClientException;
import org.springframework.web.client.RestTemplate;

import com.ssafy.back_footp.entity.User;
import com.ssafy.back_footp.repository.UserRepository;
import com.ssafy.back_footp.request.KakaoInfo;
import com.ssafy.back_footp.request.KakaoPay;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
@RequiredArgsConstructor
public class PayService {
	
	private static final String HOST = "https://kapi.kakao.com";
	
	@Value("${ADMIN_KEY}")
	String adminKey;
	
	@Autowired
	UserRepository userRepository;
	
	private KakaoPay kakao;
	private KakaoInfo kakaoInfo;
	
	@Transactional
	public KakaoPay kakaoPay(long userId) {
		
		RestTemplate restTemplate = new RestTemplate();
		
		//헤더
		HttpHeaders headers = new HttpHeaders();
		
		headers.add("Authorization", "KakaoAK "+adminKey);
		headers.add("Accept", MediaType.APPLICATION_JSON_UTF8_VALUE);
		headers.add("Content-Type", MediaType.APPLICATION_FORM_URLENCODED_VALUE + ";charset=UTF-8");
		
		//바디
		MultiValueMap<String, String> params = new LinkedMultiValueMap<String, String>();
        params.add("cid", "TC0ONETIME");
        params.add("partner_order_id", "1001");
        params.add("partner_user_id", "footp");
        params.add("item_name", "푸포인트");
        params.add("quantity", "1");
        params.add("total_amount", "50000");
        params.add("tax_free_amount", "100");
        params.add("approval_url", "http://localhost:8080/kakaoPaySuccess");
        params.add("cancel_url", "http://localhost:8080/kakaoPayCancel");
        params.add("fail_url", "http://localhost:8080/kakaoPaySuccessFail");
        
        HttpEntity<MultiValueMap<String, String>> body = new HttpEntity<MultiValueMap<String, String>>(params, headers);
        
        try {
        	kakao = restTemplate.postForObject(new URI(HOST + "/v1/payment/ready"), body, KakaoPay.class);
            kakao.setUserId(userId);
            
            log.info("" + kakao);
            return kakao;
 
        } catch (RestClientException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        } catch (URISyntaxException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
        
        return null;
	}
	
	@Transactional
	public KakaoInfo kakaoPayInfo(String pg_token) {
		
		System.out.println(kakao.getNext_redirect_app_url());
		 
        log.info("KakaoPayInfoVO............................................");
        log.info("-----------------------------");
        
        RestTemplate restTemplate = new RestTemplate();
 
        // 서버로 요청할 Header
        HttpHeaders headers = new HttpHeaders();
        headers.add("Authorization", "KakaoAK " + adminKey);
        headers.add("Accept", MediaType.APPLICATION_JSON_UTF8_VALUE);
        headers.add("Content-Type", MediaType.APPLICATION_FORM_URLENCODED_VALUE + ";charset=UTF-8");
 
        // 서버로 요청할 Body
        MultiValueMap<String, String> params = new LinkedMultiValueMap<String, String>();
        params.add("cid", "TC0ONETIME");
        params.add("tid", kakao.getTid());
        params.add("partner_order_id", "1001");
        params.add("partner_user_id", "footp");
        params.add("pg_token", pg_token);
        params.add("total_amount", "50000");
        
        HttpEntity<MultiValueMap<String, String>> body = new HttpEntity<MultiValueMap<String, String>>(params, headers);
        
        try {
        	kakaoInfo = restTemplate.postForObject(new URI(HOST + "/v1/payment/approve"), body, KakaoInfo.class);
            log.info("" + kakaoInfo);
            // 결제가 완료되면 유저의 cash를 5만만큼 증가시킨다.
            User user = userRepository.findByUserId(kakao.getUserId());
            user.setUserCash(user.getUserCash()+50000);
            
            userRepository.save(user);
            return kakaoInfo;
        
        } catch (RestClientException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        } catch (URISyntaxException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
        
        return null;
    }

}
