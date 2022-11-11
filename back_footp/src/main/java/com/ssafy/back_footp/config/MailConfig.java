package com.ssafy.back_footp.config;

import java.util.Properties;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.JavaMailSenderImpl;


@Configuration
public class MailConfig {
	
	@Value("${MAIL_PASSWORD}")
	String mailPassword;

	@Bean
	public JavaMailSender javaMailService() {
		JavaMailSenderImpl javaMailSender = new JavaMailSenderImpl();
		
		javaMailSender.setHost("smtp.gmail.com");
        javaMailSender.setUsername("footp.company@gmail.com");
        javaMailSender.setPassword(mailPassword); //이제 구글 보안은 이 앱 비밀번호를 사용해서 해야합니다. (2단계 보안 설정 후 앱 비밀번호를 발급받아 사용)

        javaMailSender.setPort(465);

        javaMailSender.setJavaMailProperties(getMailProperties());

        return javaMailSender;
        
        
	}

	private Properties getMailProperties() {
		Properties properties = new Properties();
        properties.setProperty("mail.transport.protocol", "smtp");
        properties.setProperty("mail.smtp.auth", "true");
        properties.setProperty("mail.smtp.starttls.enable", "true");
        properties.setProperty("mail.debug", "true");
        properties.setProperty("mail.smtp.ssl.trust","smtp.gmail.com");
        properties.setProperty("mail.smtp.port", "465");
        properties.setProperty("mail.smtp.ssl.enable","true");
        properties.setProperty("mail.smtp.ssl.protocols", "TLSv1.2");
        properties.setProperty("mail.smtp.connectiontimeout", "5000");
        properties.setProperty("mail.smtp.writetimeout", "5000");
        return properties;
	}
}
