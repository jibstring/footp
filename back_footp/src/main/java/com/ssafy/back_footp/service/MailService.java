package com.ssafy.back_footp.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.MailSender;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.PostMapping;

import com.ssafy.back_footp.entity.Mail;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@RequiredArgsConstructor
public class MailService {
	
	private static final String fromAddress = "apxjvm@gmail.com";

	@Autowired
	private JavaMailSender MailSender;

	public void mailSend(Mail mail) {

		SimpleMailMessage message = new SimpleMailMessage();
		message.setTo(mail.getAddress());
		message.setFrom(fromAddress);
		message.setSubject(mail.getTitle());
		message.setText(mail.getContent());

		MailSender.send(message);
	}

	public Mail sendEmailService(String email, String name) {
		try {
			Mail mail = new Mail();

			mail.setAddress(email+"@naver.com");
			mail.setTitle(name);
			mail.setContent("test");

			return mail;
		} catch (Exception e) {
			return null;
		}
	}
}
