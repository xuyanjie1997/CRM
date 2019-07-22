package com.xyj.base.service;

import java.util.List;

import com.xyj.base.mapper.BaseMapper;

public abstract class BaseService<T>{

	public abstract BaseMapper<T> getMapper();
	
	public int insert(T t) {
		return getMapper().insert(t);
	}
	
	public void deleteBatch(Object ... ids) {
		if(ids == null || ids.length < 1) {
			return;
		}
		for (Object id : ids) {
			getMapper().delete(id);
		}
	}
	
	public int delete(Object id) {
		return getMapper().delete(id);
	}
	
	public int update(T t) {
		return getMapper().update(t);
	}
	
	public T select(Object id) {
		return getMapper().select(id);
	}
	
	public List<T> selectAll(T t){
		return getMapper().selectAll(t);
	}
	
	public List<T> selectModel(T t){
		return getMapper().selectModel(t);
	}
	
	public int selectCount(T t) {
		return getMapper().selectCount(t);
	}
	
	public int updateActive(T t) {
		return getMapper().updateActive(t);
	}
	
}
