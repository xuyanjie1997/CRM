package com.xyj.crm.model;

import java.util.ArrayList;
import java.util.List;

import com.xyj.base.model.BaseModel;

public class MenuModel extends BaseModel{

	private String url ;		//	菜单路径
	private String parentCode ; //	上级菜单编号
	private Integer level;		//	菜单等级
	private Double order;		//	顺序
	
	private String parentName ;
	
	private List<MenuModel> child = new ArrayList<MenuModel>();

	public String getUrl() {
		return url;
	}

	public void setUrl(String url) {
		this.url = url;
	}

	public String getParentCode() {
		return parentCode;
	}

	public void setParentCode(String parentCode) {
		this.parentCode = parentCode;
	}

	public Integer getLevel() {
		return level;
	}

	public void setLevel(Integer level) {
		this.level = level;
	}

	public Double getOrder() {
		return order;
	}

	public void setOrder(Double order) {
		this.order = order;
	}

	public String getParentName() {
		return parentName;
	}

	public void setParentName(String parentName) {
		this.parentName = parentName;
	}

	public List<MenuModel> getChild() {
		return child;
	}

	public void setChild(List<MenuModel> child) {
		this.child = child;
	} 
	
}
