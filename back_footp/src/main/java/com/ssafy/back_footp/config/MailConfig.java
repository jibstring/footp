package com.ssafy.back_footp.config;

import java.util.Properties;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.JavaMailSenderImpl;


@Configuration
public class MailConfig {

	@Bean
	public JavaMailSender javaMailService() {
		JavaMailSenderImpl javaMailSender = new JavaMailSenderImpl();
		
		javaMailSender.setHost("smtp.gmail.com");
        javaMailSender.setUsername("apxjvm@gmail.com");
        javaMailSender.setPassword("lvckmhooadfhoqzo"); //이제 구글 보안은 이 앱 비밀번호를 사용해서 해야합니다. (2단계 보안 설정 후 앱 비밀번호를 발급받아 사용)

        javaMailSender.setPort(587);

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
        properties.setProperty("mail.smtp.ssl.enable","true");
        properties.setProperty("mail.smtp.socketFactory.port", "587");
        properties.setProperty("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");
        properties.setProperty("mail.smtp.socketFactory.fallback", "false");
        return properties;
	}
}
