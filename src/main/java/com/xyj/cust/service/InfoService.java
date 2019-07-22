package com.xyj.cust.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.xyj.base.mapper.BaseMapper;
import com.xyj.base.service.BaseService;
import com.xyj.cust.mapper.InfoMapper;

@Service
public class InfoService<T> extends BaseService<T> {

	@Autowired
	public InfoMapper<T> infoMapper;
	
	@Override
	public BaseMapper<T> getMapper() {
		return infoMapper;
	}

	public int updateBatch(Object id2) {
		return infoMapper.updateBatch(id2);
	}

}
