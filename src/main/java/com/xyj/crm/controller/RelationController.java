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

import com.xyj.crm.model.MenuModel;
import com.xyj.crm.model.RelationModel;
import com.xyj.crm.model.RoleModel;
import com.xyj.crm.service.MenuService;
import com.xyj.crm.service.RelationService;
import com.xyj.crm.service.RoleService;
import com.xyj.util.FmtEmpty;

@Controller
@RequestMapping("/rel")
public class RelationController {

	@Autowired
	private RelationService<RelationModel> relationService;
	@Autowired
	private RoleService<RoleModel> roleService;
	@Autowired
	private MenuService<MenuModel> menuService;
	
	@ResponseBody
	@RequestMapping(value="/selectList" , produces = "text/html;charset=UTF-8")
	public String selectList(RelationModel model) {
		String rolecode = "%" + model.getRoleCode() + "%";
		String menucode = "%" + model.getMenuCode() + "%";
		RelationModel rm = new RelationModel();
		rm.setRoleCode(rolecode);
		rm.setMenuCode(menucode);
		rm.setPageIndex(model.getPageIndex());
		rm.setPageLimit(model.getPageLimit());
		rm.setPageOn(true);
		rm.setOrderby("role_code");
		List<RelationModel> list = relationService.selectModel(rm);
		Map<String , Object> map = new HashMap<>();
		map.put("data", list);
		map.put("code", 0);
		map.put("count", relationService.selectCount(rm));
		return new JSONObject(map).toString();
	}
	
	@RequestMapping("/addorupd")
	public String addorupd(String code , Model model) {
		if(!FmtEmpty.isEmpty(code)) {
			Integer id = Integer.parseInt(code);
			model.addAttribute("model", relationService.select(id));
		}
		RoleModel rm = new RoleModel();
		model.addAttribute("role", roleService.selectAll(rm));
		MenuModel mm = new MenuModel();
		model.addAttribute("menu", menuService.selectAll(mm));
		return "web/page/user/reladdorupd";
	}
	
	@ResponseBody
	@RequestMapping("/save")
	public int save(RelationModel rm) {
		Integer id = rm.getId();
		String rolecode = rm.getRoleCode();
		String menucode = rm.getMenuCode();
		RelationModel model = new RelationModel();
		model.setRoleCode(rolecode);
		model.setMenuCode(menucode);
		if(relationService.select(id) == null) {
			//	添加
			return insertIfNotExist(rm);
		}else if(relationService.select(id) != null) {
			//	修改
			boolean b = (relationService.selectByCodes(model) == null);
			if(b == true) {
				return relationService.update(rm) + 2;//	return 3 修改成功
			}else {
				return 8;//	当前用户已拥有此权限
			}
		}else {
			return 9;//	操作失败
		}
	}
	private int insertIfNotExist(RelationModel rm) {
		if(relationService.selectByCodes(rm) == null) {
			return FmtEmpty.isEmpty(relationService.insert(rm)) ? 4 : 0;//	return 0 添加成功 ； return 4 添加失败  
		}
		return 1;//	当前记录已存在
	}
	
	@ResponseBody
	@RequestMapping("/del")
	public int del(String relId) {
		Integer id = Integer.parseInt(relId);
		RelationModel model = new RelationModel();
		model.setId(id);
		return relationService.delete(model.getId());
	}
	
}
