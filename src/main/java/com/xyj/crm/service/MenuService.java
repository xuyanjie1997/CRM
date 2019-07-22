package com.xyj.crm.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.xyj.base.mapper.BaseMapper;
import com.xyj.base.service.BaseService;
import com.xyj.crm.mapper.MenuMapper;
import com.xyj.crm.model.MenuModel;

@Service
public class MenuService<T> extends BaseService<T> {

	@Autowired
	private MenuMapper<T> menuMapper;
	
	@Override
	public BaseMapper<T> getMapper() {
		return menuMapper;
	}

	public List<MenuModel> selectUpMenu() {
		return menuMapper.selectUpMenu();
	}

}
