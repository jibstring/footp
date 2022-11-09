package com.ssafy.back_footp.repository;

import com.ssafy.back_footp.entity.Gather;

import java.util.List;

public interface GatherCustomRepository {

     List<Gather> findAllInScreenOrderByGatherWritedate(double lon_r, double lon_l, double lat_d, double lat_u);
     List<Gather> findAllInScreenOrderByGatherLikenum(double lon_r, double lon_l, double lat_d, double lat_u);

}
