package com.ssafy.back_footp.request;

import lombok.Data;

@Data
public class AmountVO {
	
	private Integer total, tax_free, vat, point, discount;

}
