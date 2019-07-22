package com.xyj.crm.mapper;

import java.util.List;

import com.xyj.base.mapper.BaseMapper;
import com.xyj.crm.model.MenuModel;

public interface MenuMapper<T> extends BaseMapper<T>{

	List<MenuModel> selectUpMenu();
	
}
