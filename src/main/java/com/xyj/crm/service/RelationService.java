package com.xyj.crm.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.xyj.base.mapper.BaseMapper;
import com.xyj.base.service.BaseService;
import com.xyj.crm.mapper.RelationMapper;
import com.xyj.crm.model.RelationModel;

@Service
public class RelationService<T> extends BaseService<T> {
	
	@Autowired
	private RelationMapper<T> relationMapper;

	@Override
	public BaseMapper<T> getMapper() {
		return relationMapper;
	}
	
	public RelationModel selectByCodes(RelationModel model) {
		return relationMapper.selectByCodes(model);
	}
	
}
