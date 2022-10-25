package com.ssafy.back_footp.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import com.ssafy.back_footp.entity.Notice;

public interface NoticeRepository extends JpaRepository<Notice, Long>{

}
