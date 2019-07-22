package com.xyj.cust.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.xyj.base.mapper.BaseMapper;
import com.xyj.base.service.BaseService;
import com.xyj.cust.mapper.SaleMapper;
import com.xyj.cust.model.SaleModel;

@Service
public class SaleService<T> extends BaseService<T>{

	@Autowired
	private SaleMapper<T> saleMapper;
	
	@Override
	public BaseMapper<T> getMapper() {
		return saleMapper;
	}

	public SaleModel selectByCodes(SaleModel model) {
		return saleMapper.selectByCodes(model);
	}

	public int updateBatch(Object id) {
		return saleMapper.updateBatch(id);		
	}

	public List<SaleModel> selectVolume() {
		return saleMapper.selectVolume();
	}
	
}
