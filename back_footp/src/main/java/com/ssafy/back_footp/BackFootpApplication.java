package com.ssafy.back_footp;

import java.time.LocalDateTime;
import java.util.Date;
import java.util.TimeZone;

import javax.annotation.PostConstruct;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class BackFootpApplication {
	
	@PostConstruct
	public void started() {
		TimeZone.setDefault(TimeZone.getTimeZone("Asia/Seoul"));
	}

	public static void main(String[] args) {

		SpringApplication.run(BackFootpApplication.class, args);
		System.out.println("Hibernate Version: "+org.hibernate.Version.getVersionString());
	}

}
