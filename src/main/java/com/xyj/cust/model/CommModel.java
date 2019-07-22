package com.xyj.cust.model;

import com.xyj.base.model.BaseModel;

public class CommModel extends BaseModel{

	private String userCode;	//	用户编号
	private String custCode;	//	顾客编号
	
	private String userName;
	private String custName;
	
	public String getUserCode() {
		return userCode;
	}
	public void setUserCode(String userCode) {
		this.userCode = userCode;
	}
	public String getCustCode() {
		return custCode;
	}
	public void setCustCode(String custCode) {
		this.custCode = custCode;
	}
	public String getUserName() {
		return userName;
	}
	public void setUserName(String userName) {
		this.userName = userName;
	}
	public String getCustName() {
		return custName;
	}
	public void setCustName(String custName) {
		this.custName = custName;
	}
	
}
