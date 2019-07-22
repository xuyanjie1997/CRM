package com.xyj.base.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.xyj.base.mapper.BaseMapper;
import com.xyj.base.mapper.DictionaryMapper;

@Service
public class DictionaryService<T> extends BaseService<T>{

	@Autowired
	private DictionaryMapper<T> dictionaryMapper;
	
	@Override
	public BaseMapper<T> getMapper() {
		return dictionaryMapper;
	}

}
