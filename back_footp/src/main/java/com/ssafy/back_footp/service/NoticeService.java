package com.ssafy.back_footp.service;

import com.ssafy.back_footp.entity.Notice;
import com.ssafy.back_footp.repository.NoticeRepository;
import com.ssafy.back_footp.response.eventlistDTO;
import com.ssafy.back_footp.response.messagelistDTO;
import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.transaction.annotation.Transactional;

import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
public class NoticeService {
    @Autowired
    NoticeRepository noticeRepository;

    public JSONObject getNotice() {
        List<Notice> noticelist = new ArrayList<>();
        noticeRepository.findAll().forEach(Notice->noticelist.add(Notice));

        JSONObject jsonObject = new JSONObject();
        jsonObject.put("notice", noticelist);

        return jsonObject;
    }

    public JSONObject createNotice(Notice notice) {
        System.out.println("service: "+notice.getNoticeTitle());
        noticeRepository.save(new Notice(notice.getNoticeId(), notice.getNoticeTitle(), notice.getNoticeContent(), notice.getNoticeDate()));

        List<Notice> noticelist = new ArrayList<>();
        noticeRepository.findAll().forEach(Notice->noticelist.add(Notice));

        JSONObject jsonObject = new JSONObject();
        jsonObject.put("notice", noticelist);

        return jsonObject;
    }
}
