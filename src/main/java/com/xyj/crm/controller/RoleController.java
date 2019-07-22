package com.xyj.crm.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.xyj.crm.model.RoleModel;
import com.xyj.crm.model.UserModel;
import com.xyj.crm.service.RoleService;
import com.xyj.crm.service.UserService;
import com.xyj.util.FmtEmpty;

@Controller
@RequestMapping("/role")
public class RoleController {

	@Autowired
	private RoleService<RoleModel> roleService;
	@Autowired
	private UserService<UserModel> userService;
	
	@ResponseBody
	@RequestMapping(value="/selectList",produces="text/html;charset=UTF-8")
	private String selectList(RoleModel model) {
		String code = "%" + model.getCode() + "%" ;
		String name = "%" + model.getName() + "%" ;
		RoleModel rm = new RoleModel();
		rm.setCode(code);
		rm.setName(name);
		rm.setPageIndex(model.getPageIndex());
		rm.setPageLimit(model.getPageLimit());
		rm.setPageOn(true);
		List<RoleModel> list = roleService.selectModel(rm);
		Map<String, Object> map = new HashMap<String, Object>();
	    map.put("data", list);
	    map.put("code", 0);
	    map.put("count", roleService.selectCount(model));
	    return new JSONObject(map).toString();	
	}
	
	@ResponseBody
	@RequestMapping("/del")
	public int del(RoleModel model) {
		String code = model.getCode();
		UserModel u = new UserModel();
		u.setRoleCode(code);
		int count = userService.selectCount(u);
		if(count == 0) {
			return roleService.delete(code);
		}else {
			return 2;
		}		
	}
	
	@RequestMapping("/addorupd")
	public String addorupd(String code , Model model) {
		if(!FmtEmpty.isEmpty(code)) {
			model.addAttribute("model", roleService.select(code));
		}
		return "web/page/user/roleaddorupd";
	}
	
	@ResponseBody
	@RequestMapping("/save")
	public int save(RoleModel model) {
		String code = model.getCode();
		if(roleService.select(code) == null) {
			//	添加
			return insertIfNotExist(model);
		}else if(roleService.select(code) != null) {
			return roleService.update(model) + 2;
		}else {		
			return 9;		
		}		
	}
	
	private int insertIfNotExist(RoleModel model) {
		String code = model.getCode();
		if(roleService.select(code) == null) {
			return FmtEmpty.isEmpty(roleService.insert(model)) ? 4 : 0;
		}
		return 1;
	}
	
}
