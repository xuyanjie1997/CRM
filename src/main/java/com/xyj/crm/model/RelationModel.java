package com.xyj.crm.model;

import com.xyj.base.model.BaseModel;

public class RelationModel  extends BaseModel{

	private String roleCode;	//	角色编号
	private String menuCode;	//	菜单编号
	
	private RoleModel roleModel = new RoleModel();
	private MenuModel menuModel = new MenuModel();
	
	public String getRoleCode() {
		return roleCode;
	}
	public void setRoleCode(String roleCode) {
		this.roleCode = roleCode;
	}
	public String getMenuCode() {
		return menuCode;
	}
	public void setMenuCode(String menuCode) {
		this.menuCode = menuCode;
	}
	public RoleModel getRoleModel() {
		return roleModel;
	}
	public void setRoleModel(RoleModel roleModel) {
		this.roleModel = roleModel;
	}
	public MenuModel getMenuModel() {
		return menuModel;
	}
	public void setMenuModel(MenuModel menuModel) {
		this.menuModel = menuModel;
	}
	
}
