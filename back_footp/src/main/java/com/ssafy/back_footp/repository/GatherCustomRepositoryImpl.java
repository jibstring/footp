package com.ssafy.back_footp.repository;

import com.ssafy.back_footp.entity.Gather;
import org.springframework.beans.factory.annotation.Autowired;

import javax.persistence.EntityManager;
import javax.persistence.Query;
import java.util.List;

public class GatherCustomRepositoryImpl implements GatherCustomRepository {

    @Autowired
    EntityManager em;

    @Override
    public List<Gather> findAllInScreenOrderByGatherWritedate(double lon_r, double lon_l, double lat_d, double lat_u){

        String polygonstr = "POLYGON(("+lon_l+" "+lat_u+", "+lon_r+" "+lat_u+", "+lon_r+" "+lat_d+", "+lon_l+" "+lat_d+", "+lon_l+" "+lat_u+"))";
        String sql = "SELECT * from gather WHERE ST_CONTAINS(ST_GEOMFROMTEXT('"+polygonstr+"'), gather_point)  order by gather_writedate";

        System.out.println(sql);

        Query query = em.createNativeQuery(sql, Gather.class);
        List<Gather> gatherlist = query.getResultList();

        return gatherlist;
    }


    @Override
    public List<Gather> findAllInScreenOrderByGatherLikenum(double lon_r, double lon_l, double lat_d, double lat_u){
        String polygonstr = "POLYGON(("+lon_l+" "+lat_u+", "+lon_r+" "+lat_u+", "+lon_r+" "+lat_d+", "+lon_l+" "+lat_d+", "+lon_l+" "+lat_u+"))";
        String sql = "SELECT * from gather WHERE ST_CONTAINS(ST_GEOMFROMTEXT('"+polygonstr+"'), gather_point)  order by gather_likenum desc";

        System.out.println(sql);

        Query query = em.createNativeQuery(sql, Gather.class);
        List<Gather> gatherlist = query.getResultList();

        return gatherlist;
    }

}
