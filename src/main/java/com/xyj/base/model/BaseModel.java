package com.xyj.base.model;

import com.xyj.util.Pager;

public class BaseModel  extends Pager{

    private Integer id;          // 自增主键
    private String  createTime;  // 创建时间
    private String  updateTime;  // 更新时间
    private String createBy;    // 创建人（一般为用户表主键）
    private String updateBy;    // 更新人（一般为用户表主键）
    private Integer deleted = 0; // 删除标志（0=未删，1=已删）
    private String state ; 		// 	状态标志
    private Double  order;       // 排序序号（小数类型）
    private String  name;        // 名称
    private String  code;        // 编码
    private String  descr;       // 描述
    private Integer type;        // 类型（一般为字典表主键）
    
	public Integer getId() {
		return id;
	}
	public void setId(Integer id) {
		this.id = id;
	}
	public String getCreateTime() {
		return createTime;
	}
	public void setCreateTime(String createTime) {
		this.createTime = createTime;
	}
	public String getUpdateTime() {
		return updateTime;
	}
	public void setUpdateTime(String updateTime) {
		this.updateTime = updateTime;
	}
	
	public String getCreateBy() {
		return createBy;
	}
	public void setCreateBy(String createBy) {
		this.createBy = createBy;
	}
	public String getUpdateBy() {
		return updateBy;
	}
	public void setUpdateBy(String updateBy) {
		this.updateBy = updateBy;
	}
	public Integer getDeleted() {
		return deleted;
	}
	public void setDeleted(Integer deleted) {
		this.deleted = deleted;
	}

	public String getState() {
		return state;
	}
	public void setState(String state) {
		this.state = state;
	}
	public Double getOrder() {
		return order;
	}
	public void setOrder(Double order) {
		this.order = order;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getCode() {
		return code;
	}
	public void setCode(String code) {
		this.code = code;
	}
	public String getDescr() {
		return descr;
	}
	public void setDescr(String descr) {
		this.descr = descr;
	}
	public Integer getType() {
		return type;
	}
	public void setType(Integer type) {
		this.type = type;
	}
    
    
	
}
