package com.xyj.crm.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.xyj.base.mapper.BaseMapper;
import com.xyj.base.service.BaseService;
import com.xyj.crm.mapper.RoleMapper;

@Service
public class RoleService<T> extends BaseService<T>{
	
	@Autowired
	private RoleMapper<T> roleMapper;

	@Override
	public BaseMapper<T> getMapper() {
		return roleMapper;
	}

}
