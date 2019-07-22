package com.xyj.cust.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.xyj.base.mapper.BaseMapper;
import com.xyj.base.service.BaseService;
import com.xyj.cust.mapper.MdseMapper;

@Service
public class MdseService<T> extends BaseService<T> {
	
	@Autowired
	private MdseMapper<T> mdseMapper;

	@Override
	public BaseMapper<T> getMapper() {
		return mdseMapper;
	}

	public int updateBatch(Object id) {
		return mdseMapper.updateBatch(id);
		
	}

}
