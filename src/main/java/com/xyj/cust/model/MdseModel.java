package com.xyj.cust.model;

import com.xyj.base.model.BaseModel;

public class MdseModel extends BaseModel{

	private String cost;	//	价格
	private Integer num;	//	数量
	
	public String getCost() {
		return cost;
	}
	public void setCost(String cost) {
		this.cost = cost;
	}
	public Integer getNum() {
		return num;
	}
	public void setNum(Integer num) {
		this.num = num;
	}
	
}
