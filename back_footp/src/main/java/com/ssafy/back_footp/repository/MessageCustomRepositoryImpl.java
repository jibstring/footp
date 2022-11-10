package com.ssafy.back_footp.repository;

import com.ssafy.back_footp.entity.Message;
import org.springframework.beans.factory.annotation.Autowired;

import javax.persistence.EntityManager;
import javax.persistence.Query;

import java.util.List;

public class MessageCustomRepositoryImpl implements MessageCustomRepository {

    @Autowired
    EntityManager em;

    @Override
    public List<Message> findAllInScreenOrderByMessageWritedate(double lon_r, double lon_l, double lat_d, double lat_u){

        String polygonstr = "POLYGON(("+lon_l+" "+lat_u+", "+lon_r+" "+lat_u+", "+lon_r+" "+lat_d+", "+lon_l+" "+lat_d+", "+lon_l+" "+lat_u+"))";
        String sql = "SELECT * from message WHERE ST_CONTAINS(ST_GEOMFROMTEXT('"+polygonstr+"'), message_point)  order by message_writedate desc";

        System.out.println(sql);

        Query query = em.createNativeQuery(sql, Message.class);
        List<Message> messagelist = query.getResultList();

        return messagelist;
    }


    @Override
    public List<Message> findAllInScreenOrderByMessageLikenum(double lon_r, double lon_l, double lat_d, double lat_u){
        String polygonstr = "POLYGON(("+lon_l+" "+lat_u+", "+lon_r+" "+lat_u+", "+lon_r+" "+lat_d+", "+lon_l+" "+lat_d+", "+lon_l+" "+lat_u+"))";
        String sql = "SELECT * from message WHERE ST_CONTAINS(ST_GEOMFROMTEXT('"+polygonstr+"'), message_point)  order by message_likenum desc";

        System.out.println(sql);

        Query query = em.createNativeQuery(sql, Message.class);
        List<Message> messagelist = query.getResultList();

        return messagelist;
    }

}
