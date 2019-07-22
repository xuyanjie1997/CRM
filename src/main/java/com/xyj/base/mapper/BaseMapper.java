package com.xyj.base.mapper;

import java.util.List;

public interface BaseMapper<T> {

	int insert(T t);
	
	int delete(Object  id);
	
	int deleteModel(T t);
	
	int update(T t);
	
	int updateActive(T t);
	
	T select(Object id);
	
	int selectCount(T t);
	
	List<T> selectAll(T t);
	
	List<T> selectModel(T t);
	
}
