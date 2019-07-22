package com.xyj.cust.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.xyj.base.mapper.BaseMapper;
import com.xyj.base.service.BaseService;
import com.xyj.cust.mapper.CommMapper;

@Service
public class CommService<T> extends BaseService<T> {

	@Autowired
	private CommMapper<T> commMapper;
	
	@Override
	public BaseMapper<T> getMapper() {
		return commMapper;
	}

	public int updateBatch(Object id) {
		return commMapper.updateBatch(id);
	}

}
