package com.ssafy.back_footp.repository;

import com.ssafy.back_footp.entity.Message;

import java.util.List;

public interface MessageCustomRepository {

     List<Message> findAllInScreenOrderByMessageWritedate(double lon_r, double lon_l, double lat_d, double lat_u);
     List<Message> findAllInScreenOrderByMessageLikenum(double lon_r, double lon_l, double lat_d, double lat_u);

}
