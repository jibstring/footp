package com.ssafy.back_footp.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WebConfig implements WebMvcConfigurer {

	@Override
	public void addCorsMappings(CorsRegistry registry) {
		registry.addMapping("/**").allowedOrigins("*").allowedMethods("GET", "POST", "PUT", "DELETE", "OPTIONS")
				.maxAge(6000);
	}

//  Swagger UI 실행시 404처리
//	@Override
//	public void addResourceHandlers(ResourceHandlerRegistry registry) {
//		registry.addResourceHandler("/swagger-ui/index.html")
//				.addResourceLocations("classpath:/META-INF/resources/swagger-ui/index.html");
//		registry.addResourceHandler("/webjars/").addResourceLocations("classpath:/META-INF/resources/webjars/");
//	}

}
