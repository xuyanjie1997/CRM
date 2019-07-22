package com.xyj.cust.mapper;

import java.util.List;

import com.xyj.base.mapper.BaseMapper;
import com.xyj.cust.model.SaleModel;

public interface SaleMapper<T> extends BaseMapper<T> {

	SaleModel selectByCodes(SaleModel model);

	int updateBatch(Object id);

	List<SaleModel> selectVolume();

}
