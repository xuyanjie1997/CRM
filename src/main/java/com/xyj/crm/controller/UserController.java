package com.xyj.crm.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.xyj.crm.model.MenuModel;
import com.xyj.crm.model.RelationModel;
import com.xyj.crm.model.RoleModel;
import com.xyj.crm.model.UserModel;
import com.xyj.crm.service.RelationService;
import com.xyj.crm.service.RoleService;
import com.xyj.crm.service.UserService;
import com.xyj.util.FmtEmpty;
import com.xyj.util.FmtMD5;

@Controller
@RequestMapping("/user")
public class UserController {

	@Autowired
	private UserService<UserModel> userService;
	@Autowired
	private RelationService<RelationModel> relService;
	@Autowired
	private RoleService<RoleModel> roleService;
	
	@RequestMapping("/login")
	public String login(UserModel user , HttpSession session , Model model) {
		UserModel um = userService.select(user.getCode());
		String msg;
		String view;
		if(um == null) {
			msg = "帐号不存在";
			view = "/web/login";
		}else if(um.getPassword().equals(FmtMD5.encode(user.getPassword()))){
			view = "/WEB-INF/main";
			session.setAttribute("user", um);
			model.addAttribute("menus" , getMenu(um));
			msg = "登录成功";
		}else {
			msg = "密码错误";
			view = "/web/login";
		}
		model.addAttribute("msg", msg);
		return view;
	}

	@RequestMapping("/logout")
	public String logout(HttpServletRequest request) {
		request.getSession().removeAttribute("user");
		String view = "/web/login";
		return view;
	}
	
	/**
	 * @param um
	 * @return
	 * 	查找对应角色的菜单
	 */
	private List<MenuModel> getMenu(UserModel um) {
		String roleCode = um.getRoleCode();
		if(FmtEmpty.isEmpty(roleCode)) {
			return null;
		}
		RelationModel rm = new RelationModel();
		rm.setRoleCode(roleCode);
		List<RelationModel> list = relService.selectAll(rm);
		if(FmtEmpty.isEmpty(list)) {
			return null;
		}
		List<MenuModel> result = new ArrayList<>();
		for(RelationModel rel : list) {
			MenuModel mm = rel.getMenuModel();
			String parentCode = mm.getParentCode();
			if(FmtEmpty.isEmpty(parentCode) || "00".equals(parentCode)) {
				result.add(mm);
				continue;
			}
			for(MenuModel m : result) {
				if(m.getCode().equals(parentCode)) {
					m.getChild().add(mm);
					break;
				}
			}
		}
		return result;
	}
	
	@ResponseBody
	@RequestMapping(value="/selectList",produces="text/html;charset=UTF-8")
	public String selectList(UserModel um , Model roleMo){
		String code = "%" + um.getCode() + "%" ;
		String name = "%" + um.getName() + "%" ;
		String roleCode = um.getRoleCode();
		UserModel model = new UserModel();
		model.setCode(code);
		model.setName(name);
		model.setRoleCode(roleCode);
		model.setOrderby("role_code");
		model.setPageIndex(um.getPageIndex());
		model.setPageLimit(um.getPageLimit());
		model.setPageOn(true);
		List<UserModel> list = userService.selectModel(model);	
		Map<String, Object> map = new HashMap<String, Object>();
	    map.put("data", list);
	    map.put("code", 0);
	    map.put("count", userService.selectCount(model));
	    roleMo.addAttribute("roleMo", roleService.selectModel(new RoleModel()));
	    return new JSONObject(map).toString();
	}
	
	@RequestMapping("/addorupd")
	public String addorupd(String code , Model model) {
		if(!FmtEmpty.isEmpty(code)) {
			model.addAttribute("model", userService.select(code));
		}
		RoleModel rm = new RoleModel();
		model.addAttribute("role", roleService.selectAll(rm));
		return "web/page/user/useraddorupd";
		
	}

	@ResponseBody
	@RequestMapping("/save")
	public int save(UserModel um) {
		String code = um.getCode();
		String roleCode = um.getRoleCode();
		if(userService.select(code) == null) {
			//	添加
			if(roleCode.equals("JL1")) {
				um.setParentCode("0");
			}
			um.setPassword(FmtMD5.encode("123456"));
			return insertIfNotExist(um);
		}else if(userService.select(code) != null) {
			return userService.updateActive(um) + 2;
		}else {		
			return 9;		
		}
	}
	
	private int insertIfNotExist(UserModel model) {
		String code = model.getCode();
		if(userService.select(code) == null) {
			return FmtEmpty.isEmpty(userService.insert(model)) ? 4 : 0;
		}
		return 1;
	}

	@ResponseBody
	@RequestMapping("/updpass")
	public int updpass(String repassword , UserModel model) {
		String password = model.getPassword();
		if(password.equals(repassword)) {
			password = FmtMD5.encode(password);
			model.setPassword(password);
			return userService.update(model);
		}else if(!(password.equals(repassword))){
			return 2 ;
		}
		return 3 ;
	}
	
	@ResponseBody
	@RequestMapping("/del")
	public int del(UserModel model) {
		return userService.delete(model.getCode());
	}
	
}
