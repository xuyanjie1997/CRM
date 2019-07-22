package com.xyj.crm.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.xyj.base.mapper.BaseMapper;
import com.xyj.base.service.BaseService;
import com.xyj.crm.mapper.UserMapper;

@Service
public class UserService<T> extends BaseService<T>{
	
	@Autowired
	private UserMapper<T> userMapper;

	@Override
	public BaseMapper<T> getMapper() {
		return userMapper;
	}

}
