package com.ssafy.back_footp;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class BackFootpApplication {

	public static void main(String[] args) {

		SpringApplication.run(BackFootpApplication.class, args);
		System.out.println("Hibernate Version: "+org.hibernate.Version.getVersionString());
	}

}
