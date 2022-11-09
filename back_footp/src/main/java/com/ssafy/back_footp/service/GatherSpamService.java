package com.ssafy.back_footp.service;

import javax.transaction.Transactional;

import com.ssafy.back_footp.repository.GatherRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ssafy.back_footp.entity.Gather;
import com.ssafy.back_footp.entity.GatherSpam;
import com.ssafy.back_footp.repository.GatherSpamRepository;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@RequiredArgsConstructor
public class GatherSpamService {

	@Autowired
	private GatherSpamRepository eventSpamRepository;
	@Autowired
	private GatherRepository gatherRepository;

	// 발자국의 id를 받아와 해당 발자국이 받은 신고 수를 반환한다.
	public int spamNum(long eid) {
		int result = eventSpamRepository.countByGatherId(gatherRepository.findById(eid).get());
		return result;
	}

	// 신고를 누르지 않은 상태에서 누른경우, Table에 추가하기 위해 Create한다.
	@Transactional
	public GatherSpam createSpam(GatherSpam gatherSpam) {
		GatherSpam savedSpam = eventSpamRepository.save(gatherSpam);

		// Likenum 증가
		Gather evt = gatherRepository.findById(gatherSpam.getGatherId().getGatherId()).get();
		evt.setGatherSpamnum(evt.getGatherSpamnum()+1);
		gatherRepository.save(evt);

		return savedSpam;
	}

}
