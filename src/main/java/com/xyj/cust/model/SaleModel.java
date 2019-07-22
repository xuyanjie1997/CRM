package com.xyj.cust.model;

import com.xyj.base.model.BaseModel;

public class SaleModel extends BaseModel{

	private String userCode;	//	用户编号
	private String custCode;	//	顾客编号
	private String mdseCode;	//	商品编号
	private Integer volume;		//	销量
	
	//	子查询
	private String userName;
	private String custName;
	private String mdseName;
	private String stateName;
	
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
	public String getMdseCode() {
		return mdseCode;
	}
	public void setMdseCode(String mdseCode) {
		this.mdseCode = mdseCode;
	}
	public Integer getVolume() {
		return volume;
	}
	public void setVolume(Integer volume) {
		this.volume = volume;
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
	public String getMdseName() {
		return mdseName;
	}
	public void setMdseName(String mdseName) {
		this.mdseName = mdseName;
	}
	public String getStateName() {
		return stateName;
	}
	public void setStateName(String stateName) {
		this.stateName = stateName;
	}
	
}
