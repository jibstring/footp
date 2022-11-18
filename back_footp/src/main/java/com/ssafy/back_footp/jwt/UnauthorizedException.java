package com.ssafy.back_footp.jwt;

public class UnauthorizedException extends RuntimeException{

	/**
	 * 
	 */
	private static final long serialVersionUID = 7612577985955439531L;
	
	public UnauthorizedException() {
		super("계정 권한이 유효하지 않습니다. \n 다시 로그인 해주세요.");
	}


}
