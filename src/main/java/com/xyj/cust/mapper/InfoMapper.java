package com.xyj.cust.mapper;

import com.xyj.base.mapper.BaseMapper;

public interface InfoMapper<T> extends BaseMapper<T> {

	int updateBatch(Object id2);

}
